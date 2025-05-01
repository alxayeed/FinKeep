import 'package:dartz/dartz.dart';
import 'package:spendly/core/error/failure.dart';
import 'package:spendly/core/usecase/usecase.dart';
import 'package:spendly/features/lendings/domain/repositories/lending_repository.dart';

import '../entity/lend_entity.dart';

class AddLendingUseCase extends UseCase<void, LendingEntity> {
  final LendingRepository repository;

  AddLendingUseCase({required this.repository});

  @override
  Future<Either<Failure, void>> call(LendingEntity lending) async {
    return await repository.addLending(lending);
  }
}
