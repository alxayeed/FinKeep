import 'package:flutter/material.dart';

import '../responsive/responsive.dart';

class AppTextStyles {
  AppTextStyles._();

  /// Central Section/List headers styling
  static TextStyle sectionHeader(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return TextStyle(
      fontSize: 16.sp,
      fontFamily: 'Manrope',
      fontWeight: FontWeight.bold,
      color: isDark ? Colors.white : const Color(0xFF0F172A),
      letterSpacing: 0.1,
    );
  }

  /// Central List Card Title / Label styling
  static TextStyle cardTitle(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return TextStyle(
      fontSize: 16.sp,
      fontFamily: 'Manrope',
      fontWeight: FontWeight.bold,
      color: isDark ? Colors.white : const Color(0xFF0F172A),
    );
  }

  /// Central List Card Subtitle / Time / Date / Details styling
  static TextStyle cardSubtitle(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return TextStyle(
      fontSize: 13.sp,
      fontFamily: 'Manrope',
      fontWeight: FontWeight.w600,
      color: isDark ? Colors.white38 : const Color(0xFF94A3B8),
    );
  }

  /// Central List Card Amount styling
  static TextStyle cardAmount(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return TextStyle(
      fontSize: 16.sp,
      fontFamily: 'Manrope',
      fontWeight: FontWeight.bold,
      color: isDark ? Colors.white : const Color(0xFF0F172A),
    );
  }
}
