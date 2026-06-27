import 'package:feedback_github/feedback_github.dart';
import 'package:finkeep/core/routes/app_router.dart';
import 'package:flutter/material.dart';

class GlobalFeedbackOverlay extends StatelessWidget {
  final Widget child;

  const GlobalFeedbackOverlay({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final notifier = FeedbackScope.of(context);
    if (notifier == null || !notifier.config.enabled) {
      return child;
    }

    return Stack(
      children: [
        child,
        AnimatedBuilder(
          animation: AppRouter.router.routerDelegate,
          builder: (context, _) {
            // Safe access to path, with fallback if not yet initialized or ready
            String path = '/';
            try {
              path = AppRouter.router.routeInformationProvider.value.uri.path;
            } catch (_) {}

            double bottomOffset = 16.0;
            if (path == '/' ||
                path == '/expenses' ||
                path == '/lendings' ||
                path == '/investments') {
              bottomOffset = 210.0;
            } else if (path == '/expenseReport') {
              bottomOffset = 96.0;
            }

            return Positioned(
              right: 16,
              bottom: bottomOffset,
              child: const FeedbackButton(),
            );
          },
        ),
      ],
    );
  }
}
