import 'dart:developer';
import 'dart:ui';

import 'package:get/get.dart';
import 'package:spendly/features/expense/domain/usecases/get_monthly_expense.dart';
import 'package:spendly/core/extensions/double_ext.dart';

import '../../../../core/enums/expense_category.dart';
import '../../../auth/presentation/controller/auth_controller.dart';
import 'package:spendly/core/config/app_config.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/expense_entity.dart';
import '../../domain/usecases/get_last_month_total_usecase.dart';
import '../../domain/usecases/usecases.dart';

class ExpenseController extends GetxController {
  final GetAllExpensesUseCase getAllExpenses;
  final GetMonthlyExpensesUseCase getMonthlyExpensesUseCase;
  final GetExpensesInRangeUseCase getExpensesInRangeUseCase;
  final GetExpenseUseCase getExpense;
  final AddExpenseUseCase addExpense;
  final UpdateExpenseUseCase updateExpense;
  final DeleteExpenseUseCase deleteExpense;

  // ===== Last Month Usecase =====
  final GetLastMonthTotalUseCase getLastMonthTotalUseCase;

  var expenses = <ExpenseEntity>[].obs;
  var isLoading = false.obs;
  var totalExpense = 0.0.obs;

  var reportExpenses = <ExpenseEntity>[].obs;
  var reportFilteredExpenses = <ExpenseEntity>[].obs;
  var reportTotalExpense = 0.0.obs;

  final categories = <String>[
    'All',
    ...ExpenseCategory.values.map((e) => e.displayName),
  ];

  var selectedCategory = 'All'.obs;
  var filteredExpenses = <ExpenseEntity>[].obs;
  Rx<DateTime> selectedMonth = DateTime.now().obs;
  bool shouldRefresh = false;

  final Rx<DateTime?> startDate = Rx<DateTime?>(null);
  final Rx<DateTime?> endDate = Rx<DateTime?>(null);

  // ===== Budget & Last Month Total =====
  var monthlyBudget = 30000.0.obs;
  var categoryBudgets = <ExpenseCategory, double>{}.obs;
  var isBudgetLoading = false.obs;
  var lastMonthTotal = 0.0.obs;
  var lastMonthExpenses = <ExpenseEntity>[].obs;

  final AuthController authController = Get.find();

  late String userId;

  ExpenseController({
    required this.getAllExpenses,
    required this.getMonthlyExpensesUseCase,
    required this.getExpensesInRangeUseCase,
    required this.getExpense,
    required this.addExpense,
    required this.updateExpense,
    required this.deleteExpense,
    required this.getLastMonthTotalUseCase,
  });

  @override
  void onInit() {
    userId = authController.user?.email ?? 'unknown_user';
    fetchMonthlyExpenses();
    clearReportState();
    super.onInit();
  }

  void clearReportState() {
    reportExpenses.value = [];
    reportFilteredExpenses.value = [];
    reportTotalExpense.value = 0.0;
    startDate.value = null;
    endDate.value = null;
  }

  double getTotalExpense() {
    totalExpense.value = expenses.fold(0.0, (sum, item) => sum + item.amount);
    return totalExpense.value;
  }

  Future<void> fetchMonthlyExpenses() async {
    DateTime month = selectedMonth.value;
    if (_isCurrentMonthDataFetched(month) && !shouldRefresh) {
      filterExpensesByCategory();
      updateTotalExpense();
      return;
    }

    selectedCategory.value = 'All';
    isLoading.value = true;
    try {
      expenses.value = await getMonthlyExpensesUseCase(userId, month);
      getTotalExpense();
      filterExpensesByCategory();

      await fetchLastMonthTotal();
      await fetchLastMonthExpenses();
      await loadBudgetsForMonth(month);
    } finally {
      isLoading.value = false;
      shouldRefresh = false;
    }
  }

