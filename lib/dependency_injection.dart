import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:spendly/core/error/exception_mapper.dart';
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
import 'package:spendly/features/lendings/data/datasources/lending_data_source.dart';
import 'package:spendly/features/lendings/data/datasources/lending_firestore_data_source.dart';
import 'package:spendly/features/lendings/data/repositories/lending_repository_impl.dart';
import 'package:spendly/features/lendings/domain/repositories/lending_repository.dart';
import 'package:spendly/features/lendings/domain/usecases/get_all_lendings_usecase.dart';
import 'package:spendly/features/lendings/presentation/controllers/lendings_controller.dart';

class DependencyInjection {
  static void initDependencies() {
    Get.lazyPut<FirebaseFirestore>(() => FirebaseFirestore.instance);

    // ExceptionMapper
    Get.lazyPut<ExceptionMapper>(() => ExceptionMapper());

    // Data Sources
    Get.lazyPut<ExpenseRemoteDataSource>(
      () => FirebaseCloudStoreDataSource(
        fireStore: Get.find(),
      ),
    );

    // Register Lending DataSource
    Get.lazyPut<LendingDataSource>(
      () => LendingFirestoreDataSource(
        firestore: Get.find(),
      ),
    );

    // Repositories
    Get.lazyPut<ExpenseRepository>(() => ExpenseRepositoryImpl(Get.find()));
    Get.lazyPut<LendingRepository>(() => LendingRepositoryImpl(
          dataSource: Get.find(),
          exceptionMapper: Get.find(),
        ));

    // Use Cases
    // Expenses
    Get.lazyPut(() => GetAllExpensesUseCase(Get.find()));
    Get.lazyPut(() => GetMonthlyExpensesUseCase(Get.find()));
    Get.lazyPut(() => GetExpenseUseCase(Get.find()));
    Get.lazyPut(() => AddExpenseUseCase(Get.find()));
    Get.lazyPut(() => UpdateExpenseUseCase(Get.find()));
    Get.lazyPut(() => DeleteExpenseUseCase(Get.find()));

    // Lendings
    Get.lazyPut(() => GetAllLendingsUseCase(Get.find()));

    // Controllers
    // Expenses
    Get.lazyPut(() => ExpenseController(
          getAllExpenses: Get.find(),
          getMonthlyExpensesUseCase: Get.find(),
          getExpense: Get.find(),
          addExpense: Get.find(),
          updateExpense: Get.find(),
          deleteExpense: Get.find(),
        ));

    // Lendings
    Get.lazyPut(
      () => LendingController(
        getAllLendingsUseCase: Get.find(),
      ),
    );
  }
}
