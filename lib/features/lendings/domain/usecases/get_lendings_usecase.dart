import 'package:dartz/dartz.dart';
import 'package:spendly/core/error/failure.dart';
import 'package:spendly/core/usecase/usecase.dart';
import 'package:spendly/features/lendings/domain/repositories/lending_repository.dart';
import 'package:spendly/features/lendings/domain/usecases/lending_params.dart';

import '../entity/lend_entity.dart';

class GetLendingsUseCase
    extends UseCase<List<LendingEntity>, GetLendingsParams> {
  final LendingRepository repository;

  GetLendingsUseCase({required this.repository});

  @override
  Future<Either<Failure, List<LendingEntity>>> call(
      GetLendingsParams params) async {
    return await repository.getLendings(
      userId: params.userId,
      typeFilter: params.typeFilter,
      monthFilter: params.monthFilter,
      statusFilter: params.statusFilter,
      personNameFilter: params.personNameFilter,
    );
  }
}
