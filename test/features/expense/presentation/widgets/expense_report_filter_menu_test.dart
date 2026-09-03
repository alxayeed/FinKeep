import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:finkeep/core/common/models/date_filter.dart';
import 'package:finkeep/core/responsive/responsive.dart';
import 'package:finkeep/core/styles/currency_provider.dart';
import 'package:finkeep/features/expense/domain/entities/expense_category_entity.dart';
import 'package:finkeep/features/expense/domain/usecases/usecases.dart';
import 'package:finkeep/features/expense/domain/usecases/add_expense_category_usecase.dart';
import 'package:finkeep/features/expense/domain/usecases/get_expense_categories_usecase.dart';
import 'package:finkeep/features/expense/domain/usecases/update_expense_category_usecase.dart';
import 'package:finkeep/features/expense/domain/usecases/delete_expense_category_usecase.dart';
import 'package:finkeep/features/expense/presentation/controllers/expense_category_controller.dart';
import 'package:finkeep/features/expense/presentation/controllers/expense_report_controller.dart';
import 'package:finkeep/features/expense/presentation/widgets/expense_report_filter_menu.dart';

class MockGetExpensesInRangeUseCase extends Mock
    implements GetExpensesInRangeUseCase {}

class MockAddExpenseCategoryUseCase extends Mock
    implements AddExpenseCategoryUseCase {}

class MockGetExpenseCategoriesUseCase extends Mock
    implements GetExpenseCategoriesUseCase {}

class MockUpdateExpenseCategoryUseCase extends Mock
    implements UpdateExpenseCategoryUseCase {}

class MockDeleteExpenseCategoryUseCase extends Mock
    implements DeleteExpenseCategoryUseCase {}

void main() {
  late MockGetExpensesInRangeUseCase mockGetExpenses;
  late MockAddExpenseCategoryUseCase mockAddCat;
  late MockGetExpenseCategoriesUseCase mockGetCats;
  late MockUpdateExpenseCategoryUseCase mockUpdateCat;
  late MockDeleteExpenseCategoryUseCase mockDeleteCat;
  late ExpenseCategoryController catController;

  setUp(() {
    Get.reset();
    mockGetExpenses = MockGetExpensesInRangeUseCase();
    mockAddCat = MockAddExpenseCategoryUseCase();
    mockGetCats = MockGetExpenseCategoriesUseCase();
    mockUpdateCat = MockUpdateExpenseCategoryUseCase();
    mockDeleteCat = MockDeleteExpenseCategoryUseCase();

    when(() => mockGetExpenses.call(any(), any()))
        .thenAnswer((_) async => []);
    when(() => mockGetCats.call()).thenAnswer((_) async => [
          const ExpenseCategoryEntity(
            id: '1',
            displayLabel: 'Food',
            emoji: '🍔',
          ),
          const ExpenseCategoryEntity(
            id: '2',
            displayLabel: 'Transport',
            emoji: '🚗',
          ),
        ]);

    Get.put<GetExpensesInRangeUseCase>(mockGetExpenses);
    Get.put<AddExpenseCategoryUseCase>(mockAddCat);
    Get.put<GetExpenseCategoriesUseCase>(mockGetCats);
    Get.put<UpdateExpenseCategoryUseCase>(mockUpdateCat);
    Get.put<DeleteExpenseCategoryUseCase>(mockDeleteCat);

    Get.put<ExpenseReportController>(
      ExpenseReportController(getExpensesInRangeUseCase: mockGetExpenses),
    );

    catController = Get.put<ExpenseCategoryController>(
      ExpenseCategoryController(
        addCategoryUseCase: mockAddCat,
        getCategoriesUseCase: mockGetCats,
        updateCategoryUseCase: mockUpdateCat,
        deleteCategoryUseCase: mockDeleteCat,
      ),
    );
    catController.categories.assignAll([
      const ExpenseCategoryEntity(id: '1', displayLabel: 'Food', emoji: '🍔'),
      const ExpenseCategoryEntity(id: '2', displayLabel: 'Transport', emoji: '🚗'),
    ]);
  });

  tearDown(() {
    Get.reset();
  });

  testWidgets('ExpenseReportFilterMenu renders controls, multi-select category and toggles',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      CurrencyTheme(
        notifier: CurrencyProvider(),
        child: MaterialApp(
          home: Builder(
            builder: (context) {
              Responsive.init(context, refHeight: 844, refWidth: 390);
              return Scaffold(
                body: ElevatedButton(
                  onPressed: () => showExpenseReportFilterMenu(
                    context,
                    dateFilter: DateFilter(
                      type: DateFilterType.yearly,
                      referenceDate: DateTime(2026, 3, 1),
                    ),
                  ),
                  child: const Text('Open Modal'),
                ),
              );
            },
          ),
        ),
      ),
    );

    // Open Modal
    await tester.tap(find.text('Open Modal'));
    await tester.pumpAndSettle();

    // Verify Modal Header & Inline Date Period Selector
    expect(find.text('Filter Menu'), findsOneWidget);
    expect(find.text('Yearly'), findsOneWidget);
    expect(find.text('Year 2026'), findsOneWidget);

    // Tap next chevron to go to Year 2027
    await tester.tap(find.byIcon(Icons.chevron_right_rounded));
    await tester.pumpAndSettle();
    expect(find.text('Year 2027'), findsOneWidget);

    // Verify Multi-select Category Field
    expect(find.text('Category Filter (Multi-Select)'), findsOneWidget);
    expect(find.text('✨ All Categories'), findsOneWidget);

    // Verify Action Buttons: Clear & Apply Filters
    expect(find.text('Clear'), findsOneWidget);
    expect(find.text('Apply Filters'), findsOneWidget);

    // Tap Food Category Chip
    await tester.tap(find.text('🍔 Food'));
    await tester.pumpAndSettle();

    // Tap Apply Button
    await tester.tap(find.text('Apply Filters'));
    await tester.pumpAndSettle();

    // Verify modal is dismissed after apply
    expect(find.text('Filter Menu'), findsNothing);
  });

  testWidgets('ExpenseReportFilterMenu Clear button resets and auto-dismisses modal', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final reportController = Get.find<ExpenseReportController>();
    reportController.selectedCategories.assignAll(['Food', 'Fuel']);

    await tester.pumpWidget(
      CurrencyTheme(
        notifier: CurrencyProvider(),
        child: MaterialApp(
          home: Builder(
            builder: (context) {
              Responsive.init(context, refHeight: 844, refWidth: 390);
              return Scaffold(
                body: ElevatedButton(
                  onPressed: () => showExpenseReportFilterMenu(context),
                  child: const Text('Open Filter'),
                ),
              );
            },
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Open Filter Menu
    await tester.tap(find.text('Open Filter'));
    await tester.pumpAndSettle();
    expect(find.text('Filter Menu'), findsOneWidget);

    // Scroll to & Tap Clear Button
    await tester.ensureVisible(find.text('Clear'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Clear'));
    await tester.pumpAndSettle();

    // Verify modal is dismissed and controller categories reset
    expect(find.text('Filter Menu'), findsNothing);
    expect(reportController.selectedCategories, isEmpty);
  });
}
