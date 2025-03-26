import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spendly/core/constants/app_strings.dart';
import 'package:spendly/core/enums/lending_type.dart';
import 'package:spendly/features/lendings/domain/entity/lend_entity.dart';
import 'package:spendly/features/lendings/presentation/widgets/lending_card_widget.dart';

void main() {
  testWidgets('LendingCardWidget displays the correct lending details',
      (tester) async {
    final lending = LendingEntity(
      id: '1',
      amount: 500,
      date: DateTime.now(),
      dueDate: DateTime.now().add(Duration(days: 7)),
      lenderId: 'lender_1',
      borrowerName: 'John Doe',
      type: LendingType.given,
      note: 'Test note',
    );

    await tester.pumpWidget(
      MaterialApp(
        home: LendingCardWidget(lending: lending),
      ),
    );

    expect(find.text('Amount: 500'), findsOneWidget);
    expect(find.text('Borrower: John Doe'), findsOneWidget);
    expect(
        find.text('Due: ${lending.dueDate.toLocal().toString().split(' ')[0]}'),
        findsOneWidget);
  });

  testWidgets(
      'LendingCardWidget displays the correct lending details without a note',
      (tester) async {
    final lending = LendingEntity(
      id: '2',
      amount: 300,
      date: DateTime.now(),
      dueDate: DateTime.now().add(Duration(days: 7)),
      lenderId: 'lender_2',
      borrowerName: 'Jane Doe',
      type: LendingType.taken,
      note: null,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: LendingCardWidget(lending: lending),
      ),
    );

    expect(find.text('Amount: 300'), findsOneWidget);
    expect(find.text('Borrower: Jane Doe'), findsOneWidget);
    expect(
        find.text('Due: ${lending.dueDate.toLocal().toString().split(' ')[0]}'),
        findsOneWidget);
    expect(find.text('Note: ${AppStrings.notAvailable}'),
        findsOneWidget); // Check for the placeholder text
  });

  testWidgets('LendingCardWidget displays formatted due date correctly',
      (tester) async {
    final lending = LendingEntity(
      id: '3',
      amount: 1500,
      date: DateTime.now(),
      dueDate: DateTime(2025, 12, 31),
      lenderId: 'lender_3',
      borrowerName: 'Mark Smith',
      type: LendingType.given,
      note: 'Test note',
    );

    await tester.pumpWidget(
      MaterialApp(
        home: LendingCardWidget(lending: lending),
      ),
    );

    expect(find.text('Amount: 1500'), findsOneWidget);
    expect(find.text('Borrower: Mark Smith'), findsOneWidget);
    expect(find.text('Due: 2025-12-31'), findsOneWidget);
  });

  testWidgets(
      'LendingCardWidget displays default due date formatting for edge cases',
      (tester) async {
    final lending = LendingEntity(
      id: '4',
      amount: 100,
      date: DateTime.now(),
      dueDate: DateTime.now(),
      lenderId: 'lender_4',
      borrowerName: 'Emily White',
      type: LendingType.taken,
      note: 'Urgent payment',
    );

    await tester.pumpWidget(
      MaterialApp(
        home: LendingCardWidget(lending: lending),
      ),
    );

    expect(find.text('Amount: 100'), findsOneWidget);
    expect(find.text('Borrower: Emily White'), findsOneWidget);
    expect(
        find.text('Due: ${lending.dueDate.toLocal().toString().split(' ')[0]}'),
        findsOneWidget);
  });
}
