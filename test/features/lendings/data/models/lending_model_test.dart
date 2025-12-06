// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:spendly/features/lendings/data/models/lending/lending_model.dart';
// import 'package:spendly/features/lendings/domain/entity/lending/lending_entity.dart';
//
// void main() {
//   final tDateTimeCreated = DateTime(2024, 5, 10, 10, 30);
//   final tTimestampCreated = Timestamp.fromDate(tDateTimeCreated);
//   final tDateTimeDue = DateTime(2024, 8, 10);
//   final tTimestampDue = Timestamp.fromDate(tDateTimeDue);
//
//   final tLendingModel = LendingModel(
//     id: "testId123",
//     type: LendingType.given,
//     personName: "John Borrower",
//     amount: 1500.50,
//     description: "Loan for project",
//     createdDate: tDateTimeCreated,
//     dueDate: tDateTimeDue,
//     status: LendingStatus.due,
//     userId: "userABC",
//   );
//
//   final tLendingModelNoOptionals = LendingModel(
//     id: "testId456",
//     type: LendingType.taken,
//     personName: "Jane Lender",
//     amount: 300.0,
//     // description is null
//     createdDate: tDateTimeCreated,
//     // dueDate is null
//     status: LendingStatus.paid,
//     userId: "userXYZ",
//   );
//
//   test(
//     'should be a subclass of LendingEntity',
//     () async {
//       expect(tLendingModel, isA<LendingEntity>());
//     },
//   );
//
//   group('fromJson', () {
//     test('should return a valid model from JSON', () {
//       final Map<String, dynamic> jsonMap = {
//         'id': "testId123",
//         'type': 'given',
//         'personName': "John Borrower",
//         'amount': 1500.50, // Can be double
//         'description': "Loan for project",
//         'createdDate': tTimestampCreated,
//         'dueDate': tTimestampDue,
//         'status': 'due',
//         'userId': "userABC",
//       };
//
//       final result = LendingModel.fromJson(jsonMap);
//
//       expect(result, equals(tLendingModel));
//     });
//
//     test('should return a valid model from JSON with null optional fields', () {
//       final Map<String, dynamic> jsonMap = {
//         'id': "testId456",
//         'type': 'taken',
//         'personName': "Jane Lender",
//         'amount': 300, // Can be int
//         'description': null,
//         'createdDate': tTimestampCreated,
//         'dueDate': null,
//         'status': 'paid',
//         'userId': "userXYZ",
//       };
//
//       final result = LendingModel.fromJson(jsonMap);
//
//       expect(result, equals(tLendingModelNoOptionals));
//       expect(result.description, isNull);
//       expect(result.dueDate, isNull);
//     });
//
//     test('should default LendingType correctly for invalid type string', () {
//       final Map<String, dynamic> jsonMap = {
//         'id': "testId123",
//         'type': 'invalid_type',
//         'personName': "John Borrower",
//         'amount': 1500.50,
//         'description': "Loan for project",
//         'createdDate': tTimestampCreated,
//         'dueDate': tTimestampDue,
//         'status': 'due',
//         'userId': "userABC",
//       };
//
//       final result = LendingModel.fromJson(jsonMap);
//
//       expect(result.type, LendingType.given); // Check default
//     });
//
//     test('should default LendingStatus correctly for invalid status string',
//         () {
//       final Map<String, dynamic> jsonMap = {
//         'id': "testId123",
//         'type': 'given',
//         'personName': "John Borrower",
//         'amount': 1500.50,
//         'description': "Loan for project",
//         'createdDate': tTimestampCreated,
//         'dueDate': tTimestampDue,
//         'status': 'invalid_status', // Invalid status
//         'userId': "userABC",
//       };
//
//       final result = LendingModel.fromJson(jsonMap);
//
//       expect(result.status, LendingStatus.due); // Check default
//     });
//
//     // Note: Tests for missing fields would likely cause runtime errors
//     // due to required fields in factory constructor, unless you add specific handling.
//     // Testing defaults for enums handles the primary parsing logic robustness.
//   });
//
//   group('toJson', () {
//     test('should convert LendingModel to JSON map correctly', () {
//       final result = tLendingModel.toJson();
//       final expectedJsonMap = {
//         'id': "testId123",
//         'type': 'given',
//         'personName': "John Borrower",
//         'amount': 1500.50,
//         'description': "Loan for project",
//         'createdDate': tTimestampCreated,
//         'dueDate': tTimestampDue,
//         'status': 'due',
//         'userId': "userABC",
//       };
//
//       expect(result, equals(expectedJsonMap));
//     });
//
//     test(
//         'should convert LendingModel with null optionals to JSON map correctly',
//         () {
//       final result = tLendingModelNoOptionals.toJson();
//       final expectedJsonMap = {
//         'id': "testId456",
//         'type': 'taken',
//         'personName': "Jane Lender",
//         'amount': 300.0,
//         'description': null,
//         'createdDate': tTimestampCreated,
//         'dueDate': null,
//         'status': 'paid',
//         'userId': "userXYZ",
//       };
//
//       expect(result, equals(expectedJsonMap));
//     });
//   });
//
//   test('should convert LendingModel to LendingEntity correctly', () {
//     final result = tLendingModel.toEntity();
//
//     // Basic type check
//     expect(result, isA<LendingEntity>());
//
//     // Check field values are copied correctly
//     expect(result.id, tLendingModel.id);
//     expect(result.type, tLendingModel.type);
//     expect(result.personName, tLendingModel.personName);
//     expect(result.amount, tLendingModel.amount);
//     expect(result.description, tLendingModel.description);
//     expect(result.createdDate, tLendingModel.createdDate);
//     expect(result.dueDate, tLendingModel.dueDate);
//     expect(result.status, tLendingModel.status);
//     expect(result.userId, tLendingModel.userId);
//
//     // Ensure it's not the same instance (if that matters for your logic)
//     expect(result, isNot(same(tLendingModel)));
//   });
// }
