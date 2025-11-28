import 'package:dartz/dartz.dart';
import 'package:spendly/core/constants/app_strings.dart';
import 'package:spendly/core/error/exception_mapper.dart';
import 'package:spendly/core/error/failure.dart';
import 'package:spendly/features/lendings/data/datasources/lending_data_source.dart';
import 'package:spendly/features/lendings/data/models/lending_model.dart';
import 'package:spendly/features/lendings/domain/repositories/lending_repository.dart';

import '../../domain/entity/lend_entity.dart';

class LendingRepositoryImpl implements LendingRepository {
  final LendingDataSource remoteDataSource;
  final ExceptionMapper exceptionMapper;

  LendingRepositoryImpl({
    required this.remoteDataSource,
    required this.exceptionMapper,
  });

  @override
  Future<Either<Failure, void>> addLending(LendingEntity lending) async {
    try {
      final lendingModel = LendingModel(
        id: lending.id,
        type: lending.type,
        personName: lending.personName,
        amount: lending.amount,
        description: lending.description,
        createdDate: lending.createdDate,
        dueDate: lending.dueDate,
        status: lending.status,
        userId: lending.userId,
      );
      await remoteDataSource.addLending(lendingModel);
      return const Right(null);
    } catch (exception) {
      final failure = exception is Exception
          ? exceptionMapper.map(exception)
          : ServerFailure(message: AppStrings.unknownError);
      return Left(failure);
    }
  }

  @override
  Future<Either<Failure, List<LendingEntity>>> getLendings({
    required String userId,
    LendingType? typeFilter,
    DateTime? monthFilter,
    LendingStatus? statusFilter,
    String? personNameFilter,
  }) async {
    try {
      final lendingModels = await remoteDataSource.getLendings(
        userId: userId,
        typeFilter: typeFilter,
        monthFilter: monthFilter,
        statusFilter: statusFilter,
        personNameFilter: personNameFilter,
      );
      // Since LendingModel extends LendingEntity, direct return is possible
      return Right(lendingModels);
    } catch (exception) {
      final failure = exception is Exception
          ? exceptionMapper.map(exception)
          : ServerFailure(message: AppStrings.unknownError);
      return Left(failure);
    }
  }

  @override
  Future<Either<Failure, void>> updateLending(LendingEntity lending) async {
    try {
      if (lending.id.isEmpty) {
        return Left(ServerFailure(
            message: 'Cannot update lending without a valid ID.'));
      }
      await remoteDataSource.updateLending(lending.toModel());
      return const Right(null);
    } catch (exception) {
      final failure = exception is Exception
          ? exceptionMapper.map(exception)
          : ServerFailure(message: AppStrings.unknownError);
      return Left(failure);
    }
  }

  Future<Either<Failure, void>> updateLendingStatus(
      String lendingId, LendingStatus newStatus) async {
    try {
      await remoteDataSource.updateLendingStatus(lendingId, newStatus);
      return const Right(null);
    } catch (exception) {
      final failure = exception is Exception
          ? exceptionMapper.map(exception)
          : ServerFailure(message: AppStrings.unknownError);
      return Left(failure);
    }
  }

  @override
  Future<Either<Failure, void>> deleteLending(String lendingId) async {
    try {
      await remoteDataSource.deleteLending(lendingId);
      return const Right(null);
    } catch (exception) {
      final failure = exception is Exception
          ? exceptionMapper.map(exception)
          : ServerFailure(message: AppStrings.unknownError);
      return Left(failure);
    }
  }

  @override
  Future<Either<Failure, double>> getTotalLendingAmount({
    required String userId,
    LendingType? typeFilter,
    LendingStatus? statusFilter,
    String? personNameFilter,
  }) async {
    try {
      final total = await remoteDataSource.getTotalLendingAmount(
        userId: userId,
        typeFilter: typeFilter,
        statusFilter: statusFilter,
        personNameFilter: personNameFilter,
      );
      return Right(total);
    } catch (exception) {
      final failure = exception is Exception
          ? exceptionMapper.map(exception)
          : ServerFailure(message: AppStrings.unknownError);
      return Left(failure);
    }
  }

  @override
  Future<Either<Failure, int>> getLendingsCount({
    required String userId,
    LendingType? typeFilter,
    LendingStatus? statusFilter,
    String? personNameFilter,
  }) async {
    try {
      final count = await remoteDataSource.getLendingsCount(
        userId: userId,
        typeFilter: typeFilter,
        statusFilter: statusFilter,
        personNameFilter: personNameFilter,
      );
      return Right(count);
    } catch (exception) {
      final failure = exception is Exception
          ? exceptionMapper.map(exception)
          : ServerFailure(message: AppStrings.unknownError);
      return Left(failure);
    }
  }
}
