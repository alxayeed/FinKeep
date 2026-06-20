import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/responsive/responsive.dart';
import '../../../../core/styles/app_colors.dart';
import 'payment_medium_chart.dart';


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
          height: 102.h,
          margin: EdgeInsets.symmetric(vertical: 8.h),
          decoration: BoxDecoration(
            color: itemBg,
            borderRadius: BorderRadius.circular(16.r),
          ),
          padding: EdgeInsets.all(16.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 80.w,
                          height: 10.h,
                          color: Colors.white,
                        ),
                        SizedBox(height: 4.h),
                        Container(
                          width: 110.w,
                          height: 16.h,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                  Container(width: 1.w, height: 28.h, color: Colors.white24),
                  SizedBox(width: 12.w),
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 60.w,
                          height: 10.h,
                          color: Colors.white,
                        ),
                        SizedBox(height: 4.h),
                        Container(
                          width: 50.w,
                          height: 16.h,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                  Container(width: 1.w, height: 28.h, color: Colors.white24),
                  SizedBox(width: 12.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(width: 30.w, height: 10.h, color: Colors.white),
                      SizedBox(height: 4.h),
                      Container(width: 24.w, height: 14.h, color: Colors.white),
                    ],
                  ),
                ],
              ),
              const Spacer(),
              // Mimic slider progress indicator
              Container(
                width: double.infinity,
                height: 8.h,
                color: Colors.white,
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        const PaymentMediumChartShimmer(),
        SizedBox(height: 16.h),
        Container(
          padding: EdgeInsets.all(18.r),
          decoration: BoxDecoration(
            color: itemBg,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(width: 120.w, height: 10.h, color: Colors.white),
                    Container(width: 70.w, height: 9.h, color: Colors.white),
                  ],
                ),
              ),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 4,
                separatorBuilder: (context, index) => SizedBox(height: 6.h),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 4.h),
                    child: Row(
                      children: [
                        Container(
                          width: 28.r,
                          height: 28.r,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: 60.w,
                                    height: 10.h,
                                    color: Colors.white,
                                  ),
                                  Container(
                                    width: 70.w,
                                    height: 10.h,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                              SizedBox(height: 4.h),
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      height: 4.h,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(width: 8.w),
                                  Container(
                                    width: 20.w,
                                    height: 8.h,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
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
