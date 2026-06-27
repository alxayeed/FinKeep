// ignore_for_file: subtype_of_sealed_class, unused_import
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:finkeep/features/lendings/data/datasources/lending_firestore_data_source.dart';
import 'package:finkeep/features/lendings/data/models/lending_person/lending_person_model.dart';

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}
class MockCollectionReference extends Mock implements CollectionReference<Map<String, dynamic>> {}
class MockQuerySnapshot extends Mock implements QuerySnapshot<Map<String, dynamic>> {}
class MockQueryDocumentSnapshot extends Mock implements QueryDocumentSnapshot<Map<String, dynamic>> {}
class MockDocumentReference extends Mock implements DocumentReference<Map<String, dynamic>> {}
class MockDocumentSnapshot extends Mock implements DocumentSnapshot<Map<String, dynamic>> {}

void main() {
  late MockFirebaseFirestore mockFirestore;
  late MockCollectionReference mockLendingsCollection;
  late MockCollectionReference mockPersonsCollection;
  late MockCollectionReference mockRepaymentsCollection;
  late LendingFirestoreDataSource dataSource;

  setUp(() {
    mockFirestore = MockFirebaseFirestore();
    mockLendingsCollection = MockCollectionReference();
    mockPersonsCollection = MockCollectionReference();
    mockRepaymentsCollection = MockCollectionReference();

    when(() => mockFirestore.collection(any())).thenAnswer((invocation) {
      final path = invocation.positionalArguments[0] as String;
      if (path.startsWith('lendings')) {
        return mockLendingsCollection;
      } else if (path.startsWith('loan_parties')) {
        return mockPersonsCollection;
      } else {
        return mockRepaymentsCollection;
      }
    });

    dataSource = LendingFirestoreDataSource(firestore: mockFirestore);
  });

  group('LendingFirestoreDataSource.getLendings', () {
    test('should return lending records with fallback Unknown Person when person is not found', () async {
      // Arrange
      final mockLendingDoc = MockQueryDocumentSnapshot();
      final mockLendingData = {
        'type': 'given',
        'personId': 'non_existent_person_id',
        'amount': 1000.0,
        'repaidAmount': 0.0,
        'description': 'Test lending',
        'createdDate': Timestamp.fromDate(DateTime(2026, 6, 27)),
        'status': 'due',
        'paymentMethod': 'cash',
        'repayments': [],
      };

      final mockQuerySnapshot = MockQuerySnapshot();
      when(() => mockLendingDoc.id).thenReturn('lend_1');
      when(() => mockLendingDoc.data()).thenReturn(mockLendingData);
      when(() => mockQuerySnapshot.docs).thenReturn([mockLendingDoc]);
      when(() => mockLendingsCollection.get()).thenAnswer((_) async => mockQuerySnapshot);

      final mockPersonDocRef = MockDocumentReference();
      final mockPersonDocSnapshot = MockDocumentSnapshot();

      when(() => mockPersonsCollection.doc('non_existent_person_id')).thenReturn(mockPersonDocRef);
      when(() => mockPersonDocRef.get()).thenAnswer((_) async => mockPersonDocSnapshot);
      when(() => mockPersonDocSnapshot.exists).thenReturn(false);

      // Act
      final result = await dataSource.getLendings();

      // Assert
      expect(result, isNotEmpty);
      expect(result.first.id, 'lend_1');
      expect(result.first.person.id, 'non_existent_person_id');
      expect(result.first.person.name, 'Unknown Person');
    });
  });
}
