import 'package:flutter/material.dart';
import '../../styles/app_colors.dart';
import '../../responsive/responsive.dart';

class CustomPermissionDialog extends StatelessWidget {
  final String title;
  final String description;
  final String actionText;
  final String cancelText;
  final IconData? icon;
  final VoidCallback onActionPressed;
  final VoidCallback? onCancelPressed;

  const CustomPermissionDialog({
    super.key,
    required this.title,
    required this.description,
    required this.actionText,
    required this.cancelText,
    this.icon,
    required this.onActionPressed,
    this.onCancelPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.cardDark : AppColors.cardLight;
    final textColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final subtitleColor = isDark ? Colors.white60 : const Color(0xFF64748B);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      backgroundColor: cardBg,
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Container(
                width: 60.w,
                height: 60.h,
                decoration: BoxDecoration(
                  color: AppColors.primaryTeal.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 28.sp,
                  color: AppColors.primaryTeal,
                ),
              ),
              SizedBox(height: 16.h),
            ],
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                fontFamily: 'Manrope',
                color: textColor,
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.sp,
                fontFamily: 'Manrope',
                color: subtitleColor,
                height: 1.5,
              ),
            ),
            SizedBox(height: 24.h),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: onCancelPressed ?? () => Navigator.of(context).pop(),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: Text(
                      cancelText,
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        fontWeight: FontWeight.w600,
                        fontSize: 13.sp,
                        color: subtitleColor,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onActionPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryTealDark,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: Text(
                      actionText,
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        fontWeight: FontWeight.w600,
                        fontSize: 13.sp,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
