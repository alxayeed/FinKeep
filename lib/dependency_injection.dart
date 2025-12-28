import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:spendly/core/error/exception_mapper.dart';
import 'package:spendly/features/auth/data/datasource/auth_remote_data_source.dart';
import 'package:spendly/features/auth/data/repository/auth_repository_impl.dart';
import 'package:spendly/features/auth/domain/repository/auth_repository.dart';
import 'package:spendly/features/auth/domain/usecases/login_usecase.dart';
import 'package:spendly/features/auth/domain/usecases/logout_usecase.dart';
import 'package:spendly/features/auth/domain/usecases/register_usecase.dart';
import 'package:spendly/features/auth/presentation/controller/auth_controller.dart';
// Expense Feature Dependencies
import 'package:spendly/features/expense/data/datasources/expense_remote_datasource.dart';
import 'package:spendly/features/expense/data/datasources/firebase_cloudstore_datasource.dart';
import 'package:spendly/features/expense/data/repositories/expense_repository_impl.dart';
import 'package:spendly/features/expense/domain/repositories/expense_repository.dart';
import 'package:spendly/features/expense/domain/usecases/add_expense_usecase.dart';
import 'package:spendly/features/expense/domain/usecases/delete_expense_usecase.dart';
import 'package:spendly/features/expense/domain/usecases/get_all_expenses_usecase.dart';
import 'package:spendly/features/expense/domain/usecases/get_expense_usecase.dart';
import 'package:spendly/features/expense/domain/usecases/get_last_month_total_usecase.dart';
import 'package:spendly/features/expense/domain/usecases/get_monthly_expense.dart';
import 'package:spendly/features/expense/domain/usecases/update_expense_usecase.dart';
import 'package:spendly/features/expense/presentation/controllers/expense_controller.dart';
import 'package:spendly/features/investments/data/repositories/investment_repository.dart';
// Lending Feature Dependencies
import 'package:spendly/features/lendings/data/datasources/lending_data_source.dart';
import 'package:spendly/features/lendings/data/datasources/lending_firestore_data_source.dart';
import 'package:spendly/features/lendings/data/repositories/lending_repository_impl.dart';
import 'package:spendly/features/lendings/domain/repositories/lending_repository.dart';

import 'features/expense/domain/usecases/get_expenses_in_range_usecase.dart';
import 'features/investments/data/datasources/investment_data_source.dart';
import 'features/investments/data/datasources/investment_firestore_data_source.dart';
import 'features/investments/domain/repositories/investment_repository.dart';
import 'features/investments/domain/usecases/add_investment_usecase.dart';
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

class DependencyInjection {
  static void initDependencies() {
    Get.lazyPut<FirebaseFirestore>(
      () => FirebaseFirestore.instance,
      fenix: true,
    );
    Get.lazyPut<ExceptionMapper>(() => ExceptionMapper());

    // --- Auth Feature ---
    Get.lazyPut<FirebaseAuth>(
      () => FirebaseAuth.instance,
      fenix: true,
    );
    Get.lazyPut<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(firebaseAuth: Get.find()),
    );
    Get.lazyPut<AuthRepository>(
      () => AuthRepositoryImpl(remoteDataSource: Get.find()),
    );
    Get.lazyPut(() => LoginUseCase(Get.find()));
    Get.lazyPut(() => RegisterUseCase(Get.find()));
    Get.lazyPut(() => LogoutUseCase(Get.find()));
    Get.lazyPut(
      () => AuthController(
        loginUseCase: Get.find(),
        registerUseCase: Get.find(),
        logoutUseCase: Get.find(),
      ),
    );
    Get.lazyPut(() => SplashController());


    // --- Expense Feature ---
    Get.lazyPut<ExpenseRemoteDataSource>(
      () => FirebaseCloudStoreDataSource(fireStore: Get.find()),
    );
    Get.lazyPut<ExpenseRepository>(() => ExpenseRepositoryImpl(Get.find()));
    Get.lazyPut(() => GetAllExpensesUseCase(Get.find()));
    Get.lazyPut(() => GetMonthlyExpensesUseCase(Get.find()));
    Get.lazyPut(() => GetLastMonthTotalUseCase(Get.find()));
    Get.lazyPut(() => GetExpensesInRangeUseCase(Get.find()));
    Get.lazyPut(() => GetExpenseUseCase(Get.find()));
    Get.lazyPut(() => AddExpenseUseCase(Get.find()));
    Get.lazyPut(() => UpdateExpenseUseCase(Get.find()));
    Get.lazyPut(() => DeleteExpenseUseCase(Get.find()));

    Get.lazyPut(
      () => ExpenseController(
        getAllExpenses: Get.find(),
        getMonthlyExpensesUseCase: Get.find(),
        getLastMonthTotalUseCase: Get.find(),
        getExpensesInRangeUseCase: Get.find(),
        getExpense: Get.find(),
        addExpense: Get.find(),
        updateExpense: Get.find(),
        deleteExpense: Get.find(),
      ),
    );

    // --- Lending Feature ---
    Get.lazyPut<LendingDataSource>(
      () => LendingFirestoreDataSource(firestore: Get.find()),
    );
    Get.lazyPut<LendingRepository>(
      () => LendingRepositoryImpl(
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
    Get.lazyPut<InvestmentDataSource>(
      () => InvestmentFirestoreDataSource(firestore: Get.find()),
    );

    Get.lazyPut<InvestmentRepository>(
      () => InvestmentRepositoryImpl(dataSource: Get.find()),
    );

    // Use Cases
    Get.lazyPut(() => GetInvestmentsUseCase(Get.find()));
    Get.lazyPut(() => AddInvestmentUseCase(Get.find()));
    Get.lazyPut(() => UpdateInvestmentUseCase(Get.find()));

    // Controller
    Get.lazyPut(
      () => InvestmentController(
        getInvestmentsUseCase: Get.find(),
        addInvestmentUseCase: Get.find(),
        updateInvestmentUseCase: Get.find(),
      ),
    );
  }
}
