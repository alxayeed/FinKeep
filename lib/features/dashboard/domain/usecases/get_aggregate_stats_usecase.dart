import '../entities/dashboard_aggregate_stats_entity.dart';
import '../repositories/dashboard_repository.dart';

class GetAggregateStatsUseCase {
  final DashboardRepository repository;

  GetAggregateStatsUseCase(this.repository);

  Future<DashboardAggregateStatsEntity> call(
    DateTime start,
    DateTime end,
  ) async {
    return await repository.getAggregateStats(start, end);
  }
}
