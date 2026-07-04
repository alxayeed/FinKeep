import '../repositories/expense_repository.dart';

class DeleteExpenseCategoryUseCase {
  final ExpenseRepository repository;

  DeleteExpenseCategoryUseCase(this.repository);

  Future<void> call(String id) async {
    await repository.deleteCategory(id);
  }
}
