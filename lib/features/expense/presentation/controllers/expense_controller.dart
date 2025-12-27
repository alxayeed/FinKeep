import 'dart:developer';
import 'dart:ui';

import 'package:get/get.dart';
import 'package:spendly/features/expense/domain/usecases/get_monthly_expense.dart';

import '../../../../core/enums/expense_category.dart';
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
  var monthlyBudget = 25000.0.obs;
  var lastMonthTotal = 0.0.obs;
  final String userId = "dummy_user_id";

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
    } finally {
      isLoading.value = false;
      shouldRefresh = false;
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

  Future<void> fetchExpensesInRange(DateTime start, DateTime end) async {
    clearReportState();

    startDate.value = start;
    endDate.value = end;
    selectedCategory.value = 'All';
    isLoading.value = true;

    try {
      reportExpenses.value = await getExpensesInRangeUseCase.call(start, end);
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
      fetchMonthlyExpenses(); // will also fetch last month total
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
    if (selectedCategory.value == 'All') {
      totalExpense.value = expenses.fold(0.0, (sum, item) => sum + item.amount);
    } else {
      totalExpense.value = filteredExpenses.fold(
        0.0,
        (sum, item) => sum + item.amount,
      );
    }
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
    fetchMonthlyExpenses(); // will also fetch last month total
  }
}
