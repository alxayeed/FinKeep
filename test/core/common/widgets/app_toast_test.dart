import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:finkeep/core/common/widgets/app_toast.dart';
import 'package:finkeep/core/responsive/responsive.dart';

void main() {
  Widget buildTestScaffold({required Widget child}) {
    return MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (context) {
            Responsive.init(context, refHeight: 844, refWidth: 390);
            return child;
          },
        ),
      ),
    );
  }

  testWidgets('AppToast.showSuccess renders message and check icon', (tester) async {
    await tester.pumpWidget(
      buildTestScaffold(
        child: Builder(
          builder: (context) => ElevatedButton(
            onPressed: () => AppToast.showSuccess(context, message: 'Expense saved successfully'),
            child: const Text('Show Success'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Show Success'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Expense saved successfully'), findsOneWidget);
    expect(find.byIcon(Icons.check_circle_rounded), findsOneWidget);
  });

  testWidgets('AppToast.showError renders message and error icon', (tester) async {
    await tester.pumpWidget(
      buildTestScaffold(
        child: Builder(
          builder: (context) => ElevatedButton(
            onPressed: () => AppToast.showError(context, message: 'An unexpected error occurred'),
            child: const Text('Show Error'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Show Error'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('An unexpected error occurred'), findsOneWidget);
    expect(find.byIcon(Icons.error_outline_rounded), findsOneWidget);
  });

  testWidgets('AppToast.showInfo renders message and info icon', (tester) async {
    await tester.pumpWidget(
      buildTestScaffold(
        child: Builder(
          builder: (context) => ElevatedButton(
            onPressed: () => AppToast.showInfo(context, message: 'Backup sync completed in background'),
            child: const Text('Show Info'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Show Info'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Backup sync completed in background'), findsOneWidget);
    expect(find.byIcon(Icons.info_outline_rounded), findsOneWidget);
  });

  testWidgets('AppToast.showDebug renders message and bug icon', (tester) async {
    await tester.pumpWidget(
      buildTestScaffold(
        child: Builder(
          builder: (context) => ElevatedButton(
            onPressed: () => AppToast.showDebug(context, message: 'Debug payload size: 14.2 KB'),
            child: const Text('Show Debug'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Show Debug'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Debug payload size: 14.2 KB'), findsOneWidget);
    expect(find.byIcon(Icons.bug_report_rounded), findsOneWidget);
  });

  testWidgets('AppToast with action button triggers callback on tap', (tester) async {
    bool actionInvoked = false;

    await tester.pumpWidget(
      buildTestScaffold(
        child: Builder(
          builder: (context) => ElevatedButton(
            onPressed: () => AppToast.showSuccess(
              context,
              message: 'Download complete',
              actionLabel: 'View',
              onAction: () {
                actionInvoked = true;
              },
            ),
            child: const Text('Show Toast with Action'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Show Toast with Action'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Download complete'), findsOneWidget);
    expect(find.text('View'), findsOneWidget);

    await tester.tap(find.text('View'));
    await tester.pump();

    expect(actionInvoked, isTrue);
  });

  testWidgets('AppToast.showView renders message and View action', (tester) async {
    bool viewInvoked = false;

    await tester.pumpWidget(
      buildTestScaffold(
        child: Builder(
          builder: (context) => ElevatedButton(
            onPressed: () => AppToast.showView(
              context,
              message: 'Report ready',
              onView: () {
                viewInvoked = true;
              },
            ),
            child: const Text('Show View Toast'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Show View Toast'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Report ready'), findsOneWidget);
    expect(find.text('View'), findsOneWidget);

    await tester.tap(find.text('View'));
    await tester.pump();

    expect(viewInvoked, isTrue);
  });
}
