import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:finkeep/core/common/models/date_filter.dart';
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
import 'package:finkeep/features/expense/presentation/widgets/budget_progress_card.dart';
import 'package:finkeep/features/expense/presentation/widgets/category_focus_card.dart';
import 'package:finkeep/features/expense/presentation/widgets/expense_report_hero_card.dart';
import 'package:finkeep/features/expense/presentation/widgets/period_summary_card.dart';

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
      amount: 50.0,
      category: 'Food',
      date: DateTime(2026, 8, 16),
      description: 'Coffee snack',
      paymentMethod: PaymentType.card,
    ),
    ExpenseEntity(
      id: 'e3',
      amount: 100.0,
      category: 'Transport',
      date: DateTime(2026, 8, 17),
      description: 'Fuel',
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
    reportController.reportRangeBudget.value = 1000.0;

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

  Widget createWidgetUnderTest({required List<ExpenseEntity> expenses}) {
    return CurrencyTheme(
      notifier: CurrencyProvider(),
      child: MaterialApp(
        home: Builder(
          builder: (context) {
            Responsive.init(context, refHeight: 844, refWidth: 390);
            return Scaffold(
              body: SingleChildScrollView(
                child: ExpenseReportHeroCard(
                  expenses: expenses,
                  isReport: true,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  testWidgets('Renders BudgetProgressCard when all categories & standard period are active',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    reportController.selectedCategories.clear();
    reportController.dateFilter.value = DateFilter(
      type: DateFilterType.yearly,
      referenceDate: DateTime(2026, 1, 1),
    );

    await tester.pumpWidget(createWidgetUnderTest(expenses: sampleExpenses));
    await tester.pumpAndSettle();

    expect(find.byType(BudgetProgressCard), findsOneWidget);
    expect(find.byType(CategoryFocusCard), findsNothing);
    expect(find.byType(PeriodSummaryCard), findsNothing);
  });

  testWidgets('Renders CategoryFocusCard when specific category filter is active',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final foodExpenses = sampleExpenses.where((e) => e.category == 'Food').toList();
    reportController.selectedCategories.assignAll(['Food']);

    await tester.pumpWidget(createWidgetUnderTest(expenses: foodExpenses));
    await tester.pumpAndSettle();

    expect(find.byType(CategoryFocusCard), findsOneWidget);
    expect(find.text('TOTAL CATEGORY SPENDING'), findsOneWidget);
    expect(find.text('Category Focus'), findsOneWidget);
    expect(find.text('Share of Period'), findsOneWidget);
    expect(find.text('2 txns'), findsOneWidget);
    expect(find.byType(BudgetProgressCard), findsNothing);
  });

  testWidgets('Renders PeriodSummaryCard when arbitrary custom date range is active',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    reportController.selectedCategories.clear();
    reportController.startDate.value = DateTime(2026, 8, 10);
    reportController.endDate.value = DateTime(2026, 8, 18);
    reportController.dateFilter.value = DateFilter(
      type: DateFilterType.custom,
      referenceDate: DateTime(2026, 8, 10),
      customStartDate: DateTime(2026, 8, 10),
      customEndDate: DateTime(2026, 8, 18),
    );

    await tester.pumpWidget(createWidgetUnderTest(expenses: sampleExpenses));
    await tester.pumpAndSettle();

    expect(find.byType(PeriodSummaryCard), findsOneWidget);
    expect(find.text('TOTAL PERIOD SPENDING'), findsOneWidget);
    expect(find.text('Daily Average'), findsOneWidget);
    expect(find.text('9 days'), findsOneWidget);
    expect(find.byType(BudgetProgressCard), findsNothing);
    expect(find.byType(CategoryFocusCard), findsNothing);
  });
}
