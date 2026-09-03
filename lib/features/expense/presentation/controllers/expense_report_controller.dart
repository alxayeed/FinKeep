import 'package:finkeep/core/error/exception_handler.dart';
import 'package:get/get.dart';
import 'package:finkeep/core/enums/expense_category.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/expense_entity.dart';
import '../../domain/usecases/usecases.dart';
import 'package:intl/intl.dart';
import 'package:finkeep/core/services/local_db_service.dart';
import 'budget_controller.dart';

import '../../../../core/common/models/date_filter.dart';

import '../../domain/entities/expense_pdf_report_config.dart';

class ExpenseReportController extends GetxController {
  final GetExpensesInRangeUseCase getExpensesInRangeUseCase;

  var isLoading = false.obs;
  var reportExpenses = <ExpenseEntity>[].obs;
  var reportFilteredExpenses = <ExpenseEntity>[].obs;
  var reportTotalExpense = 0.0.obs;
  var reportRangeBudget = 0.0.obs;
  var missingBudgetMonths = <DateTime>[].obs;

  final categories = <String>[
    'All',
    ...ExpenseCategory.values.map((e) => e.displayName),
  ];

  var selectedCategory = 'All'.obs;
  final RxList<String> selectedCategories = <String>[].obs;
  var searchQuery = ''.obs;

  final Rx<DateTime?> startDate = Rx<DateTime?>(null);
  final Rx<DateTime?> endDate = Rx<DateTime?>(null);
  final Rx<DateFilter> dateFilter = DateFilter(
    type: DateFilterType.yearly,
    referenceDate: DateTime.now(),
  ).obs;
  final Rx<ExpenseReportPdfMode> listMode = ExpenseReportPdfMode.compact.obs;
  final RxBool includeCategorySummary = true.obs;
  final RxBool includeMonthlyBreakdown = true.obs;
  final RxBool includePaymentMethodBreakdown = true.obs;
  final RxBool includeHighLowAvgMetrics = true.obs;

  ExpenseReportController({
    required this.getExpensesInRangeUseCase,
  });

  @override
  void onInit() {
    clearReportState();
    super.onInit();
  }

  Future<void> updateDateFilter(DateFilter newFilter) async {
    dateFilter.value = newFilter;
    final range = newFilter.dateRange;
    if (range != null) {
      await fetchExpensesInRange(range.start, range.end);
    }
  }

  Future<void> applyReportFilters({
    required DateFilter newDateFilter,
    required List<String> categories,
    ExpenseReportPdfMode? mode,
    bool? categorySummary,
    bool? monthlyBreakdown,
    bool? paymentMethodBreakdown,
    bool? highLowAvgMetrics,
  }) async {
    if (mode != null) {
      listMode.value = mode;
    }
    if (categorySummary != null) includeCategorySummary.value = categorySummary;
    if (monthlyBreakdown != null) includeMonthlyBreakdown.value = monthlyBreakdown;
    if (paymentMethodBreakdown != null) includePaymentMethodBreakdown.value = paymentMethodBreakdown;
    if (highLowAvgMetrics != null) includeHighLowAvgMetrics.value = highLowAvgMetrics;

    final oldStart = startDate.value;
    final oldEnd = endDate.value;

    dateFilter.value = newDateFilter;
    selectedCategories.assignAll(categories);

    final range = newDateFilter.dateRange;
    final DateTime targetStart;
    final DateTime targetEnd;

    if (range != null) {
      targetStart = range.start;
      targetEnd = range.end;
    } else {
      final now = DateTime.now();
      targetStart = newDateFilter.customStartDate ?? DateTime(2000, 1, 1);
      targetEnd = newDateFilter.customEndDate ?? DateTime(now.year + 10, 12, 31, 23, 59, 59);
    }

    final isDateRangeChanged = oldStart == null ||
        oldEnd == null ||
        !oldStart.isAtSameMomentAs(targetStart) ||
        !oldEnd.isAtSameMomentAs(targetEnd);

    if (isDateRangeChanged) {
      await fetchExpensesInRange(targetStart, targetEnd);
    } else {
      filterReportExpensesByCategory();
    }
  }

