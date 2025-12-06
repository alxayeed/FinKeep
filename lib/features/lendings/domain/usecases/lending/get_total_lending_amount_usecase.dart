import 'package:dartz/dartz.dart';

import '../../../../../core/error/failure.dart';
import '../../entity/lending/lending_entity.dart';
import '../../repositories/lending_repository.dart';

class GetTotalLendingAmountUseCase {
  final LendingRepository repository;

  GetTotalLendingAmountUseCase({required this.repository});

  Future<Either<Failure, double>> call({
    required String userId,
    LendingType? typeFilter,
    LendingStatus? statusFilter,
    String? personNameFilter,
  }) async {
    return await repository.getTotalLendingAmount(
      userId: userId,
      typeFilter: typeFilter,
      statusFilter: statusFilter,
      personNameFilter: personNameFilter,
    );
  }
}
