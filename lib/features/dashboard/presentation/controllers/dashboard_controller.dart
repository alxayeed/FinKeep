import 'package:get/get.dart';
import '../../domain/entities/dashboard_aggregate_stats_entity.dart';
import '../../domain/entities/dashboard_category_breakdown_entity.dart';
import '../../domain/entities/dashboard_trend_point_entity.dart';
import '../../domain/entities/dashboard_recent_activity_entity.dart';
import '../../domain/entities/dashboard_timeframe.dart';
import '../../domain/usecases/usecases.dart';

class DashboardController extends GetxController {
  final GetAggregateStatsUseCase getAggregateStatsUseCase;
  final GetExpenseCategoryBreakdownUseCase getExpenseCategoryBreakdownUseCase;
  final GetIncomeCategoryBreakdownUseCase getIncomeCategoryBreakdownUseCase;
  final GetTrendPointsUseCase getTrendPointsUseCase;
  final GetRecentActivitiesUseCase getRecentActivitiesUseCase;

  DashboardController({
    required this.getAggregateStatsUseCase,
    required this.getExpenseCategoryBreakdownUseCase,
    required this.getIncomeCategoryBreakdownUseCase,
    required this.getTrendPointsUseCase,
    required this.getRecentActivitiesUseCase,
  });

  // Timeframe selection states
  final timeframe = DashboardTimeframe.currentMonth.obs;
  final customStartDate = Rxn<DateTime>();
  final customEndDate = Rxn<DateTime>();

  // 1. Stats state
  final stats = Rxn<DashboardAggregateStatsEntity>();
  final statsLoading = false.obs;
  final statsError = ''.obs;

  // 2. Expense breakdown state
  final expenseBreakdown = <DashboardCategoryBreakdownEntity>[].obs;
  final expenseBreakdownLoading = false.obs;
  final expenseBreakdownError = ''.obs;

  // 3. Income breakdown state
  final incomeBreakdown = <DashboardCategoryBreakdownEntity>[].obs;
  final incomeBreakdownLoading = false.obs;
  final incomeBreakdownError = ''.obs;

  // 4. Trends state
  final trends = <DashboardTrendPointEntity>[].obs;
  final trendsLoading = false.obs;
  final trendsError = ''.obs;

  // 5. Recent Activities state
  final recentActivities = <DashboardRecentActivityEntity>[].obs;
  final recentActivitiesLoading = false.obs;
  final recentActivitiesError = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllDashboardData();
    // React to changes in timeframe
    ever(timeframe, (_) => fetchAllDashboardData());
  }

  void fetchAllDashboardData() {
    final range = _getDateRange();
    if (range == null) return;

    final start = range['start']!;
    final end = range['end']!;

    fetchAggregateStats(start, end);
    fetchExpenseCategoryBreakdown(start, end);
    fetchIncomeCategoryBreakdown(start, end);
    fetchTrendPoints(start, end);
    fetchRecentActivities(start, end);
  }

  Future<void> fetchAggregateStats(DateTime start, DateTime end) async {
    statsLoading.value = true;
    statsError.value = '';
    try {
      final result = await getAggregateStatsUseCase(start, end);
      stats.value = result;
    } catch (e) {
      statsError.value = 'Failed to load stats: $e';
    } finally {
      statsLoading.value = false;
    }
  }

  Future<void> fetchExpenseCategoryBreakdown(DateTime start, DateTime end) async {
    expenseBreakdownLoading.value = true;
    expenseBreakdownError.value = '';
    try {
      final result = await getExpenseCategoryBreakdownUseCase(start, end);
      expenseBreakdown.assignAll(result);
    } catch (e) {
      expenseBreakdownError.value = 'Failed to load expense categories: $e';
    } finally {
      expenseBreakdownLoading.value = false;
    }
  }

  Future<void> fetchIncomeCategoryBreakdown(DateTime start, DateTime end) async {
    incomeBreakdownLoading.value = true;
    incomeBreakdownError.value = '';
    try {
      final result = await getIncomeCategoryBreakdownUseCase(start, end);
      incomeBreakdown.assignAll(result);
    } catch (e) {
      incomeBreakdownError.value = 'Failed to load income categories: $e';
    } finally {
      incomeBreakdownLoading.value = false;
    }
  }

  Future<void> fetchTrendPoints(DateTime start, DateTime end) async {
    trendsLoading.value = true;
    trendsError.value = '';
    try {
      final result = await getTrendPointsUseCase(start, end);
      trends.assignAll(result);
    } catch (e) {
      trendsError.value = 'Failed to load trends: $e';
    } finally {
      trendsLoading.value = false;
    }
  }

  Future<void> fetchRecentActivities(DateTime start, DateTime end) async {
    recentActivitiesLoading.value = true;
    recentActivitiesError.value = '';
    try {
      final result = await getRecentActivitiesUseCase(start, end);
      recentActivities.assignAll(result);
    } catch (e) {
      recentActivitiesError.value = 'Failed to load recent activity: $e';
    } finally {
      recentActivitiesLoading.value = false;
    }
  }

  void updateTimeframe(DashboardTimeframe newTimeframe) {
    timeframe.value = newTimeframe;
  }

  void setCustomRange(DateTime start, DateTime end) {
    customStartDate.value = start;
    customEndDate.value = end;
    timeframe.value = DashboardTimeframe.custom;
    fetchAllDashboardData();
  }

  Map<String, DateTime>? _getDateRange() {
    final now = DateTime.now();
    switch (timeframe.value) {
      case DashboardTimeframe.currentMonth:
        final start = DateTime(now.year, now.month, 1);
        final end = DateTime(now.year, now.month + 1, 0, 23, 59, 59);
        return {'start': start, 'end': end};
      case DashboardTimeframe.last3Months:
        final start = DateTime(now.year, now.month - 2, 1);
        final end = DateTime(now.year, now.month + 1, 0, 23, 59, 59);
        return {'start': start, 'end': end};
      case DashboardTimeframe.last6Months:
        final start = DateTime(now.year, now.month - 5, 1);
        final end = DateTime(now.year, now.month + 1, 0, 23, 59, 59);
        return {'start': start, 'end': end};
      case DashboardTimeframe.last12Months:
        final start = DateTime(now.year, now.month - 11, 1);
        final end = DateTime(now.year, now.month + 1, 0, 23, 59, 59);
        return {'start': start, 'end': end};
      case DashboardTimeframe.custom:
        if (customStartDate.value != null && customEndDate.value != null) {
          final end = DateTime(
            customEndDate.value!.year,
            customEndDate.value!.month,
            customEndDate.value!.day,
            23,
            59,
            59,
          );
          return {'start': customStartDate.value!, 'end': end};
        }
        return null;
    }
  }
}
