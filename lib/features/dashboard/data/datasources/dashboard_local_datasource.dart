import '../models/dashboard_aggregate_stats_model.dart';
import '../models/dashboard_category_breakdown_model.dart';
import '../models/dashboard_recent_activity_model.dart';
import '../models/dashboard_trend_point_model.dart';

abstract class DashboardLocalDataSource {
  /// Returns aggregate financial stats (totals, savings rate, net lendings, etc.)
  /// for the given date range.
  Future<DashboardAggregateStatsModel> getAggregateStats(
    DateTime start,
    DateTime end,
  );

  /// Returns expense category breakdown for the given date range.
  Future<List<DashboardCategoryBreakdownModel>> getExpenseCategoryBreakdown(
    DateTime start,
    DateTime end,
  );

  /// Returns income category breakdown for the given date range.
  Future<List<DashboardCategoryBreakdownModel>> getIncomeCategoryBreakdown(
    DateTime start,
    DateTime end,
  );

  /// Returns daily cumulative trend points for the given date range.
  Future<List<DashboardTrendPointModel>> getTrendPoints(
    DateTime start,
    DateTime end,
  );

  /// Returns the most recent N activities (expenses, incomes, lendings)
  /// within the given date range.
  Future<List<DashboardRecentActivityModel>> getRecentActivities(
    DateTime start,
    DateTime end, {
    int limit = 8,
  });
}
