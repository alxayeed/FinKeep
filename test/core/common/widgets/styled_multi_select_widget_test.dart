import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:finkeep/core/common/widgets/styled_multi_category_selector_field.dart';
import 'package:finkeep/core/common/widgets/styled_multi_select_widget.dart';
import 'package:finkeep/core/responsive/responsive.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('StyledMultiSelectWidget allows toggling items and select all',
      (WidgetTester tester) async {
    Set<String> selected = {'Food'};
    final items = ['Food', 'Transport', 'Shopping'];

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            Responsive.init(context, refHeight: 844, refWidth: 390);
            return Scaffold(
              body: StatefulBuilder(
                builder: (context, setState) {
                  return StyledMultiSelectWidget<String>(
                    items: items,
                    selectedItems: selected,
                    titleExtractor: (item) => item,
                    onSelectionChanged: (updated) {
                      setState(() => selected = updated);
                    },
                  );
                },
              ),
            );
          },
        ),
      ),
    );

    expect(find.text('Select All'), findsOneWidget);
    expect(find.text('Food'), findsOneWidget);
    expect(find.text('Transport'), findsOneWidget);
    expect(find.text('Shopping'), findsOneWidget);
    expect(find.text('1/3'), findsOneWidget);

    // Tap Transport to add it
    await tester.tap(find.text('Transport'));
    await tester.pumpAndSettle();
    expect(selected.contains('Transport'), isTrue);
    expect(find.text('2/3'), findsOneWidget);

    // Tap Select All to select all
    await tester.tap(find.text('Select All'));
    await tester.pumpAndSettle();
    expect(selected.length, 3);
    expect(find.text('3/3'), findsOneWidget);

    // Tap Select All again to deselect all
    await tester.tap(find.text('Select All'));
    await tester.pumpAndSettle();
    expect(selected.isEmpty, isTrue);
    expect(find.text('0/3'), findsOneWidget);
  });

  testWidgets('StyledMultiCategorySelectorField opens sheet and applies selection',
      (WidgetTester tester) async {
    Set<String> selected = {'Food'};
    final items = ['Food', 'Transport', 'Utilities'];

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            Responsive.init(context, refHeight: 844, refWidth: 390);
            return Scaffold(
              body: StatefulBuilder(
                builder: (context, setState) {
                  return StyledMultiCategorySelectorField<String>(
                    selectedItems: selected,
                    labelText: 'Categories',
                    items: items,
                    titleExtractor: (item) => item,
                    onSelectionChanged: (updated) {
                      setState(() => selected = updated);
                    },
                  );
                },
              ),
            );
          },
        ),
      ),
    );

    expect(find.text('Categories'), findsOneWidget);

    // Tap the selector box
    await tester.tap(find.byIcon(Icons.category_rounded));
    await tester.pumpAndSettle();

    expect(find.text('Select Categories'), findsOneWidget);
    expect(find.text('Done (1)'), findsOneWidget);

    // Tap Done
    await tester.tap(find.text('Done (1)'));
    await tester.pumpAndSettle();

    // Sheet closed
    expect(find.text('Select Categories'), findsNothing);
  });
}
