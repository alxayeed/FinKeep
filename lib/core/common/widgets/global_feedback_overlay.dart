import 'package:feedback_github/feedback_github.dart';
import 'package:finkeep/core/routes/app_router.dart';
import 'package:flutter/material.dart';

class GlobalFeedbackOverlay extends StatefulWidget {
  final Widget child;

  const GlobalFeedbackOverlay({super.key, required this.child});

  @override
  State<GlobalFeedbackOverlay> createState() => _GlobalFeedbackOverlayState();
}

class _GlobalFeedbackOverlayState extends State<GlobalFeedbackOverlay> {
  late final VoidCallback _routerListener;
  String _currentPath = '/';

  @override
  void initState() {
    super.initState();

    _routerListener = () {
      if (mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            _updatePath();
          }
        });
      }
    };

    // Defer the initial path resolution and listener registration to avoid interfering with Router mount
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _updatePath();
        AppRouter.router.routerDelegate.addListener(_routerListener);
      }
    });
  }

  void _updatePath() {
    String path = '/';
    try {
      path = AppRouter.router.routeInformationProvider.value.uri.path;
    } catch (_) {}
    if (path != _currentPath) {
      setState(() {
        _currentPath = path;
      });
    }
  }

  @override
  void dispose() {
    try {
      AppRouter.router.routerDelegate.removeListener(_routerListener);
    } catch (_) {}
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notifier = FeedbackScope.of(context);
    if (notifier == null || !notifier.config.enabled) {
      return widget.child;
    }

    double bottomOffset = 16.0;
    if (_currentPath == '/' ||
        _currentPath == '/expenses' ||
        _currentPath == '/lendings' ||
        _currentPath == '/investments') {
      bottomOffset = 210.0;
    } else if (_currentPath == '/expenseReport') {
      bottomOffset = 96.0;
    }

    return Stack(
      children: [
        widget.child,
        Positioned(
          right: 16,
          bottom: bottomOffset,
          child: const FeedbackButton(
            backgroundColor: Colors.deepPurpleAccent,
          ),
        ),
      ],
    );
  }
}
