import '../entities/income/income_entity.dart';
import '../entities/income_category/income_category_entity.dart';

abstract class IncomeRepository {
  // Income CRUD
  Future<void> addIncome(IncomeEntity income);
  Future<void> updateIncome(IncomeEntity income);
  Future<void> deleteIncome(String id);
  Future<List<IncomeEntity>> getIncomes();
  Future<IncomeEntity?> getIncomeById(String id);
  Future<List<IncomeEntity>> getIncomesForMonth(DateTime selectedMonth);
  Future<List<IncomeEntity>> getIncomesInRange(DateTime start, DateTime end);
  Future<double> getTotalIncomesForMonth(DateTime selectedMonth);

  // IncomeCategory CRUD
  Future<void> addCategory(IncomeCategoryEntity category);
  Future<List<IncomeCategoryEntity>> getCategories();
  Future<void> updateCategory(IncomeCategoryEntity category);
  Future<void> deleteCategory(String id);
}
