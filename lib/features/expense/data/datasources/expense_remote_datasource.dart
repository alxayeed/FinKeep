import '../models/expense_model.dart';

abstract class ExpenseRemoteDataSource {
  Future<void> createExpense(ExpenseModel expense);

  Future<ExpenseModel?> getExpenseById(String id);

  Future<List<ExpenseModel>> getExpenses(String userId);

  Future<void> updateExpense(ExpenseModel expense);

  Future<void> deleteExpense(String id);

  Future<List<ExpenseModel>> getExpensesForMonth(
    String userId,
    DateTime selectedMonth,
  );

  Future<List<ExpenseModel>> getExpensesInRange(
    String userId,
    DateTime start,
    DateTime end,
  );

  Future<double> getTotalExpensesForMonth(
    String userId,
    DateTime selectedMonth,
  );
}
