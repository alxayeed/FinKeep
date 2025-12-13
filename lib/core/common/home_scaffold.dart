import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:spendly/core/styles/app_colors.dart';

import '../routes/app_router.dart';

class HomeScaffold extends StatelessWidget {
  final Widget child;

  const HomeScaffold({super.key, required this.child});

  int _currentIndex(BuildContext context) {
    final currentRouteName = GoRouterState.of(context).matchedLocation;

    // 2. Compare the current path string with the AppRoutes path constants
    if (currentRouteName.startsWith(AppRoutes.lendings)) return 1;
    if (currentRouteName.startsWith(AppRoutes.expenseReport)) {
      return 2; // Using the new report route name
    }
    return 0; // Default is /expenses
  }

  @override
  Widget build(BuildContext context) {
    final index = _currentIndex(context);

    // Define colors (assuming AppColors are available)
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
        // Fix: Use foreground color for unselected text style
        unselectedLabelStyle:
            const TextStyle(fontWeight: FontWeight.normal, color: accentColor),
        selectedFontSize: 14.0,
        unselectedFontSize: 12.0,

        // Functionality
        currentIndex: index,
        onTap: (i) {
          if (i == 0) context.goNamed(AppRoutes.expenses);
          if (i == 1) context.goNamed(AppRoutes.lendings);
          if (i == 2) {
            context.goNamed(AppRoutes.expenseReport);
          }
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
        ],
      ),
    );
  }
}
