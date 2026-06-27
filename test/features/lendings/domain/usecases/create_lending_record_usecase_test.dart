import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:finkeep/core/enums/payment_type.dart';
import 'package:finkeep/features/lendings/domain/entity/lending/lending_entity.dart';
import 'package:finkeep/features/lendings/domain/entity/lending_person/lending_person_entity.dart';
import 'package:finkeep/features/lendings/domain/repositories/lending_repository.dart';
import 'package:finkeep/features/lendings/domain/usecases/lending/add_lending_usecase.dart';

class MockLendingRepository extends Mock implements LendingRepository {}

void main() {
  late MockLendingRepository mockRepository;
  late AddLendingUseCase useCase;

  setUp(() {
    mockRepository = MockLendingRepository();
    useCase = AddLendingUseCase(repository: mockRepository);
    registerFallbackValue(const LendingPersonEntity(id: '', name: ''));
    registerFallbackValue(
      LendingEntity(
        id: '1',
        type: LendingType.given,
        personId: '',
        person: const LendingPersonEntity(id: '', name: 'Test Person'),
        amount: 100.0,
        repaidAmount: 0.0,
        createdDate: DateTime(2026, 6, 27),
        status: LendingStatus.due,
      ),
    );
  });

  group('AddLendingUseCase TDD test', () {
    test('should update personId in lending when creating a new person', () async {
      // Arrange
      const newPerson = LendingPersonEntity(id: '', name: 'New Person');
      final lending = LendingEntity(
        id: 'lending_1',
        type: LendingType.given,
        personId: '',
        person: newPerson,
        amount: 500.0,
        repaidAmount: 0.0,
        createdDate: DateTime(2026, 6, 27),
        status: LendingStatus.due,
      );

      const createdPerson = LendingPersonEntity(id: 'created_person_id', name: 'New Person');

      when(() => mockRepository.addPerson(any())).thenAnswer((_) async => const Right(null));
      when(() => mockRepository.getUserPersons(nameFilter: 'New Person'))
          .thenAnswer((_) async => const Right([createdPerson]));
      when(() => mockRepository.addLending(any())).thenAnswer((_) async => const Right(null));

      // Act
      final result = await useCase(lending);

      // Assert
      expect(result, const Right(null));
      
      // Verify repository.addLending was called with updated personId and person
      final verification = verify(() => mockRepository.addLending(captureAny()));
      final capturedLending = verification.captured.first as LendingEntity;
      
      expect(capturedLending.person.id, 'created_person_id');
      expect(capturedLending.personId, 'created_person_id'); // This should fail on current implementation
    });
  });
}
