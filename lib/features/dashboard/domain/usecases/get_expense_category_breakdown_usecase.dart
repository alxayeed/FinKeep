import '../entities/dashboard_category_breakdown_entity.dart';
import '../repositories/dashboard_repository.dart';

class GetExpenseCategoryBreakdownUseCase {
  final DashboardRepository repository;

  GetExpenseCategoryBreakdownUseCase(this.repository);

  Future<List<DashboardCategoryBreakdownEntity>> call(
    DateTime start,
    DateTime end,
  ) async {
    return await repository.getExpenseCategoryBreakdown(start, end);
  }
}
