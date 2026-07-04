import '../entities/dashboard_aggregate_stats_entity.dart';
import '../entities/dashboard_category_breakdown_entity.dart';
import '../entities/dashboard_trend_point_entity.dart';
import '../entities/dashboard_recent_activity_entity.dart';
import '../entities/monthly_standing_entity.dart';

abstract class DashboardRepository {
  /// Fetches monthly standing financial overview data.
  Future<MonthlyStandingEntity> getMonthlyStanding(DateTime month);

  /// Fetches aggregate financial summary stats for the summary card tile.
  Future<DashboardAggregateStatsEntity> getAggregateStats(
    DateTime start,
    DateTime end,
  );

  /// Fetches expense category breakdown for the doughnut chart tile.
  Future<List<DashboardCategoryBreakdownEntity>> getExpenseCategoryBreakdown(
    DateTime start,
    DateTime end,
  );

  /// Fetches income category breakdown for the income chart tile.
  Future<List<DashboardCategoryBreakdownEntity>> getIncomeCategoryBreakdown(
    DateTime start,
    DateTime end,
  );

  /// Fetches daily cumulative trend data for the cash flow line chart tile.
  Future<List<DashboardTrendPointEntity>> getTrendPoints(
    DateTime start,
    DateTime end,
  );

  /// Fetches the most recent N activities for the activity feed tile.
  Future<List<DashboardRecentActivityEntity>> getRecentActivities(
    DateTime start,
    DateTime end, {
    int limit = 8,
  });
}
