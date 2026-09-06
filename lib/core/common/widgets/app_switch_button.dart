import 'package:finkeep/core/styles/app_colors.dart';
import 'package:flutter/material.dart';

class AppSwitchButton extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const AppSwitchButton({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Switch(
      value: value,
      onChanged: onChanged,
      activeThumbColor: AppColors.primaryTeal,
      activeTrackColor: AppColors.primaryTeal.withValues(alpha: 0.38),
      inactiveThumbColor: isDark ? const Color(0xFF94A3B8) : Colors.white,
      inactiveTrackColor:
          isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
      trackOutlineColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return Colors.transparent;
        }
        return isDark ? const Color(0xFF475569) : const Color(0xFFCBD5E1);
      }),
    );
  }
}
