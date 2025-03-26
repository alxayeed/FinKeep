// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mocktail/mocktail.dart';
// import 'package:spendly/core/enums/lending_type.dart';
// import 'package:spendly/core/error/exceptions.dart';
// import 'package:spendly/features/lendings/data/datasources/lending_firestore_data_source.dart';
// import 'package:spendly/features/lendings/data/models/lending_model.dart';
//
// // Mock class for FirebaseFirestore
// class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}
//
// class MockQuerySnapshot extends Mock
//     implements QuerySnapshot<Map<String, dynamic>> {}
//
// class MockQueryDocumentSnapshot extends Mock {
//   Map<String, dynamic> data() {
//     return {
//       'id': 'testId',
//       'amount': 1000,
//       'date': Timestamp.fromDate(DateTime(2025, 3, 23)),
//       'dueDate': Timestamp.fromDate(DateTime(2025, 6, 23)),
//       'lenderId': 'Lender123',
//       'borrowerName': 'John Doe',
//       'type': 'given',
//       'note': 'Test note',
//     };
//   }
// }
//
// void main() {
//   late LendingFirestoreDataSource lendingFirestoreDataSource;
//   late MockFirebaseFirestore mockFirebaseFirestore;
//
//   setUp(() {
//     mockFirebaseFirestore = MockFirebaseFirestore();
//     lendingFirestoreDataSource =
//         LendingFirestoreDataSource(firestore: mockFirebaseFirestore);
//   });
//
//   group('getAllLendings', () {
//     final tLendingModel = LendingModel(
//       id: "testId",
//       amount: 1000,
//       date: DateTime(2025, 3, 23),
//       dueDate: DateTime(2025, 6, 23),
//       lenderId: 'Lender123',
//       borrowerName: 'John Doe',
//       type: LendingType.given,
//       note: 'Test note',
//     );
//
//     test(
//         'should return a list of LendingModel when data is fetched successfully',
//         () async {
//       final mockQuerySnapshot = MockQuerySnapshot();
//       final mockDoc = MockQueryDocumentSnapshot();
//
//       when(() => mockQuerySnapshot.docs).thenReturn([mockDoc]);
//       when(() => mockFirebaseFirestore.collection('lendings').get())
//           .thenAnswer((_) async => mockQuerySnapshot);
//
//       final result = await lendingFirestoreDataSource.getAllLendings();
//
//       expect(result, isA<List<LendingModel>>());
//       expect(result.length, 1);
//       expect(result[0], tLendingModel);
//     });
//
//     test(
//         'should throw ServerException when an error occurs while fetching data',
//         () async {
//       when(() => mockFirebaseFirestore.collection('lendings').get())
//           .thenThrow(Exception('Failed to fetch data'));
//
//       final call = lendingFirestoreDataSource.getAllLendings;
//
//       expect(() => call(), throwsA(isA<ServerException>()));
//     });
//   });
// }
