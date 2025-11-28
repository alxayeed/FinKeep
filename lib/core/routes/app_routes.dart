import 'package:get/get.dart';
import 'package:spendly/features/expense/presentation/screens/screens.dart';
import 'package:spendly/features/lendings/presentation/screens/lending_list_screen.dart';

import '../../features/expense/presentation/screens/expense_report_screen.dart';
import '../../features/lendings/presentation/bindings/add_lending_binding.dart';
import '../../features/lendings/presentation/screens/add_lending_screen.dart';

class AppRoutes {
  static const String home = '/';
  static const String expenses = '/expenses';
  static const String addExpense = '/addExpense';
  static const String expenseDetails = '/expenseDetails';
  static const String dailyExpense = '/dailyExpense';
  static const String weeklyExpense = '/weeklyExpense';
  static const String monthlyExpense = '/monthlyExpense';
  static const String yearlyExpense = '/yearlyExpense';
  static const expenseReport = '/expenseReport';

  // New Lending Routes
  static const String lendingList = '/lendingList';
  static const String addLending = '/addLending';

  static List<GetPage> routes = [
    GetPage(name: home, page: () => const MonthlyExpenseScreen()),
    GetPage(name: addExpense, page: () => const CreateExpenseScreen()),
    // GetPage(name: expenseDetails, page: () => ExpenseDetailsScreen(expense: Get.arguments)),
    GetPage(name: dailyExpense, page: () => const DailyExpenseScreen()),
    GetPage(name: weeklyExpense, page: () => const WeeklyExpenseScreen()),
    GetPage(name: monthlyExpense, page: () => const MonthlyExpenseScreen()),
    GetPage(name: yearlyExpense, page: () => const YearlyExpenseScreen()),

    GetPage(
      name: lendingList,
      page: () => const LendingListScreen(),
      // binding: LendingBindings(),
    ),
    GetPage(
      name: addLending,
      page: () => const AddLendingScreen(),
      binding: AddLendingBinding(),
    ),
    GetPage(
      name: AppRoutes.expenseReport,
      page: () => const ExpenseReportScreen(),
    ),
  ];
}
