import 'package:spendly/features/lendings/data/models/lending/lending_model.dart';
import 'package:spendly/features/lendings/data/models/repayment/repayment_model.dart';

import '../../domain/entity/lending/lending_entity.dart';
import '../models/lending_person/lending_person_model.dart';

abstract class LendingDataSource {
  // Lending methods
  Future<void> addLending(LendingModel lending);

  Future<List<LendingModel>> getLendings({
    required String userId,
    LendingType? typeFilter,
    DateTime? monthFilter,
    LendingStatus? statusFilter,
    String? personIdFilter,
  });

  // Future<void> updateLendingStatus(String lendingId, LendingStatus newStatus);

  Future<void> updateLending(LendingModel lending);

  Future<void> deleteLending(String lendingId);

  Future<double> getTotalLendingAmount({
    required String userId,
    LendingType? typeFilter,
    LendingStatus? statusFilter,
    String? personNameFilter,
  });

  Future<int> getLendingsCount({
    required String userId,
    LendingType? typeFilter,
    LendingStatus? statusFilter,
    String? personNameFilter,
  });

  // LendingPerson methods
  Future<void> addPerson(LendingPersonModel person);

  Future<LendingPersonModel> getPersonById(String personId);

  Future<List<LendingPersonModel>> getUserPersons(String userId,
      {String? nameFilter});

  Future<void> updatePerson(LendingPersonModel person);

  Future<void> deletePerson(String personId);

  // Repayment methods
  Future<void> addRepayment(RepaymentModel repayment);

  Future<List<RepaymentModel>> getRepaymentsForLending(String lendingId);

  Future<void> updateRepayment(RepaymentModel repayment);

  Future<void> deleteRepayment(String repaymentId);
}
