import 'package:flutter_test/flutter_test.dart';
import 'package:spendly/core/enums/lending_type.dart';
import 'package:spendly/features/lendings/data/models/lending_model.dart';
import 'package:spendly/features/lendings/domain/entity/lend_entity.dart';

void main() {
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

  test(
    'should be a subclass of LendingEntity',
    () async {
      // Assert
      expect(tLendingModel, isA<LendingEntity>());
    },
  );

  test('should parse LendingType correctly from JSON', () {
    final jsonMap = {
      'id': 'testId',
      'amount': 1000,
      'date': '2025-03-23T00:00:00.000',
      'dueDate': '2025-06-23T00:00:00.000',
      'lenderId': 'Lender123',
      'borrowerName': 'John Doe',
      'type': 'given',
      'note': 'Test note',
    };

    final result = LendingModel.fromJson(jsonMap);

    expect(result.type, LendingType.given);
  });

  test('should default to LendingType.given for invalid type in JSON', () {
    final jsonMap = {
      'id': 'testId',
      'amount': 1000,
      'date': '2025-03-23T00:00:00.000',
      'dueDate': '2025-06-23T00:00:00.000',
      'lenderId': 'Lender123',
      'borrowerName': 'John Doe',
      'type': 'invalid_type',
      'note': 'Test note',
    };

    final result = LendingModel.fromJson(jsonMap);

    expect(result.type, LendingType.given);
  });

  test('should default to LendingType.given when type is missing in JSON', () {
    final jsonMap = {
      'id': 'testId',
      'amount': 1000,
      'date': '2025-03-23T00:00:00.000',
      'dueDate': '2025-06-23T00:00:00.000',
      'lenderId': 'Lender123',
      'borrowerName': 'John Doe',
      'note': 'Test note',
    };

    final result = LendingModel.fromJson(jsonMap);

    expect(result.type, LendingType.given);
  });

  test('should convert LendingModel to JSON correctly', () {
    final result = tLendingModel.toJson();

    expect(result, {
      'id': 'testId',
      'amount': 1000,
      'date': '2025-03-23T00:00:00.000',
      'dueDate': '2025-06-23T00:00:00.000',
      'lenderId': 'Lender123',
      'borrowerName': 'John Doe',
      'type': 'given',
      'note': 'Test note',
    });
  });

  test('should convert LendingModel to LendingEntity correctly', () {
    final result = tLendingModel.toEntity();

    expect(result, isA<LendingEntity>());

    expect(result.id, tLendingModel.id);
    expect(result.amount, tLendingModel.amount);
    expect(result.date, tLendingModel.date);
    expect(result.dueDate, tLendingModel.dueDate);
    expect(result.lenderId, tLendingModel.lenderId);
    expect(result.borrowerName, tLendingModel.borrowerName);
    expect(result.type, tLendingModel.type);
    expect(result.note, tLendingModel.note);
  });
}