  Future<void> loadBudgetsForMonth(DateTime month) async {
    isBudgetLoading.value = true;
    try {
      final firestore = Get.find<FirebaseFirestore>();
      final collectionName = AppConfig.isProd ? 'budgets' : 'budgets_dev';
      
      final monthKey = DateFormat('yyyy-MMMM').format(month);
      final monthDocId = '${userId}_$monthKey';
      
      // 1. Try loading month-specific budget
      final monthSnap = await firestore.collection(collectionName).doc(monthDocId).get();
      if (monthSnap.exists && monthSnap.data() != null) {
        final data = monthSnap.data()!;
        monthlyBudget.value = (data['overallBudget'] as num?)?.toDouble() ?? 30000.0;
        
        final catBudgets = <ExpenseCategory, double>{};
        if (data['categoryBudgets'] is Map) {
          final map = data['categoryBudgets'] as Map;
          map.forEach((k, v) {
            final cat = ExpenseCategoryExtension.fromString(k.toString());
            catBudgets[cat] = (v as num).toDouble();
          });
        }
        categoryBudgets.value = catBudgets;
        return;
      }
      
      // 2. Try loading recurring budget (only if the target month is the current month or in the future)
      final now = DateTime.now();
      final currentMonthStart = DateTime(now.year, now.month);
      final targetMonthStart = DateTime(month.year, month.month);
      if (!targetMonthStart.isBefore(currentMonthStart)) {
        final recurringDocId = '${userId}_recurring';
        final recSnap = await firestore.collection(collectionName).doc(recurringDocId).get();
        if (recSnap.exists && recSnap.data() != null) {
          final data = recSnap.data()!;
          monthlyBudget.value = (data['overallBudget'] as num?)?.toDouble() ?? 30000.0;
          
          final catBudgets = <ExpenseCategory, double>{};
          if (data['categoryBudgets'] is Map) {
            final map = data['categoryBudgets'] as Map;
            map.forEach((k, v) {
              final cat = ExpenseCategoryExtension.fromString(k.toString());
              catBudgets[cat] = (v as num).toDouble();
            });
          }
          categoryBudgets.value = catBudgets;
          return;
        }
      }
      
      // 3. Fallback to default overall budget of 30,000 and default category budgets
      monthlyBudget.value = 30000.0;
      categoryBudgets.value = {
        ExpenseCategory.family: 12000.0,
        ExpenseCategory.personal: 5000.0,
        ExpenseCategory.transport: 3000.0,
        ExpenseCategory.food: 2500.0,
        ExpenseCategory.utilities: 1500.0,
        ExpenseCategory.lend: 1500.0,
        ExpenseCategory.clothing: 1500.0,
        ExpenseCategory.hangout: 1500.0,
        ExpenseCategory.other: 1500.0,
      };
    } catch (e) {
      log('Error loading budget: $e');
      monthlyBudget.value = 30000.0;
      categoryBudgets.value = {
        ExpenseCategory.family: 12000.0,
        ExpenseCategory.personal: 5000.0,
        ExpenseCategory.transport: 3000.0,
        ExpenseCategory.food: 2500.0,
        ExpenseCategory.utilities: 1500.0,
        ExpenseCategory.lend: 1500.0,
        ExpenseCategory.clothing: 1500.0,
        ExpenseCategory.hangout: 1500.0,
        ExpenseCategory.other: 1500.0,
      };
    } finally {
      isBudgetLoading.value = false;
    }
  }

  Future<void> saveBudgetsForMonth({
    required DateTime month,
    required double overall,
    required Map<ExpenseCategory, double> categories,
    required bool isRecurring,
  }) async {
    isBudgetLoading.value = true;
    try {
      final firestore = Get.find<FirebaseFirestore>();
      final collectionName = AppConfig.isProd ? 'budgets' : 'budgets_dev';
      
      // Prepare category map of string to double
      final categoryMap = <String, double>{};
      categories.forEach((cat, limit) {
        categoryMap[cat.name] = limit;
      });
      
      final budgetData = {
        'userId': userId,
        'overallBudget': overall,
        'categoryBudgets': categoryMap,
      };

      if (isRecurring) {
        // Save to recurring document
        final recurringDocId = '${userId}_recurring';
        await firestore.collection(collectionName).doc(recurringDocId).set(budgetData);
      } else {
        // Save to month-specific document
        final monthKey = DateFormat('yyyy-MMMM').format(month);
        final monthDocId = '${userId}_$monthKey';
        await firestore.collection(collectionName).doc(monthDocId).set({
          ...budgetData,
          'monthKey': monthKey,
        });
      }
      
      // Update in-memory state
      monthlyBudget.value = overall;
      categoryBudgets.value = categories;
    } catch (e) {
      log('Error saving budget: $e');
      rethrow;
    } finally {
      isBudgetLoading.value = false;
    }
  }

  Future<void> fetchLastMonthTotal() async {
    try {
      lastMonthTotal.value = await getLastMonthTotalUseCase(
        userId,
        currentMonth: selectedMonth.value,
      );
    } catch (e) {
      log('Error fetching last month total: $e');
      lastMonthTotal.value = 0.0;
    }
  }

  Future<void> fetchLastMonthExpenses() async {
    try {
      final prevMonth = DateTime(
        selectedMonth.value.month == 1 ? selectedMonth.value.year - 1 : selectedMonth.value.year,
        selectedMonth.value.month == 1 ? 12 : selectedMonth.value.month - 1,
        1,
      );
      lastMonthExpenses.value = await getMonthlyExpensesUseCase(userId, prevMonth);
    } catch (e) {
      log('Error fetching last month expenses: $e');
      lastMonthExpenses.value = [];
    }
  }

