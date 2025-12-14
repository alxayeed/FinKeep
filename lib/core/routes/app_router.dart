import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/expense/domain/entities/expense_entity.dart';
import '../../features/expense/presentation/screens/expense_report_screen.dart';
import '../../features/expense/presentation/screens/screens.dart';
import '../../features/lendings/domain/entity/lending/lending_entity.dart';
import '../../features/lendings/presentation/screens/add_lending_screen.dart';
import '../../features/lendings/presentation/screens/lending_details_screen.dart';
import '../../features/lendings/presentation/screens/lending_list_screen.dart';
import '../../features/lendings/presentation/screens/update_lending_screen.dart';
import '../common/home_scaffold.dart';

class AppRoutes {
  static const String home = '/';

  // Expenses
  static const String expenses = '/expenses';
  static const String addExpense = '/addExpense';
  static const String expenseDetails = '/expenseDetails';
  static const String expenseReport = '/expenseReport';

  // Lending Routes
  static const String lendings = '/lendings';
  static const String lendingDetails = '/lendingDetails';
  static const String addLending = '/addLending';
  static const String updateLending = '/updateLending';
}

// --------------------------------------------------------------------------
// ROUTER IMPLEMENTATION (No Transitions)
// --------------------------------------------------------------------------

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.expenses,
    routes: [
      /// ----------------------------------------------------
      /// 1. SHELL ROUTE (Routes with Bottom Nav)
      /// ----------------------------------------------------
      ShellRoute(
        builder: (context, state, child) => HomeScaffold(child: child),
        routes: [
          // A. Expenses Tab
          GoRoute(
            path: AppRoutes.expenses,
            name: AppRoutes.expenses,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: MonthlyExpenseScreen(),
            ),
          ),

          // B. Lendings Tab
          GoRoute(
            path: AppRoutes.lendings,
            name: AppRoutes.lendings,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: LendingListScreen(),
            ),
          ),

          // C. Reports Tab
          GoRoute(
            path: AppRoutes.expenseReport,
            name: AppRoutes.expenseReport,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: ExpenseReportScreen(),
            ),
          ),
        ],
      ),

      /// ----------------------------------------------------
      /// 2. TOP-LEVEL ROUTES (No Transition)
      /// ----------------------------------------------------

      // Expenses Detail/Add
      GoRoute(
        path: AppRoutes.addExpense,
        name: AppRoutes.addExpense,
        pageBuilder: (context, state) => const NoTransitionPage(
          child: CreateExpenseScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.expenseDetails,
        name: AppRoutes.expenseDetails,
        pageBuilder: (context, state) {
          final extra = state.extra;
          if (extra is! ExpenseEntity) {
            return const NoTransitionPage(
              child: ErrorScreen(message: 'Invalid Expense data.'),
            );
          }
          return NoTransitionPage(
            child: ExpenseDetailsScreen(expense: extra),
          );
        },
      ),

      // Lendings Detail/Add/Update
      GoRoute(
        path: AppRoutes.addLending,
        name: AppRoutes.addLending,
        pageBuilder: (context, state) => const NoTransitionPage(
          child: AddLendingScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.lendingDetails,
        name: AppRoutes.lendingDetails,
        pageBuilder: (context, state) {
          final extra = state.extra;
          if (extra is! LendingEntity) {
            return const NoTransitionPage(
              child: ErrorScreen(message: 'Invalid Lending data.'),
            );
          }
          return NoTransitionPage(
            child: LendingDetailsScreen(lending: extra),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.updateLending,
        name: AppRoutes.updateLending,
        pageBuilder: (context, state) {
          final extra = state.extra;
          if (extra is! LendingEntity) {
            return const NoTransitionPage(
              child: ErrorScreen(message: 'Invalid Lending data.'),
            );
          }
          return NoTransitionPage(
            child: UpdateLendingScreen(lending: extra),
          );
        },
      ),
    ],
  );
}

// Dummy ErrorScreen
class ErrorScreen extends StatelessWidget {
  final String message;

  const ErrorScreen({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Center(child: Text(message)),
    );
  }
}
