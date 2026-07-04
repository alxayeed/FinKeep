import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:finkeep/core/error/exception_mapper.dart';
// Expense Feature Dependencies
import 'package:finkeep/features/expense/data/datasources/expense_remote_datasource.dart';
import 'package:finkeep/features/expense/data/datasources/firebase_cloudstore_datasource.dart';
import 'package:finkeep/features/expense/data/repositories/expense_repository_impl.dart';
import 'package:finkeep/features/expense/domain/repositories/expense_repository.dart';
import 'package:finkeep/features/expense/domain/usecases/add_expense_usecase.dart';
import 'package:finkeep/features/expense/domain/usecases/delete_expense_usecase.dart';
import 'package:finkeep/features/expense/domain/usecases/get_all_expenses_usecase.dart';
import 'package:finkeep/features/expense/domain/usecases/get_expense_usecase.dart';
import 'package:finkeep/features/expense/domain/usecases/get_last_month_total_usecase.dart';
import 'package:finkeep/features/expense/domain/usecases/get_monthly_expense.dart';
import 'package:finkeep/features/expense/domain/usecases/update_expense_usecase.dart';
import 'package:finkeep/features/expense/presentation/controllers/monthly_expense_controller.dart';
import 'package:finkeep/features/expense/presentation/controllers/expense_report_controller.dart';
import 'package:finkeep/features/expense/presentation/controllers/budget_controller.dart';
import 'package:finkeep/features/expense/domain/usecases/add_expense_category_usecase.dart';
import 'package:finkeep/features/expense/domain/usecases/delete_expense_category_usecase.dart';
import 'package:finkeep/features/expense/domain/usecases/get_expense_categories_usecase.dart';
import 'package:finkeep/features/expense/domain/usecases/update_expense_category_usecase.dart';
import 'package:finkeep/features/expense/presentation/controllers/expense_category_controller.dart';
import 'package:finkeep/features/investments/data/repositories/investment_repository.dart';
// Lending Feature Dependencies
import 'package:finkeep/features/lendings/data/datasources/lending_data_source.dart';
import 'package:finkeep/features/lendings/data/datasources/lending_firestore_data_source.dart';
import 'package:finkeep/features/lendings/data/repositories/lending_repository_impl.dart';
import 'package:finkeep/features/lendings/domain/repositories/lending_repository.dart';

import 'features/expense/domain/usecases/get_expenses_in_range_usecase.dart';
import 'features/investments/data/datasources/investment_data_source.dart';
import 'features/investments/data/datasources/investment_firestore_data_source.dart';
import 'features/investments/domain/repositories/investment_repository.dart';
import 'features/investments/domain/usecases/add_investment_usecase.dart';
import 'features/investments/domain/usecases/add_return_entry_usecase.dart';
import 'features/investments/domain/usecases/get_investments_usecase.dart';
import 'features/investments/domain/usecases/update_investment_usecase.dart';
import 'features/investments/presentation/controller/investment_controller.dart';
import 'features/lendings/domain/usecases/lending/add_lending_usecase.dart';
import 'features/lendings/domain/usecases/lending/delete_lending_usecase.dart';
import 'features/lendings/domain/usecases/lending/get_lendings_count_usecase.dart';
import 'features/lendings/domain/usecases/lending/get_lendings_usecase.dart';
import 'features/lendings/domain/usecases/lending/get_total_lending_amount_usecase.dart';
import 'features/lendings/domain/usecases/lending/update_lending_usecase.dart';
import 'features/lendings/domain/usecases/lending_person/add_person_usecase.dart';
import 'features/lendings/domain/usecases/lending_person/delete_person_usecase.dart';
import 'features/lendings/domain/usecases/lending_person/get_person_by_id_usecase.dart';
import 'features/lendings/domain/usecases/lending_person/get_user_persons_usecase.dart';
import 'features/lendings/domain/usecases/lending_person/update_person_usecase.dart';
import 'features/lendings/domain/usecases/repayment/add_repayment_usecase.dart';
import 'features/lendings/domain/usecases/repayment/delete_repayment_usecase.dart';
import 'features/lendings/domain/usecases/repayment/get_repayments_for_lending_usecase.dart';
import 'features/lendings/domain/usecases/repayment/update_repayment_usecase.dart';
import 'features/lendings/presentation/controllers/lendings_controller.dart';
import 'package:finkeep/core/services/local_db_service.dart';
import 'package:finkeep/core/services/app_update_service.dart';
import 'package:finkeep/core/services/biometric_service.dart';
import 'package:finkeep/core/services/push_notification_service.dart';
import 'package:finkeep/features/expense/data/datasources/expense_local_datasource.dart';
import 'package:finkeep/features/expense/data/datasources/expense_hive_datasource.dart';
import 'package:finkeep/features/investments/data/datasources/investment_local_datasource.dart';
import 'package:finkeep/features/investments/data/datasources/investment_hive_datasource.dart';
import 'package:finkeep/features/lendings/data/datasources/lending_local_datasource.dart';
import 'package:finkeep/features/lendings/data/datasources/lending_hive_datasource.dart';
import 'package:finkeep/features/income/income.dart';
import 'package:finkeep/features/dashboard/data/datasources/dashboard_local_datasource.dart';
import 'package:finkeep/features/dashboard/data/datasources/dashboard_hive_datasource.dart';
import 'package:finkeep/features/dashboard/data/datasources/dashboard_remote_datasource.dart';
import 'package:finkeep/features/dashboard/data/datasources/dashboard_firestore_datasource.dart';
import 'package:finkeep/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:finkeep/features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'package:finkeep/features/dashboard/domain/usecases/usecases.dart';
import 'package:finkeep/features/dashboard/presentation/controllers/dashboard_controller.dart';

