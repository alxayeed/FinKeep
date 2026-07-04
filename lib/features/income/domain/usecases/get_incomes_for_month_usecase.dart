import '../entities/income/income_entity.dart';
import '../repositories/income_repository.dart';

class GetIncomesForMonthUseCase {
  final IncomeRepository repository;

  GetIncomesForMonthUseCase(this.repository);

  Future<List<IncomeEntity>> call(DateTime selectedMonth) async {
    return await repository.getIncomesForMonth(selectedMonth);
  }
}
