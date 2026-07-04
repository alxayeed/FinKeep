import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:finkeep/core/error/exception_handler.dart';
import '../../domain/entities/income/income_entity.dart';
import '../../domain/entities/income_category/income_category_entity.dart';
import '../../domain/usecases/add_income_usecase.dart';
import '../../domain/usecases/delete_income_usecase.dart';
import '../../domain/usecases/get_income_usecase.dart';
import '../../domain/usecases/get_incomes_for_month_usecase.dart';
import '../../domain/usecases/get_incomes_in_range_usecase.dart';
import '../../domain/usecases/get_incomes_usecase.dart';
import '../../domain/usecases/update_income_usecase.dart';
import 'income_category_controller.dart';

class IncomeController extends GetxController {
  final AddIncomeUseCase addIncomeUseCase;
  final GetIncomeUseCase getIncomeUseCase;
  final GetIncomesUseCase getIncomesUseCase;
  final GetIncomesForMonthUseCase getIncomesForMonthUseCase;
  final GetIncomesInRangeUseCase getIncomesInRangeUseCase;
  final UpdateIncomeUseCase updateIncomeUseCase;
  final DeleteIncomeUseCase deleteIncomeUseCase;
  final IncomeCategoryController categoryController;

  IncomeController({
    required this.addIncomeUseCase,
    required this.getIncomeUseCase,
    required this.getIncomesUseCase,
    required this.getIncomesForMonthUseCase,
    required this.getIncomesInRangeUseCase,
    required this.updateIncomeUseCase,
    required this.deleteIncomeUseCase,
    required this.categoryController,
  });

  var incomes = <IncomeEntity>[].obs;
  var isLoading = false.obs;
  var totalIncome = 0.0.obs;

  var selectedCategory = 'All'.obs; // Category ID or 'All'
  var searchQuery = ''.obs;
  var filteredIncomes = <IncomeEntity>[].obs;
  Rx<DateTime> selectedMonth = DateTime.now().obs;
  bool shouldRefresh = false;

  @override
  void onInit() {
    super.onInit();
    fetchMonthlyIncomes();
  }

  Future<void> fetchMonthlyIncomes() async {
    isLoading.value = true;
    try {
      final list = await getIncomesForMonthUseCase(selectedMonth.value);
      incomes.assignAll(list);
      updateTotalIncome();
      filterIncomes();
    } catch (e, stackTrace) {
      ExceptionHandler.handle(e, stackTrace, 'IncomeController.fetchMonthlyIncomes');
    } finally {
      isLoading.value = false;
      shouldRefresh = false;
    }
  }

  void filterIncomes() {
    final query = searchQuery.value.trim().toLowerCase();
    List<IncomeEntity> temp = incomes;

    if (selectedCategory.value != 'All') {
      temp = temp.where((inc) => inc.categoryId == selectedCategory.value).toList();
    }

    if (query.isNotEmpty) {
      temp = temp.where((inc) {
        final cat = categoryController.categories.firstWhereOrNull((c) => c.id == inc.categoryId);
        final catLabel = cat?.displayLabel.toLowerCase() ?? '';
        return inc.description.toLowerCase().contains(query) ||
            inc.amount.toString().contains(query) ||
            catLabel.contains(query);
      }).toList();
    }

    filteredIncomes.assignAll(temp);
  }

  void updateSelectedCategory(String categoryId) {
    selectedCategory.value = categoryId;
    filterIncomes();
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
    filterIncomes();
  }

  void updateSelectedMonth(DateTime newMonth) {
    selectedMonth.value = newMonth;
    fetchMonthlyIncomes();
  }

  void updateTotalIncome() {
    totalIncome.value = incomes.fold(0.0, (acc, item) => acc + item.amount);
  }

  Future<void> createIncome(
    IncomeEntity income, {
    VoidCallback? onSuccess,
    Function(dynamic)? onError,
  }) async {
    try {
      await addIncomeUseCase(income);
      onSuccess?.call();
      await fetchMonthlyIncomes();
    } catch (e, stackTrace) {
      onError?.call(e);
      ExceptionHandler.handle(e, stackTrace, 'IncomeController.createIncome');
    }
  }

  Future<void> editIncome(
    IncomeEntity income, {
    VoidCallback? onSuccess,
    Function(dynamic)? onError,
  }) async {
    try {
      await updateIncomeUseCase(income);
      onSuccess?.call();
      await fetchMonthlyIncomes();
    } catch (e, stackTrace) {
      onError?.call(e);
      ExceptionHandler.handle(e, stackTrace, 'IncomeController.editIncome');
    }
  }

  Future<void> removeIncome(
    String id, {
    VoidCallback? onSuccess,
    Function(dynamic)? onError,
  }) async {
    try {
      await deleteIncomeUseCase(id);
      onSuccess?.call();
      await fetchMonthlyIncomes();
    } catch (e, stackTrace) {
      onError?.call(e);
      ExceptionHandler.handle(e, stackTrace, 'IncomeController.removeIncome');
    }
  }

  // --- Merged Filtering Logic for Categories ---
  List<IncomeCategoryEntity> get filterCategories {
    final active = categoryController.categories.where((c) => !c.isDeleted).toList();
    final deleted = categoryController.categories.where((c) => c.isDeleted).toList();

    // Set of category IDs in currently fetched month
    final loadedCategoryIds = incomes.map((e) => e.categoryId).toSet();

    // Include deleted categories only if they have entries in this month
    final usedDeleted = deleted.where((c) => loadedCategoryIds.contains(c.id)).toList();

    return [...active, ...usedDeleted];
  }

  // --- Grouping logs for chronological display ---
  List<Object> get groupedIncomes {
    if (filteredIncomes.isEmpty) return [];

    final Map<DateTime, List<IncomeEntity>> groupedMap = {};
    final Map<DateTime, double> dailyTotals = {};

    for (var income in filteredIncomes) {
      final dateKey = DateTime(
        income.date.year,
        income.date.month,
        income.date.day,
      );

      if (groupedMap[dateKey] == null) {
        groupedMap[dateKey] = [];
        dailyTotals[dateKey] = 0.0;
      }

      groupedMap[dateKey]!.add(income);
      dailyTotals[dateKey] = dailyTotals[dateKey]! + income.amount;
    }

    final List<Object> flattened = [];
    final sortedDates = groupedMap.keys.toList()..sort((a, b) => b.compareTo(a));

    for (var date in sortedDates) {
      flattened.add({'date': date, 'total': dailyTotals[date]});
      final dayIncomes = groupedMap[date]!..sort((a, b) => b.date.compareTo(a.date));
      flattened.addAll(dayIncomes);
    }

    return flattened;
  }
}
