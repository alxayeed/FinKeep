// import 'package:dartz/dartz.dart';
// import 'package:finkeep/core/error/failure.dart';
// import 'package:finkeep/core/usecase/usecase.dart';
// import 'package:finkeep/features/lendings/domain/repositories/lending_repository.dart';
// import 'package:finkeep/features/lendings/domain/usecases/lending_params.dart';
//
// import '../entity/lending/lending_entity.dart';
//
// class GetLendingsUseCase
//     extends UseCase<List<LendingEntity>, GetLendingsParams> {
//   final LendingRepository repository;
//
//   GetLendingsUseCase({required this.repository});
//
//   @override
//   Future<Either<Failure, List<LendingEntity>>> call(
//       GetLendingsParams params) async {
//     return await repository.getLendings(
//       userId: params.userId,
//       typeFilter: params.typeFilter,
//       monthFilter: params.monthFilter,
//       statusFilter: params.statusFilter,
//       personNameFilter: params.personNameFilter,
//     );
//   }
// }