  Future<void> fetchExpensesInRange(DateTime start, DateTime end) async {
    clearReportState();

    startDate.value = start;
    endDate.value = end;
    selectedCategory.value = 'All';
    isLoading.value = true;

    try {
      reportExpenses.value = await getExpensesInRangeUseCase.call(
        userId,
        start,
        end,
      );
      updateReportTotalExpense();
      filterReportExpensesByCategory();
    } catch (e) {
      log('Error fetching expenses in range: $e');
      reportExpenses.value = [];
    } finally {
      isLoading.value = false;
      shouldRefresh = false;
    }
  }

  void filterReportExpensesByCategory() {
    if (selectedCategory.value == 'All') {
      reportFilteredExpenses.value = reportExpenses;
    } else {
      reportFilteredExpenses.value = reportExpenses
          .where((expense) => expense.category == selectedCategory.value)
          .toList();
    }
  }

  void updateReportTotalExpense() {
    if (selectedCategory.value == 'All') {
      reportTotalExpense.value = reportExpenses.fold(
        0.0,
        (sum, item) => sum + item.amount,
      );
    } else {
      reportTotalExpense.value = reportFilteredExpenses.fold(
        0.0,
        (sum, item) => sum + item.amount,
      );
    }
  }

  Future<void> createExpense(
    ExpenseEntity expense, {
    VoidCallback? onSuccess,
    Function(dynamic)? onError,
  }) async {
    shouldRefresh = true;
    try {
      await addExpense.call(expense);
      onSuccess?.call();
      fetchMonthlyExpenses();
    } catch (e) {
      onError?.call(e);
      log('Create Expense Error: $e');
    }
  }

  Future<void> editExpense(
    ExpenseEntity expense, {
    VoidCallback? onSuccess,
    Function(dynamic)? onError,
  }) async {
    shouldRefresh = true;
    try {
      await updateExpense.call(expense);
      onSuccess?.call();
      fetchMonthlyExpenses(); // will also fetch last month total
    } catch (e) {
      onError?.call(e);
      log('Edit Expense Error: $e');
    }
  }

  Future<void> removeExpense(
    String id, {
    VoidCallback? onSuccess,
    Function(dynamic)? onError,
  }) async {
    shouldRefresh = true;
    try {
      await deleteExpense.call(id);
      onSuccess?.call();
      fetchMonthlyExpenses(); // will also fetch last month total
    } catch (e) {
      onError?.call(e);
      log('Remove Expense Error: $e');
    }
  }

  void filterExpensesByCategory() {
    if (selectedCategory.value == 'All') {
      filteredExpenses.value = expenses;
    } else {
      filteredExpenses.value = expenses
          .where((expense) => expense.category == selectedCategory.value)
          .toList();
    }
  }

  void updateSelectedCategory(String category) {
    selectedCategory.value = category;

    if (startDate.value != null && endDate.value != null) {
      filterReportExpensesByCategory();
      updateReportTotalExpense();
    } else {
      filterExpensesByCategory();
      updateTotalExpense();
    }
  }

  void updateTotalExpense() {
    totalExpense.value = expenses.fold(0.0, (sum, item) => sum + item.amount);
  }

  bool _isCurrentMonthDataFetched(DateTime month) {
    if (expenses.isEmpty) return false;
    final currentMonth = month.month;
    final firstExpenseMonth = expenses.first.date.month;
    return currentMonth == firstExpenseMonth;
  }

  void updateSelectedMonth(DateTime newMonth) {
    selectedMonth.value = newMonth;
    clearReportState();
    shouldRefresh = true;
    fetchMonthlyExpenses();
  }

  List<Object> getGroupedExpenses() {
    final List<ExpenseEntity> source = filteredExpenses;
    return _groupExpensesList(source);
  }

  List<Object> getGroupedReportExpenses() {
    final List<ExpenseEntity> source = reportFilteredExpenses;
    return _groupExpensesList(source);
  }

  List<Object> get groupedExpenses => getGroupedExpenses();

  List<Object> _groupExpensesList(List<ExpenseEntity> source) {
    if (source.isEmpty) return [];

    final Map<DateTime, List<ExpenseEntity>> groupedMap = {};
    final Map<DateTime, double> dailyTotals = {};

    for (var expense in source) {
      final dateKey = DateTime(
        expense.date.year,
        expense.date.month,
        expense.date.day,
      );

      if (groupedMap[dateKey] == null) {
        groupedMap[dateKey] = [];
        dailyTotals[dateKey] = 0.0;
      }

      groupedMap[dateKey]!.add(expense);
      dailyTotals[dateKey] = dailyTotals[dateKey]! + expense.amount;
    }

    final List<Object> flattened = [];
    final sortedDates = groupedMap.keys.toList()
      ..sort((a, b) => b.compareTo(a));

    for (var date in sortedDates) {
      flattened.add({'date': date, 'total': dailyTotals[date]});

      final dayExpenses = groupedMap[date]!
        ..sort((a, b) => b.date.compareTo(a.date));
      flattened.addAll(dayExpenses);
    }

    return flattened;
  }

