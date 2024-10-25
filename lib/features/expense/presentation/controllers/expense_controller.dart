import 'package:get/get.dart';
import 'package:spendly/features/expense/domain/usecases/get_monthly_expense.dart';

import '../../domain/entities/expense_entity.dart';
import '../../domain/usecases/usecases.dart';


class ExpenseController extends GetxController {
  final GetAllExpensesUseCase getAllExpenses;
  final GetMonthlyExpensesUseCase getMonthlyExpensesUseCase;
  final GetExpenseUseCase getExpense;
  final AddExpenseUseCase addExpense;
  final UpdateExpenseUseCase updateExpense;
  final DeleteExpenseUseCase deleteExpense;

  var expenses = <ExpenseEntity>[].obs;
  var isLoading = false.obs;

  ExpenseController({
    required this.getAllExpenses,
    required this.getMonthlyExpensesUseCase,
    required this.getExpense,
    required this.addExpense,
    required this.updateExpense,
    required this.deleteExpense,
  });

  @override
  void onInit() {
    fetchExpenses();
    super.onInit();
  }



  Future<void> fetchExpenses() async {
    isLoading.value = true;
    try {
      expenses.value = await getAllExpenses.call('userId'); // Replace with actual userId
    } catch (e) {
      // Handle error
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchMonthlyExpenses(DateTime month) async {
    isLoading.value = true;
    try {
      expenses.value = await getMonthlyExpensesUseCase('userId', month);
    } catch (e) {
      // Handle error
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createExpense(ExpenseEntity expense) async {
    await addExpense.call(expense);
    fetchExpenses();
  }

  Future<void> editExpense(ExpenseEntity expense) async {
    await updateExpense.call(expense);
    fetchExpenses();
  }

  Future<void> removeExpense(String id) async {
    await deleteExpense.call(id);
    fetchExpenses();
  }
}
