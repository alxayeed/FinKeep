import 'package:spendly/features/lendings/data/models/lending_model.dart';

import '../../domain/entity/lend_entity.dart';

abstract class LendingDataSource {
  Future<void> addLending(LendingModel lending);

  Future<List<LendingModel>> getLendings({
    required String userId,
    LendingType? typeFilter,
    DateTime? monthFilter,
    LendingStatus? statusFilter,
    String? personNameFilter,
  });

  Future<void> updateLendingStatus(String lendingId, LendingStatus newStatus);

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
}
