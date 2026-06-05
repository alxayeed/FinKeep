import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/responsive/responsive.dart';
import '../../../../core/styles/app_colors.dart';

class InvestmentSummaryShimmer extends StatelessWidget {
  const InvestmentSummaryShimmer({super.key});

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
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        children: [
          // 1. Status Distribution Chart Skeleton
          Container(
            height: 180.h,
            padding: EdgeInsets.all(18.r),
            decoration: BoxDecoration(
              color: itemBg,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Row(
              children: [
                Container(
                  width: 130.w,
                  height: 130.w,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 24.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(4, (_) => Padding(
                      padding: EdgeInsets.symmetric(vertical: 6.h),
                      child: Row(
                        children: [
                          Container(width: 10.r, height: 10.r, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle)),
                          SizedBox(width: 8.w),
                          Container(width: 60.w, height: 10.h, color: Colors.white),
                        ],
                      ),
                    )),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.h),

          // 2. Overall Summary Card Skeleton
          Container(
            height: 140.h,
            padding: EdgeInsets.all(20.r),
            decoration: BoxDecoration(
              color: itemBg,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(width: 80.w, height: 8.h, color: Colors.white),
                        SizedBox(height: 8.h),
                        Container(width: 100.w, height: 16.h, color: Colors.white),
                      ],
                    )),
                    Expanded(child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(width: 80.w, height: 8.h, color: Colors.white),
                        SizedBox(height: 8.h),
                        Container(width: 100.w, height: 16.h, color: Colors.white),
                      ],
                    )),
                  ],
                ),
                const Spacer(),
                Row(
                  children: [
                    Expanded(child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(width: 60.w, height: 8.h, color: Colors.white),
                        SizedBox(height: 6.h),
                        Container(width: 80.w, height: 12.h, color: Colors.white),
                      ],
                    )),
                    Expanded(child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(width: 60.w, height: 8.h, color: Colors.white),
                        SizedBox(height: 6.h),
                        Container(width: 80.w, height: 12.h, color: Colors.white),
                      ],
                    )),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 20.h),

          // 3. Active Summary Card Skeleton
          Container(
            height: 180.h,
            padding: EdgeInsets.all(20.r),
            decoration: BoxDecoration(
              color: itemBg,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(width: 80.w, height: 8.h, color: Colors.white),
                        SizedBox(height: 8.h),
                        Container(width: 100.w, height: 14.h, color: Colors.white),
                      ],
                    )),
                    Expanded(child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(width: 80.w, height: 8.h, color: Colors.white),
                        SizedBox(height: 8.h),
                        Container(width: 100.w, height: 14.h, color: Colors.white),
                      ],
                    )),
                  ],
                ),
                const Spacer(),
                Row(
                  children: [
                    Expanded(child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(width: 80.w, height: 8.h, color: Colors.white),
                        SizedBox(height: 8.h),
                        Container(width: 100.w, height: 14.h, color: Colors.white),
                      ],
                    )),
                    Expanded(child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(width: 80.w, height: 8.h, color: Colors.white),
                        SizedBox(height: 8.h),
                        Container(width: 100.w, height: 14.h, color: Colors.white),
                      ],
                    )),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
