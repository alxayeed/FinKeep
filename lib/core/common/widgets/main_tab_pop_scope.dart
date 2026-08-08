import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:finkeep/core/routes/app_router.dart';

class MainTabPopScope extends StatefulWidget {
  final int index;
  final Widget child;

  const MainTabPopScope({
    super.key,
    required this.index,
    required this.child,
  });

  @override
  State<MainTabPopScope> createState() => _MainTabPopScopeState();
}

class _MainTabPopScopeState extends State<MainTabPopScope> {
  static DateTime? _lastBackPressTime;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;

        // If on secondary tab, return to Dashboard tab first
        if (widget.index != 0) {
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
      child: widget.child,
    );
  }
}
