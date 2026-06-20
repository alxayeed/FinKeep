import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:finkeep/core/common/widgets/error_widget.dart';

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

  testWidgets('ErrorIndicator shows retry button when onRetry is provided',
      (tester) async {
    const errorMessage = 'Something went wrong!';
    bool retryCalled = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ErrorIndicatorWidget(
            errorMessage: errorMessage,
            onRetry: () {
              retryCalled = true;
            },
          ),
        ),
      ),
    );

    final retryButtonFinder = find.widgetWithText(ElevatedButton, 'Retry');
    expect(retryButtonFinder, findsOneWidget);

    await tester.tap(retryButtonFinder);
    expect(retryCalled, true);
  });
}
