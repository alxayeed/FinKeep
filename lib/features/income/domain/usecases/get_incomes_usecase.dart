import '../entities/income/income_entity.dart';
import '../repositories/income_repository.dart';

class GetIncomesUseCase {
  final IncomeRepository repository;

  GetIncomesUseCase(this.repository);

  Future<List<IncomeEntity>> call() async {
    return await repository.getIncomes();
  }
}
