import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entity/lending/lending_entity.dart';
import '../entity/lending_person/lending_person_entity.dart';
import '../entity/repayment/repayment_entity.dart';

abstract class LendingRepository {
  // Lending methods
  Future<Either<Failure, void>> addLending(LendingEntity lending);

  Future<Either<Failure, List<LendingEntity>>> getLendings({
    LendingType? typeFilter,
    DateTime? monthFilter,
    LendingStatus? statusFilter,
    String? personIdFilter,
  });

  Future<Either<Failure, void>> updateLending(LendingEntity lending);

  Future<Either<Failure, void>> deleteLending(String lendingId);

  Future<Either<Failure, double>> getTotalLendingAmount({
    LendingType? typeFilter,
    LendingStatus? statusFilter,
    String? personNameFilter,
  });

  Future<Either<Failure, int>> getLendingsCount({
    LendingType? typeFilter,
    LendingStatus? statusFilter,
    String? personNameFilter,
  });

  // LendingPerson methods
  Future<Either<Failure, void>> addPerson(LendingPersonEntity person);

  Future<Either<Failure, LendingPersonEntity>> getPersonById(String personId);

  Future<Either<Failure, List<LendingPersonEntity>>> getUserPersons({
    String? nameFilter,
  });

  Future<Either<Failure, void>> updatePerson(LendingPersonEntity person);

  Future<Either<Failure, void>> deletePerson(String personId);

  // Repayment methods
  Future<Either<Failure, void>> addRepayment(RepaymentEntity repayment);

  Future<Either<Failure, List<RepaymentEntity>>> getRepaymentsForLending(
      String lendingId);

  Future<Either<Failure, void>> updateRepayment(RepaymentEntity repayment);

  Future<Either<Failure, void>> deleteRepayment(String repaymentId);
}
