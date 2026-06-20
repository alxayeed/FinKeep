import 'package:spendly/core/config/app_config.dart';
import '../../domain/entities/expense_entity.dart';
import '../../domain/repositories/expense_repository.dart';
import '../datasources/expense_local_datasource.dart';
import '../datasources/expense_remote_datasource.dart';

class ExpenseRepositoryImpl implements ExpenseRepository {
  final ExpenseLocalDataSource localDataSource;
  final ExpenseRemoteDataSource remoteDataSource;

  ExpenseRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<void> addExpense(ExpenseEntity expense) async {
    if (AppConfig.useRemote) {
      await remoteDataSource.createExpense(expense.toModel());
    } else {
      await localDataSource.createExpense(expense.toModel());
    }
  }

  @override
  Future<void> updateExpense(ExpenseEntity expense) async {
    if (AppConfig.useRemote) {
      await remoteDataSource.updateExpense(expense.toModel());
    } else {
      await localDataSource.updateExpense(expense.toModel());
    }
  }

  @override
  Future<void> deleteExpense(String id) async {
    if (AppConfig.useRemote) {
      await remoteDataSource.deleteExpense(id);
    } else {
      await localDataSource.deleteExpense(id);
    }
  }

  @override
  Future<ExpenseEntity?> getExpenseById(String id) async {
    if (AppConfig.useRemote) {
      final model = await remoteDataSource.getExpenseById(id);
      return model?.toEntity();
    } else {
      final model = await localDataSource.getExpenseById(id);
      return model?.toEntity();
    }
  }

  @override
  Future<List<ExpenseEntity>> getExpenses() async {
    if (AppConfig.useRemote) {
      final models = await remoteDataSource.getExpenses();
      return models.map((m) => m.toEntity()).toList();
    } else {
      final models = await localDataSource.getExpenses();
      return models.map((m) => m.toEntity()).toList();
    }
  }

  @override
  Future<List<ExpenseEntity>> getExpensesForMonth(DateTime selectedMonth) async {
    if (AppConfig.useRemote) {
      final models = await remoteDataSource.getExpensesForMonth(selectedMonth);
      return models.map((m) => m.toEntity()).toList();
    } else {
      final models = await localDataSource.getExpensesForMonth(selectedMonth);
      return models.map((m) => m.toEntity()).toList();
    }
  }

  @override
  Future<List<ExpenseEntity>> getExpensesInRange(DateTime start, DateTime end) async {
    if (AppConfig.useRemote) {
      final models = await remoteDataSource.getExpensesInRange(start, end);
      return models.map((m) => m.toEntity()).toList();
    } else {
      final models = await localDataSource.getExpensesInRange(start, end);
      return models.map((m) => m.toEntity()).toList();
    }
  }

  @override
  Future<double> getTotalExpensesForMonth(DateTime selectedMonth) async {
    if (AppConfig.useRemote) {
      return await remoteDataSource.getTotalExpensesForMonth(selectedMonth);
    } else {
      return await localDataSource.getTotalExpensesForMonth(selectedMonth);
    }
  }
}
