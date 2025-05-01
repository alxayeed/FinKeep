import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spendly/core/constants/app_strings.dart';
import 'package:spendly/core/error/exception_mapper.dart';
import 'package:spendly/core/error/exceptions.dart';
import 'package:spendly/core/error/failure.dart';
import 'package:spendly/features/lendings/data/datasources/lending_data_source.dart';
import 'package:spendly/features/lendings/data/models/lending_model.dart';
import 'package:spendly/features/lendings/data/repositories/lending_repository_impl.dart';
import 'package:spendly/features/lendings/domain/entity/lend_entity.dart';

class MockLendingDataSource extends Mock implements LendingDataSource {}

void main() {
  late MockLendingDataSource mockLendingDataSource;
  late LendingRepositoryImpl lendingRepositoryImpl;
  late ExceptionMapper exceptionMapper;

  setUp(() {
    mockLendingDataSource = MockLendingDataSource();
    exceptionMapper = ExceptionMapper();
    lendingRepositoryImpl = LendingRepositoryImpl(
      remoteDataSource: mockLendingDataSource,
      exceptionMapper: exceptionMapper,
    );
    // Register fallback values for any() matchers if needed, especially for custom types/enums
    registerFallbackValue(LendingType.given);
    registerFallbackValue(LendingStatus.due);
    registerFallbackValue(LendingModel(
      id: 'fallbackId',
      type: LendingType.given,
      personName: 'Fallback Person',
      amount: 0.0,
      createdDate: DateTime(2000),
      status: LendingStatus.due,
      userId: 'fallbackUser',
    ));
  });

  // --- Test Data ---
  const tUserId = 'user123';
  final tDateTimeCreated = DateTime(2024, 5, 10);
  final tDateTimeDue = DateTime(2024, 8, 10);

  final tLendingModel = LendingModel(
    id: "lend1",
    type: LendingType.given,
    personName: "John Doe",
    amount: 100.0,
    description: "Test desc",
    createdDate: tDateTimeCreated,
    dueDate: tDateTimeDue,
    status: LendingStatus.due,
    userId: tUserId,
  );

  final tLendingEntity = LendingEntity(
    id: "lend1",
    type: LendingType.given,
    personName: "John Doe",
    amount: 100.0,
    description: "Test desc",
    createdDate: tDateTimeCreated,
    dueDate: tDateTimeDue,
    status: LendingStatus.due,
    userId: tUserId,
  );

  const tLendingId = 'lend1';
  const tNewStatus = LendingStatus.paid;
  const tTotalAmount = 150.50;
  const tCount = 5;
  final tServerException =
      ServerException(message: AppStrings.internalServerError);
  final tServerFailure = ServerFailure(message: AppStrings.internalServerError);

  // --- Test Groups ---

  group('getLendings', () {
    test(
        'should return a list of LendingEntity when data source call is successful',
        () async {
      // Arrange
      when(() => mockLendingDataSource.getLendings(
            userId: any(named: 'userId'),
            typeFilter: any(named: 'typeFilter'),
            monthFilter: any(named: 'monthFilter'),
            statusFilter: any(named: 'statusFilter'),
            personNameFilter: any(named: 'personNameFilter'),
          )).thenAnswer((_) async => [tLendingModel]);
      // Act
      final result = await lendingRepositoryImpl.getLendings(userId: tUserId);
      // Assert
      expect(result, equals(Right([tLendingModel]))); // Model extends Entity
      verify(() => mockLendingDataSource.getLendings(
            userId: tUserId,
            typeFilter: null,
            monthFilter: null,
            statusFilter: null,
            personNameFilter: null,
          )).called(1);
      verifyNoMoreInteractions(mockLendingDataSource);
    });

    test(
        'should return ServerFailure when data source call throws ServerException',
        () async {
      // Arrange
      when(() =>
              mockLendingDataSource.getLendings(userId: any(named: 'userId')))
          .thenThrow(tServerException);
      // Act
      final result = await lendingRepositoryImpl.getLendings(userId: tUserId);
      // Assert
      expect(result, equals(Left(tServerFailure)));
      verify(() => mockLendingDataSource.getLendings(userId: tUserId))
          .called(1);
      verifyNoMoreInteractions(mockLendingDataSource);
    });
  });

  group('addLending', () {
    test('should return Right(null) when data source call is successful',
        () async {
      // Arrange
      when(() => mockLendingDataSource.addLending(any()))
          .thenAnswer((_) async => Future.value()); // Simulate void success
      // Act
      final result = await lendingRepositoryImpl.addLending(tLendingEntity);
      // Assert
      expect(result, equals(const Right(null)));
      verify(() => mockLendingDataSource.addLending(tLendingModel)).called(1);
      verifyNoMoreInteractions(mockLendingDataSource);
    });

    test(
        'should return ServerFailure when data source call throws ServerException',
        () async {
      // Arrange
      when(() => mockLendingDataSource.addLending(any()))
          .thenThrow(tServerException);
      // Act
      final result = await lendingRepositoryImpl.addLending(tLendingEntity);
      // Assert
      expect(result, equals(Left(tServerFailure)));
      verify(() => mockLendingDataSource.addLending(tLendingModel)).called(1);
      verifyNoMoreInteractions(mockLendingDataSource);
    });
  });

  group('updateLendingStatus', () {
    test('should return Right(null) when data source call is successful',
        () async {
      // Arrange
      when(() => mockLendingDataSource.updateLendingStatus(any(), any()))
          .thenAnswer((_) async => Future.value());
      // Act
      final result = await lendingRepositoryImpl.updateLendingStatus(
          tLendingId, tNewStatus);
      // Assert
      expect(result, equals(const Right(null)));
      verify(() =>
              mockLendingDataSource.updateLendingStatus(tLendingId, tNewStatus))
          .called(1);
      verifyNoMoreInteractions(mockLendingDataSource);
    });

    test(
        'should return ServerFailure when data source call throws ServerException',
        () async {
      // Arrange
      when(() => mockLendingDataSource.updateLendingStatus(any(), any()))
          .thenThrow(tServerException);
      // Act
      final result = await lendingRepositoryImpl.updateLendingStatus(
          tLendingId, tNewStatus);
      // Assert
      expect(result, equals(Left(tServerFailure)));
      verify(() =>
              mockLendingDataSource.updateLendingStatus(tLendingId, tNewStatus))
          .called(1);
      verifyNoMoreInteractions(mockLendingDataSource);
    });
  });

  group('deleteLending', () {
    test('should return Right(null) when data source call is successful',
        () async {
      // Arrange
      when(() => mockLendingDataSource.deleteLending(any()))
          .thenAnswer((_) async => Future.value());
      // Act
      final result = await lendingRepositoryImpl.deleteLending(tLendingId);
      // Assert
      expect(result, equals(const Right(null)));
      verify(() => mockLendingDataSource.deleteLending(tLendingId)).called(1);
      verifyNoMoreInteractions(mockLendingDataSource);
    });

    test(
        'should return ServerFailure when data source call throws ServerException',
        () async {
      // Arrange
      when(() => mockLendingDataSource.deleteLending(any()))
          .thenThrow(tServerException);
      // Act
      final result = await lendingRepositoryImpl.deleteLending(tLendingId);
      // Assert
      expect(result, equals(Left(tServerFailure)));
      verify(() => mockLendingDataSource.deleteLending(tLendingId)).called(1);
      verifyNoMoreInteractions(mockLendingDataSource);
    });
  });

  group('getTotalLendingAmount', () {
    test('should return total amount when data source call is successful',
        () async {
      // Arrange
      when(() => mockLendingDataSource.getTotalLendingAmount(
            userId: any(named: 'userId'),
            typeFilter: any(named: 'typeFilter'),
            statusFilter: any(named: 'statusFilter'),
            personNameFilter: any(named: 'personNameFilter'),
          )).thenAnswer((_) async => tTotalAmount);
      // Act
      final result =
          await lendingRepositoryImpl.getTotalLendingAmount(userId: tUserId);
      // Assert
      expect(result, equals(const Right(tTotalAmount)));
      verify(() => mockLendingDataSource.getTotalLendingAmount(
            userId: tUserId,
            typeFilter: null,
            statusFilter: null,
            personNameFilter: null,
          )).called(1);
      verifyNoMoreInteractions(mockLendingDataSource);
    });

    test(
        'should return ServerFailure when data source call throws ServerException',
        () async {
      // Arrange
      when(() => mockLendingDataSource.getTotalLendingAmount(
          userId: any(named: 'userId'))).thenThrow(tServerException);
      // Act
      final result =
          await lendingRepositoryImpl.getTotalLendingAmount(userId: tUserId);
      // Assert
      expect(result, equals(Left(tServerFailure)));
      verify(() => mockLendingDataSource.getTotalLendingAmount(userId: tUserId))
          .called(1);
      verifyNoMoreInteractions(mockLendingDataSource);
    });
  });

  group('getLendingsCount', () {
    test('should return count when data source call is successful', () async {
      // Arrange
      when(() => mockLendingDataSource.getLendingsCount(
            userId: any(named: 'userId'),
            typeFilter: any(named: 'typeFilter'),
            statusFilter: any(named: 'statusFilter'),
            personNameFilter: any(named: 'personNameFilter'),
          )).thenAnswer((_) async => tCount);
      // Act
      final result =
          await lendingRepositoryImpl.getLendingsCount(userId: tUserId);
      // Assert
      expect(result, equals(const Right(tCount)));
      verify(() => mockLendingDataSource.getLendingsCount(
            userId: tUserId,
            typeFilter: null,
            statusFilter: null,
            personNameFilter: null,
          )).called(1);
      verifyNoMoreInteractions(mockLendingDataSource);
    });

    test(
        'should return ServerFailure when data source call throws ServerException',
        () async {
      // Arrange
      when(() => mockLendingDataSource.getLendingsCount(
          userId: any(named: 'userId'))).thenThrow(tServerException);
      // Act
      final result =
          await lendingRepositoryImpl.getLendingsCount(userId: tUserId);
      // Assert
      expect(result, equals(Left(tServerFailure)));
      verify(() => mockLendingDataSource.getLendingsCount(userId: tUserId))
          .called(1);
      verifyNoMoreInteractions(mockLendingDataSource);
    });
  });
}
