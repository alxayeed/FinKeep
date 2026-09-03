import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:finkeep/core/enums/payment_type.dart';
import 'package:finkeep/core/responsive/responsive.dart';
import 'package:finkeep/core/styles/currency_provider.dart';
import 'package:finkeep/features/expense/domain/entities/expense_category_entity.dart';
import 'package:finkeep/features/expense/domain/entities/expense_entity.dart';
import 'package:finkeep/features/expense/domain/usecases/usecases.dart';
import 'package:finkeep/features/expense/domain/usecases/add_expense_category_usecase.dart';
import 'package:finkeep/features/expense/domain/usecases/get_expense_categories_usecase.dart';
import 'package:finkeep/features/expense/domain/usecases/update_expense_category_usecase.dart';
import 'package:finkeep/features/expense/domain/usecases/delete_expense_category_usecase.dart';
import 'package:finkeep/features/expense/presentation/controllers/budget_controller.dart';
import 'package:finkeep/features/expense/presentation/controllers/expense_category_controller.dart';
import 'package:finkeep/features/expense/presentation/controllers/expense_report_controller.dart';
import 'package:finkeep/features/expense/presentation/widgets/expense_pdf_export_sheet.dart';

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

class MockBudgetController extends GetxController
    with Mock
    implements BudgetController {}

void main() {
  late MockGetExpensesInRangeUseCase mockGetExpenses;
  late MockAddExpenseCategoryUseCase mockAddCat;
  late MockGetExpenseCategoriesUseCase mockGetCats;
  late MockUpdateExpenseCategoryUseCase mockUpdateCat;
  late MockDeleteExpenseCategoryUseCase mockDeleteCat;
  late MockBudgetController mockBudget;

  late ExpenseReportController reportController;

  final sampleExpenses = [
    ExpenseEntity(
      id: 'e1',
      amount: 150.0,
      category: 'Food',
      date: DateTime(2026, 8, 15),
      description: 'Groceries lunch',
      paymentMethod: PaymentType.cash,
    ),
    ExpenseEntity(
      id: 'e2',
      amount: 50.0,
      category: 'Transport',
      date: DateTime(2026, 8, 16),
      description: 'Taxi',
      paymentMethod: PaymentType.card,
    ),
  ];

  setUp(() {
    Get.reset();
    mockGetExpenses = MockGetExpensesInRangeUseCase();
    mockAddCat = MockAddExpenseCategoryUseCase();
    mockGetCats = MockGetExpenseCategoriesUseCase();
    mockUpdateCat = MockUpdateExpenseCategoryUseCase();
    mockDeleteCat = MockDeleteExpenseCategoryUseCase();
    mockBudget = MockBudgetController();

    when(() => mockBudget.monthlyBudget).thenReturn(1000.0.obs);
    when(() => mockBudget.getBudgetForMonth(any()))
        .thenAnswer((_) async => 1000.0);
    Get.put<BudgetController>(mockBudget);

    when(() => mockGetExpenses.call(any(), any()))
        .thenAnswer((_) async => sampleExpenses);
    when(() => mockGetCats.call()).thenAnswer((_) async => [
          const ExpenseCategoryEntity(id: '1', displayLabel: 'Food', emoji: '🍔'),
          const ExpenseCategoryEntity(id: '2', displayLabel: 'Transport', emoji: '🚗'),
        ]);

    Get.put<GetExpensesInRangeUseCase>(mockGetExpenses);
    Get.put<AddExpenseCategoryUseCase>(mockAddCat);
    Get.put<GetExpenseCategoriesUseCase>(mockGetCats);
    Get.put<UpdateExpenseCategoryUseCase>(mockUpdateCat);
    Get.put<DeleteExpenseCategoryUseCase>(mockDeleteCat);

    reportController = Get.put<ExpenseReportController>(
      ExpenseReportController(getExpensesInRangeUseCase: mockGetExpenses),
    );
    reportController.reportExpenses.assignAll(sampleExpenses);
    reportController.reportFilteredExpenses.assignAll(sampleExpenses);

    Get.put<ExpenseCategoryController>(
      ExpenseCategoryController(
        addCategoryUseCase: mockAddCat,
        getCategoriesUseCase: mockGetCats,
        updateCategoryUseCase: mockUpdateCat,
        deleteCategoryUseCase: mockDeleteCat,
      ),
    );
  });

  tearDown(() {
    Get.reset();
  });

  Widget createWidgetUnderTest() {
    return CurrencyTheme(
      notifier: CurrencyProvider(),
      child: MaterialApp(
        home: Builder(
          builder: (context) {
            Responsive.init(context, refHeight: 844, refWidth: 390);
            return Scaffold(
              body: Center(
                child: ElevatedButton(
                  onPressed: () => showExpensePdfExportSheet(
                    context,
                    controller: reportController,
                  ),
                  child: const Text('Open Export Sheet'),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  testWidgets('ExpensePdfExportSheet renders Transaction Layout and section toggles',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    // Tap to open sheet
    await tester.tap(find.text('Open Export Sheet'));
    await tester.pumpAndSettle();

    // Verify Title & Subtitle
    expect(find.text('Export PDF Report'), findsOneWidget);
    expect(find.text('Choose statement layout and breakdown sections'), findsOneWidget);

    // Verify Transaction Layout section with Category Summary and Detailed Statement
    expect(find.text('Transaction Layout'), findsOneWidget);
    expect(find.text('Category Summary'), findsOneWidget);
    expect(find.text('Aggregated subtotals'), findsOneWidget);
    expect(find.text('Detailed Statement'), findsOneWidget);
    expect(find.text('Line-by-line transactions'), findsOneWidget);

    // Verify Include in PDF Report section with section toggles
    expect(find.text('Include in PDF Report'), findsOneWidget);
    expect(find.text('📊 Category Breakdown'), findsOneWidget);
    expect(find.text('📈 Monthly Trend'), findsOneWidget);
    expect(find.text('💳 Payment Methods'), findsOneWidget);

    // Verify Preview & Generate PDF Button
    expect(find.text('Preview & Generate PDF'), findsOneWidget);

    // Select Detailed Statement
    await tester.tap(find.text('Detailed Statement'));
    await tester.pumpAndSettle();

    // Toggle Monthly Trend
    await tester.tap(find.text('📈 Monthly Trend'));
    await tester.pumpAndSettle();
  });
}
