import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:spendly/core/styles/app_colors.dart';

import '../routes/app_router.dart';

class HomeScaffold extends StatelessWidget {
  final Widget child;

  const HomeScaffold({super.key, required this.child});

  int _currentIndex(BuildContext context) {
    final currentRouteName = GoRouterState.of(context).matchedLocation;

    if (currentRouteName.startsWith(AppRoutes.lendings)) return 1;
    if (currentRouteName.startsWith(AppRoutes.expenseReport)) return 2;
    if (currentRouteName.startsWith(AppRoutes.profile)) return 3;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final index = _currentIndex(context);

    Color primaryColor = AppColors.primaryTeal;
    const Color accentColor = AppColors.white;
    const Color unselectedColor = Colors.grey;

    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: primaryColor,
        selectedItemColor: accentColor,
        unselectedItemColor: unselectedColor,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.normal,
          color: unselectedColor,
        ),
        selectedFontSize: 14.0,
        unselectedFontSize: 12.0,
        currentIndex: index,
        onTap: (i) {
          if (i == 0) context.goNamed(AppRoutes.expenses);
          if (i == 1) context.goNamed(AppRoutes.lendings);
          if (i == 2) context.goNamed(AppRoutes.expenseReport);
          if (i == 3) context.goNamed(AppRoutes.profile);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.monetization_on_outlined),
            activeIcon: Icon(Icons.monetization_on),
            label: 'Expenses',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.handshake_outlined),
            activeIcon: Icon(Icons.handshake),
            label: 'Lendings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            activeIcon: Icon(Icons.bar_chart),
            label: 'Reports',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
