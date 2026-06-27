// ignore_for_file: unused_import
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:hive/hive.dart';
import 'package:finkeep/core/services/local_db_service.dart';
import 'package:finkeep/features/lendings/data/datasources/lending_hive_datasource.dart';
import 'package:finkeep/features/lendings/data/models/lending_person/lending_person_model.dart';

class MockLocalDbService extends Mock implements LocalDbService {}
class MockHiveBox extends Mock implements Box<Map> {}

void main() {
  late MockLocalDbService mockLocalDb;
  late MockHiveBox mockLendingsBox;
  late MockHiveBox mockPersonsBox;
  late LendingHiveDataSource dataSource;

  setUp(() {
    mockLocalDb = MockLocalDbService();
    mockLendingsBox = MockHiveBox();
    mockPersonsBox = MockHiveBox();

    when(() => mockLocalDb.lendingsBox).thenReturn(mockLendingsBox);
    when(() => mockLocalDb.personsBox).thenReturn(mockPersonsBox);

    dataSource = LendingHiveDataSource(localDb: mockLocalDb);
  });

  group('LendingHiveDataSource.getLendings', () {
    test('should return lending records with fallback Unknown Person when person is not found', () async {
      // Arrange
      final lendingMap = {
        'id': 'lend_1',
        'type': 'given',
        'personId': 'non_existent_person_id',
        'amount': 1000.0,
        'repaidAmount': 0.0,
        'description': 'Test lending record',
        'createdDate': DateTime(2026, 6, 27).toIso8601String(),
        'status': 'due',
        'paymentMethod': 'cash',
        'repayments': [],
      };

      when(() => mockLendingsBox.values).thenReturn([lendingMap]);
      when(() => mockPersonsBox.get('non_existent_person_id')).thenReturn(null);

      // Act
      final result = await dataSource.getLendings();

      // Assert
      expect(result, isNotEmpty);
      expect(result.first.id, 'lend_1');
      expect(result.first.person.id, 'non_existent_person_id');
      expect(result.first.person.name, 'Unknown Person');
    });

    test('should heal lending record and restore person info from nested person map when personId is empty', () async {
      // Arrange
      final lendingMap = {
        'id': 'lend_2',
        'type': 'given',
        'personId': '', // empty personId
        'amount': 1500.0,
        'repaidAmount': 0.0,
        'description': 'Test healing',
        'createdDate': DateTime(2026, 6, 27).toIso8601String(),
        'status': 'due',
        'paymentMethod': 'cash',
        'repayments': [],
        'person': {
          'id': 'p_recovered_1',
          'name': 'Recovered Person Name',
          'contactNumber': '+88012345',
        },
      };

      when(() => mockLendingsBox.values).thenReturn([lendingMap]);
      when(() => mockPersonsBox.get('p_recovered_1')).thenReturn({
        'id': 'p_recovered_1',
        'name': 'Recovered Person Name',
        'contactNumber': '+88012345',
      });
      when(() => mockLendingsBox.put('lend_2', any())).thenAnswer((_) async {});

      // Act
      final result = await dataSource.getLendings();

      // Assert
      expect(result, isNotEmpty);
      expect(result.first.id, 'lend_2');
      expect(result.first.personId, 'p_recovered_1'); // Should be healed
      expect(result.first.person.name, 'Recovered Person Name');
      expect(result.first.person.contactNumber, '+88012345');
      verify(() => mockLendingsBox.put('lend_2', any())).called(1);
    });
  });
}
