import 'package:finkeep/core/error/exception_handler.dart';
import 'package:get/get.dart';
import 'package:finkeep/core/enums/expense_category.dart';
import '../../domain/entities/expense_entity.dart';
import '../../domain/usecases/usecases.dart';
import 'budget_controller.dart';

class ExpenseReportController extends GetxController {
  final GetExpensesInRangeUseCase getExpensesInRangeUseCase;

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
  var searchQuery = ''.obs;

  final Rx<DateTime?> startDate = Rx<DateTime?>(null);
  final Rx<DateTime?> endDate = Rx<DateTime?>(null);

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
    searchQuery.value = '';
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
        start,
        end,
      );
      updateReportTotalExpense();
      filterReportExpensesByCategory();
      await calculateBudgetForRange(start, end);
    } catch (e, stackTrace) {
      ExceptionHandler.handle(e, stackTrace, 'ExpenseReportController.fetchExpensesInRange');
      reportExpenses.value = [];
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> calculateBudgetForRange(DateTime start, DateTime end) async {
    final budgetController = Get.find<BudgetController>();
    double totalBudget = 0.0;

    var current = DateTime(start.year, start.month, 1);
    final limitDate = DateTime(end.year, end.month, 1);

    while (!current.isAfter(limitDate)) {
      final monthBudget = await budgetController.getBudgetForMonth(current);
      totalBudget += monthBudget;
      current = DateTime(current.year, current.month + 1, 1);
    }

    reportRangeBudget.value = totalBudget;
  }

  void filterReportExpensesByCategory() {
    final query = searchQuery.value.trim().toLowerCase();
    List<ExpenseEntity> temp = reportExpenses;
    
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
    
    reportFilteredExpenses.value = temp;
  }

  void updateReportTotalExpense() {
    reportTotalExpense.value = reportFilteredExpenses.fold(
      0.0,
      (sum, item) => sum + item.amount,
    );
  }

  void updateSelectedCategory(String category) {
    selectedCategory.value = category;
    filterReportExpensesByCategory();
    updateReportTotalExpense();
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
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
