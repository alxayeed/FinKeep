
import '../../domain/entities/expense_entity.dart';
import '../../domain/repositories/expense_repository.dart';
import '../datasources/expense_remote_datasource.dart';

class ExpenseRepositoryImpl implements ExpenseRepository {
  final ExpenseRemoteDataSource remoteDataSource;

  ExpenseRepositoryImpl(this.remoteDataSource);

  @override
  Future<void> addExpense(ExpenseEntity expense) async {
    await remoteDataSource.createExpense(expense.toModel());
  }

  @override
  Future<void> updateExpense(ExpenseEntity expense) async {
    await remoteDataSource.updateExpense(expense.toModel());
  }

  @override
  Future<void> deleteExpense(String id) async {
    await remoteDataSource.deleteExpense(id);
  }

  @override
  Future<List<ExpenseEntity>> getExpenses(String userId) async {
    final expenses = await remoteDataSource.getExpenses(userId);
    return expenses.map((expenseModel) => expenseModel.toEntity()).toList();
  }

  @override
  Future<ExpenseEntity?> getExpenseById(String id) async {
    final expenseModel = await remoteDataSource.getExpenseById(id);
    return expenseModel?.toEntity();
  }
}
