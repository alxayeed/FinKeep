import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:finkeep/core/common/widgets/custom_app_bar.dart';
import 'package:finkeep/core/common/widgets/app_date_filter.dart';
import 'package:finkeep/core/responsive/responsive.dart';
import 'package:finkeep/core/styles/currency_provider.dart';
import 'package:finkeep/features/expense/domain/entities/expense_category_entity.dart';
import 'package:finkeep/features/expense/domain/usecases/usecases.dart';
import 'package:finkeep/features/expense/domain/usecases/add_expense_category_usecase.dart';
import 'package:finkeep/features/expense/domain/usecases/get_expense_categories_usecase.dart';
import 'package:finkeep/features/expense/domain/usecases/update_expense_category_usecase.dart';
import 'package:finkeep/features/expense/domain/usecases/delete_expense_category_usecase.dart';
import 'package:finkeep/features/expense/presentation/controllers/budget_controller.dart';
import 'package:finkeep/features/expense/presentation/controllers/expense_category_controller.dart';
import 'package:finkeep/features/expense/presentation/controllers/expense_report_controller.dart';
import 'package:finkeep/features/expense/presentation/screens/expense_report_screen.dart';

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

  setUp(() {
    SharedPreferences.setMockInitialValues({'ignore_missing_budget_prompt': true});
    Get.reset();
    mockGetExpenses = MockGetExpensesInRangeUseCase();
    mockAddCat = MockAddExpenseCategoryUseCase();
    mockGetCats = MockGetExpenseCategoriesUseCase();
    mockUpdateCat = MockUpdateExpenseCategoryUseCase();
    mockDeleteCat = MockDeleteExpenseCategoryUseCase();
    mockBudget = MockBudgetController();

    when(() => mockBudget.monthlyBudget).thenReturn(0.0.obs);
    when(() => mockBudget.getBudgetForMonth(any()))
        .thenAnswer((_) async => 0.0);
    Get.put<BudgetController>(mockBudget);

    when(() => mockGetExpenses.call(any(), any()))
        .thenAnswer((_) async => []);
    when(() => mockGetCats.call()).thenAnswer((_) async => [
          const ExpenseCategoryEntity(id: '1', displayLabel: 'Food', emoji: '🍔'),
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
    ]);
  });

  tearDown(() {
    Get.reset();
  });

  testWidgets('ExpenseReportScreen renders CustomAppBar with back button and FAB opens filter menu with AppDateFilter',
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
              return const ExpenseReportScreen();
            },
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Verify CustomAppBar renders with title and back button
    expect(find.byType(CustomAppBar), findsOneWidget);
    expect(find.text('Expense Report'), findsOneWidget);
    expect(find.byIcon(Icons.chevron_left_rounded), findsOneWidget);

    // Verify AppDateFilter is NOT in the main screen body
    expect(find.byType(AppDateFilter), findsNothing);

    // Verify Active Duration banner is rendered
    expect(find.textContaining('Year 2026'), findsOneWidget);
    expect(find.textContaining('All Categories'), findsOneWidget);

    // Verify PDF export action in CustomAppBar
    expect(find.byIcon(Icons.picture_as_pdf_rounded), findsOneWidget);

    // Verify single tune icon in duration banner exists
    expect(find.byIcon(Icons.tune_rounded), findsOneWidget);

    // Tap Duration Banner to open Filter Menu
    await tester.tap(find.byIcon(Icons.tune_rounded));
    await tester.pumpAndSettle();

    // Verify Filter Menu is shown and contains inline Date Period selector
    expect(find.text('Filter Menu'), findsOneWidget);
    expect(find.text('Yearly'), findsOneWidget);
  });
}
