import '../entities/expense_entity.dart';
import '../entities/expense_category_entity.dart';

abstract class ExpenseRepository {
  Future<void> addExpense(ExpenseEntity expense);

  Future<void> updateExpense(ExpenseEntity expense);

  Future<void> deleteExpense(String id);

  Future<List<ExpenseEntity>> getExpenses();

  Future<ExpenseEntity?> getExpenseById(String id);

  Future<List<ExpenseEntity>> getExpensesForMonth(
    DateTime selectedMonth,
  );

  Future<List<ExpenseEntity>> getExpensesInRange(
    DateTime start,
    DateTime end,
  );

  Future<double> getTotalExpensesForMonth(
    DateTime selectedMonth,
  );

  // ExpenseCategory CRUD
  Future<void> addCategory(ExpenseCategoryEntity category);
  Future<List<ExpenseCategoryEntity>> getCategories();
  Future<void> updateCategory(ExpenseCategoryEntity category);
  Future<void> deleteCategory(String id);
}
