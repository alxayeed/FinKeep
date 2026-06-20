import 'package:dartz/dartz.dart';
import 'package:spendly/core/config/app_config.dart';
import 'package:spendly/core/error/exception_mapper.dart';
import 'package:spendly/core/error/exception_handler.dart';
import 'package:spendly/core/error/failure.dart';
import 'package:spendly/features/lendings/data/datasources/lending_data_source.dart';
import 'package:spendly/features/lendings/data/datasources/lending_local_datasource.dart';
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

  @override
  Future<Either<Failure, void>> addLending(LendingEntity lending) async {
    try {
      final lendingModel = LendingModel.fromEntity(lending);
      if (AppConfig.useRemote) {
        await remoteDataSource.addLending(lendingModel);
      } else {
        await localDataSource.addLending(lendingModel);
      }
      return const Right(null);
    } catch (exception) {
      return Left(_handleException(exception));
    }
  }

  @override
  Future<Either<Failure, List<LendingEntity>>> getLendings({
    LendingType? typeFilter,
    DateTime? monthFilter,
    LendingStatus? statusFilter,
    String? personIdFilter,
  }) async {
    try {
      final List<LendingModel> lendingModels;
      if (AppConfig.useRemote) {
        lendingModels = await remoteDataSource.getLendings(
          typeFilter: typeFilter,
          monthFilter: monthFilter,
          statusFilter: statusFilter,
          personIdFilter: personIdFilter,
        );
      } else {
        lendingModels = await localDataSource.getLendings(
          typeFilter: typeFilter,
          monthFilter: monthFilter,
          statusFilter: statusFilter,
          personIdFilter: personIdFilter,
        );
      }
      final lendings = lendingModels.map((model) => model.toEntity()).toList();
      return Right(lendings);
    } catch (exception) {
      return Left(_handleException(exception));
    }
  }

  @override
  Future<Either<Failure, void>> updateLending(LendingEntity lending) async {
    try {
      final model = LendingModel.fromEntity(lending);
      if (AppConfig.useRemote) {
        await remoteDataSource.updateLending(model);
      } else {
        await localDataSource.updateLending(model);
      }
      return const Right(null);
    } catch (exception) {
      return Left(_handleException(exception));
    }
  }

  @override
  Future<Either<Failure, void>> deleteLending(String lendingId) async {
    try {
      if (AppConfig.useRemote) {
        await remoteDataSource.deleteLending(lendingId);
      } else {
        await localDataSource.deleteLending(lendingId);
      }
      return const Right(null);
    } catch (exception) {
      return Left(_handleException(exception));
    }
  }

  @override
  Future<Either<Failure, double>> getTotalLendingAmount({
    LendingType? typeFilter,
    LendingStatus? statusFilter,
    String? personNameFilter,
  }) async {
    try {
      final double total;
      if (AppConfig.useRemote) {
        total = await remoteDataSource.getTotalLendingAmount(
          typeFilter: typeFilter,
          statusFilter: statusFilter,
          personNameFilter: personNameFilter,
        );
      } else {
        total = await localDataSource.getTotalLendingAmount(
          typeFilter: typeFilter,
          statusFilter: statusFilter,
          personNameFilter: personNameFilter,
        );
      }
      return Right(total);
    } catch (exception) {
      return Left(_handleException(exception));
    }
  }

  @override
  Future<Either<Failure, int>> getLendingsCount({
    LendingType? typeFilter,
    LendingStatus? statusFilter,
    String? personNameFilter,
  }) async {
    try {
      final int count;
      if (AppConfig.useRemote) {
        count = await remoteDataSource.getLendingsCount(
          typeFilter: typeFilter,
          statusFilter: statusFilter,
          personNameFilter: personNameFilter,
        );
      } else {
        count = await localDataSource.getLendingsCount(
          typeFilter: typeFilter,
          statusFilter: statusFilter,
          personNameFilter: personNameFilter,
        );
      }
      return Right(count);
    } catch (exception) {
      return Left(_handleException(exception));
    }
  }

  @override
  Future<Either<Failure, void>> addPerson(LendingPersonEntity person) async {
    try {
      final model = LendingPersonModel.fromEntity(person);
      if (AppConfig.useRemote) {
        await remoteDataSource.addPerson(model);
      } else {
        await localDataSource.addPerson(model);
      }
      return const Right(null);
    } catch (exception) {
      return Left(_handleException(exception));
    }
  }

  @override
  Future<Either<Failure, LendingPersonEntity>> getPersonById(
    String personId,
  ) async {
    try {
      final LendingPersonModel model;
      if (AppConfig.useRemote) {
        model = await remoteDataSource.getPersonById(personId);
      } else {
        model = await localDataSource.getPersonById(personId);
      }
      return Right(model.toEntity());
    } catch (exception) {
      return Left(_handleException(exception));
    }
  }

  @override
  Future<Either<Failure, List<LendingPersonEntity>>> getUserPersons({
    String? nameFilter,
  }) async {
    try {
      final List<LendingPersonModel> models;
      if (AppConfig.useRemote) {
        models = await remoteDataSource.getUserPersons(
          nameFilter: nameFilter,
        );
      } else {
        models = await localDataSource.getUserPersons(
          nameFilter: nameFilter,
        );
      }
      final persons = models.map((m) => m.toEntity()).toList();
      return Right(persons);
    } catch (exception) {
      return Left(_handleException(exception));
    }
  }

  @override
  Future<Either<Failure, void>> updatePerson(LendingPersonEntity person) async {
    try {
      final model = LendingPersonModel.fromEntity(person);
      if (AppConfig.useRemote) {
        await remoteDataSource.updatePerson(model);
      } else {
        await localDataSource.updatePerson(model);
      }
      return const Right(null);
    } catch (exception) {
      return Left(_handleException(exception));
    }
  }

  @override
  Future<Either<Failure, void>> deletePerson(String personId) async {
    try {
      if (AppConfig.useRemote) {
        await remoteDataSource.deletePerson(personId);
      } else {
        await localDataSource.deletePerson(personId);
      }
      return const Right(null);
    } catch (exception) {
      return Left(_handleException(exception));
    }
  }

  @override
  Future<Either<Failure, void>> addRepayment(RepaymentEntity repayment) async {
    try {
      final model = RepaymentModel.fromEntity(repayment);
      if (AppConfig.useRemote) {
        await remoteDataSource.addRepayment(model);
      } else {
        await localDataSource.addRepayment(model);
      }
      return const Right(null);
    } catch (exception) {
      return Left(_handleException(exception));
    }
  }

  @override
  Future<Either<Failure, List<RepaymentEntity>>> getRepaymentsForLending(
    String lendingId,
  ) async {
    try {
      final List<RepaymentModel> models;
      if (AppConfig.useRemote) {
        models = await remoteDataSource.getRepaymentsForLending(lendingId);
      } else {
        models = await localDataSource.getRepaymentsForLending(lendingId);
      }
      final repayments = models.map((m) => m.toEntity()).toList();
      return Right(repayments);
    } catch (exception) {
      return Left(_handleException(exception));
    }
  }

  @override
  Future<Either<Failure, void>> updateRepayment(
    RepaymentEntity repayment,
  ) async {
    try {
      final model = RepaymentModel.fromEntity(repayment);
      if (AppConfig.useRemote) {
        await remoteDataSource.updateRepayment(model);
      } else {
        await localDataSource.updateRepayment(model);
      }
      return const Right(null);
    } catch (exception) {
      return Left(_handleException(exception));
    }
  }

  @override
  Future<Either<Failure, void>> deleteRepayment(String repaymentId) async {
    try {
      if (AppConfig.useRemote) {
        await remoteDataSource.deleteRepayment(repaymentId);
      } else {
        await localDataSource.deleteRepayment(repaymentId);
      }
      return const Right(null);
    } catch (exception) {
      return Left(_handleException(exception));
    }
  }

  Failure _handleException(dynamic exception, [StackTrace? stackTrace, String? context]) {
    return ExceptionHandler.handle(
      exception,
      stackTrace,
      context ?? 'LendingRepositoryImpl',
    );
  }
}
