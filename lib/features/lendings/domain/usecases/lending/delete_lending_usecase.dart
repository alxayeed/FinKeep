import 'package:dartz/dartz.dart';

import '../../../../../core/error/failure.dart';
import '../../repositories/lending_repository.dart';

class DeleteLendingUseCase {
  final LendingRepository repository;

  DeleteLendingUseCase({required this.repository});

  Future<Either<Failure, void>> call(String lendingId) async {
    return await repository.deleteLending(lendingId);
  }
}
