import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/responsive/responsive.dart';
import '../../../../core/styles/app_colors.dart';

class MonthlyExpenseShimmer extends StatelessWidget {
  final int selectedTab;

  const MonthlyExpenseShimmer({super.key, required this.selectedTab});

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
      child: selectedTab == 0
          ? _buildSummaryShimmer(itemBg)
          : _buildDetailsShimmer(itemBg),
    );
  }

  Widget _buildSummaryShimmer(Color itemBg) {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      children: [
        // 1. BudgetProgressCard Skeleton
        Container(
          height: 180.h,
          decoration: BoxDecoration(
            color: itemBg,
            borderRadius: BorderRadius.circular(24.r),
          ),
          padding: EdgeInsets.all(16.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(width: 80.w, height: 12.h, color: Colors.white),
              SizedBox(height: 12.h),
              Container(width: 140.w, height: 24.h, color: Colors.white),
              const Spacer(),
              // Mimic slider progress indicator
              Container(
                width: double.infinity,
                height: 8.h,
                color: Colors.white,
              ),
              SizedBox(height: 12.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(width: 70.w, height: 10.h, color: Colors.white),
                  Container(width: 50.w, height: 10.h, color: Colors.white),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),

        // 2. SmartInsightBanner Skeleton
        Container(
          height: 68.h,
          decoration: BoxDecoration(
            color: itemBg,
            borderRadius: BorderRadius.circular(16.r),
          ),
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
          child: Row(
            children: [
              Container(width: 32.r, height: 32.r, color: Colors.white),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(width: 100.w, height: 10.h, color: Colors.white),
                    SizedBox(height: 6.h),
                    Container(
                      width: double.infinity,
                      height: 8.h,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 20.h),

        // 3. CategorySpendingList Checklist Skeletons
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(width: 120.w, height: 16.h, color: Colors.white),
            Container(width: 60.w, height: 12.h, color: Colors.white),
          ],
        ),
        SizedBox(height: 12.h),
        ...List.generate(4, (index) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: Container(
              height: 68.h,
              decoration: BoxDecoration(
                color: itemBg,
                borderRadius: BorderRadius.circular(16.r),
              ),
              padding: EdgeInsets.all(12.r),
              child: Row(
                children: [
                  Container(width: 36.r, height: 36.r, color: Colors.white),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 80.w,
                              height: 12.h,
                              color: Colors.white,
                            ),
                            Container(
                              width: 50.w,
                              height: 12.h,
                              color: Colors.white,
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        Container(
                          width: double.infinity,
                          height: 6.h,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildDetailsShimmer(Color itemBg) {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(vertical: 8.h),
      children: [
        ...List.generate(2, (dayIndex) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Daily Header Skeleton
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(width: 110.w, height: 10.h, color: Colors.white),
                    Container(width: 50.w, height: 10.h, color: Colors.white),
                  ],
                ),
              ),

              // Transaction Item Card Skeletons
              ...List.generate(dayIndex == 0 ? 6 : 4, (cardIndex) {
                return Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 4.h,
                  ),
                  child: Container(
                    height: 64.h,
                    decoration: BoxDecoration(
                      color: itemBg,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    padding: EdgeInsets.all(12.r),
                    child: Row(
                      children: [
                        Container(
                          width: 40.r,
                          height: 40.r,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        SizedBox(width: 14.w),
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
                        Container(
                          width: 50.w,
                          height: 14.h,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                );
              }),
              SizedBox(height: 8.h),
            ],
          );
        }),
      ],
    );
  }
}
