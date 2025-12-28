import '../entities/expense_entity.dart';
import '../repositories/expense_repository.dart';

class GetExpensesInRangeUseCase {
  final ExpenseRepository repository;

  GetExpensesInRangeUseCase(this.repository);

  Future<List<ExpenseEntity>> call(
    String userId,
    DateTime start,
    DateTime end,
  ) async {
    return await repository.getExpensesInRange(userId, start, end);
  }
}
