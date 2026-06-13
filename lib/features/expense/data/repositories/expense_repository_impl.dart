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
    await localDataSource.createExpense(expense.toModel());
    if (AppConfig.isPersonal) {
      try {
        await remoteDataSource.createExpense(expense.toModel());
      } catch (e) {
        // Will be picked up by the offline sync queue in Step 6
      }
    }
  }

  @override
  Future<void> updateExpense(ExpenseEntity expense) async {
    await localDataSource.updateExpense(expense.toModel());
    if (AppConfig.isPersonal) {
      try {
        await remoteDataSource.updateExpense(expense.toModel());
      } catch (e) {
        // Sync queue will process it
      }
    }
  }

  @override
  Future<void> deleteExpense(String id) async {
    await localDataSource.deleteExpense(id);
    if (AppConfig.isPersonal) {
      try {
        await remoteDataSource.deleteExpense(id);
      } catch (e) {
        // Sync queue will process it
      }
    }
  }

  @override
  Future<List<ExpenseEntity>> getExpenses(String userId) async {
    // Offline-first: read locally.
    final localExpenses = await localDataSource.getExpenses(userId);
    return localExpenses.map((model) => model.toEntity()).toList();
  }

  @override
  Future<ExpenseEntity?> getExpenseById(String id) async {
    final localModel = await localDataSource.getExpenseById(id);
    return localModel?.toEntity();
  }

  @override
  Future<List<ExpenseEntity>> getExpensesForMonth(
    String userId,
    DateTime selectedMonth,
  ) async {
    final localExpenses = await localDataSource.getExpensesForMonth(userId, selectedMonth);
    return localExpenses.map((model) => model.toEntity()).toList();
  }

  @override
  Future<List<ExpenseEntity>> getExpensesInRange(
    String userId,
    DateTime start,
    DateTime end,
  ) async {
    final localExpenses = await localDataSource.getExpensesInRange(userId, start, end);
    return localExpenses.map((model) => model.toEntity()).toList();
  }

  @override
  Future<double> getTotalExpensesForMonth(
    String userId,
    DateTime selectedMonth,
  ) async {
    return await localDataSource.getTotalExpensesForMonth(userId, selectedMonth);
  }
}
