import '../entities/expense_category_entity.dart';
import '../repositories/expense_repository.dart';

class AddExpenseCategoryUseCase {
  final ExpenseRepository repository;

  AddExpenseCategoryUseCase(this.repository);

  Future<void> call(ExpenseCategoryEntity category) async {
    await repository.addCategory(category);
  }
}
