import 'package:dartz/dartz.dart';

import '../../../../../core/error/failure.dart';
import '../../entity/lending/lending_entity.dart';
import '../../repositories/lending_repository.dart';

class GetLendingsUseCase {
  final LendingRepository repository;

  GetLendingsUseCase({required this.repository});

  Future<Either<Failure, List<LendingEntity>>> call({
    LendingType? typeFilter,
    DateTime? monthFilter,
    LendingStatus? statusFilter,
    String? personIdFilter,
  }) async {
    return await repository.getLendings(
      typeFilter: typeFilter,
      monthFilter: monthFilter,
      statusFilter: statusFilter,
      personIdFilter: personIdFilter,
    );
  }
}
