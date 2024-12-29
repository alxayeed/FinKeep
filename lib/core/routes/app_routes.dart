import 'package:get/get.dart';

import '../../features/expense/presentation/screens/screens.dart';

class AppRoutes {
  static const String home = '/';
  static const String expenses = '/expenses';
  static const String expenseDetails = '/expenseDetails';
  static const String dailyExpense = '/dailyExpense';
  static const String weeklyExpense = '/weeklyExpense';
  static const String monthlyExpense = '/monthlyExpense';
  static const String yearlyExpense = '/yearlyExpense';

  static List<GetPage> routes = [
    GetPage(name: home, page: () => const MonthlyExpenseScreen()),
    // GetPage(
    //     name: expenseDetails,
    //     page: () => ExpenseDetailsScreen(expense: Get.arguments)),
    GetPage(name: dailyExpense, page: () => const DailyExpenseScreen()),
    GetPage(name: weeklyExpense, page: () => const WeeklyExpenseScreen()),
    GetPage(name: monthlyExpense, page: () => const MonthlyExpenseScreen()),
    GetPage(name: yearlyExpense, page: () => const YearlyExpenseScreen()),
  ];
}
