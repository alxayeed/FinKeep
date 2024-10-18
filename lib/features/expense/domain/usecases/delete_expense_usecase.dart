import '../repositories/expense_repository.dart';

class DeleteExpenseUseCase {
  final ExpenseRepository repository;

  DeleteExpenseUseCase(this.repository);

  Future<void> call(String id) async {
    if (id.isEmpty) {
      throw Exception('Invalid ID');
    }
    await repository.deleteExpense(id);
  }
}