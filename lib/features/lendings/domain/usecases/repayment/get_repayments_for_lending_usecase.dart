import 'package:dartz/dartz.dart';

import '../../../../../core/error/failure.dart';
import '../../entity/repayment/repayment_entity.dart';
import '../../repositories/lending_repository.dart';

class GetRepaymentsForLendingUseCase {
  final LendingRepository repository;

  GetRepaymentsForLendingUseCase({required this.repository});

  Future<Either<Failure, List<RepaymentEntity>>> call(String lendingId) async {
    return await repository.getRepaymentsForLending(lendingId);
  }
}
