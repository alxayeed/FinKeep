import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entity/lend_entity.dart';

abstract class LendingRepository {
  // Future<Either<Failure, LendingEntity>> createLending(LendingEntity lending);

  Future<Either<Failure, List<LendingEntity>>> getAllLendings();
}
