import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:spendly/core/common/widgets/custom_bottom_nav_bar.dart';

import '../routes/app_router.dart';

class HomeScaffold extends StatelessWidget {
  final Widget child;

  const HomeScaffold({super.key, required this.child});

  int _currentIndex(BuildContext context) {
    final currentRouteName = GoRouterState.of(context).matchedLocation;

    if (currentRouteName.startsWith(AppRoutes.lendings)) return 1;
    if (currentRouteName.startsWith(AppRoutes.expenseReport)) return 2;
    if (currentRouteName.startsWith(AppRoutes.investments)) return 3;
    if (currentRouteName.startsWith(AppRoutes.profile)) return 4;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final index = _currentIndex(context);

    final navItems = const [
      CustomNavBarItem(
        icon: Icons.monetization_on_outlined,
        activeIcon: Icons.monetization_on,
        label: 'Expenses',
      ),
      CustomNavBarItem(
        icon: Icons.handshake_outlined,
        activeIcon: Icons.handshake,
        label: 'Lendings',
      ),
      CustomNavBarItem(
        icon: Icons.bar_chart_outlined,
        activeIcon: Icons.bar_chart,
        label: 'Reports',
      ),
      CustomNavBarItem(
        icon: Icons.trending_up_outlined,
        activeIcon: Icons.trending_up,
        label: 'Investments',
      ),
      CustomNavBarItem(
        icon: Icons.person_outline,
        activeIcon: Icons.person,
        label: 'Profile',
      ),
    ];

    return Scaffold(
      body: child,
      // Let's use the floatingPill variation first as requested
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: index,
        style: CustomNavBarStyle.floatingPill,
        items: navItems,
        onTap: (i) {
          if (i == 0) context.goNamed(AppRoutes.expenses);
          if (i == 1) context.goNamed(AppRoutes.lendings);
          if (i == 2) context.goNamed(AppRoutes.expenseReport);
          if (i == 3) context.goNamed(AppRoutes.investments);
          if (i == 4) context.goNamed(AppRoutes.profile);
        },
      ),
    );
  }
}
