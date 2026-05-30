import 'package:flutter/material.dart';
import '../../../../core/responsive/responsive.dart';
import '../../../../core/utils/app_localizations.dart';

class SegmentedTabBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabChanged;

  const SegmentedTabBar({
    super.key,
    required this.selectedIndex,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Container(
        height: 38.h,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFEEF0F2),
          borderRadius: BorderRadius.circular(12.r),
        ),
        padding: EdgeInsets.all(3.r),
        child: Stack(
          children: [
            // Animated background slider
            AnimatedAlign(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              alignment: selectedIndex == 0 ? Alignment.centerLeft : Alignment.centerRight,
              child: FractionallySizedBox(
                widthFactor: 0.5,
                child: Container(
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF334155) : Colors.white,
                    borderRadius: BorderRadius.circular(9.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 4.r,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Two tabs overlay
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => onTabChanged(0),
                    behavior: HitTestBehavior.opaque,
                    child: Center(
                      child: Text(
                        AppLocalizations.translate('summary'),
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontFamily: 'Manrope',
                          fontWeight: selectedIndex == 0 ? FontWeight.bold : FontWeight.w600,
                          color: selectedIndex == 0
                              ? (isDark ? Colors.white : const Color(0xFF0F172A))
                              : (isDark ? Colors.white38 : const Color(0xFF64748B)),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => onTabChanged(1),
                    behavior: HitTestBehavior.opaque,
                    child: Center(
                      child: Text(
                        AppLocalizations.translate('details'),
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontFamily: 'Manrope',
                          fontWeight: selectedIndex == 1 ? FontWeight.bold : FontWeight.w600,
                          color: selectedIndex == 1
                              ? (isDark ? Colors.white : const Color(0xFF0F172A))
                              : (isDark ? Colors.white38 : const Color(0xFF64748B)),
                        ),
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
