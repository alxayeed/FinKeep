import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../../../../core/common/widgets/privacy_text.dart';
import '../../../../core/responsive/responsive.dart';
import '../../../../core/styles/app_colors.dart';
import '../../../../core/styles/currency_provider.dart';
import '../../domain/entities/expense_entity.dart';

/// Context-aware card displaying period-specific metrics
/// when an arbitrary or custom date range is active in reports.
class PeriodSummaryCard extends StatelessWidget {
  final List<ExpenseEntity> expenses;
  final DateTime startDate;
  final DateTime endDate;

  const PeriodSummaryCard({
    super.key,
    required this.expenses,
    required this.startDate,
    required this.endDate,
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

    final double totalSpending = expenses.fold(0.0, (sum, e) => sum + e.amount);
    final int days = (endDate.difference(startDate).inDays + 1).clamp(1, 36500);
    final double dailyAvg = days > 0 ? totalSpending / days : 0.0;
    final int txCount = expenses.length;
    final double maxExpense = expenses.isNotEmpty
        ? expenses.map((e) => e.amount).reduce((a, b) => a > b ? a : b)
        : 0.0;

    final String dateRangeStr =
        '${DateFormat('dd MMM').format(startDate)} - ${DateFormat('dd MMM yyyy').format(endDate)}';

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
                    Icon(
                      Icons.date_range_rounded,
                      size: 15.sp,
                      color: AppColors.primaryTeal,
                    ),
                    SizedBox(width: 6.w),
                    Expanded(
                      child: Text(
                        dateRangeStr,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'Manrope',
                          fontSize: 12.5.sp,
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
                  color: isDark
                      ? const Color(0xFF1E293B)
                      : const Color(0xFFEEF2F6),
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Text(
                  '$days ${days == 1 ? "day" : "days"}',
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 10.5.sp,
                    fontWeight: FontWeight.bold,
                    color: mutedCol,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),

          // Main Metric: Total Spent
          Text(
            'TOTAL PERIOD SPENDING',
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
                totalSpending,
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
                // 1. Daily Average
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Daily Average',
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
                            dailyAvg,
                            style: TextStyle(
                              fontFamily: 'Manrope',
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryTeal,
                            ),
                          ),
                          SizedBox(width: 2.w),
                          FaIcon(
                            context.currency.icon,
                            size: 8.sp,
                            color: AppColors.primaryTeal,
                          ),
                        ],
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
                // 3. Peak Expense
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Highest Txn',
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
                            maxExpense,
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
