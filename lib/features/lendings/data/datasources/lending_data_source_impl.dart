// import 'package:dartz/dartz.dart';
//
// import '../../../../core/error/failure.dart';
// import '../models/lending_model.dart';
// import 'lending_data_source.dart';
//
// class LendingDataSourceImpl implements LendingDataSource {
//   final List<LendingModel> _lendingList = [];
//
//   @override
//   Future<Either<Failure, LendingModel>> createLending(
//       LendingModel lending) async {
//     try {
//       _lendingList.add(lending);
//       return Right(lending);
//     } catch (e) {
//       return Left(NetworkFailure("OOPs"));
//     }
//   }
// }
