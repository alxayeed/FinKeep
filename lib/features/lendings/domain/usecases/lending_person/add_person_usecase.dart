import 'package:dartz/dartz.dart';

import '../../../../../core/error/failure.dart';
import '../../entity/lending_person_entity.dart';
import '../../repositories/lending_repository.dart';

class AddPersonUseCase {
  final LendingRepository repository;

  AddPersonUseCase({required this.repository});

  Future<Either<Failure, void>> call(LendingPersonEntity person) async {
    return await repository.addPerson(person);
  }
}
