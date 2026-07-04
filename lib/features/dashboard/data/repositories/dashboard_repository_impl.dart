import 'package:finkeep/core/config/app_config.dart';

import '../../domain/entities/dashboard_aggregate_stats_entity.dart';
import '../../domain/entities/dashboard_category_breakdown_entity.dart';
import '../../domain/entities/dashboard_trend_point_entity.dart';
import '../../domain/entities/dashboard_recent_activity_entity.dart';
import '../../domain/entities/monthly_standing_entity.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../datasources/dashboard_local_datasource.dart';
import '../datasources/dashboard_remote_datasource.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardLocalDataSource localDataSource;
  final DashboardRemoteDataSource remoteDataSource;

  DashboardRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<MonthlyStandingEntity> getMonthlyStanding(DateTime month) async {
    final model = AppConfig.useRemote
        ? await remoteDataSource.getMonthlyStanding(month)
        : await localDataSource.getMonthlyStanding(month);
    return model.toEntity();
  }

  @override
  Future<DashboardAggregateStatsEntity> getAggregateStats(
    DateTime start,
    DateTime end,
  ) async {
    final model = AppConfig.useRemote
        ? await remoteDataSource.getAggregateStats(start, end)
        : await localDataSource.getAggregateStats(start, end);
    return model.toEntity();
  }

  @override
  Future<List<DashboardCategoryBreakdownEntity>> getExpenseCategoryBreakdown(
    DateTime start,
    DateTime end,
  ) async {
    final models = AppConfig.useRemote
        ? await remoteDataSource.getExpenseCategoryBreakdown(start, end)
        : await localDataSource.getExpenseCategoryBreakdown(start, end);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<DashboardCategoryBreakdownEntity>> getIncomeCategoryBreakdown(
    DateTime start,
    DateTime end,
  ) async {
    final models = AppConfig.useRemote
        ? await remoteDataSource.getIncomeCategoryBreakdown(start, end)
        : await localDataSource.getIncomeCategoryBreakdown(start, end);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<DashboardTrendPointEntity>> getTrendPoints(
    DateTime start,
    DateTime end,
  ) async {
    final models = AppConfig.useRemote
        ? await remoteDataSource.getTrendPoints(start, end)
        : await localDataSource.getTrendPoints(start, end);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<DashboardRecentActivityEntity>> getRecentActivities(
    DateTime start,
    DateTime end, {
    int limit = 8,
  }) async {
    final models = AppConfig.useRemote
        ? await remoteDataSource.getRecentActivities(start, end, limit: limit)
        : await localDataSource.getRecentActivities(start, end, limit: limit);
    return models.map((m) => m.toEntity()).toList();
  }
}
