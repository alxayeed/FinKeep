import 'package:flutter/material.dart';
import '../../responsive/responsive.dart';

import '../../styles/app_colors.dart';

class CustomFAB extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;

  const CustomFAB({
    super.key,
    required this.onPressed,
    this.icon = Icons.add,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: AppColors.primaryTeal,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      elevation: 6,
      onPressed: onPressed,
      child: Icon(icon, size: 28.sp),
    );
  }
}
