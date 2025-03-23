import 'package:get/get.dart';
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

class DependencyInjection {
  static void initDependencies() {
    // Data Sources
    Get.lazyPut<ExpenseRemoteDataSource>(() => FirebaseCloudStoreDataSource());
    // Get.lazyPut<LendingDataSource>(() => LendingDataSourceImpl());

    // Repositories
    Get.lazyPut<ExpenseRepository>(() => ExpenseRepositoryImpl(Get.find()));
    // Get.lazyPut<LendingRepository>(() => LendingRepositoryImpl(Get.find()));

    // Use Cases
    //Expenses
    Get.lazyPut(() => GetAllExpensesUseCase(Get.find()));
    Get.lazyPut(() => GetMonthlyExpensesUseCase(Get.find()));
    Get.lazyPut(() => GetExpenseUseCase(Get.find()));
    Get.lazyPut(() => AddExpenseUseCase(Get.find()));
    Get.lazyPut(() => UpdateExpenseUseCase(Get.find()));
    Get.lazyPut(() => DeleteExpenseUseCase(Get.find()));
    //Lendings
    // Get.lazyPut(
    //     () => CreateLendingRecordUsecase(Get.find()));

    // Controllers
    Get.lazyPut(() => ExpenseController(
          getAllExpenses: Get.find(),
          getMonthlyExpensesUseCase: Get.find(),
          getExpense: Get.find(),
          addExpense: Get.find(),
          updateExpense: Get.find(),
          deleteExpense: Get.find(),
        ));
  }
}
