import 'package:dartz/dartz.dart';

import '../../../../../core/error/failure.dart';
import '../../entity/lending/lending_entity.dart';
import '../../repositories/lending_repository.dart';

class UpdateLendingUseCase {
  final LendingRepository repository;

  UpdateLendingUseCase({required this.repository});

  Future<Either<Failure, void>> call(LendingEntity lending) async {
    return await repository.updateLending(lending);
  }
}
