import '../entities/income_category/income_category_entity.dart';
import '../repositories/income_repository.dart';

class AddIncomeCategoryUseCase {
  final IncomeRepository repository;

  AddIncomeCategoryUseCase(this.repository);

  Future<void> call(IncomeCategoryEntity category) async {
    await repository.addCategory(category);
  }
}
