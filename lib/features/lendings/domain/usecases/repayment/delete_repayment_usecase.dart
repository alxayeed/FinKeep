import 'package:dartz/dartz.dart';

import '../../../../../core/error/failure.dart';
import '../../repositories/lending_repository.dart';

class DeleteRepaymentUseCase {
  final LendingRepository repository;

  DeleteRepaymentUseCase({required this.repository});

  Future<Either<Failure, void>> call(String repaymentId) async {
    return await repository.deleteRepayment(repaymentId);
  }
}
