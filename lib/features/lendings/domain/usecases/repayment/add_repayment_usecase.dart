import 'package:dartz/dartz.dart';

import '../../../../../core/error/failure.dart';
import '../../entity/repayment/repayment_entity.dart';
import '../../repositories/lending_repository.dart';

class AddRepaymentUseCase {
  final LendingRepository repository;

  AddRepaymentUseCase({required this.repository});

  Future<Either<Failure, void>> call(RepaymentEntity repayment) async {
    return await repository.addRepayment(repayment);
  }
}
