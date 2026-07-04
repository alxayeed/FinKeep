import 'package:finkeep/core/config/app_config.dart';
import '../../domain/entities/income/income_entity.dart';
import '../../domain/entities/income_category/income_category_entity.dart';
import '../../domain/repositories/income_repository.dart';
import '../../data/models/income/income_model.dart';
import '../../data/models/income_category/income_category_model.dart';
import '../datasources/income_local_datasource.dart';
import '../datasources/income_remote_datasource.dart';

class IncomeRepositoryImpl implements IncomeRepository {
  final IncomeLocalDataSource localDataSource;
  final IncomeRemoteDataSource remoteDataSource;

  IncomeRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  // --- Income CRUD ---
  @override
  Future<void> addIncome(IncomeEntity income) async {
    final model = IncomeModel.fromEntity(income);
    if (AppConfig.useRemote) {
      await remoteDataSource.createIncome(model);
    } else {
      await localDataSource.createIncome(model);
    }
  }

  @override
  Future<void> updateIncome(IncomeEntity income) async {
    final model = IncomeModel.fromEntity(income);
    if (AppConfig.useRemote) {
      await remoteDataSource.updateIncome(model);
    } else {
      await localDataSource.updateIncome(model);
    }
  }

  @override
  Future<void> deleteIncome(String id) async {
    if (AppConfig.useRemote) {
      await remoteDataSource.deleteIncome(id);
    } else {
      await localDataSource.deleteIncome(id);
    }
  }

  @override
  Future<List<IncomeEntity>> getIncomes() async {
    if (AppConfig.useRemote) {
      final list = await remoteDataSource.getIncomes();
      return list.map((m) => m.toEntity()).toList();
    } else {
      final list = await localDataSource.getIncomes();
      return list.map((m) => m.toEntity()).toList();
    }
  }

  @override
  Future<IncomeEntity?> getIncomeById(String id) async {
    if (AppConfig.useRemote) {
      final model = await remoteDataSource.getIncomeById(id);
      return model?.toEntity();
    } else {
      final model = await localDataSource.getIncomeById(id);
      return model?.toEntity();
    }
  }

  @override
  Future<List<IncomeEntity>> getIncomesForMonth(DateTime selectedMonth) async {
    if (AppConfig.useRemote) {
      final list = await remoteDataSource.getIncomesForMonth(selectedMonth);
      return list.map((m) => m.toEntity()).toList();
    } else {
      final list = await localDataSource.getIncomesForMonth(selectedMonth);
      return list.map((m) => m.toEntity()).toList();
    }
  }

  @override
  Future<List<IncomeEntity>> getIncomesInRange(DateTime start, DateTime end) async {
    if (AppConfig.useRemote) {
      final list = await remoteDataSource.getIncomesInRange(start, end);
      return list.map((m) => m.toEntity()).toList();
    } else {
      final list = await localDataSource.getIncomesInRange(start, end);
      return list.map((m) => m.toEntity()).toList();
    }
  }

  @override
  Future<double> getTotalIncomesForMonth(DateTime selectedMonth) async {
    if (AppConfig.useRemote) {
      return await remoteDataSource.getTotalIncomesForMonth(selectedMonth);
    } else {
      return await localDataSource.getTotalIncomesForMonth(selectedMonth);
    }
  }

  // --- Category CRUD ---
  @override
  Future<void> addCategory(IncomeCategoryEntity category) async {
    final model = IncomeCategoryModel.fromEntity(category);
    if (AppConfig.useRemote) {
      await remoteDataSource.createCategory(model);
    } else {
      await localDataSource.createCategory(model);
    }
  }

  @override
  Future<List<IncomeCategoryEntity>> getCategories() async {
    if (AppConfig.useRemote) {
      final list = await remoteDataSource.getCategories();
      return list.map((m) => m.toEntity()).toList();
    } else {
      final list = await localDataSource.getCategories();
      return list.map((m) => m.toEntity()).toList();
    }
  }

  @override
  Future<void> updateCategory(IncomeCategoryEntity category) async {
    final model = IncomeCategoryModel.fromEntity(category);
    if (AppConfig.useRemote) {
      await remoteDataSource.updateCategory(model);
    } else {
      await localDataSource.updateCategory(model);
    }
  }

  @override
  Future<void> deleteCategory(String id) async {
    if (AppConfig.useRemote) {
      await remoteDataSource.deleteCategory(id);
    } else {
      await localDataSource.deleteCategory(id);
    }
  }
}
