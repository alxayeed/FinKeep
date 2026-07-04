import '../entities/income/income_entity.dart';
import '../repositories/income_repository.dart';

class GetIncomesInRangeUseCase {
  final IncomeRepository repository;

  GetIncomesInRangeUseCase(this.repository);

  Future<List<IncomeEntity>> call(DateTime start, DateTime end) async {
    return await repository.getIncomesInRange(start, end);
  }
}
