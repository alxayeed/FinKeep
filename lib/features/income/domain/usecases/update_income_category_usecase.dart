import '../entities/income_category/income_category_entity.dart';
import '../repositories/income_repository.dart';

class UpdateIncomeCategoryUseCase {
  final IncomeRepository repository;

  UpdateIncomeCategoryUseCase(this.repository);

  Future<void> call(IncomeCategoryEntity category) async {
    await repository.updateCategory(category);
  }
}
