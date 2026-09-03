import 'package:flutter/material.dart';
import '../../../../core/responsive/responsive.dart';
import '../../../../core/utils/app_localizations.dart';

class SegmentedTabBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabChanged;
  final List<String>? tabs;

  const SegmentedTabBar({
    super.key,
    required this.selectedIndex,
    required this.onTabChanged,
    this.tabs,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tabLabels = tabs ??
        [
          AppLocalizations.translate('summary'),
          AppLocalizations.translate('details'),
        ];
    final count = tabLabels.length;
    final alignmentX = count > 1
        ? -1.0 + (2.0 / (count - 1)) * selectedIndex
        : 0.0;

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
              alignment: Alignment(alignmentX, 0.0),
              child: FractionallySizedBox(
                widthFactor: 1.0 / count,
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
            // Tabs overlay
            Row(
              children: [
                for (int i = 0; i < count; i++)
                  Expanded(
                    child: GestureDetector(
                      onTap: () => onTabChanged(i),
                      behavior: HitTestBehavior.opaque,
                      child: Center(
                        child: Text(
                          tabLabels[i],
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: count > 2 ? 11.5.sp : 13.sp,
                            fontFamily: 'Manrope',
                            fontWeight: selectedIndex == i
                                ? FontWeight.bold
                                : FontWeight.w600,
                            color: selectedIndex == i
                                ? (isDark
                                    ? Colors.white
                                    : const Color(0xFF0F172A))
                                : (isDark
                                    ? Colors.white38
                                    : const Color(0xFF64748B)),
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
