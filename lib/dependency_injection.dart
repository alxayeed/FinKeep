import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:spendly/core/error/exception_mapper.dart';
// Expense Feature Dependencies
import 'package:spendly/features/expense/data/datasources/expense_remote_datasource.dart';
import 'package:spendly/features/expense/data/datasources/firebase_cloudstore_datasource.dart';
import 'package:spendly/features/expense/data/repositories/expense_repository_impl.dart';
import 'package:spendly/features/expense/domain/repositories/expense_repository.dart';
import 'package:spendly/features/expense/domain/usecases/add_expense_usecase.dart';
import 'package:spendly/features/expense/domain/usecases/delete_expense_usecase.dart';
import 'package:spendly/features/expense/domain/usecases/get_all_expenses_usecase.dart';
import 'package:spendly/features/expense/domain/usecases/get_expense_usecase.dart';
import 'package:spendly/features/expense/domain/usecases/get_monthly_expense.dart';
import 'package:spendly/features/expense/domain/usecases/update_expense_usecase.dart';
import 'package:spendly/features/expense/presentation/controllers/expense_controller.dart';
// Lending Feature Dependencies
import 'package:spendly/features/lendings/data/datasources/lending_data_source.dart';
import 'package:spendly/features/lendings/data/datasources/lending_firestore_data_source.dart';
import 'package:spendly/features/lendings/data/repositories/lending_repository_impl.dart';
import 'package:spendly/features/lendings/domain/repositories/lending_repository.dart';
import 'package:spendly/features/lendings/domain/usecases/add_lending_usecase.dart';
import 'package:spendly/features/lendings/domain/usecases/delete_lending_usecase.dart'; // Import DeleteLendingUseCase
import 'package:spendly/features/lendings/domain/usecases/get_lendings_usecase.dart';
import 'package:spendly/features/lendings/domain/usecases/update_lending_usecase.dart'; // Import UpdateLendingUseCase
// Import aggregation use cases when created
// import 'package:spendly/features/lendings/domain/usecases/get_total_lending_amount_usecase.dart';
// import 'package:spendly/features/lendings/domain/usecases/get_lendings_count_usecase.dart';
import 'package:spendly/features/lendings/presentation/controllers/add_lending_controller.dart';

import 'features/lendings/presentation/controllers/lendings_controller.dart';

class DependencyInjection {
  static void initDependencies() {
    Get.lazyPut<FirebaseFirestore>(() => FirebaseFirestore.instance,
        fenix: true);
    Get.lazyPut<ExceptionMapper>(() => ExceptionMapper());
    // Get.lazyPut<AuthService>(() => YourAuthServiceImpl());

    // --- Expense Feature ---
    Get.lazyPut<ExpenseRemoteDataSource>(
      () => FirebaseCloudStoreDataSource(fireStore: Get.find()),
    );
    Get.lazyPut<ExpenseRepository>(() => ExpenseRepositoryImpl(Get.find()));
    Get.lazyPut(() => GetAllExpensesUseCase(Get.find()));
    Get.lazyPut(() => GetMonthlyExpensesUseCase(Get.find()));
    Get.lazyPut(() => GetExpenseUseCase(Get.find()));
    Get.lazyPut(() => AddExpenseUseCase(Get.find()));
    Get.lazyPut(() => UpdateExpenseUseCase(Get.find()));
    Get.lazyPut(() => DeleteExpenseUseCase(Get.find()));
    Get.lazyPut(() => ExpenseController(
          getAllExpenses: Get.find(),
          getMonthlyExpensesUseCase: Get.find(),
          getExpense: Get.find(),
          addExpense: Get.find(),
          updateExpense: Get.find(),
          deleteExpense: Get.find(),
        ));

    // --- Lending Feature ---
    Get.lazyPut<LendingDataSource>(
      () => LendingFirestoreDataSource(firestore: Get.find()),
    );
    Get.lazyPut<LendingRepository>(() => LendingRepositoryImpl(
          remoteDataSource: Get.find(),
          exceptionMapper: Get.find(),
        ));

    // Use Cases
    Get.lazyPut(() => GetLendingsUseCase(repository: Get.find()));
    Get.lazyPut(() => AddLendingUseCase(repository: Get.find()));
    Get.lazyPut(
        () => UpdateLendingUseCase(repository: Get.find())); // Register Update
    Get.lazyPut(
        () => DeleteLendingUseCase(repository: Get.find())); // Register Delete
    // Get.lazyPut(() => GetTotalLendingAmountUseCase(repository: Get.find()));
    // Get.lazyPut(() => GetLendingsCountUseCase(repository: Get.find()));

    // Controllers
    Get.lazyPut(() => AddLendingController(
          addLendingUseCase: Get.find(),
          // authService: Get.find(),
        ));
    Get.lazyPut(() => LendingsController(
          getLendingsUseCase: Get.find(),
          deleteLendingUseCase: Get.find(),
          updateLendingUseCase: Get.find(),
        ));
    // Register EditLendingController when created
    // Get.lazyPut(() => EditLendingController(updateLendingUseCase: Get.find(), ...));
    // Register LendingSummaryController when created
    // Get.lazyPut(() => LendingSummaryController(getTotalLendingAmountUseCase: Get.find(), ...));
  }
}
