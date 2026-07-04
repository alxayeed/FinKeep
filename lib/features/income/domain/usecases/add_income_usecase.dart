import '../entities/income/income_entity.dart';
import '../repositories/income_repository.dart';

class AddIncomeUseCase {
  final IncomeRepository repository;

  AddIncomeUseCase(this.repository);

  Future<void> call(IncomeEntity income) async {
    if (income.amount <= 0) {
      throw Exception('Amount must be greater than zero');
    }
    await repository.addIncome(income);
  }
}