  Future<void> resetReportFilters() async {
    listMode.value = ExpenseReportPdfMode.compact;
    includeCategorySummary.value = true;
    includeMonthlyBreakdown.value = true;
    includePaymentMethodBreakdown.value = true;
    includeHighLowAvgMetrics.value = true;
    final defaultFilter = DateFilter(
      type: DateFilterType.yearly,
      referenceDate: DateTime.now(),
    );
    await applyReportFilters(
      newDateFilter: defaultFilter,
      categories: [],
      mode: ExpenseReportPdfMode.compact,
      categorySummary: true,
      monthlyBreakdown: true,
      paymentMethodBreakdown: true,
      highLowAvgMetrics: true,
    );
  }

  void clearReportState() {
    reportExpenses.value = [];
    reportFilteredExpenses.value = [];
    reportTotalExpense.value = 0.0;
    startDate.value = null;
    endDate.value = null;
    searchQuery.value = '';
    reportRangeBudget.value = 0.0;
    missingBudgetMonths.clear();
  }

  Future<void> fetchExpensesInRange(DateTime start, DateTime end) async {
    clearReportState();

    startDate.value = start;
    endDate.value = end;
    isLoading.value = true;

    try {
      reportExpenses.value = await getExpensesInRangeUseCase.call(
        start,
        end,
      );
      filterReportExpensesByCategory();
      await calculateBudgetForRange(start, end);
      await checkMissingBudgets();
    } catch (e, stackTrace) {
      ExceptionHandler.handle(e, stackTrace, 'ExpenseReportController.fetchExpensesInRange');
      reportExpenses.value = [];
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> checkMissingBudgets() async {
    final prefs = await SharedPreferences.getInstance();
    final ignorePrompt = prefs.getBool('ignore_missing_budget_prompt') ?? false;
    if (ignorePrompt) {
      missingBudgetMonths.clear();
      return;
    }

    final start = startDate.value;
    final end = endDate.value;
    if (start == null || end == null) return;

    final budgetController = Get.find<BudgetController>();
    final Map<DateTime, double> monthlyExpenses = {};
    for (var expense in reportExpenses) {
      final monthStart = DateTime(expense.date.year, expense.date.month, 1);
      monthlyExpenses[monthStart] = (monthlyExpenses[monthStart] ?? 0.0) + expense.amount;
    }

    final DateTime now = DateTime.now();
    final DateTime currentMonthStart = DateTime(now.year, now.month, 1);

    final List<DateTime> missing = [];
    for (var monthStart in monthlyExpenses.keys) {
      if (monthStart.isBefore(currentMonthStart)) {
        final budget = await budgetController.getBudgetForMonth(monthStart);
        if (budget <= 0.0) {
          missing.add(monthStart);
        }
      }
    }

    if (missing.isNotEmpty) {
      missing.sort((a, b) => a.compareTo(b));
      missingBudgetMonths.value = missing;
    } else {
      missingBudgetMonths.clear();
    }
  }

  Future<void> ignoreMissingBudgetPrompt() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('ignore_missing_budget_prompt', true);
    missingBudgetMonths.clear();
  }

  Future<void> saveBudgetForMonths(List<DateTime> months, double amount) async {
    final budgetController = Get.find<BudgetController>();
    for (var month in months) {
      final String monthDocId = DateFormat('yyyy-MMMM').format(month);
      final localDb = LocalDbService();
      Map<ExpenseCategory, double> categories = {};
      final localData = localDb.budgetsBox.get(monthDocId) ?? localDb.budgetsBox.get('recurring');
      if (localData != null && localData['categoryBudgets'] is Map) {
        final map = localData['categoryBudgets'] as Map;
        map.forEach((k, v) {
          final cat = ExpenseCategoryExtension.fromString(k.toString());
          categories[cat] = (v as num).toDouble();
        });
      }

      await budgetController.saveBudgetsForMonth(
        month: month,
        overall: amount,
        categories: categories,
        isRecurring: false,
      );
    }
    missingBudgetMonths.clear();
    final start = startDate.value;
    final end = endDate.value;
    if (start != null && end != null) {
      await calculateBudgetForRange(start, end);
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
    
    if (selectedCategories.isNotEmpty) {
      temp = temp.where((expense) => selectedCategories.contains(expense.category)).toList();
    } else if (selectedCategory.value != 'All') {
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
    updateReportTotalExpense();
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
