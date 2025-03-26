import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spendly/core/constants/app_strings.dart';
import 'package:spendly/core/enums/lending_type.dart';
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
      dataSource: mockLendingDataSource,
      exceptionMapper: exceptionMapper,
    );
  });

  group('getAllLendings', () {
    final tLendingModel = LendingModel(
      id: "testId",
      amount: 1000,
      date: DateTime(2025, 3, 23),
      dueDate: DateTime(2025, 6, 23),
      lenderId: 'Lender123',
      borrowerName: 'John Doe',
      type: LendingType.given,
      note: 'Test note',
    );

    final tLendingEntity = LendingEntity(
      id: "testId",
      amount: 1000,
      date: DateTime(2025, 3, 23),
      dueDate: DateTime(2025, 6, 23),
      lenderId: 'Lender123',
      borrowerName: 'John Doe',
      type: LendingType.given,
      note: 'Test note',
    );

    test(
        'should return a list of LendingEntity when data is fetched successfully',
        () async {
      when(() => mockLendingDataSource.getAllLendings())
          .thenAnswer((_) async => [tLendingModel]);

      final result = await lendingRepositoryImpl.getAllLendings();

      expect(result.isRight(), true);
      result.fold(
        (failure) => null,
        (lendings) {
          expect(lendings, isA<List<LendingEntity>>());
          expect(lendings.length, 1);
          expect(lendings[0], tLendingEntity);
        },
      );
    });

    test('should return a ServerFailure when data fetching fails', () async {
      when(() => mockLendingDataSource.getAllLendings())
          .thenThrow(ServerException(message: AppStrings.internalServerError));

      final result = await lendingRepositoryImpl.getAllLendings();

      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<ServerFailure>());
          expect((failure as ServerFailure).message,
              AppStrings.internalServerError);
        },
        (lendings) => null,
      );
    });

    test('should return an empty list if no data is found', () async {
      when(() => mockLendingDataSource.getAllLendings())
          .thenAnswer((_) async => []);

      final result = await lendingRepositoryImpl.getAllLendings();

      expect(result.isRight(), true);
      result.fold(
        (failure) => null,
        (lendings) {
          expect(lendings, isA<List<LendingEntity>>());
          expect(lendings.isEmpty, true);
        },
      );
    });

    // Test for Model to Entity Conversion
    test('should convert LendingModel to LendingEntity', () async {
      when(() => mockLendingDataSource.getAllLendings())
          .thenAnswer((_) async => [tLendingModel]);

      final result = await lendingRepositoryImpl.getAllLendings();

      result.fold(
        (failure) => null,
        (lendings) {
          expect(lendings[0], isA<LendingEntity>());
          expect(lendings[0].id, tLendingEntity.id);
          expect(lendings[0].amount, tLendingEntity.amount);
          expect(lendings[0].date, tLendingEntity.date);
          expect(lendings[0].dueDate, tLendingEntity.dueDate);
          expect(lendings[0].lenderId, tLendingEntity.lenderId);
          expect(lendings[0].borrowerName, tLendingEntity.borrowerName);
          expect(lendings[0].type, tLendingEntity.type);
          expect(lendings[0].note, tLendingEntity.note);
        },
      );
    });

    // Test for Exception Mapping
    test('should map ServerException to ServerFailure', () async {
      when(() => mockLendingDataSource.getAllLendings())
          .thenThrow(ServerException(message: AppStrings.internalServerError));

      final result = await lendingRepositoryImpl.getAllLendings();

      result.fold(
        (failure) {
          expect(failure, isA<ServerFailure>());
          expect((failure as ServerFailure).message,
              AppStrings.internalServerError);
        },
        (lendings) => null,
      );
    });
  });
}
