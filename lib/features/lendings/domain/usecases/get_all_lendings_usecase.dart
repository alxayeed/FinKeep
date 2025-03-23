import 'package:dartz/dartz.dart';
import 'package:spendly/core/error/failure.dart';
import 'package:spendly/core/usecase/usecase.dart';
import 'package:spendly/features/lendings/domain/entity/lend_entity.dart';
import 'package:spendly/features/lendings/domain/repositories/lending_repository.dart';

class GetAllLendingsUseCase extends UseCase<List<LendingEntity>, NoParams> {
  final LendingRepository lendingRepository;

  GetAllLendingsUseCase(this.lendingRepository);

  @override
  Future<Either<Failure, List<LendingEntity>>> call(NoParams params) {
    return lendingRepository.getAllLendings();
  }
}
