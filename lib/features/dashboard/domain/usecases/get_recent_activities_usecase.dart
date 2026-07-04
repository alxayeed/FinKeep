import '../entities/dashboard_recent_activity_entity.dart';
import '../repositories/dashboard_repository.dart';

class GetRecentActivitiesUseCase {
  final DashboardRepository repository;

  GetRecentActivitiesUseCase(this.repository);

  Future<List<DashboardRecentActivityEntity>> call(
    DateTime start,
    DateTime end, {
    int limit = 8,
  }) async {
    return await repository.getRecentActivities(start, end, limit: limit);
  }
}
