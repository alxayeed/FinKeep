import 'package:dartz/dartz.dart';

import '../../../../../core/error/failure.dart';
import '../../entity/lending/lending_entity.dart';
import '../../entity/lending_person/lending_person_entity.dart';
import '../../repositories/lending_repository.dart';

class AddLendingUseCase {
  final LendingRepository repository;

  AddLendingUseCase({required this.repository});

  Future<Either<Failure, void>> call(LendingEntity lending) async {
    try {
      LendingPersonEntity person = lending.person;

      // Check if the person is new (no id)
      if (person.id.isEmpty) {
        final createPersonResult = await repository.addPerson(person);
        return createPersonResult.fold(
          (failure) => Left(failure),
          (_) async {
            // After creating person, fetch the created person to get id
            final getPersonResult = await repository
                .getUserPersons(nameFilter: person.name);
            return getPersonResult.fold(
              (failure) => Left(failure),
              (persons) {
                if (persons.isEmpty) {
                  return Left(
                      ServerFailure(message: 'Failed to create person'));
                }
                final createdPerson = persons.first;
                final updatedLending = lending.copyWith(person: createdPerson);
                return repository.addLending(updatedLending);
              },
            );
          },
        );
      }

      // Person already exists, just create lending
      return await repository.addLending(lending);
    } catch (e) {
      return Left(ServerFailure(message: 'Unexpected error: $e'));
    }
  }
}
