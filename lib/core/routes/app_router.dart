import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:spendly/features/investments/domain/entities/investment.dart';
import 'package:spendly/features/investments/presentation/screens/add_investment_screen.dart';
import 'package:spendly/features/investments/presentation/screens/edit_investment_screen.dart';
import 'package:spendly/features/investments/presentation/screens/investment_detail_screen.dart';
import 'package:spendly/features/investments/presentation/screens/investment_list_screen.dart';

import '../../features/auth/presentation/screen/login_screen.dart';
import '../../features/auth/presentation/screen/profile_screen.dart';
import '../../features/auth/presentation/screen/registration_screen.dart';
import '../../features/expense/domain/entities/expense_entity.dart';
import '../../features/expense/presentation/screens/expense_report_screen.dart';
import '../../features/expense/presentation/screens/screens.dart';
import '../../features/investments/domain/entities/return_entry.dart';
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

  // Investments Routes
  static const String investments = '/investments';
  static const String investmentDetails = '/investmentDetails';
  static const String addInvestment = '/addInvestment';
  static const String updateInvestment = '/updateInvestment';

  // Profile
  static const String profile = '/profile';

  // Auth
  static const String login = '/login';
  static const String register = '/register';
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

final List<String> authenticatedRoutes = [
  AppRoutes.home,
  AppRoutes.expenses,
  AppRoutes.lendings,
  AppRoutes.investments,
  AppRoutes.profile,
  AppRoutes.expenseReport,
];

final List<String> unauthenticatedRoutes = [
  AppRoutes.login,
  AppRoutes.register,
];

class AppRouter {
  static final GoRouter router = GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: AppRoutes.home,
    refreshListenable: GoRouterRefreshStream(
      FirebaseAuth.instance.authStateChanges(),
    ),
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
            path: AppRoutes.profile,
            name: AppRoutes.profile,
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: ProfileScreen()),
          ),
          GoRoute(
            path: AppRoutes.expenseReport,
            name: AppRoutes.expenseReport,
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: ExpenseReportScreen()),
          ),
        ],
      ),

      // Expenses Detail/Add
      GoRoute(
        path: AppRoutes.addExpense,
        name: AppRoutes.addExpense,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: CreateExpenseScreen()),
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
              onAddReturn: (String p1, ReturnEntry p2) {},
            ),
          );
        },
      ),

      // Auth Routes
      GoRoute(
        path: AppRoutes.login,
        name: AppRoutes.login,
        builder: (context, state) => LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.register,
        name: AppRoutes.register,
        builder: (context, state) => RegistrationScreen(),
      ),
    ],

    redirect: (context, state) {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null && authenticatedRoutes.contains(state.matchedLocation)) {
        return AppRoutes.login;
      }

      if (user != null &&
          unauthenticatedRoutes.contains(state.matchedLocation)) {
        return AppRoutes.home;
      }

      return null;
    },
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

/// Helper to refresh GoRouter when FirebaseAuth state changes
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<User?> stream) {
    notifyListeners();
    _subscription = stream.listen((event) {
      notifyListeners();
    });
  }

  late final StreamSubscription<User?> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
