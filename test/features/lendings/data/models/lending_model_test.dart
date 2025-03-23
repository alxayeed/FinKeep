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
}
