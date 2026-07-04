import 'package:finkeep/core/common/widgets/custom_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../config/app_config.dart';
import '../routes/app_router.dart';

class HomeScaffold extends StatelessWidget {
  final Widget child;

  const HomeScaffold({super.key, required this.child});

  int _currentIndex(BuildContext context) {
    final currentRouteName = GoRouterState.of(context).matchedLocation;

    if (currentRouteName.startsWith(AppRoutes.expenses)) return 1;
    if (currentRouteName.startsWith(AppRoutes.income)) return 2;
    if (currentRouteName.startsWith(AppRoutes.lendings)) return 3;
    if (currentRouteName.startsWith(AppRoutes.expenseReport)) return 4;
    if (currentRouteName.startsWith(AppRoutes.investments)) return 5;
    return 0; // Dashboard
  }

  @override
  Widget build(BuildContext context) {
    final index = _currentIndex(context);

    final navItems = [
      const CustomNavBarItem(
        icon: Icons.dashboard_outlined,
        activeIcon: Icons.dashboard,
        label: 'Dashboard',
      ),
      const CustomNavBarItem(
        icon: Icons.monetization_on_outlined,
        activeIcon: Icons.monetization_on,
        label: 'Expenses',
      ),
      const CustomNavBarItem(
        icon: Icons.account_balance_wallet_outlined,
        activeIcon: Icons.account_balance_wallet,
        label: 'Income',
      ),
      const CustomNavBarItem(
        icon: Icons.handshake_outlined,
        activeIcon: Icons.handshake,
        label: 'Lendings',
      ),
      const CustomNavBarItem(
        icon: Icons.bar_chart_outlined,
        activeIcon: Icons.bar_chart,
        label: 'Reports',
      ),
      if (AppConfig.isPersonal) ...const [
        CustomNavBarItem(
          icon: Icons.trending_up_outlined,
          activeIcon: Icons.trending_up,
          label: 'Investments',
        ),
      ],
    ];

    return Scaffold(
      body: child,
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: index,
        style: CustomNavBarStyle.floatingPill,
        items: navItems,
        onTap: (i) {
          if (i == 0) context.goNamed(AppRoutes.home);
          if (i == 1) context.goNamed(AppRoutes.expenses);
          if (i == 2) context.goNamed(AppRoutes.income);
          if (i == 3) context.goNamed(AppRoutes.lendings);
          if (i == 4) context.goNamed(AppRoutes.expenseReport);
          if (i == 5 && AppConfig.isPersonal) {
            context.goNamed(AppRoutes.investments);
          }
        },
      ),
    );
  }
}
