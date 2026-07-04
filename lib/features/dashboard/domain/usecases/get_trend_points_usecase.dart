import '../entities/dashboard_trend_point_entity.dart';
import '../repositories/dashboard_repository.dart';

class GetTrendPointsUseCase {
  final DashboardRepository repository;

  GetTrendPointsUseCase(this.repository);

  Future<List<DashboardTrendPointEntity>> call(
    DateTime start,
    DateTime end,
  ) async {
    return await repository.getTrendPoints(start, end);
  }
}
