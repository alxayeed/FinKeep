import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:finkeep/features/lendings/presentation/widgets/loading_indicator_widget.dart';

void main() {
  testWidgets('LoadingIndicator displays a loading spinner', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: LoadingIndicatorWidget(),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('LoadingIndicator has correct styling', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: LoadingIndicatorWidget(),
        ),
      ),
    );

    final circularProgressIndicatorFinder =
        find.byType(CircularProgressIndicator);
    final circularProgressIndicator = tester
        .widget<CircularProgressIndicator>(circularProgressIndicatorFinder);

    final color =
        (circularProgressIndicator.valueColor as AlwaysStoppedAnimation<Color>)
            .value;
    expect(color, Colors.blue);
  });

  testWidgets('LoadingIndicator can display custom color', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: LoadingIndicatorWidget(color: Colors.green),
        ),
      ),
    );

    final circularProgressIndicatorFinder =
        find.byType(CircularProgressIndicator);
    final circularProgressIndicator = tester
        .widget<CircularProgressIndicator>(circularProgressIndicatorFinder);

    final color =
        (circularProgressIndicator.valueColor as AlwaysStoppedAnimation<Color>)
            .value;
    expect(color, Colors.green);
  });
}
