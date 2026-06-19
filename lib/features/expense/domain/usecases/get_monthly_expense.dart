import '../entities/expense_entity.dart';
import '../repositories/expense_repository.dart';

class GetMonthlyExpensesUseCase {
  final ExpenseRepository repository;

  GetMonthlyExpensesUseCase(this.repository);

  Future<List<ExpenseEntity>> call(DateTime month) async {
    return await repository.getExpensesForMonth(month);
  }
}
