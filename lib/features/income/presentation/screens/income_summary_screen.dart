import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:finkeep/core/config/app_config.dart';
import 'package:finkeep/core/responsive/responsive.dart';
import 'package:finkeep/core/styles/app_colors.dart';
import 'package:finkeep/core/extensions/double_ext.dart';
import 'package:finkeep/core/styles/currency_provider.dart';

import '../controllers/income_controller.dart';
import '../controllers/income_category_controller.dart';
import '../widgets/income_category_chart.dart';

class IncomeSummaryScreen extends StatelessWidget {
  final IncomeController controller;

  const IncomeSummaryScreen({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final IncomeCategoryController categoryController = Get.find();

    return Obx(() {
      final double totalIncomeVal = controller.totalIncome.value;
      final incomesList = controller.incomes;

      // Group totals dynamically
      final Map<String, double> categoryTotals = {};
      for (var inc in incomesList) {
        categoryTotals[inc.categoryId] = (categoryTotals[inc.categoryId] ?? 0.0) + inc.amount;
      }

      // Filter categories to show only those with transactions in this month OR those not deleted
      final relevantCategories = categoryController.categories.where((c) {
        final hasTransactions = categoryTotals.containsKey(c.id) && categoryTotals[c.id]! > 0;
        return !c.isDeleted || hasTransactions;
      }).toList();

      // Sort relevant categories by total amount descending
      relevantCategories.sort((a, b) {
        final totalA = categoryTotals[a.id] ?? 0.0;
        final totalB = categoryTotals[b.id] ?? 0.0;
        return totalB.compareTo(totalA);
      });

      return RefreshIndicator(
        onRefresh: () async {
          controller.shouldRefresh = true;
          await controller.fetchMonthlyIncomes();
        },
        color: AppColors.primaryTeal,
        notificationPredicate: (notification) =>
            AppConfig.useRemote &&
            defaultScrollNotificationPredicate(notification),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              // 1. Income Category Pie Chart
              IncomeCategoryChart(incomes: incomesList),
              SizedBox(height: 16.h),

              // 2. Breakdown Progress Bars Card
              Container(
                padding: EdgeInsets.all(18.r),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.cardDark : AppColors.cardLight,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 10.r,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'BREAKDOWN BY CATEGORY',
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontFamily: 'Manrope',
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white38 : const Color(0xFF94A3B8),
                        letterSpacing: 1.2,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    if (relevantCategories.isEmpty)
                      Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 20.h),
                          child: Text(
                            'No data available',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontFamily: 'Manrope',
                              color: isDark ? Colors.white38 : const Color(0xFF94A3B8),
                            ),
                          ),
                        ),
                      )
                    else
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: relevantCategories.length,
                        separatorBuilder: (context, index) => SizedBox(height: 14.h),
                        itemBuilder: (context, index) {
                          final cat = relevantCategories[index];
                          final amount = categoryTotals[cat.id] ?? 0.0;
                          final double percent = totalIncomeVal > 0 ? (amount / totalIncomeVal) : 0.0;
                          final percentText = '${(percent * 100).toStringAsFixed(0)}%';

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        cat.emoji,
                                        style: TextStyle(fontSize: 16.sp),
                                      ),
                                      SizedBox(width: 8.w),
                                      Text(
                                        cat.isDeleted ? '${cat.displayLabel} (Deleted)' : cat.displayLabel,
                                        style: TextStyle(
                                          fontSize: 13.sp,
                                          fontFamily: 'Manrope',
                                          fontWeight: FontWeight.bold,
                                          fontStyle: cat.isDeleted ? FontStyle.italic : FontStyle.normal,
                                          color: cat.isDeleted
                                              ? (isDark ? Colors.white38 : const Color(0xFF94A3B8))
                                              : (isDark ? Colors.white : const Color(0xFF334155)),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.baseline,
                                    textBaseline: TextBaseline.alphabetic,
                                    children: [
                                      Text(
                                        amount.toCurrency(),
                                        style: TextStyle(
                                          fontSize: 13.sp,
                                          fontFamily: 'Manrope',
                                          fontWeight: FontWeight.bold,
                                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                                        ),
                                      ),
                                      SizedBox(width: 2.w),
                                      Text(
                                        context.currency.symbol,
                                        style: TextStyle(
                                          fontSize: 10.sp,
                                          fontFamily: 'Manrope',
                                          fontWeight: FontWeight.bold,
                                          color: isDark ? Colors.white30 : const Color(0xFF94A3B8),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 6.h),
                              Row(
                                children: [
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(9999.r),
                                      child: SizedBox(
                                        height: 6.h,
                                        child: LinearProgressIndicator(
                                          value: percent,
                                          backgroundColor: isDark
                                              ? const Color(0xFF1E293B)
                                              : const Color(0xFFF1F5F9),
                                          valueColor: const AlwaysStoppedAnimation<Color>(
                                            AppColors.primaryTeal,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 12.w),
                                  Text(
                                    percentText,
                                    style: TextStyle(
                                      fontSize: 10.sp,
                                      fontFamily: 'Manrope',
                                      fontWeight: FontWeight.bold,
                                      color: isDark ? Colors.white30 : const Color(0xFF94A3B8),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      ),
                  ],
                ),
              ),
              SizedBox(height: 100.h),
            ],
          ),
        ),
      );
    });
  }
}
