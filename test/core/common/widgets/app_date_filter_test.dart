import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:finkeep/core/common/models/date_filter.dart';
import 'package:finkeep/core/common/widgets/app_date_filter.dart';
import 'package:finkeep/core/responsive/responsive.dart';

void main() {
  Widget createWidgetUnderTest(Widget child) {
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

  group('AppDateFilter Widget Tests', () {
    testWidgets('Header variant renders displayTitle and chevrons', (tester) async {
      DateFilter currentFilter = DateFilter(
        type: DateFilterType.monthly,
        referenceDate: DateTime(2026, 8, 1),
      );

      await tester.pumpWidget(
        createWidgetUnderTest(
          AppDateFilter(
            dateFilter: currentFilter,
            onDateFilterChanged: (newFilter) => currentFilter = newFilter,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('August 2026'), findsOneWidget);
      expect(find.byIcon(Icons.chevron_left), findsOneWidget);
      expect(find.byIcon(Icons.chevron_right), findsOneWidget);
    });

    testWidgets('Inline variant renders type chips and period navigator', (tester) async {
      DateFilter currentFilter = DateFilter(
        type: DateFilterType.yearly,
        referenceDate: DateTime(2026, 1, 1),
      );

      await tester.pumpWidget(
        createWidgetUnderTest(
          StatefulBuilder(
            builder: (context, setState) {
              return AppDateFilter.inline(
                dateFilter: currentFilter,
                onDateFilterChanged: (newFilter) {
                  setState(() => currentFilter = newFilter);
                },
              );
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Yearly'), findsOneWidget);
      expect(find.text('Monthly'), findsOneWidget);
      expect(find.text('Year 2026'), findsOneWidget);

      // Tap next chevron
      await tester.tap(find.byIcon(Icons.chevron_right_rounded));
      await tester.pumpAndSettle();
      expect(find.text('Year 2027'), findsOneWidget);
    });

    testWidgets('Inline variant custom date renders independent Start and End date fields', (tester) async {
      DateFilter currentFilter = DateFilter(
        type: DateFilterType.custom,
        referenceDate: DateTime(2026, 8, 1),
        customStartDate: DateTime(2026, 8, 1),
        customEndDate: DateTime(2026, 8, 31),
      );

      await tester.pumpWidget(
        createWidgetUnderTest(
          StatefulBuilder(
            builder: (context, setState) {
              return AppDateFilter.inline(
                dateFilter: currentFilter,
                onDateFilterChanged: (newFilter) {
                  setState(() => currentFilter = newFilter);
                },
              );
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify Start Date & End Date fields exist
      expect(find.text('Start Date'), findsOneWidget);
      expect(find.text('End Date'), findsOneWidget);
      expect(find.text('01/08/2026'), findsOneWidget);
      expect(find.text('31/08/2026'), findsOneWidget);

      // Tap Start Date to open date picker dialog
      await tester.tap(find.text('Start Date'));
      await tester.pumpAndSettle();

      // Verify DatePicker dialog is displayed
      expect(find.byType(DatePickerDialog), findsOneWidget);
    });
  });
}
