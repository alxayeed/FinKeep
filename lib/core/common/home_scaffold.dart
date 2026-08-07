import 'package:finkeep/core/common/widgets/custom_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../config/app_config.dart';
import '../routes/app_router.dart';

class HomeScaffold extends StatefulWidget {
  final Widget child;

  const HomeScaffold({super.key, required this.child});

  @override
  State<HomeScaffold> createState() => _HomeScaffoldState();
}

class _HomeScaffoldState extends State<HomeScaffold> {
  DateTime? _lastBackPressTime;

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

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;

        // If on secondary tab, return to Dashboard tab
        if (index != 0) {
          context.goNamed(AppRoutes.home);
          return;
        }

        // If on Dashboard tab, double-tap to exit app
        final now = DateTime.now();
        if (_lastBackPressTime == null ||
            now.difference(_lastBackPressTime!) > const Duration(seconds: 2)) {
          _lastBackPressTime = now;
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Press back again to exit'),
              duration: Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
              margin: EdgeInsets.only(bottom: 80, left: 24, right: 24),
            ),
          );
        } else {
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
        body: widget.child,
        bottomNavigationBar: CustomBottomNavBar(
          currentIndex: index,
          style: CustomNavBarStyle.indicatorLine,
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
      ),
    );
  }
}
