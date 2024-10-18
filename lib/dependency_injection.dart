import 'package:get/get.dart';
import 'features/expense/data/datasources/firebase_cloudstore_datasource.dart';
import 'features/expense/data/repositories/expense_repository_impl.dart';
import 'features/expense/data/datasources/expense_remote_datasource.dart';
import 'features/expense/domain/repositories/expense_repository.dart';
import 'features/expense/domain/usecases/get_all_expenses_usecase.dart';
import 'features/expense/domain/usecases/get_expense_usecase.dart';
import 'features/expense/domain/usecases/add_expense_usecase.dart';
import 'features/expense/domain/usecases/update_expense_usecase.dart';
import 'features/expense/domain/usecases/delete_expense_usecase.dart';
import 'features/expense/presentation/controllers/expense_controller.dart';

class DependencyInjection{
  static void initDependencies() {
    // Data Sources
    Get.lazyPut<ExpenseRemoteDataSource>(() => FirebaseCloudStoreDataSource());

    // Repositories
    Get.lazyPut<ExpenseRepository>(() => ExpenseRepositoryImpl(Get.find()));

    // Use Cases
    Get.lazyPut(() => GetAllExpensesUseCase(Get.find()));
    Get.lazyPut(() => GetExpenseUseCase(Get.find()));
    Get.lazyPut(() => AddExpenseUseCase(Get.find()));
    Get.lazyPut(() => UpdateExpenseUseCase(Get.find()));
    Get.lazyPut(() => DeleteExpenseUseCase(Get.find()));

    // Controllers
    Get.lazyPut(() => ExpenseController(
      getAllExpenses: Get.find(),
      getExpense: Get.find(),
      addExpense: Get.find(),
      updateExpense: Get.find(),
      deleteExpense: Get.find(),
    ));
  }
}