  String getDynamicInsight() {
    if (expenses.isEmpty) {
      return "Start adding expenses to get smart insights on your spending habits!";
    }

    final double totalCurrent = totalExpense.value;
    final double totalLast = lastMonthTotal.value;

    // 1. Overall comparison
    String overallInsight = "";
    if (totalLast > 0) {
      final double diff = totalCurrent - totalLast;
      final double percent = (diff / totalLast * 100).abs();
      if (diff > 0) {
        overallInsight = "Your total spending is ${percent.toStringAsFixed(0)}% higher than last month (increased by ${diff.toCurrency()} ৳). ";
      } else if (diff < 0) {
        overallInsight = "Great job! Your total spending is ${percent.toStringAsFixed(0)}% lower than last month (saved ${diff.abs().toCurrency()} ৳). ";
      } else {
        overallInsight = "Your total spending is exactly the same as last month. ";
      }
    } else {
      overallInsight = "You spent a total of ${totalCurrent.toCurrency()} ৳ this month. ";
    }

    // 2. Dynamic significant category comparison
    String categoryInsight = "";
    if (lastMonthExpenses.isNotEmpty) {
      // Calculate category spending for this month
      final Map<String, double> currentCategoryTotals = {};
      for (var e in expenses) {
        currentCategoryTotals[e.category] = (currentCategoryTotals[e.category] ?? 0.0) + e.amount;
      }

      // Calculate category spending for last month
      final Map<String, double> lastCategoryTotals = {};
      for (var e in lastMonthExpenses) {
        lastCategoryTotals[e.category] = (lastCategoryTotals[e.category] ?? 0.0) + e.amount;
      }

      // Find the category with the highest absolute difference (change) between the two months
      String? significantCategory;
      double maxAbsoluteChange = -1.0;
      double chosenChange = 0.0;
      double currentAmount = 0.0;
      double lastAmount = 0.0;

      // Check all unique categories from both months
      final allCategories = {...currentCategoryTotals.keys, ...lastCategoryTotals.keys};
      for (var cat in allCategories) {
        final double currVal = currentCategoryTotals[cat] ?? 0.0;
        final double lastVal = lastCategoryTotals[cat] ?? 0.0;
        final double change = currVal - lastVal;
        final double absChange = change.abs();

        if (absChange > maxAbsoluteChange) {
          maxAbsoluteChange = absChange;
          chosenChange = change;
          significantCategory = cat;
          currentAmount = currVal;
          lastAmount = lastVal;
        }
      }

      if (significantCategory != null && maxAbsoluteChange > 0) {
        if (chosenChange > 0) {
          final double percent = lastAmount > 0 ? (chosenChange / lastAmount * 100) : 100.0;
          categoryInsight = "Watch out for $significantCategory: you spent ${currentAmount.toCurrency()} ৳, which is ${percent.toStringAsFixed(0)}% higher than last month (an increase of ${chosenChange.toCurrency()} ৳).";
        } else {
          final double savings = chosenChange.abs();
          final double percent = lastAmount > 0 ? (savings / lastAmount * 100) : 100.0;
          categoryInsight = "Superb control on $significantCategory! You spent ${currentAmount.toCurrency()} ৳, which is ${percent.toStringAsFixed(0)}% lower than last month (saved ${savings.toCurrency()} ৳).";
        }
      } else {
        categoryInsight = "Your category spending remains very stable compared to last month.";
      }
    } else {
      // Fallback if no last month expenses list is loaded yet
      // Find the highest spending category this month
      String? highestCategory;
      double maxCategorySpent = 0.0;
      final Map<String, double> categoryTotals = {};
      for (var e in expenses) {
        categoryTotals[e.category] = (categoryTotals[e.category] ?? 0.0) + e.amount;
      }
      categoryTotals.forEach((cat, amount) {
        if (amount > maxCategorySpent) {
          maxCategorySpent = amount;
          highestCategory = cat;
        }
      });

      if (highestCategory != null) {
        categoryInsight = "Your highest spending category this month is $highestCategory, totaling ${maxCategorySpent.toCurrency()} ৳.";
      }
    }

    return "$overallInsight$categoryInsight";
  }
}
