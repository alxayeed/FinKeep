import 'package:flutter/material.dart';
import 'package:finkeep/core/responsive/responsive.dart';

class OnboardingSlide extends StatelessWidget {
  final Widget illustration;
  final String title;
  final String subtitle;
  final Widget? extra;

  const OnboardingSlide({
    required this.illustration,
    required this.title,
    required this.subtitle,
    this.extra,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final titleColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final subtitleColor = isDark ? Colors.white70 : const Color(0xFF475569);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Illustration slot
          Expanded(
            child: Center(
              child: illustration,
            ),
          ),
          
          SizedBox(height: 24.h),

          // Title
          Text(
            title,
            style: TextStyle(
              fontFamily: 'Manrope',
              fontSize: 24.sp,
              fontWeight: FontWeight.w800,
              color: titleColor,
              letterSpacing: -0.5,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 12.h),

          // Subtitle
          Text(
            subtitle,
            style: TextStyle(
              fontFamily: 'Manrope',
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: subtitleColor,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),

          if (extra != null) ...[
            SizedBox(height: 24.h),
            extra!,
          ],
          
          // Padding to keep content away from indicators and buttons
          SizedBox(height: 140.h),
        ],
      ),
    );
  }
}
