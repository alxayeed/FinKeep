import 'package:dartz/dartz.dart';

import '../../../../../core/error/failure.dart';
import '../../entity/lending/lending_entity.dart';
import '../../repositories/lending_repository.dart';

class GetLendingsCountUseCase {
  final LendingRepository repository;

  GetLendingsCountUseCase({required this.repository});

  Future<Either<Failure, int>> call({
    LendingType? typeFilter,
    LendingStatus? statusFilter,
    String? personNameFilter,
  }) async {
    return await repository.getLendingsCount(
      typeFilter: typeFilter,
      statusFilter: statusFilter,
      personNameFilter: personNameFilter,
    );
  }
}
