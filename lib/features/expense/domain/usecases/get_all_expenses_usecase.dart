
import '../entities/expense_entity.dart';
import '../repositories/expense_repository.dart';

class GetAllExpensesUseCase {
  final ExpenseRepository repository;

  GetAllExpensesUseCase(this.repository);

  Future<List<ExpenseEntity>> call(String userId) async {
    if (userId.isEmpty) {
      throw Exception('User ID cannot be empty');
    }
    return await repository.getExpenses(userId);
  }
}