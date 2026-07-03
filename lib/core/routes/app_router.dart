import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:finkeep/features/investments/domain/entities/investment.dart';
import 'package:finkeep/features/investments/presentation/screens/add_investment_screen.dart';
import 'package:finkeep/features/investments/presentation/screens/edit_investment_screen.dart';
import 'package:finkeep/features/investments/presentation/screens/investment_detail_screen.dart';
import 'package:finkeep/features/investments/presentation/screens/investment_list_screen.dart';

import '../common/settings_screen.dart';
import '../common/privacy_policy_screen.dart';
import '../../features/expense/domain/entities/expense_entity.dart';
import '../../features/expense/presentation/screens/screens.dart';
import '../../features/lendings/domain/entity/lending/lending_entity.dart';
import '../../features/lendings/presentation/screens/add_lending_screen.dart';
import '../../features/lendings/presentation/screens/lending_details_screen.dart';
import '../../features/lendings/presentation/screens/lending_list_screen.dart';
import '../../features/lendings/presentation/screens/update_lending_screen.dart';
import '../common/home_scaffold.dart';
import '../common/onboarding/onboarding_screen.dart';

class AppRoutes {
  static const String home = '/';

  // Expenses
  static const String expenses = '/expenses';
  static const String addExpense = '/addExpense';
  static const String expenseDetails = '/expenseDetails';
  static const String editExpense = '/editExpense';
  static const String expenseReport = '/expenseReport';
  static const String setMonthlyBudget = '/setMonthlyBudget';
  static const String missingBudget = '/missingBudget';

  // Lending Routes
  static const String lendings = '/lendings';
  static const String lendingDetails = '/lendingDetails';
  static const String addLending = '/addLending';
  static const String updateLending = '/updateLending';

  // Investments Routes
  static const String investments = '/investments';
  static const String investmentDetails = '/investmentDetails';
  static const String addInvestment = '/addInvestment';
  static const String updateInvestment = '/updateInvestment';

  // Settings
  static const String settings = '/settings';
  static const String privacyPolicy = '/privacyPolicy';

  // Onboarding
  static const String onboarding = '/onboarding';
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  static late final GoRouter router;

  static void init(bool seenOnboarding) {
    router = GoRouter(
      navigatorKey: navigatorKey,
      initialLocation: seenOnboarding ? AppRoutes.home : AppRoutes.onboarding,
      routes: [
        ShellRoute(
          builder: (context, state, child) => HomeScaffold(child: child),
          routes: [
            GoRoute(
              path: AppRoutes.home,
              name: AppRoutes.home,
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: MonthlyExpenseScreen()),
            ),
            GoRoute(
              path: AppRoutes.expenses,
              name: AppRoutes.expenses,
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: MonthlyExpenseScreen()),
            ),
            GoRoute(
              path: AppRoutes.lendings,
              name: AppRoutes.lendings,
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: LendingListScreen()),
            ),
            GoRoute(
              path: AppRoutes.investments,
              name: AppRoutes.investments,
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: InvestmentListScreen()),
            ),
            GoRoute(
              path: AppRoutes.expenseReport,
              name: AppRoutes.expenseReport,
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: ExpenseReportScreen()),
            ),
          ],
        ),

        GoRoute(
          path: AppRoutes.settings,
          name: AppRoutes.settings,
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: SettingsScreen()),
        ),
        GoRoute(
          path: AppRoutes.privacyPolicy,
          name: AppRoutes.privacyPolicy,
          pageBuilder: (context, state) {
            return const NoTransitionPage(child: PrivacyPolicyScreen());
          },
        ),
        GoRoute(
          path: AppRoutes.addExpense,
          name: AppRoutes.addExpense,
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: CreateExpenseScreen()),
        ),
        GoRoute(
          path: AppRoutes.setMonthlyBudget,
          name: AppRoutes.setMonthlyBudget,
          pageBuilder: (context, state) {
            final DateTime month = state.extra as DateTime? ?? DateTime.now();
            return NoTransitionPage(child: SetMonthlyBudgetScreen(month: month));
          },
        ),
        GoRoute(
          path: AppRoutes.missingBudget,
          name: AppRoutes.missingBudget,
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: MissingBudgetScreen()),
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
            return NoTransitionPage(child: ExpenseDetailsScreen(expense: extra));
          },
        ),
        GoRoute(
          path: AppRoutes.editExpense,
          name: AppRoutes.editExpense,
          pageBuilder: (context, state) {
            final extra = state.extra;
            if (extra is! ExpenseEntity) {
              return const NoTransitionPage(
                child: ErrorScreen(message: 'Invalid Expense data for editing.'),
              );
            }
            return NoTransitionPage(
              child: EditExpenseScreen(expense: extra),
            );
          },
        ),

        // Lendings Detail/Add/Update
        GoRoute(
          path: AppRoutes.addLending,
          name: AppRoutes.addLending,
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: AddLendingScreen()),
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
            return NoTransitionPage(child: LendingDetailsScreen(lending: extra));
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
            return NoTransitionPage(child: UpdateLendingScreen(lending: extra));
          },
        ),

        // Investment Detail/Add/Update
        GoRoute(
          path: AppRoutes.addInvestment,
          name: AppRoutes.addInvestment,
          pageBuilder: (context, state) =>
              NoTransitionPage(child: AddInvestmentScreen(onSubmit: (p1) {})),
        ),
        GoRoute(
          path: AppRoutes.updateInvestment,
          name: AppRoutes.updateInvestment,
          pageBuilder: (context, state) {
            final extra = state.extra;
            if (extra is! Investment) {
              return const NoTransitionPage(
                child: ErrorScreen(message: 'Invalid Investment data.'),
              );
            }
            return NoTransitionPage(
              child: EditInvestmentScreen(
                investment: extra,
                onUpdate: (Investment p1) {},
              ),
            );
          },
        ),
        GoRoute(
          path: AppRoutes.investmentDetails,
          name: AppRoutes.investmentDetails,
          pageBuilder: (context, state) {
            final extra = state.extra;
            if (extra is! Investment) {
              return const NoTransitionPage(
                child: ErrorScreen(message: 'Invalid Investment data.'),
              );
            }
            return NoTransitionPage(
              child: InvestmentDetailScreen(
                investment: extra,
              ),
            );
          },
        ),
        GoRoute(
          path: AppRoutes.onboarding,
          name: AppRoutes.onboarding,
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: OnboardingScreen()),
        ),
      ],
    );
  }
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
