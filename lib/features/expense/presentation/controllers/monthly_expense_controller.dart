import 'package:spendly/core/error/exception_handler.dart';
import 'dart:ui';
import 'package:get/get.dart';
import 'package:spendly/features/expense/domain/usecases/get_monthly_expense.dart';
import 'package:spendly/core/extensions/double_ext.dart';
import '../../../../core/enums/expense_category.dart';
import '../../domain/entities/expense_entity.dart';
import '../../domain/usecases/get_last_month_total_usecase.dart';
import '../../domain/usecases/usecases.dart';
import 'budget_controller.dart';

class MonthlyExpenseController extends GetxController {
  final GetAllExpensesUseCase getAllExpenses;
  final GetMonthlyExpensesUseCase getMonthlyExpensesUseCase;
  final GetExpenseUseCase getExpense;
  final AddExpenseUseCase addExpense;
  final UpdateExpenseUseCase updateExpense;
  final DeleteExpenseUseCase deleteExpense;
  final GetLastMonthTotalUseCase getLastMonthTotalUseCase;

  var expenses = <ExpenseEntity>[].obs;
  var isLoading = false.obs;
  var totalExpense = 0.0.obs;

  final categories = <String>[
    'All',
    ...ExpenseCategory.values.map((e) => e.displayName),
  ];

  var selectedCategory = 'All'.obs;
  var searchQuery = ''.obs;
  var filteredExpenses = <ExpenseEntity>[].obs;
  Rx<DateTime> selectedMonth = DateTime.now().obs;
  bool shouldRefresh = false;

  // ===== Budget & Last Month Total =====
  final BudgetController _budgetController = Get.find();
  RxDouble get monthlyBudget => _budgetController.monthlyBudget;
  RxMap<ExpenseCategory, double> get categoryBudgets => _budgetController.categoryBudgets;
  RxBool get isBudgetLoading => _budgetController.isBudgetLoading;

  var lastMonthTotal = 0.0.obs;
  var lastMonthExpenses = <ExpenseEntity>[].obs;

  MonthlyExpenseController({
    required this.getAllExpenses,
    required this.getMonthlyExpensesUseCase,
    required this.getExpense,
    required this.addExpense,
    required this.updateExpense,
    required this.deleteExpense,
    required this.getLastMonthTotalUseCase,
  });

  @override
  void onInit() {
    fetchMonthlyExpenses();
    super.onInit();
  }

  double getTotalExpense() {
    totalExpense.value = expenses.fold(0.0, (acc, item) => acc + item.amount);
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
    searchQuery.value = '';
    isLoading.value = true;
    try {
      expenses.value = await getMonthlyExpensesUseCase(month);
      getTotalExpense();
      filterExpensesByCategory();

      await fetchLastMonthTotal();
      await fetchLastMonthExpenses();
      await _budgetController.loadBudgetsForMonth(month);
    } finally {
      isLoading.value = false;
      shouldRefresh = false;
    }
  }

  Future<void> fetchLastMonthTotal() async {
    try {
      lastMonthTotal.value = await getLastMonthTotalUseCase(
        currentMonth: selectedMonth.value,
      );
    } catch (e, stackTrace) {
      ExceptionHandler.handle(e, stackTrace, 'MonthlyExpenseController.fetchLastMonthTotal');
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
      lastMonthExpenses.value = await getMonthlyExpensesUseCase(prevMonth);
    } catch (e, stackTrace) {
      ExceptionHandler.handle(e, stackTrace, 'MonthlyExpenseController.fetchLastMonthExpenses');
      lastMonthExpenses.value = [];
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
    } catch (e, stackTrace) {
      onError?.call(e);
      ExceptionHandler.handle(e, stackTrace, 'MonthlyExpenseController.createExpense');
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
      fetchMonthlyExpenses();
    } catch (e, stackTrace) {
      onError?.call(e);
      ExceptionHandler.handle(e, stackTrace, 'MonthlyExpenseController.editExpense');
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
      fetchMonthlyExpenses();
    } catch (e, stackTrace) {
      onError?.call(e);
      ExceptionHandler.handle(e, stackTrace, 'MonthlyExpenseController.removeExpense');
    }
  }

  void filterExpensesByCategory() {
    final query = searchQuery.value.trim().toLowerCase();
    List<ExpenseEntity> temp = expenses;
    
    if (selectedCategory.value != 'All') {
      temp = temp.where((expense) => expense.category == selectedCategory.value).toList();
    }
    
    if (query.isNotEmpty) {
      temp = temp.where((expense) =>
        expense.description.toLowerCase().contains(query) ||
        expense.amount.toString().contains(query) ||
        expense.category.toLowerCase().contains(query)
      ).toList();
    }
    
    filteredExpenses.value = temp;
  }

  void updateSelectedCategory(String category) {
    selectedCategory.value = category;
    filterExpensesByCategory();
    updateTotalExpense();
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
    filterExpensesByCategory();
    updateTotalExpense();
  }

  void updateTotalExpense() {
    totalExpense.value = expenses.fold(0.0, (acc, item) => acc + item.amount);
  }

  bool _isCurrentMonthDataFetched(DateTime month) {
    if (expenses.isEmpty) return false;
    final currentMonth = month.month;
    final firstExpenseMonth = expenses.first.date.month;
    return currentMonth == firstExpenseMonth;
  }

  void updateSelectedMonth(DateTime newMonth) {
    selectedMonth.value = newMonth;
    shouldRefresh = true;
    fetchMonthlyExpenses();
  }

  List<Object> getGroupedExpenses() {
    final List<ExpenseEntity> source = filteredExpenses;
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
