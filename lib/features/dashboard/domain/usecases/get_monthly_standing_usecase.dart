import '../entities/monthly_standing_entity.dart';
import '../repositories/dashboard_repository.dart';

class GetMonthlyStandingUseCase {
  final DashboardRepository repository;

  GetMonthlyStandingUseCase(this.repository);

  Future<MonthlyStandingEntity> call(DateTime start, [DateTime? end]) async {
    return await repository.getMonthlyStanding(start, end);
  }
}
