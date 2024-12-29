import 'package:get/get.dart';
import 'package:spendly/features/expense/domain/usecases/get_monthly_expense.dart';

import '../../../../core/enums/expense_category.dart';
import '../../domain/entities/expense_entity.dart';
import '../../domain/usecases/usecases.dart';

class ExpenseController extends GetxController {
  final GetAllExpensesUseCase getAllExpenses;
  final GetMonthlyExpensesUseCase getMonthlyExpensesUseCase;
  final GetExpenseUseCase getExpense;
  final AddExpenseUseCase addExpense;
  final UpdateExpenseUseCase updateExpense;
  final DeleteExpenseUseCase deleteExpense;

  var expenses = <ExpenseEntity>[].obs;
  var isLoading = false.obs;
  var totalExpense = 0.0.obs;

  // Categories derived from enum
  final categories = <String>[
    'All',
    ...ExpenseCategory.values.map((e) => e.displayName),
  ];

  var selectedCategory = 'All'.obs;
  var filteredExpenses = <ExpenseEntity>[].obs;
  Rx<DateTime> selectedMonth = DateTime.now().obs;
  bool shouldRefresh = false;

  ExpenseController({
    required this.getAllExpenses,
    required this.getMonthlyExpensesUseCase,
    required this.getExpense,
    required this.addExpense,
    required this.updateExpense,
    required this.deleteExpense,
  });

  @override
  void onInit() {
    fetchMonthlyExpenses();
    super.onInit();
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
      expenses.value = await getMonthlyExpensesUseCase('userId', month);
      getTotalExpense();
      filterExpensesByCategory();
    } finally {
      isLoading.value = false;
      shouldRefresh = false;
    }
  }

  Future<void> createExpense(ExpenseEntity expense) async {
    shouldRefresh = true;
    await addExpense.call(expense);
    fetchMonthlyExpenses();
  }

  Future<void> editExpense(ExpenseEntity expense) async {
    shouldRefresh = true;
    await updateExpense.call(expense);
    fetchMonthlyExpenses();
    Get.back();
  }

  Future<void> removeExpense(String id) async {
    shouldRefresh = true;
    await deleteExpense.call(id);
    fetchMonthlyExpenses();
  }

  void filterExpensesByCategory() {
    if (selectedCategory.value == 'All') {
      filteredExpenses.value = expenses;
    } else {
      filteredExpenses.value = expenses
          .where((expense) =>
      expense.category ==
          selectedCategory.value)
          .toList();
    }
  }


  void updateSelectedCategory(String category) {
    selectedCategory.value = category;
    filterExpensesByCategory();
    updateTotalExpense();
  }

  void updateTotalExpense() {
    if (selectedCategory.value == 'All') {
      totalExpense.value = expenses.fold(0.0, (sum, item) => sum + item.amount);
    } else {
      totalExpense.value = filteredExpenses.fold(0.0, (sum, item) => sum + item.amount);
    }
  }

  bool _isCurrentMonthDataFetched(DateTime month) {
    if (expenses.isEmpty) return false;

    final currentMonth = month.month;
    final firstExpenseMonth = expenses.first.date.month;

    return currentMonth == firstExpenseMonth;
  }

  void updateSelectedMonth(DateTime selectedMonth) {
    selectedMonth = selectedMonth;
    filterExpensesByCategory();
    updateTotalExpense();
  }
}
