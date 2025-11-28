import '../entities/expense_entity.dart';

abstract class ExpenseRepository {
  Future<void> addExpense(ExpenseEntity expense);

  Future<void> updateExpense(ExpenseEntity expense);

  Future<void> deleteExpense(String id);

  Future<List<ExpenseEntity>> getExpenses(String userId);

  Future<ExpenseEntity?> getExpenseById(String id);

  Future<List<ExpenseEntity>> getExpensesForMonth(
      String userId, DateTime selectedMonth);

  Future<List<ExpenseEntity>> getExpensesInRange(
    String userId,
    DateTime start,
    DateTime end,
  );
}
