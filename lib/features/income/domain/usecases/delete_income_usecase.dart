import '../repositories/income_repository.dart';

class DeleteIncomeUseCase {
  final IncomeRepository repository;

  DeleteIncomeUseCase(this.repository);

  Future<void> call(String id) async {
    await repository.deleteIncome(id);
  }
}
