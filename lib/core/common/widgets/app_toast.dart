import 'package:flutter/material.dart';
import 'package:finkeep/core/responsive/responsive.dart';
import 'package:finkeep/core/styles/app_colors.dart';

/// Supported visual styles for [AppToast].
enum AppToastType {
  success,
  error,
  info,
  debug,
}

/// A centralized toast/snackbar utility providing consistent styling, iconography,
/// and action button support across FinKeep.
class AppToast {
  const AppToast._();

  /// Displays a customizable toast message using [ScaffoldMessenger].
  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> show(
    BuildContext context, {
    required String message,
    AppToastType type = AppToastType.info,
    String? actionLabel,
    VoidCallback? onAction,
    Duration? duration,
    IconData? icon,
    bool hideCurrent = true,
  }) {
    final messenger = ScaffoldMessenger.of(context);
    if (hideCurrent) {
      messenger.hideCurrentSnackBar();
    }

    final config = _getConfig(type, customIcon: icon);

    final snackBar = SnackBar(
      content: Row(
        children: [
          Icon(
            config.icon,
            color: Colors.white,
            size: 20.sp,
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                fontFamily: 'Manrope',
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: config.backgroundColor,
      behavior: SnackBarBehavior.floating,
      duration: duration ?? const Duration(seconds: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.r),
      ),
      action: (actionLabel != null && onAction != null)
          ? SnackBarAction(
              label: actionLabel,
              textColor: Colors.white,
              onPressed: onAction,
            )
          : null,
    );

    return messenger.showSnackBar(snackBar);
  }

  /// Convenience helper to display a Success toast (Emerald / check icon).
  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSuccess(
    BuildContext context, {
    required String message,
    String? actionLabel,
    VoidCallback? onAction,
    Duration? duration,
    IconData? icon,
  }) {
    return show(
      context,
      message: message,
      type: AppToastType.success,
      actionLabel: actionLabel,
      onAction: onAction,
      duration: duration,
      icon: icon,
    );
  }

  /// Convenience helper to display an Error toast (Red / alert icon).
  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showError(
    BuildContext context, {
    required String message,
    String? actionLabel,
    VoidCallback? onAction,
    Duration? duration,
    IconData? icon,
  }) {
    return show(
      context,
      message: message,
      type: AppToastType.error,
      actionLabel: actionLabel,
      onAction: onAction,
      duration: duration,
      icon: icon,
    );
  }

  /// Convenience helper to display an Info toast (Sky blue / info icon).
  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showInfo(
    BuildContext context, {
    required String message,
    String? actionLabel,
    VoidCallback? onAction,
    Duration? duration,
    IconData? icon,
  }) {
    return show(
      context,
      message: message,
      type: AppToastType.info,
      actionLabel: actionLabel,
      onAction: onAction,
      duration: duration,
      icon: icon,
    );
  }

  /// Convenience helper to display a toast with a dedicated action button.
  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason>
      showWithAction(
    BuildContext context, {
    required String message,
    required String actionLabel,
    required VoidCallback onAction,
    AppToastType type = AppToastType.info,
    Duration? duration,
    IconData? icon,
  }) {
    return show(
      context,
      message: message,
      type: type,
      actionLabel: actionLabel,
      onAction: onAction,
      duration: duration,
      icon: icon,
    );
  }

  /// Convenience helper to display a toast with a "View" button.
  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showView(
    BuildContext context, {
    required String message,
    required VoidCallback onView,
    AppToastType type = AppToastType.success,
    Duration? duration,
    IconData? icon,
  }) {
    return show(
      context,
      message: message,
      type: type,
      actionLabel: 'View',
      onAction: onView,
      duration: duration,
      icon: icon,
    );
  }

  /// Convenience helper to display a Debug toast (Violet / bug icon).
  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showDebug(
    BuildContext context, {
    required String message,
    String? actionLabel,
    VoidCallback? onAction,
    Duration? duration,
    IconData? icon,
  }) {
    return show(
      context,
      message: message,
      type: AppToastType.debug,
      actionLabel: actionLabel,
      onAction: onAction,
      duration: duration,
      icon: icon,
    );
  }

  static _ToastConfig _getConfig(AppToastType type, {IconData? customIcon}) {
    switch (type) {
      case AppToastType.success:
        return _ToastConfig(
          backgroundColor: AppColors.primaryTealDark,
          icon: customIcon ?? Icons.check_circle_rounded,
        );
      case AppToastType.error:
        return _ToastConfig(
          backgroundColor: AppColors.error,
          icon: customIcon ?? Icons.error_outline_rounded,
        );
      case AppToastType.info:
        return _ToastConfig(
          backgroundColor: const Color(0xFF0284C7),
          icon: customIcon ?? Icons.info_outline_rounded,
        );
      case AppToastType.debug:
        return _ToastConfig(
          backgroundColor: const Color(0xFF6D28D9),
          icon: customIcon ?? Icons.bug_report_rounded,
        );
    }
  }
}

class _ToastConfig {
  final Color backgroundColor;
  final IconData icon;

  const _ToastConfig({
    required this.backgroundColor,
    required this.icon,
  });
}
