import 'package:dartz/dartz.dart';
import 'package:spendly/core/config/app_config.dart';
import 'package:spendly/core/constants/app_strings.dart';
import 'package:spendly/core/error/exception_mapper.dart';
import 'package:spendly/core/error/failure.dart';
import 'package:spendly/features/lendings/data/datasources/lending_local_datasource.dart';
import 'package:spendly/features/lendings/data/datasources/lending_data_source.dart';
import 'package:spendly/features/lendings/domain/repositories/lending_repository.dart';

import '../../domain/entity/lending/lending_entity.dart';
import '../../domain/entity/lending_person/lending_person_entity.dart';
import '../../domain/entity/repayment/repayment_entity.dart';
import '../models/lending/lending_model.dart';
import '../models/lending_person/lending_person_model.dart';
import '../models/repayment/repayment_model.dart';

class LendingRepositoryImpl implements LendingRepository {
  final LendingLocalDataSource localDataSource;
  final LendingDataSource remoteDataSource;
  final ExceptionMapper exceptionMapper;

  LendingRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.exceptionMapper,
  });

  // Lending methods
  @override
  Future<Either<Failure, void>> addLending(LendingEntity lending) async {
    try {
      final lendingModel = LendingModel.fromEntity(lending);
      await localDataSource.addLending(lendingModel);
      if (AppConfig.isPersonal) {
        try {
          await remoteDataSource.addLending(lendingModel);
        } catch (e) {
          // Will be handled by background sync
        }
      }
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
    String? personIdFilter,
  }) async {
    try {
      final lendingModels = await localDataSource.getLendings(
        userId: userId,
        typeFilter: typeFilter,
        monthFilter: monthFilter,
        statusFilter: statusFilter,
        personIdFilter: personIdFilter,
      );
      final lendings = lendingModels.map((model) => model.toEntity()).toList();
      return Right(lendings);
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
      final model = LendingModel.fromEntity(lending);
      await localDataSource.updateLending(model);
      if (AppConfig.isPersonal) {
        try {
          await remoteDataSource.updateLending(model);
        } catch (e) {
          // Will be handled by background sync
        }
      }
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
      await localDataSource.deleteLending(lendingId);
      if (AppConfig.isPersonal) {
        try {
          await remoteDataSource.deleteLending(lendingId);
        } catch (e) {
          // Will be handled by background sync
        }
      }
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
      final total = await localDataSource.getTotalLendingAmount(
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
      final count = await localDataSource.getLendingsCount(
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

  // LendingPerson methods
  @override
  Future<Either<Failure, void>> addPerson(LendingPersonEntity person) async {
    try {
      final model = LendingPersonModel.fromEntity(person);
      await localDataSource.addPerson(model);
      if (AppConfig.isPersonal) {
        try {
          await remoteDataSource.addPerson(model);
        } catch (e) {
          // Will be handled by background sync
        }
      }
      return const Right(null);
    } catch (exception) {
      final failure = exception is Exception
          ? exceptionMapper.map(exception)
          : ServerFailure(message: AppStrings.unknownError);
      return Left(failure);
    }
  }

  @override
  Future<Either<Failure, LendingPersonEntity>> getPersonById(
      String personId) async {
    try {
      final model = await localDataSource.getPersonById(personId);
      return Right(model.toEntity());
    } catch (exception) {
      final failure = exception is Exception
          ? exceptionMapper.map(exception)
          : ServerFailure(message: AppStrings.unknownError);
      return Left(failure);
    }
  }

  @override
  Future<Either<Failure, List<LendingPersonEntity>>> getUserPersons(
      String userId,
      {String? nameFilter}) async {
    try {
      final models = await localDataSource.getUserPersons(
        userId,
        nameFilter: nameFilter,
      );
      final persons = models.map((m) => m.toEntity()).toList();
      return Right(persons);
    } catch (exception) {
      final failure = exception is Exception
          ? exceptionMapper.map(exception)
          : ServerFailure(message: AppStrings.unknownError);
      return Left(failure);
    }
  }

  @override
  Future<Either<Failure, void>> updatePerson(LendingPersonEntity person) async {
    try {
      final model = LendingPersonModel.fromEntity(person);
      await localDataSource.updatePerson(model);
      if (AppConfig.isPersonal) {
        try {
          await remoteDataSource.updatePerson(model);
        } catch (e) {
          // Will be handled by background sync
        }
      }
      return const Right(null);
    } catch (exception) {
      final failure = exception is Exception
          ? exceptionMapper.map(exception)
          : ServerFailure(message: AppStrings.unknownError);
      return Left(failure);
    }
  }

  @override
  Future<Either<Failure, void>> deletePerson(String personId) async {
    try {
      await localDataSource.deletePerson(personId);
      if (AppConfig.isPersonal) {
        try {
          await remoteDataSource.deletePerson(personId);
        } catch (e) {
          // Will be handled by background sync
        }
      }
      return const Right(null);
    } catch (exception) {
      final failure = exception is Exception
          ? exceptionMapper.map(exception)
          : ServerFailure(message: AppStrings.unknownError);
      return Left(failure);
    }
  }

  // Repayment methods
  @override
  Future<Either<Failure, void>> addRepayment(RepaymentEntity repayment) async {
    try {
      final model = RepaymentModel.fromEntity(repayment);
      await localDataSource.addRepayment(model);
      if (AppConfig.isPersonal) {
        try {
          await remoteDataSource.addRepayment(model);
        } catch (e) {
          // Will be handled by background sync
        }
      }
      return const Right(null);
    } catch (exception) {
      final failure = exception is Exception
          ? exceptionMapper.map(exception)
          : ServerFailure(message: AppStrings.unknownError);
      return Left(failure);
    }
  }

  @override
  Future<Either<Failure, List<RepaymentEntity>>> getRepaymentsForLending(
      String lendingId) async {
    try {
      final models = await localDataSource.getRepaymentsForLending(lendingId);
      final repayments = models.map((m) => m.toEntity()).toList();
      return Right(repayments);
    } catch (exception) {
      final failure = exception is Exception
          ? exceptionMapper.map(exception)
          : ServerFailure(message: AppStrings.unknownError);
      return Left(failure);
    }
  }

  @override
  Future<Either<Failure, void>> updateRepayment(
      RepaymentEntity repayment) async {
    try {
      final model = RepaymentModel.fromEntity(repayment);
      await localDataSource.updateRepayment(model);
      if (AppConfig.isPersonal) {
        try {
          await remoteDataSource.updateRepayment(model);
        } catch (e) {
          // Will be handled by background sync
        }
      }
      return const Right(null);
    } catch (exception) {
      final failure = exception is Exception
          ? exceptionMapper.map(exception)
          : ServerFailure(message: AppStrings.unknownError);
      return Left(failure);
    }
  }

  @override
  Future<Either<Failure, void>> deleteRepayment(String repaymentId) async {
    try {
      await localDataSource.deleteRepayment(repaymentId);
      if (AppConfig.isPersonal) {
        try {
          await remoteDataSource.deleteRepayment(repaymentId);
        } catch (e) {
          // Will be handled by background sync
        }
      }
      return const Right(null);
    } catch (exception) {
      final failure = exception is Exception
          ? exceptionMapper.map(exception)
          : ServerFailure(message: AppStrings.unknownError);
      return Left(failure);
    }
  }
}
