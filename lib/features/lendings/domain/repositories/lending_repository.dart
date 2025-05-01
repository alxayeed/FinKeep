import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entity/lend_entity.dart';

abstract class LendingRepository {
  Future<Either<Failure, void>> addLending(LendingEntity lending);

  Future<Either<Failure, List<LendingEntity>>> getLendings({
    required String userId,
    LendingType? typeFilter,
    DateTime? monthFilter,
    LendingStatus? statusFilter,
    String? personNameFilter,
  });

  Future<Either<Failure, void>> updateLending(LendingEntity lending);

  Future<Either<Failure, void>> deleteLending(String lendingId);

  Future<Either<Failure, double>> getTotalLendingAmount({
    required String userId,
    LendingType? typeFilter,
    LendingStatus? statusFilter,
    String? personNameFilter,
  });

  Future<Either<Failure, int>> getLendingsCount({
    required String userId,
    LendingType? typeFilter,
    LendingStatus? statusFilter,
    String? personNameFilter,
  });
}
