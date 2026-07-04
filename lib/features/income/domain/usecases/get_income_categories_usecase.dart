import '../entities/income_category/income_category_entity.dart';
import '../repositories/income_repository.dart';

class GetIncomeCategoriesUseCase {
  final IncomeRepository repository;

  GetIncomeCategoriesUseCase(this.repository);

  Future<List<IncomeCategoryEntity>> call() async {
    return await repository.getCategories();
  }
}
