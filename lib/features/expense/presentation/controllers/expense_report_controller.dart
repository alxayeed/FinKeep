import 'dart:developer';
import 'package:get/get.dart';
import 'package:spendly/core/enums/expense_category.dart';
import 'package:spendly/features/auth/presentation/controller/auth_controller.dart';
import '../../domain/entities/expense_entity.dart';
import '../../domain/usecases/usecases.dart';
import 'budget_controller.dart';

class ExpenseReportController extends GetxController {
  final GetExpensesInRangeUseCase getExpensesInRangeUseCase;
  final AuthController authController = Get.find();

  var isLoading = false.obs;
  var reportExpenses = <ExpenseEntity>[].obs;
  var reportFilteredExpenses = <ExpenseEntity>[].obs;
  var reportTotalExpense = 0.0.obs;
  var reportRangeBudget = 0.0.obs;

  final categories = <String>[
    'All',
    ...ExpenseCategory.values.map((e) => e.displayName),
  ];

  var selectedCategory = 'All'.obs;

  final Rx<DateTime?> startDate = Rx<DateTime?>(null);
  final Rx<DateTime?> endDate = Rx<DateTime?>(null);

  String get userId => authController.user?.email ?? '';

  ExpenseReportController({
    required this.getExpensesInRangeUseCase,
  });

  @override
  void onInit() {
    clearReportState();
    super.onInit();
  }

  void clearReportState() {
    reportExpenses.value = [];
    reportFilteredExpenses.value = [];
    reportTotalExpense.value = 0.0;
    startDate.value = null;
    endDate.value = null;
    selectedCategory.value = 'All';
    reportRangeBudget.value = 0.0;
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
      await calculateBudgetForRange(start, end);
    } catch (e) {
      log('Error fetching expenses in range: $e');
      reportExpenses.value = [];
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> calculateBudgetForRange(DateTime start, DateTime end) async {
    final budgetController = Get.find<BudgetController>();
    double totalBudget = 0.0;

    var current = DateTime(start.year, start.month, start.day);
    final limitDate = DateTime(end.year, end.month, end.day);

    final Map<DateTime, int> monthDaysCount = {};
    while (!current.isAfter(limitDate)) {
      final monthKey = DateTime(current.year, current.month);
      monthDaysCount[monthKey] = (monthDaysCount[monthKey] ?? 0) + 1;
      current = current.add(const Duration(days: 1));
    }

    for (final entry in monthDaysCount.entries) {
      final month = entry.key;
      final daysCovered = entry.value;

      final monthBudget = await budgetController.getBudgetForMonth(month);
      final totalDaysInMonth = DateTime(month.year, month.month + 1, 0).day;
      
      totalBudget += monthBudget * (daysCovered / totalDaysInMonth);
    }

    reportRangeBudget.value = totalBudget;
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

  void updateSelectedCategory(String category) {
    selectedCategory.value = category;
    filterReportExpensesByCategory();
    updateReportTotalExpense();
  }

  List<Object> getGroupedReportExpenses() {
    final List<ExpenseEntity> source = reportFilteredExpenses;
    return _groupExpensesList(source);
  }

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
}
