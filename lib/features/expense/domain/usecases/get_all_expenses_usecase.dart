import '../entities/expense_entity.dart';
import '../repositories/expense_repository.dart';

class GetAllExpensesUseCase {
  final ExpenseRepository repository;

  GetAllExpensesUseCase(this.repository);

  Future<List<ExpenseEntity>> call() async {
    return await repository.getExpenses();
  }
}
