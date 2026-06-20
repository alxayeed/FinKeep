// import 'package:dartz/dartz.dart';
// import 'package:finkeep/core/error/failure.dart';
// import 'package:finkeep/core/usecase/usecase.dart';
// import 'package:finkeep/features/lendings/domain/repositories/lending_repository.dart';
//
// class DeleteLendingUseCase extends UseCase<void, String> {
//   final LendingRepository repository;
//
//   DeleteLendingUseCase({required this.repository});
//
//   @override
//   Future<Either<Failure, void>> call(String lendingId) async {
//     if (lendingId.isEmpty) {
//       return Left(
//           ServerFailure(message: 'Lending ID cannot be empty for delete.'));
//     }
//     return await repository.deleteLending(lendingId);
//   }
// }
