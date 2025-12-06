// import 'package:dartz/dartz.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mocktail/mocktail.dart';
// import 'package:spendly/core/error/failure.dart';
// import 'package:spendly/core/usecase/usecase.dart';
// import 'package:spendly/features/lendings/domain/entity/lending_entity.dart';
// import 'package:spendly/features/lendings/domain/repositories/lending_repository.dart';
// import 'package:spendly/features/lendings/domain/usecases/get_all_lendings_usecase.dart';
//
// class MockLendingRepository extends Mock implements LendingRepository {}
//
// void main() {
//   late GetAllLendingsUseCase useCase;
//   late MockLendingRepository mockLendingRepository;
//
//   setUp(() {
//     mockLendingRepository = MockLendingRepository();
//     useCase = GetAllLendingsUseCase(mockLendingRepository);
//   });
//
//   group('GetAllLendingsUseCase', () {
//     final List<LendingEntity> tMockLendingList = [
//       LendingEntity(
//         id: "test_id",
//         amount: 100,
//         date: DateTime.now(),
//         dueDate: DateTime.now().add(Duration(days: 30)),
//         lenderId: 'lender1',
//         borrowerName: 'John Doe',
//         type: LendingType.given,
//         note: 'Personal loan',
//       ),
//     ];
//
//     test(
//         'should return a list of LendingEntity when the repository returns data',
//         () async {
//       // Arrange
//       when(() => mockLendingRepository.getAllLendings()).thenAnswer(
//         (_) async => Right(tMockLendingList),
//       );
//
//       // Act
//       final result = await useCase(NoParams());
//
//       // Assert
//       expect(result.isRight(), true);
//       result.fold(
//         (failure) => null,
//         (lendings) {
//           expect(lendings, isA<List<LendingEntity>>());
//           expect(lendings.length, 1);
//           expect(lendings[0].borrowerName, 'John Doe');
//         },
//       );
//     });
//
//     test(
//         'should return a NetworkFailure when the repository fails to fetch data',
//         () async {
//       // Arrange
//       when(() => mockLendingRepository.getAllLendings()).thenAnswer(
//         (_) async => Left(NetworkFailure(message: 'Failed to load lendings')),
//       );
//
//       // Act
//       final result = await useCase(NoParams());
//
//       // Assert
//       expect(result.isLeft(), true);
//       result.fold(
//         (failure) {
//           expect(failure, isA<NetworkFailure>());
//           expect(
//               (failure as NetworkFailure).message, 'Failed to load lendings');
//         },
//         (lendings) => null,
//       );
//     });
//
//     test(
//         'should return a ServerFailure when the repository returns a server failure',
//         () async {
//       // Arrange
//       when(() => mockLendingRepository.getAllLendings()).thenAnswer(
//         (_) async => Left(ServerFailure(message: 'Internal server error')),
//       );
//
//       // Act
//       final result = await useCase(NoParams());
//
//       // Assert
//       expect(result.isLeft(), true);
//       result.fold(
//         (failure) {
//           expect(failure, isA<ServerFailure>());
//           expect((failure as ServerFailure).message, 'Internal server error');
//         },
//         (lendings) => null,
//       );
//     });
//
//     test('should return an empty list when the repository returns no lendings',
//         () async {
//       // Arrange
//       when(() => mockLendingRepository.getAllLendings()).thenAnswer(
//         (_) async => Right([]), // Returning an empty list
//       );
//
//       // Act
//       final result = await useCase(NoParams());
//
//       // Assert
//       expect(result.isRight(), true);
//       result.fold(
//         (failure) => null,
//         (lendings) {
//           expect(lendings, isA<List<LendingEntity>>());
//           expect(lendings.isEmpty, true); // Expecting the list to be empty
//         },
//       );
//     });
//
//     // test(
//     //     'should return a Failure when the repository throws an unexpected error',
//     //     () async {
//     //   // Arrange
//     //   when(() => mockLendingRepository.getAllLendings()).thenThrow(
//     //     Exception('Unexpected error'),
//     //   );
//     //
//     //   // Act
//     //   final result = await useCase.execute();
//     //
//     //   // Assert
//     //   expect(result.isLeft(), true);
//     //   result.fold(
//     //     (failure) {
//     //       // Here, we would expect some kind of generic failure, or you could handle it in another failure class.
//     //       expect(failure, isA<Failure>());
//     //     },
//     //     (lendings) => null,
//     //   );
//     // });
//   });
// }
