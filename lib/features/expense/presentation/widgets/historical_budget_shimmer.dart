import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/responsive/responsive.dart';
import '../../../../core/styles/app_colors.dart';

class HistoricalBudgetShimmer extends StatelessWidget {
  const HistoricalBudgetShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color baseColor = isDark
        ? const Color(0xFF1E293B)
        : const Color(0xFFE2E8F0);
    final Color highlightColor = isDark
        ? const Color(0xFF334155)
        : const Color(0xFFF1F5F9);
    final Color itemBg = isDark ? AppColors.cardDark : AppColors.cardLight;

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: ListView.separated(
        padding: EdgeInsets.all(16.r),
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 10,
        separatorBuilder: (context, index) => SizedBox(height: 12.h),
        itemBuilder: (context, index) {
          return Container(
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              color: itemBg,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Row(
              children: [
                // Month & Expense Shimmer
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 100.w,
                        height: 12.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Container(
                        width: 80.w,
                        height: 8.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 12.w),
                // Budget Input Box Shimmer
                Expanded(
                  flex: 2,
                  child: Container(
                    height: 44.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
