import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:finkeep/core/enums/payment_type.dart';
import 'package:finkeep/core/responsive/responsive.dart';
import 'package:finkeep/core/styles/currency_provider.dart';
import 'package:finkeep/features/expense/domain/entities/expense_category_entity.dart';
import 'package:finkeep/features/expense/domain/entities/expense_entity.dart';
import 'package:finkeep/features/expense/domain/entities/expense_pdf_report_config.dart';
import 'package:finkeep/features/expense/domain/usecases/usecases.dart';
import 'package:finkeep/features/expense/domain/usecases/add_expense_category_usecase.dart';
import 'package:finkeep/features/expense/domain/usecases/get_expense_categories_usecase.dart';
import 'package:finkeep/features/expense/domain/usecases/update_expense_category_usecase.dart';
import 'package:finkeep/features/expense/domain/usecases/delete_expense_category_usecase.dart';
import 'package:finkeep/features/expense/presentation/controllers/expense_category_controller.dart';
import 'package:finkeep/features/expense/presentation/controllers/expense_report_controller.dart';
import 'package:finkeep/features/expense/presentation/screens/expense_report_list_screen.dart';

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
      amount: 80.0,
      category: 'Transport',
      date: DateTime(2026, 8, 15),
      description: 'Fuel refill',
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

  Widget createWidgetUnderTest() {
    return CurrencyTheme(
      notifier: CurrencyProvider(),
      child: MaterialApp(
        home: Builder(
          builder: (context) {
            Responsive.init(context, refHeight: 844, refWidth: 390);
            return Scaffold(
              body: ExpenseReportListScreen(controller: reportController),
            );
          },
        ),
      ),
    );
  }

  testWidgets('ExpenseReportListScreen renders compact grouped table mode when listMode is compact',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    reportController.listMode.value = ExpenseReportPdfMode.compact;

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    // Verify Compact table header columns
    expect(find.text('Date'), findsOneWidget);
    expect(find.text('Category (Grouped)'), findsOneWidget);
    expect(find.text('Total Amount'), findsOneWidget);

    // Verify Grouped items
    expect(find.text('Food'), findsWidgets);
    expect(find.text('Transport'), findsWidgets);
  });

  testWidgets('ExpenseReportListScreen renders itemized details table mode when listMode is details',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    reportController.listMode.value = ExpenseReportPdfMode.details;

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    // Verify Details table header columns
    expect(find.text('Date'), findsOneWidget);
    expect(find.text('Category / Note'), findsOneWidget);
    expect(find.text('Payment'), findsOneWidget);
    expect(find.text('Amount'), findsOneWidget);

    // Verify Itemized records
    expect(find.text('Groceries lunch'), findsOneWidget);
    expect(find.text('Fuel refill'), findsOneWidget);
    expect(find.text('Cash'), findsOneWidget);
    expect(find.text('Card'), findsOneWidget);
  });
}