class DependencyInjection {
  static void initDependencies() {
    Get.lazyPut<FirebaseFirestore>(
      () => FirebaseFirestore.instance,
      fenix: true,
    );
    Get.lazyPut<ExceptionMapper>(() => ExceptionMapper());

    // --- Local DB Service Reference ---
    Get.lazyPut<LocalDbService>(() => LocalDbService(), fenix: true);
    Get.lazyPut<AppUpdateService>(() => AppUpdateService(), fenix: true);
    Get.lazyPut<BiometricService>(() => BiometricService(), fenix: true);
    Get.lazyPut<PushNotificationService>(() => PushNotificationService(), fenix: true);

    // --- Expense Feature ---
    Get.lazyPut<ExpenseLocalDataSource>(
      () => ExpenseHiveDataSource(localDb: Get.find()),
      fenix: true,
    );
    Get.lazyPut<ExpenseRemoteDataSource>(
      () => FirebaseCloudStoreDataSource(fireStore: Get.find()),
      fenix: true,
    );
    Get.lazyPut<ExpenseRepository>(
      () => ExpenseRepositoryImpl(
        localDataSource: Get.find(),
        remoteDataSource: Get.find(),
      ),
    );
    Get.lazyPut(() => GetAllExpensesUseCase(Get.find()));
    Get.lazyPut(() => GetMonthlyExpensesUseCase(Get.find()));
    Get.lazyPut(() => GetLastMonthTotalUseCase(Get.find()));
    Get.lazyPut(() => GetExpensesInRangeUseCase(Get.find()));
    Get.lazyPut(() => GetExpenseUseCase(Get.find()));
    Get.lazyPut(() => AddExpenseUseCase(Get.find()));
    Get.lazyPut(() => UpdateExpenseUseCase(Get.find()));
    Get.lazyPut(() => DeleteExpenseUseCase(Get.find()));

    Get.lazyPut(() => BudgetController());

    Get.lazyPut(() => AddExpenseCategoryUseCase(Get.find()));
    Get.lazyPut(() => GetExpenseCategoriesUseCase(Get.find()));
    Get.lazyPut(() => UpdateExpenseCategoryUseCase(Get.find()));
    Get.lazyPut(() => DeleteExpenseCategoryUseCase(Get.find()));

    Get.lazyPut(
      () => ExpenseCategoryController(
        addCategoryUseCase: Get.find(),
        getCategoriesUseCase: Get.find(),
        updateCategoryUseCase: Get.find(),
        deleteCategoryUseCase: Get.find(),
      ),
      fenix: true,
    );

    Get.lazyPut(
      () => MonthlyExpenseController(
        getAllExpenses: Get.find(),
        getMonthlyExpensesUseCase: Get.find(),
        getLastMonthTotalUseCase: Get.find(),
        getExpense: Get.find(),
        addExpense: Get.find(),
        updateExpense: Get.find(),
        deleteExpense: Get.find(),
      ),
    );

    Get.lazyPut(
      () => ExpenseReportController(
        getExpensesInRangeUseCase: Get.find(),
      ),
    );

    // --- Lending Feature ---
    Get.lazyPut<LendingLocalDataSource>(
      () => LendingHiveDataSource(localDb: Get.find()),
      fenix: true,
    );
    Get.lazyPut<LendingDataSource>(
      () => LendingFirestoreDataSource(firestore: Get.find()),
      fenix: true,
    );
    Get.lazyPut<LendingRepository>(
      () => LendingRepositoryImpl(
        localDataSource: Get.find(),
        remoteDataSource: Get.find(),
        exceptionMapper: Get.find(),
      ),
    );

    // Lending Use Cases
    Get.lazyPut(() => GetLendingsUseCase(repository: Get.find()));
    Get.lazyPut(() => AddLendingUseCase(repository: Get.find()));
    Get.lazyPut(() => UpdateLendingUseCase(repository: Get.find()));
    Get.lazyPut(() => DeleteLendingUseCase(repository: Get.find()));
    Get.lazyPut(() => GetTotalLendingAmountUseCase(repository: Get.find()));
    Get.lazyPut(() => GetLendingsCountUseCase(repository: Get.find()));

    // LendingPerson Use Cases
    Get.lazyPut(() => AddPersonUseCase(repository: Get.find()));
    Get.lazyPut(() => GetPersonByIdUseCase(repository: Get.find()));
    Get.lazyPut(() => GetUserPersonsUseCase(repository: Get.find()));
    Get.lazyPut(() => UpdatePersonUseCase(repository: Get.find()));
    Get.lazyPut(() => DeletePersonUseCase(repository: Get.find()));

    // Repayment Use Cases
    Get.lazyPut(() => AddRepaymentUseCase(repository: Get.find()));
    Get.lazyPut(() => GetRepaymentsForLendingUseCase(repository: Get.find()));
    Get.lazyPut(() => UpdateRepaymentUseCase(repository: Get.find()));
    Get.lazyPut(() => DeleteRepaymentUseCase(repository: Get.find()));

    // Controllers

    Get.lazyPut(
      () => LendingsController(
        getLendingsUseCase: Get.find(),
        deleteLendingUseCase: Get.find(),
        updateLendingUseCase: Get.find(),
        addLendingUseCase: Get.find(),
        addPersonUseCase: Get.find(),
        getUserPersonsUseCase: Get.find(),
        updatePersonUseCase: Get.find(),
        deletePersonUseCase: Get.find(),
        addRepaymentUseCase: Get.find(),
        getRepaymentsUseCase: Get.find(),
        updateRepaymentUseCase: Get.find(),
        deleteRepaymentUseCase: Get.find(),
      ),
    );

    // --- Investment Feature ---
    Get.lazyPut<InvestmentLocalDataSource>(
      () => InvestmentHiveDataSource(localDb: Get.find()),
      fenix: true,
    );
    Get.lazyPut<InvestmentDataSource>(
      () => InvestmentFirestoreDataSource(firestore: Get.find()),
      fenix: true,
    );

    Get.lazyPut<InvestmentRepository>(
      () => InvestmentRepositoryImpl(
        localDataSource: Get.find(),
        remoteDataSource: Get.find(),
      ),
    );

    // Use Cases
    Get.lazyPut(() => GetInvestmentsUseCase(Get.find()));
    Get.lazyPut(() => AddInvestmentUseCase(Get.find()));
    Get.lazyPut(() => UpdateInvestmentUseCase(Get.find()));
    Get.lazyPut(() => AddReturnEntryUseCase(Get.find()));

    // Controller
    Get.lazyPut(
      () => InvestmentController(
        getInvestmentsUseCase: Get.find(),
        addInvestmentUseCase: Get.find(),
        updateInvestmentUseCase: Get.find(),
        addReturnEntryUseCase: Get.find(),
      ),
    );

    // --- Income Feature ---
    Get.lazyPut<IncomeLocalDataSource>(
      () => IncomeHiveDataSource(localDb: Get.find()),
      fenix: true,
    );
    Get.lazyPut<IncomeRemoteDataSource>(
      () => IncomeFirestoreDataSource(firestore: Get.find()),
      fenix: true,
    );
    Get.lazyPut<IncomeRepository>(
      () => IncomeRepositoryImpl(
        localDataSource: Get.find(),
        remoteDataSource: Get.find(),
      ),
    );

    // Use cases
    Get.lazyPut(() => AddIncomeUseCase(Get.find()));
    Get.lazyPut(() => GetIncomeUseCase(Get.find()));
    Get.lazyPut(() => GetIncomesUseCase(Get.find()));
    Get.lazyPut(() => GetIncomesForMonthUseCase(Get.find()));
    Get.lazyPut(() => GetIncomesInRangeUseCase(Get.find()));
    Get.lazyPut(() => UpdateIncomeUseCase(Get.find()));
    Get.lazyPut(() => DeleteIncomeUseCase(Get.find()));
    Get.lazyPut(() => AddIncomeCategoryUseCase(Get.find()));
    Get.lazyPut(() => GetIncomeCategoriesUseCase(Get.find()));
    Get.lazyPut(() => UpdateIncomeCategoryUseCase(Get.find()));
    Get.lazyPut(() => DeleteIncomeCategoryUseCase(Get.find()));

    // Controllers
    Get.lazyPut(
      () => IncomeCategoryController(
        addCategoryUseCase: Get.find(),
        getCategoriesUseCase: Get.find(),
        updateCategoryUseCase: Get.find(),
        deleteCategoryUseCase: Get.find(),
      ),
      fenix: true,
    );
    Get.lazyPut(
      () => IncomeController(
        addIncomeUseCase: Get.find(),
        getIncomeUseCase: Get.find(),
        getIncomesUseCase: Get.find(),
        getIncomesForMonthUseCase: Get.find(),
        getIncomesInRangeUseCase: Get.find(),
        updateIncomeUseCase: Get.find(),
        deleteIncomeUseCase: Get.find(),
        categoryController: Get.find(),
      ),
      fenix: true,
    );

    // --- Dashboard Feature ---
    Get.lazyPut<DashboardLocalDataSource>(
      () => DashboardHiveDataSource(localDb: Get.find()),
      fenix: true,
    );
    Get.lazyPut<DashboardRemoteDataSource>(
      () => DashboardFirestoreDataSource(fireStore: Get.find()),
      fenix: true,
    );
    Get.lazyPut<DashboardRepository>(
      () => DashboardRepositoryImpl(
        localDataSource: Get.find(),
        remoteDataSource: Get.find(),
      ),
      fenix: true,
    );
    Get.lazyPut(() => GetAggregateStatsUseCase(Get.find()), fenix: true);
    Get.lazyPut(() => GetExpenseCategoryBreakdownUseCase(Get.find()), fenix: true);
    Get.lazyPut(() => GetIncomeCategoryBreakdownUseCase(Get.find()), fenix: true);
    Get.lazyPut(() => GetTrendPointsUseCase(Get.find()), fenix: true);
    Get.lazyPut(() => GetRecentActivitiesUseCase(Get.find()), fenix: true);
    Get.lazyPut(() => GetMonthlyStandingUseCase(Get.find()), fenix: true);
    Get.lazyPut(
      () => DashboardController(
        getAggregateStatsUseCase: Get.find(),
        getExpenseCategoryBreakdownUseCase: Get.find(),
        getIncomeCategoryBreakdownUseCase: Get.find(),
        getTrendPointsUseCase: Get.find(),
        getRecentActivitiesUseCase: Get.find(),
        getMonthlyStandingUseCase: Get.find(),
      ),
      fenix: true,
    );
  }
}
