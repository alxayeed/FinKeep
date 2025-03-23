import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spendly/core/enums/lending_type.dart';
import 'package:spendly/features/lendings/domain/entity/lend_entity.dart';
import 'package:spendly/features/lendings/domain/repositories/lending_repository.dart';
import 'package:spendly/features/lendings/domain/usecases/get_all_lendings_usecase.dart';

class MockLendingRepository extends Mock implements LendingRepository {}

void main() {
  late GetAllLendingsUseCase useCase;
  late MockLendingRepository mockLendingRepository;

  setUp(() {
    mockLendingRepository = MockLendingRepository();
    useCase = GetAllLendingsUseCase(mockLendingRepository);
  });

  group('GetAllLendingsUseCase', () {
    final List<LendingEntity> tMockLendingList = [
      LendingEntity(
        amount: 100,
        date: DateTime.now(),
        dueDate: DateTime.now().add(Duration(days: 30)),
        lenderId: 'lender1',
        borrowerName: 'John Doe',
        type: LendingType.given,
        note: 'Personal loan',
      ),
    ];

    test(
        'should return a list of LendingEntity when the repository returns data',
        () async {
      //Arrange
      when(() => mockLendingRepository.getAllLendings()).thenAnswer(
        (_) async => Right(tMockLendingList),
      );

      //Act
      final result = await useCase.execute();

      //Assert
      expect(result.isRight(), true);
      result.fold(
        (failure) => null,
        (lendings) {
          expect(lendings, isA<List<LendingEntity>>());
          expect(lendings.length, 1);
          expect(lendings[0].borrowerName, 'John Doe');
        },
      );
    });
  });
}
