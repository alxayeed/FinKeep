import 'package:finkeep/features/income/data/models/income/income_model.dart';
import 'package:finkeep/features/income/data/models/income_category/income_category_model.dart';
import 'package:finkeep/features/income/data/datasources/income_local_datasource.dart';
import 'package:finkeep/core/services/local_db_service.dart';

class IncomeHiveDataSource implements IncomeLocalDataSource {
  final LocalDbService localDb;

  IncomeHiveDataSource({required this.localDb}) {
    _seedDefaultCategoriesIfNeeded();
  }

  Future<void> _seedDefaultCategoriesIfNeeded() async {
    if (localDb.incomeCategoriesBox.isEmpty) {
      final defaults = [
        const IncomeCategoryModel(id: 'cat_salary', displayLabel: 'Salary', emoji: '💼', isCustom: false),
        const IncomeCategoryModel(id: 'cat_freelance', displayLabel: 'Freelance', emoji: '💻', isCustom: false),
        const IncomeCategoryModel(id: 'cat_business', displayLabel: 'Business', emoji: '📈', isCustom: false),
        const IncomeCategoryModel(id: 'cat_allowance', displayLabel: 'Allowance', emoji: '🎁', isCustom: false),
        const IncomeCategoryModel(id: 'cat_investment', displayLabel: 'Investment', emoji: '🪙', isCustom: false),
        const IncomeCategoryModel(id: 'cat_other', displayLabel: 'Other', emoji: '💰', isCustom: false),
      ];
      for (final cat in defaults) {
        await localDb.incomeCategoriesBox.put(cat.id, cat.toJson());
      }
    }
  }

  IncomeModel _mapIncome(Map<dynamic, dynamic> json) =>
      IncomeModel.fromJson(Map<String, dynamic>.from(json));

  IncomeCategoryModel _mapCategory(Map<dynamic, dynamic> json) =>
      IncomeCategoryModel.fromJson(Map<String, dynamic>.from(json));

  // --- Income CRUD ---
  @override
  Future<void> createIncome(IncomeModel income) async {
    await localDb.incomeBox.put(income.id, income.toJson());
  }

  @override
  Future<IncomeModel?> getIncomeById(String id) async {
    final raw = localDb.incomeBox.get(id);
    if (raw != null) {
      return _mapIncome(raw);
    }
    return null;
  }

  @override
  Future<List<IncomeModel>> getIncomes() async {
    final list = localDb.incomeBox.values
        .map((raw) => _mapIncome(raw))
        .toList();
    list.sort((a, b) => b.date.compareTo(a.date));
    return list;
  }

  @override
  Future<void> updateIncome(IncomeModel income) async {
    await localDb.incomeBox.put(income.id, income.toJson());
  }

  @override
  Future<void> deleteIncome(String id) async {
    await localDb.incomeBox.delete(id);
  }

  @override
  Future<List<IncomeModel>> getIncomesForMonth(DateTime selectedMonth) async {
    DateTime startOfMonth = DateTime(selectedMonth.year, selectedMonth.month, 1);
    DateTime endOfMonth = DateTime(selectedMonth.year, selectedMonth.month + 1, 1)
        .subtract(const Duration(seconds: 1));

    final list = localDb.incomeBox.values
        .map((raw) => _mapIncome(raw))
        .where((income) =>
            income.date.isAfter(startOfMonth.subtract(const Duration(seconds: 1))) &&
            income.date.isBefore(endOfMonth.add(const Duration(seconds: 1))))
        .toList();
    list.sort((a, b) => b.date.compareTo(a.date));
    return list;
  }

  @override
  Future<List<IncomeModel>> getIncomesInRange(DateTime start, DateTime end) async {
    final list = localDb.incomeBox.values
        .map((raw) => _mapIncome(raw))
        .where((income) =>
            income.date.isAfter(start.subtract(const Duration(seconds: 1))) &&
            income.date.isBefore(end.add(const Duration(seconds: 1))))
        .toList();
    list.sort((a, b) => b.date.compareTo(a.date));
    return list;
  }

  @override
  Future<double> getTotalIncomesForMonth(DateTime selectedMonth) async {
    final incomes = await getIncomesForMonth(selectedMonth);
    return incomes.fold<double>(0.0, (acc, income) => acc + income.amount);
  }

  // --- IncomeCategory CRUD ---
  @override
  Future<void> createCategory(IncomeCategoryModel category) async {
    await localDb.incomeCategoriesBox.put(category.id, category.toJson());
  }

  @override
  Future<List<IncomeCategoryModel>> getCategories() async {
    return localDb.incomeCategoriesBox.values
        .map((raw) => _mapCategory(raw))
        .toList();
  }

  @override
  Future<void> updateCategory(IncomeCategoryModel category) async {
    await localDb.incomeCategoriesBox.put(category.id, category.toJson());
  }

  @override
  Future<void> deleteCategory(String id) async {
    final raw = localDb.incomeCategoriesBox.get(id);
    if (raw != null) {
      final category = _mapCategory(raw);
      final updated = category.copyWith(isDeleted: true);
      await localDb.incomeCategoriesBox.put(id, updated.toJson());
    }
  }
}
