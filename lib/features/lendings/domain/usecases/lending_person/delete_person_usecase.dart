import 'package:dartz/dartz.dart';

import '../../../../../core/error/failure.dart';
import '../../repositories/lending_repository.dart';

class DeletePersonUseCase {
  final LendingRepository repository;

  DeletePersonUseCase({required this.repository});

  Future<Either<Failure, void>> call(String personId) async {
    return await repository.deletePerson(personId);
  }
}
