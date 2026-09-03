import 'package:finkeep/core/common/widgets/custom_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
  int _currentIndex(BuildContext context) {
    final currentRouteName = GoRouterState.of(context).matchedLocation;

    if (currentRouteName.startsWith(AppRoutes.expenses)) return 1;
    if (currentRouteName.startsWith(AppRoutes.income)) return 2;
    if (currentRouteName.startsWith(AppRoutes.lendings)) return 3;
    if (currentRouteName.startsWith(AppRoutes.investments)) return 4;
    return 0; // Dashboard
  }

  @override
  Widget build(BuildContext context) {
    final index = _currentIndex(context);

    final navItems = [
      CustomNavBarItem(
        icon: FontAwesomeIcons.chartPie,
        activeIcon: FontAwesomeIcons.chartPie,
        label: 'Dashboard',
      ),
      CustomNavBarItem(
        icon: FontAwesomeIcons.receipt,
        activeIcon: FontAwesomeIcons.receipt,
        label: 'Expenses',
      ),
      CustomNavBarItem(
        icon: FontAwesomeIcons.wallet,
        activeIcon: FontAwesomeIcons.wallet,
        label: 'Income',
      ),
      CustomNavBarItem(
        icon: FontAwesomeIcons.handshake,
        activeIcon: FontAwesomeIcons.handshake,
        label: 'Lendings',
      ),
      if (AppConfig.isPersonal) ...[
        CustomNavBarItem(
          icon: FontAwesomeIcons.arrowTrendUp,
          activeIcon: FontAwesomeIcons.arrowTrendUp,
          label: 'Investments',
        ),
      ],
    ];

    return Scaffold(
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
          if (i == 4 && AppConfig.isPersonal) {
            context.goNamed(AppRoutes.investments);
          }
        },
      ),
    );
  }
}
