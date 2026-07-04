import '../entities/dashboard_category_breakdown_entity.dart';
import '../repositories/dashboard_repository.dart';

class GetIncomeCategoryBreakdownUseCase {
  final DashboardRepository repository;

  GetIncomeCategoryBreakdownUseCase(this.repository);

  Future<List<DashboardCategoryBreakdownEntity>> call(
    DateTime start,
    DateTime end,
  ) async {
    return await repository.getIncomeCategoryBreakdown(start, end);
  }
}
