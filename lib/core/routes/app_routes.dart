import 'package:get/get.dart';
import 'package:spendly/features/expense/presentation/screens/screens.dart';
import 'package:spendly/features/lendings/presentation/screens/lending_list_screen.dart';
import 'package:spendly/features/lendings/presentation/screens/update_lending_screen.dart';

import '../../features/expense/presentation/screens/expense_report_screen.dart';
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

  // Lending Routes
  static const String lendingList = '/lendingList';
  static const String addLending = '/addLending';
  static const String updateLending = '/updateLending';

  static const Duration _transitionDuration = Duration(milliseconds: 0);
  static const Transition _defaultTransition = Transition.noTransition;

  static List<GetPage> routes = [
    GetPage(
      name: home,
      page: () => const MonthlyExpenseScreen(),
      transition: _defaultTransition,
      transitionDuration: _transitionDuration,
    ),
    GetPage(
      name: addExpense,
      page: () => const CreateExpenseScreen(),
      transition: _defaultTransition,
      transitionDuration: _transitionDuration,
    ),
    GetPage(
      name: monthlyExpense,
      page: () => const MonthlyExpenseScreen(),
      transition: _defaultTransition,
      transitionDuration: _transitionDuration,
    ),
    GetPage(
      name: lendingList,
      page: () => const LendingListScreen(),
      transition: _defaultTransition,
      transitionDuration: _transitionDuration,
    ),
    GetPage(
      name: expenseDetails,
      page: () => ExpenseDetailsScreen(expense: Get.arguments),
      transition: _defaultTransition,
      transitionDuration: _transitionDuration,
    ),
    GetPage(
      name: addLending,
      page: () => const AddLendingScreen(),
      transition: _defaultTransition,
      transitionDuration: _transitionDuration,
    ),
    GetPage(
      name: updateLending,
      page: () => UpdateLendingScreen(lending: Get.arguments),
      transition: _defaultTransition,
      transitionDuration: _transitionDuration,
    ),
    GetPage(
      name: expenseReport,
      page: () => const ExpenseReportScreen(),
      transition: _defaultTransition,
      transitionDuration: _transitionDuration,
    ),
  ];
}
