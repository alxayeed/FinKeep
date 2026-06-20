import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:finkeep/core/enums/payment_type.dart';
import 'package:finkeep/core/extensions/double_ext.dart';
import 'package:finkeep/core/responsive/responsive.dart';
import 'package:finkeep/core/styles/app_colors.dart';

import '../../domain/entities/expense_entity.dart';

class PaymentMediumChart extends StatelessWidget {
  final List<ExpenseEntity> expenses;

  const PaymentMediumChart({super.key, required this.expenses});

  Color _getColorForMedium(PaymentType type) {
    switch (type) {
      case PaymentType.cash:
        return const Color(0xFF059669);
      case PaymentType.mfs:
        return Colors.orange.shade600;
      case PaymentType.card:
        return Colors.blue.shade600;
      case PaymentType.transfer:
        return Colors.indigo.shade600;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Aggregate spending by payment type
    final Map<PaymentType, double> mediumTotals = {
      PaymentType.cash: 0.0,
      PaymentType.mfs: 0.0,
      PaymentType.card: 0.0,
      PaymentType.transfer: 0.0,
    };

    double totalSpent = 0.0;
    for (var expense in expenses) {
      mediumTotals[expense.paymentMethod] =
          (mediumTotals[expense.paymentMethod] ?? 0.0) + expense.amount;
      totalSpent += expense.amount;
    }

    return Container(
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
            'SPENDING BY TRANSACTION MEDIUM',
            style: TextStyle(
              fontSize: 10.sp,
              fontFamily: 'Manrope',
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white38 : const Color(0xFF94A3B8),
              letterSpacing: 1.2,
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              // Pie Chart with Total Amount in Center
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 120.w,
                    height: 120.w,
                    child: PieChart(
                      PieChartData(
                        sectionsSpace: 2,
                        centerSpaceRadius: 40.r,
                        sections: totalSpent == 0.0
                            ? [
                                PieChartSectionData(
                                  color: isDark
                                      ? const Color(0xFF334155)
                                      : const Color(0xFFE2E8F0),
                                  value: 1.0,
                                  title: '',
                                  radius: 16.r,
                                ),
                              ]
                            : PaymentType.values.map((type) {
                                final value = mediumTotals[type] ?? 0.0;
                                final percentage = (value / totalSpent) * 100;

                                return PieChartSectionData(
                                  color: _getColorForMedium(type),
                                  value: value,
                                  title: value > 0
                                      ? '${percentage.toStringAsFixed(0)}%'
                                      : '',
                                  radius: 16.r,
                                  titleStyle: TextStyle(
                                    fontSize: 9.sp,
                                    fontFamily: 'Manrope',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                );
                              }).toList(),
                      ),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        totalSpent.toCurrency(),
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontFamily: 'Manrope',
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? Colors.white
                              : const Color(0xFF0F172A),
                        ),
                      ),
                      Text(
                        'Spent (৳)',
                        style: TextStyle(
                          fontSize: 8.sp,
                          fontFamily: 'Manrope',
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? Colors.white30
                              : const Color(0xFF94A3B8),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(width: 20.w),

              // Legend
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: PaymentType.values.map((type) {
                    final value = mediumTotals[type] ?? 0.0;
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 4.h),
                      child: Row(
                        children: [
                          Container(
                            width: 8.r,
                            height: 8.r,
                            decoration: BoxDecoration(
                              color: _getColorForMedium(type),
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: Text(
                              type.displayName,
                              style: TextStyle(
                                fontSize: 11.sp,
                                fontFamily: 'Manrope',
                                fontWeight: FontWeight.w500,
                                color: isDark
                                    ? Colors.white70
                                    : const Color(0xFF334155),
                              ),
                            ),
                          ),
                          Text(
                            '${value.toCurrency()} ৳',
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontFamily: 'Manrope',
                              fontWeight: FontWeight.bold,
                              color: isDark
                                  ? Colors.white54
                                  : const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class PaymentMediumChartShimmer extends StatelessWidget {
  const PaymentMediumChartShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final itemBg = isDark ? AppColors.cardDark : AppColors.cardLight;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.h),
      padding: EdgeInsets.symmetric(vertical: 18.h),
      decoration: BoxDecoration(
        color: itemBg,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(width: 120.w, height: 10.h, color: Colors.white),
          SizedBox(height: 16.h),
          Row(
            children: [
              Container(
                width: 120.w,
                height: 120.w,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 20.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(4, (index) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 6.h),
                      child: Row(
                        children: [
                          Container(
                            width: 8.r,
                            height: 8.r,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Container(
                            width: 50.w,
                            height: 10.h,
                            color: Colors.white,
                          ),
                          const Spacer(),
                          Container(
                            width: 40.w,
                            height: 10.h,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
