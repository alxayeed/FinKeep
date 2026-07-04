import '../models/income/income_model.dart';
import '../models/income_category/income_category_model.dart';

abstract class IncomeLocalDataSource {
  // Income CRUD
  Future<void> createIncome(IncomeModel income);
  Future<IncomeModel?> getIncomeById(String id);
  Future<List<IncomeModel>> getIncomes();
  Future<void> updateIncome(IncomeModel income);
  Future<void> deleteIncome(String id);
  Future<List<IncomeModel>> getIncomesForMonth(DateTime selectedMonth);
  Future<List<IncomeModel>> getIncomesInRange(DateTime start, DateTime end);
  Future<double> getTotalIncomesForMonth(DateTime selectedMonth);

  // IncomeCategory CRUD
  Future<void> createCategory(IncomeCategoryModel category);
  Future<List<IncomeCategoryModel>> getCategories();
  Future<void> updateCategory(IncomeCategoryModel category);
  Future<void> deleteCategory(String id);
}
