import 'package:dartz/dartz.dart';
import 'package:spendly/core/constants/app_strings.dart';
import 'package:spendly/core/error/exception_mapper.dart';
import 'package:spendly/core/error/failure.dart';
import 'package:spendly/features/lendings/domain/entity/lend_entity.dart';

import '../../domain/repositories/lending_repository.dart';
import '../datasources/lending_data_source.dart';

class LendingRepositoryImpl implements LendingRepository {
  final LendingDataSource dataSource;
  final ExceptionMapper exceptionMapper;

  LendingRepositoryImpl({
    required this.dataSource,
    required this.exceptionMapper,
  });

  @override
  Future<Either<Failure, List<LendingEntity>>> getAllLendings() async {
    try {
      final lendingModels = await dataSource.getAllLendings();
      final lendingEntities =
          lendingModels.map((model) => model.toEntity()).toList();
      return Right(lendingEntities);
    } catch (exception) {
      final failure = exception is Exception
          ? exceptionMapper.map(exception)
          : ServerFailure(message: AppStrings.internalServerError);
      return Left(failure);
    }
  }
}
