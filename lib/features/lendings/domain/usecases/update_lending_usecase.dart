// import 'package:dartz/dartz.dart';
// import 'package:finkeep/core/error/failure.dart';
// import 'package:finkeep/core/usecase/usecase.dart';
// import 'package:finkeep/features/lendings/domain/repositories/lending_repository.dart';
//
// import '../entity/lending/lending_entity.dart';
//
// class UpdateLendingUseCase extends UseCase<void, LendingEntity> {
//   final LendingRepository repository;
//
//   UpdateLendingUseCase({required this.repository});
//
//   @override
//   Future<Either<Failure, void>> call(LendingEntity lending) async {
//     if (lending.id.isEmpty) {
//       return Left(
//           ServerFailure(message: 'Lending ID cannot be empty for update.'));
//     }
//     return await repository.updateLending(lending);
//   }
// }
