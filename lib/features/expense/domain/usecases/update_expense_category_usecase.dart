import '../entities/expense_category_entity.dart';
import '../repositories/expense_repository.dart';

class UpdateExpenseCategoryUseCase {
  final ExpenseRepository repository;

  UpdateExpenseCategoryUseCase(this.repository);

  Future<void> call(ExpenseCategoryEntity category) async {
    await repository.updateCategory(category);
  }
}
