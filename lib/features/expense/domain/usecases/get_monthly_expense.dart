import '../entities/expense_entity.dart';
import '../repositories/expense_repository.dart';

class GetMonthlyExpensesUseCase {
  final ExpenseRepository repository;

  GetMonthlyExpensesUseCase(this.repository);

  Future<List<ExpenseEntity>> call(String userId, DateTime month) async {
    if (userId.isEmpty) {
      throw Exception('User ID cannot be empty');
    }
    return await repository.getExpensesForMonth("dummy_user_id", month);
  }
}