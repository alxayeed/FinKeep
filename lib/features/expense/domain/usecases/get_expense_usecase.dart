import '../entities/expense_entity.dart';
import '../repositories/expense_repository.dart';

class GetExpenseUseCase {
  final ExpenseRepository repository;

  GetExpenseUseCase(this.repository);

  Future<ExpenseEntity?> call(String id) async {
    if (id.isEmpty) {
      throw Exception('Invalid ID');
    }
    return await repository.getExpenseById(id);
  }
}
