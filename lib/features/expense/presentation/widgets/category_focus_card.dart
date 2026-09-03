import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../../core/common/widgets/privacy_text.dart';
import '../../../../core/responsive/responsive.dart';
import '../../../../core/styles/app_colors.dart';
import '../../../../core/styles/currency_provider.dart';
import '../../domain/entities/expense_entity.dart';
import '../controllers/expense_category_controller.dart';

/// Context-aware card displaying category-specific focus metrics
/// when specific categories are selected in the filter.
class CategoryFocusCard extends StatelessWidget {
  final List<ExpenseEntity> categoryExpenses;
  final double totalPeriodSpending;
  final List<String> selectedCategories;

  const CategoryFocusCard({
    super.key,
    required this.categoryExpenses,
    required this.totalPeriodSpending,
    required this.selectedCategories,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textCol = isDark ? Colors.white : const Color(0xFF0F172A);
    final mutedCol = isDark ? Colors.white60 : const Color(0xFF64748B);
    final cardBorder =
        isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
    final subCardBg =
        isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC);

    final double categoryTotal =
        categoryExpenses.fold(0.0, (sum, e) => sum + e.amount);
    final double percentage = totalPeriodSpending > 0
        ? (categoryTotal / totalPeriodSpending) * 100
        : 0.0;
    final int txCount = categoryExpenses.length;
    final double avgTxn = txCount > 0 ? categoryTotal / txCount : 0.0;

    String categoryTitle = 'Category Spending';
    String emoji = '🏷️';

    if (selectedCategories.length == 1) {
      final catName = selectedCategories.first;
      categoryTitle = catName;
      if (Get.isRegistered<ExpenseCategoryController>()) {
        final cat =
            Get.find<ExpenseCategoryController>().resolveCategory(catName);
        emoji = cat.emoji.isNotEmpty ? cat.emoji : '🏷️';
      }
    } else if (selectedCategories.length > 1) {
      categoryTitle = '${selectedCategories.length} Categories Selected';
      emoji = '📁';
    }

    return Container(
      padding: EdgeInsets.all(18.r),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: cardBorder),
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
          // Header Badge
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Text(
                      emoji,
                      style: TextStyle(fontSize: 14.sp),
                    ),
                    SizedBox(width: 6.w),
                    Expanded(
                      child: Text(
                        categoryTitle,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'Manrope',
                          fontSize: 13.sp,
                          fontWeight: FontWeight.bold,
                          color: textCol,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: AppColors.primaryTeal.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Text(
                  'Category Focus',
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 10.5.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryTeal,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),

          // Main Metric: Total Spent
          Text(
            'TOTAL CATEGORY SPENDING',
            style: TextStyle(
              fontFamily: 'Manrope',
              fontSize: 10.sp,
              fontWeight: FontWeight.bold,
              color: mutedCol,
              letterSpacing: 0.5,
            ),
          ),
          SizedBox(height: 4.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              PrivacyText(
                categoryTotal,
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w800,
                  color: textCol,
                ),
              ),
              SizedBox(width: 4.w),
              FaIcon(
                context.currency.icon,
                size: 14.sp,
                color: textCol,
              ),
            ],
          ),
          SizedBox(height: 14.h),

          // 3-Column Sub-Metrics Grid
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: subCardBg,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: cardBorder.withValues(alpha: 0.7)),
            ),
            child: Row(
              children: [
                // 1. Share of Period
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Share of Period',
                        style: TextStyle(
                          fontFamily: 'Manrope',
                          fontSize: 10.sp,
                          color: mutedCol,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        '${percentage.toStringAsFixed(1)}%',
                        style: TextStyle(
                          fontFamily: 'Manrope',
                          fontSize: 13.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryTeal,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 26.h,
                  width: 1,
                  color: cardBorder,
                ),
                SizedBox(width: 10.w),
                // 2. Transactions
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Transactions',
                        style: TextStyle(
                          fontFamily: 'Manrope',
                          fontSize: 10.sp,
                          color: mutedCol,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        '$txCount txns',
                        style: TextStyle(
                          fontFamily: 'Manrope',
                          fontSize: 13.sp,
                          fontWeight: FontWeight.bold,
                          color: textCol,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 26.h,
                  width: 1,
                  color: cardBorder,
                ),
                SizedBox(width: 10.w),
                // 3. Avg / Txn
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Avg / Txn',
                        style: TextStyle(
                          fontFamily: 'Manrope',
                          fontSize: 10.sp,
                          color: mutedCol,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          PrivacyText(
                            avgTxn,
                            style: TextStyle(
                              fontFamily: 'Manrope',
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                              color: textCol,
                            ),
                          ),
                          SizedBox(width: 2.w),
                          FaIcon(
                            context.currency.icon,
                            size: 8.sp,
                            color: textCol,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
