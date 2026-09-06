import 'package:finkeep/core/config/app_config.dart';
import '../../domain/entities/expense_entity.dart';
import '../../domain/entities/expense_category_entity.dart';
import '../../domain/entities/category_delete_result.dart';
import '../../domain/repositories/expense_repository.dart';
import '../datasources/expense_local_datasource.dart';
import '../datasources/expense_remote_datasource.dart';
import '../models/expense_category_model.dart';

class ExpenseRepositoryImpl implements ExpenseRepository {
  final ExpenseLocalDataSource localDataSource;
  final ExpenseRemoteDataSource remoteDataSource;

  ExpenseRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  // --- Category CRUD ---
  @override
  Future<void> addCategory(ExpenseCategoryEntity category) async {
    final model = ExpenseCategoryModel.fromEntity(category);
    if (AppConfig.useRemote) {
      await remoteDataSource.createCategory(model);
    } else {
      await localDataSource.createCategory(model);
    }
  }

  @override
  Future<List<ExpenseCategoryEntity>> getCategories() async {
    final List<ExpenseCategoryEntity> rawCategories;
    if (AppConfig.useRemote) {
      final models = await remoteDataSource.getCategories();
      rawCategories = models.map((m) => m.toEntity()).toList();
    } else {
      final models = await localDataSource.getCategories();
      rawCategories = models.map((m) => m.toEntity()).toList();
    }

    // Auto-purge stale soft-deleted categories that have zero associated records
    final softDeleted = rawCategories.where((c) => c.isDeleted).toList();
    if (softDeleted.isEmpty) {
      return rawCategories;
    }

    final expenses = AppConfig.useRemote
        ? await remoteDataSource.getExpenses()
        : await localDataSource.getExpenses();

    final activeOrReferenced = <ExpenseCategoryEntity>[];
    for (final cat in rawCategories) {
      if (!cat.isDeleted) {
        activeOrReferenced.add(cat);
      } else {
        final normId = cat.id.toLowerCase();
        final normLabel = cat.displayLabel.toLowerCase();
        final hasRecords = expenses.any((e) {
          final expCat = e.category.toLowerCase();
          return expCat == normId || expCat == normLabel;
        });

        if (hasRecords) {
          activeOrReferenced.add(cat);
        } else {
          // 0 records associated with a soft-deleted category -> purge it from storage permanently
          if (AppConfig.useRemote) {
            await remoteDataSource.deleteCategory(cat.id, hardDelete: true);
          } else {
            await localDataSource.deleteCategory(cat.id, hardDelete: true);
          }
        }
      }
    }

    return activeOrReferenced;
  }

  @override
  Future<void> updateCategory(ExpenseCategoryEntity category) async {
    final model = ExpenseCategoryModel.fromEntity(category);
    if (AppConfig.useRemote) {
      await remoteDataSource.updateCategory(model);
    } else {
      await localDataSource.updateCategory(model);
    }
  }

  @override
  Future<CategoryDeleteResult> deleteCategory(String id) async {
    // 1. Fetch expenses to verify whether any transaction references this category
    final expenses = AppConfig.useRemote
        ? await remoteDataSource.getExpenses()
        : await localDataSource.getExpenses();

    // 2. Fetch raw categories from data source to match target by ID or label
    final rawCategories = AppConfig.useRemote
        ? (await remoteDataSource.getCategories()).map((m) => m.toEntity()).toList()
        : (await localDataSource.getCategories()).map((m) => m.toEntity()).toList();

    final targetCategory = rawCategories.firstWhere(
      (c) => c.id == id || c.displayLabel.toLowerCase() == id.toLowerCase(),
      orElse: () => ExpenseCategoryEntity(id: id, displayLabel: id, emoji: '📦', isCustom: true),
    );

    final normId = targetCategory.id.toLowerCase();
    final normLabel = targetCategory.displayLabel.toLowerCase();

    final hasRecords = expenses.any((e) {
      final expCat = e.category.toLowerCase();
      return expCat == normId || expCat == normLabel;
    });

    if (hasRecords) {
      // At least 1 transaction exists -> Soft delete to preserve historical records safely
      if (AppConfig.useRemote) {
        await remoteDataSource.deleteCategory(targetCategory.id, hardDelete: false);
      } else {
        await localDataSource.deleteCategory(targetCategory.id, hardDelete: false);
      }
      return CategoryDeleteResult.softDeleted;
    } else {
      // 0 transactions exist -> Hard delete permanently from storage
      if (AppConfig.useRemote) {
        await remoteDataSource.deleteCategory(targetCategory.id, hardDelete: true);
      } else {
        await localDataSource.deleteCategory(targetCategory.id, hardDelete: true);
      }
      return CategoryDeleteResult.hardDeleted;
    }
  }

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
