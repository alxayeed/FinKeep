import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:finkeep/core/responsive/responsive.dart';
import 'package:finkeep/features/expense/presentation/widgets/missing_budget_dialog.dart';

void main() {
  testWidgets('MissingBudgetDialog renders months and triggers onSkip on Skip tap', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    bool skipCalled = false;
    double? savedAmount;

    final missingMonths = [
      DateTime(2026, 1, 1),
      DateTime(2026, 2, 1),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            Responsive.init(context, refHeight: 844, refWidth: 390);
            return Scaffold(
              body: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => MissingBudgetDialog(
                      missingMonths: missingMonths,
                      onSave: (amount) => savedAmount = amount,
                      onSkip: () => skipCalled = true,
                    ),
                  );
                },
                child: const Text('Open Dialog'),
              ),
            );
          },
        ),
      ),
    );

    await tester.tap(find.text('Open Dialog'));
    await tester.pumpAndSettle();

    expect(find.text('Missing Budgets Detected'), findsOneWidget);
    expect(find.textContaining('January 2026, February 2026'), findsOneWidget);
    expect(find.text('Skip'), findsOneWidget);
    expect(find.text('Save Budget'), findsOneWidget);

    // Tap Skip
    await tester.tap(find.text('Skip'));
    await tester.pumpAndSettle();

    expect(skipCalled, isTrue);
    expect(savedAmount, isNull);
  });

  testWidgets('MissingBudgetDialog triggers onSave on valid budget entered', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    bool skipCalled = false;
    double? savedAmount;

    final missingMonths = [
      DateTime(2026, 1, 1),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            Responsive.init(context, refHeight: 844, refWidth: 390);
            return Scaffold(
              body: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => MissingBudgetDialog(
                      missingMonths: missingMonths,
                      onSave: (amount) => savedAmount = amount,
                      onSkip: () => skipCalled = true,
                    ),
                  );
                },
                child: const Text('Open Dialog'),
              ),
            );
          },
        ),
      ),
    );

    await tester.tap(find.text('Open Dialog'));
    await tester.pumpAndSettle();

    // Enter valid amount
    await tester.enterText(find.byType(TextField), '25000');
    await tester.tap(find.text('Save Budget'));
    await tester.pumpAndSettle();

    expect(savedAmount, 25000.0);
    expect(skipCalled, isFalse);
  });
}
