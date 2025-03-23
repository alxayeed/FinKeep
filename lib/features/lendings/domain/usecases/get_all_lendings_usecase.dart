import 'package:dartz/dartz.dart';
import 'package:spendly/core/error/failure.dart';
import 'package:spendly/features/lendings/domain/entity/lend_entity.dart';
import 'package:spendly/features/lendings/domain/repositories/lending_repository.dart';

class GetAllLendingsUseCase {
  final LendingRepository lendingRepository;

  GetAllLendingsUseCase(this.lendingRepository);

  Future<Either<Failure, List<LendingEntity>>> call() {
    return lendingRepository.getAllLendings();
  }
}
