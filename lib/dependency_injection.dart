import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:spendly/core/error/exception_mapper.dart';
// Expense Feature Dependencies
import 'package:spendly/features/expense/data/datasources/expense_remote_datasource.dart';
import 'package:spendly/features/expense/data/datasources/firebase_cloudstore_datasource.dart'; // Assuming this is correct path for expense DS
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
import 'package:spendly/features/lendings/domain/usecases/add_lending_usecase.dart'; // Import AddLendingUseCase
import 'package:spendly/features/lendings/domain/usecases/get_lendings_usecase.dart';
import 'package:spendly/features/lendings/presentation/controllers/add_lending_controller.dart'; // Import AddLendingController
import 'package:spendly/features/lendings/presentation/controllers/lending_list_controller.dart'; // Import LendingListController
// Import other lending use cases as they are created

class DependencyInjection {
  static void initDependencies() {
    // Core / Infrastructure
    Get.lazyPut<FirebaseFirestore>(() => FirebaseFirestore.instance,
        fenix: true); // fenix:true keeps instance alive
    Get.lazyPut<ExceptionMapper>(() => ExceptionMapper());
    // TODO: Register AuthService if needed by controllers
    // Get.lazyPut<AuthService>(() => YourAuthServiceImpl());

    // --- Expense Feature ---
    // Data Sources
    Get.lazyPut<ExpenseRemoteDataSource>(
      () => FirebaseCloudStoreDataSource(
        // Renaming Expense one for clarity
        fireStore: Get.find(),
      ),
    );
    // Repositories
    Get.lazyPut<ExpenseRepository>(
        () => ExpenseRepositoryImpl(Get.find())); // Assuming it only needs DS
    // Use Cases
    Get.lazyPut(() => GetAllExpensesUseCase(Get.find()));
    Get.lazyPut(() => GetMonthlyExpensesUseCase(Get.find()));
    Get.lazyPut(() => GetExpenseUseCase(Get.find()));
    Get.lazyPut(() => AddExpenseUseCase(Get.find()));
    Get.lazyPut(() => UpdateExpenseUseCase(Get.find()));
    Get.lazyPut(() => DeleteExpenseUseCase(Get.find()));
    // Controllers
    Get.lazyPut(() => ExpenseController(
          getAllExpenses: Get.find(),
          getMonthlyExpensesUseCase: Get.find(),
          getExpense: Get.find(),
          addExpense: Get.find(),
          updateExpense: Get.find(),
          deleteExpense: Get.find(),
        ));

    // --- Lending Feature ---
    // Data Sources
    Get.lazyPut<LendingDataSource>(
      () => LendingFirestoreDataSource(
        firestore: Get.find(),
      ),
    );
    // Repositories
    Get.lazyPut<LendingRepository>(() => LendingRepositoryImpl(
          remoteDataSource: Get.find(),
          exceptionMapper: Get.find(),
        ));
    // Use Cases
    Get.lazyPut(() => GetLendingsUseCase(repository: Get.find()));
    Get.lazyPut(() => AddLendingUseCase(
        repository: Get.find())); // Register AddLendingUseCase
    // Register other lending use cases here as needed:
    // Get.lazyPut(() => UpdateLendingStatusUseCase(repository: Get.find()));
    // Get.lazyPut(() => DeleteLendingUseCase(repository: Get.find()));
    // Get.lazyPut(() => GetTotalLendingAmountUseCase(repository: Get.find()));
    // Get.lazyPut(() => GetLendingsCountUseCase(repository: Get.find()));

    // Controllers
    Get.lazyPut(() => AddLendingController(
          // Register AddLendingController
          addLendingUseCase: Get.find(),
          // authService: Get.find(), // Uncomment if using AuthService
        ));
    Get.lazyPut(() => LendingListController(
          // Register LendingListController
          getLendingsUseCase: Get.find(),
          // authService: Get.find(), // Uncomment if using AuthService
        ));
    // Register other lending controllers here as needed (e.g., LendingSummaryController)
  }
}
