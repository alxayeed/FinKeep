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
    return Switch(
      value: value,
      onChanged: onChanged,
      activeThumbColor: AppColors.primaryTeal,
      activeTrackColor: AppColors.primaryTeal.withValues(alpha: 0.3),
    );
  }
}
