import '../repositories/income_repository.dart';

class DeleteIncomeCategoryUseCase {
  final IncomeRepository repository;

  DeleteIncomeCategoryUseCase(this.repository);

  Future<void> call(String id) async {
    await repository.deleteCategory(id);
  }
}
