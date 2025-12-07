import 'package:dartz/dartz.dart';

import '../../../../../core/error/failure.dart';
import '../../entity/lending_person/lending_person_entity.dart';
import '../../repositories/lending_repository.dart';

class GetPersonByIdUseCase {
  final LendingRepository repository;

  GetPersonByIdUseCase({required this.repository});

  Future<Either<Failure, LendingPersonEntity>> call(String personId) async {
    return await repository.getPersonById(personId);
  }
}
