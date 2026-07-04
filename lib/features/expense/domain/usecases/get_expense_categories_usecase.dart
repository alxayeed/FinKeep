import '../entities/expense_category_entity.dart';
import '../repositories/expense_repository.dart';

class GetExpenseCategoriesUseCase {
  final ExpenseRepository repository;

  GetExpenseCategoriesUseCase(this.repository);

  Future<List<ExpenseCategoryEntity>> call() async {
    return await repository.getCategories();
  }
}
