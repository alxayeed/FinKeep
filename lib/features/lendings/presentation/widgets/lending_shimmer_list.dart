import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:spendly/core/responsive/responsive.dart';
import 'package:spendly/core/styles/app_colors.dart';

class LendingShimmerList extends StatelessWidget {
  const LendingShimmerList({super.key});

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
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(vertical: 8.h),
        itemCount: 5,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 5.h),
            child: Container(
              height: 74.h,
              decoration: BoxDecoration(
                color: itemBg,
                borderRadius: BorderRadius.circular(18.r),
              ),
              padding: EdgeInsets.all(14.r),
              child: Row(
                children: [
                  // Avatar Skeleton
                  Container(
                    width: 46.r,
                    height: 46.r,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                  ),
                  SizedBox(width: 14.w),

                  // Title and Subtitle Skeletons
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 120.w,
                          height: 12.h,
                          color: Colors.white,
                        ),
                        SizedBox(height: 6.h),
                        Container(
                          width: 70.w,
                          height: 8.h,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),

                  // Status and Amount Skeletons on Right
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 50.w,
                        height: 14.h,
                        color: Colors.white,
                      ),
                      SizedBox(height: 6.h),
                      Container(
                        width: 40.w,
                        height: 10.h,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
