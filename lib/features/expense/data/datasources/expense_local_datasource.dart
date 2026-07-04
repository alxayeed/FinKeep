import 'package:finkeep/features/expense/data/models/expense_model.dart';
import '../models/expense_category_model.dart';

abstract class ExpenseLocalDataSource {
  Future<void> createExpense(ExpenseModel expense);

  Future<ExpenseModel?> getExpenseById(String id);

  Future<List<ExpenseModel>> getExpenses();

  Future<void> updateExpense(ExpenseModel expense);

  Future<void> deleteExpense(String id);

  Future<List<ExpenseModel>> getExpensesForMonth(
    DateTime selectedMonth,
  );

  Future<List<ExpenseModel>> getExpensesInRange(
    DateTime start,
    DateTime end,
  );

  Future<double> getTotalExpensesForMonth(
    DateTime selectedMonth,
  );

  // ExpenseCategory CRUD
  Future<void> createCategory(ExpenseCategoryModel category);
  Future<List<ExpenseCategoryModel>> getCategories();
  Future<void> updateCategory(ExpenseCategoryModel category);
  Future<void> deleteCategory(String id);
}
