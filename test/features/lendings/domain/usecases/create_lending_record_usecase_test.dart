// import 'package:dartz/dartz.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mocktail/mocktail.dart';
// import 'package:spendly/core/enums/lending_type.dart';
// import 'package:spendly/core/error/failure.dart';
// import 'package:spendly/features/lendings/domain/entity/lend_entity.dart';
// import 'package:spendly/features/lendings/domain/repositories/lending_repository.dart';
// import 'package:spendly/features/lendings/domain/usecases/create_lending_record_usecase.dart';
//
// class MockLendingRepository extends Mock implements LendingRepository {}
//
// void main() {
//   late MockLendingRepository mockLendingRepository;
//   late CreateLendingRecordUsecase useCase;
//
//   setUp(() {
//     mockLendingRepository = MockLendingRepository();
//     useCase = CreateLendingRecordUsecase(mockLendingRepository);
//   });
//
//   group('CreateLendingRecordUsecase', () {
//     final LendingEntity tLending = LendingEntity(
//       id: '1',
//       amount: 100,
//       date: DateTime.now(),
//       dueDate: DateTime.now().add(Duration(days: 7)),
//       userId: 'user1',
//       personName: 'user2',
//       type: LendingType.given,
//       note: 'Loan for groceries',
//     );
//
//     test('should create lending record successfully', () async {
//       // Arrange
//       when(() => mockLendingRepository.createLending(tLending))
//           .thenAnswer((_) async => Right(tLending));
//
//       // Act
//       final result = await useCase.execute(tLending);
//
//       // Assert
//       expect(result.isRight(), true);
//       verify(() => mockLendingRepository.createLending(tLending)).called(1);
//     });
//
//     test('should return failure if create lending fails', () async {
//       // Arrange
//       when(() => mockLendingRepository.createLending(tLending))
//           .thenAnswer((_) async => Left(Failure()));
//
//       // Act
//       final result = await useCase.execute(tLending);
//
//       // Assert
//       expect(result.isLeft(), true);
//       verify(() => mockLendingRepository.createLending(tLending)).called(1);
//     });
//   });
// }
