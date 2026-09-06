import '../entities/category_delete_result.dart';
import '../repositories/expense_repository.dart';

class DeleteExpenseCategoryUseCase {
  final ExpenseRepository repository;

  DeleteExpenseCategoryUseCase(this.repository);

  Future<CategoryDeleteResult> call(String id) async {
    return await repository.deleteCategory(id);
  }
}
