import '../entities/income/income_entity.dart';
import '../repositories/income_repository.dart';

class GetIncomeUseCase {
  final IncomeRepository repository;

  GetIncomeUseCase(this.repository);

  Future<IncomeEntity?> call(String id) async {
    return await repository.getIncomeById(id);
  }
}
