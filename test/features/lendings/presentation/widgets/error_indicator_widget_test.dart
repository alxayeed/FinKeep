import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spendly/core/common/widgets/error_widget.dart';

void main() {
  testWidgets('ErrorIndicator displays the correct error message',
      (tester) async {
    const errorMessage = 'Something went wrong!';

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ErrorIndicatorWidget(errorMessage: errorMessage),
        ),
      ),
    );

    expect(find.text(errorMessage), findsOneWidget);
  });

  testWidgets('ErrorIndicator displays an error icon', (tester) async {
    const errorMessage = 'Something went wrong!';

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ErrorIndicatorWidget(errorMessage: errorMessage),
        ),
      ),
    );

    expect(find.byIcon(Icons.error), findsOneWidget);
  });

  testWidgets('ErrorIndicator has correct styling', (tester) async {
    const errorMessage = 'Something went wrong!';

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ErrorIndicatorWidget(errorMessage: errorMessage),
        ),
      ),
    );

    final cardFinder = find.byType(Card);
    final textFinder = find.text(errorMessage);
    final iconFinder = find.byIcon(Icons.error);

    final card = tester.widget<Card>(cardFinder);
    expect(card.color, Colors.redAccent);

    final text = tester.widget<Text>(textFinder);
    expect(text.style?.color, Colors.white);

    final icon = tester.widget<Icon>(iconFinder);
    expect(icon.color, Colors.white);
  });
}
