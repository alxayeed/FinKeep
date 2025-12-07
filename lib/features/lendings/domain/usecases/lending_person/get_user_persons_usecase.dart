import 'package:dartz/dartz.dart';

import '../../../../../core/error/failure.dart';
import '../../entity/lending_person/lending_person_entity.dart';
import '../../repositories/lending_repository.dart';

class GetUserPersonsUseCase {
  final LendingRepository repository;

  GetUserPersonsUseCase({required this.repository});

  Future<Either<Failure, List<LendingPersonEntity>>> call(
    String userId, {
    String? nameFilter,
  }) async {
    return await repository.getUserPersons(userId, nameFilter: nameFilter);
  }
}
