// import 'package:dartz/dartz.dart';
//
// import '../../../../core/error/failure.dart';
// import '../../domain/entity/lend_entity.dart';
// import '../../domain/repositories/lending_repository.dart';
// import '../datasources/lending_data_source.dart';
// import '../models/lending_model.dart';
//
// class LendingRepositoryImpl implements LendingRepository {
//   final LendingDataSource dataSource;
//
//   LendingRepositoryImpl(this.dataSource);
//
//   @override
//   Future<Either<Failure, LendingEntity>> createLending(
//       LendingEntity lending) async {
//     final lendingModel = LendingModel(
//       id: lending.id,
//       amount: lending.amount,
//       date: lending.date,
//       dueDate: lending.dueDate,
//       userId: lending.userId,
//       personName: lending.personName,
//       type: lending.type,
//       note: lending.note,
//     );
//
//     final result = await dataSource.createLending(lendingModel);
//     return result.fold(
//       (failure) => Left(failure),
//       (lending) => Right(lending.toEntity()),
//     );
//   }
// }
