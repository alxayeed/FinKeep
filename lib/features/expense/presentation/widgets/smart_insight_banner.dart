import 'package:flutter/material.dart';
import '../../../../core/responsive/responsive.dart';
import '../../../../core/styles/app_colors.dart';
import '../../../../core/utils/app_localizations.dart';

class SmartInsightBanner extends StatelessWidget {
  final String? customText;

  const SmartInsightBanner({
    super.key,
    this.customText,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    final Color bannerBg = isDark ? const Color(0xFF022C22) : const Color(0xFFECFDF5);
    final Color borderBg = isDark ? const Color(0xFF047857) : const Color(0xFFD1FAE5);
    final Color titleColor = isDark ? const Color(0xFFA7F3D0) : const Color(0xFF064E3B);
    final Color textColor = isDark ? const Color(0xFF6EE7B7) : const Color(0xFF065F46);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Container(
        padding: EdgeInsets.all(14.r),
        decoration: BoxDecoration(
          color: bannerBg,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: borderBg,
            width: 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Lightbulb Icon wrapper
            Container(
              padding: EdgeInsets.all(6.r),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF064E3B) : Colors.white,
                borderRadius: BorderRadius.circular(8.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 4.r,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                Icons.lightbulb_outline_rounded,
                color: AppColors.success,
                size: 18.sp,
              ),
            ),
            SizedBox(width: 12.w),
            // Text area
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.translate('smart_insight'),
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.bold,
                      color: titleColor,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    customText ?? AppLocalizations.translate('insight_text'),
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.w600,
                      height: 1.4.h,
                      color: textColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
