import 'package:flutter/material.dart';
import 'package:finkeep/core/responsive/responsive.dart';
import 'package:finkeep/core/styles/app_colors.dart';

import '../../domain/entities/investment.dart';
import 'package:finkeep/core/styles/currency_provider.dart';
import '../../domain/enums/investment_status.dart';

class ROIDetailsCard extends StatelessWidget {
  final Investment investment;

  const ROIDetailsCard({super.key, required this.investment});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color textColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final Color labelColor = isDark ? Colors.white60 : const Color(0xFF64748B);
    final Color cardBg = isDark ? AppColors.cardDark : Colors.white;

    final totalReturns = investment.returns.fold<double>(
      0,
      (sum, r) => sum + r.amountReceived,
    );

    final profitLoss = totalReturns - investment.amountInvested;

    // Determine label and color based on status
    String label;
    Color statusColor;
    if (investment.status == InvestmentStatus.loss) {
      label = 'Loss';
      statusColor = AppColors.error;
    } else if (profitLoss > 0) {
      label = 'Profit';
      statusColor = AppColors.success;
    } else {
      label = 'Remaining';
      statusColor = AppColors.warning;
    }

    // Progress as fraction of invested amount
    final progress = (totalReturns / investment.amountInvested).clamp(0.0, 1.0);

    return Card(
      elevation: 0,
      color: cardBg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
        side: BorderSide(
          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Stack(
            children: [
              // Background progress
              Positioned.fill(
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: progress,
                  child: Container(
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                ),
              ),
              // Foreground content
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Amounts row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _amountColumn(
                        context,
                        label: 'Invested',
                        amount: investment.amountInvested,
                        textColor: textColor,
                        labelColor: labelColor,
                      ),
                      _amountColumn(
                        context,
                        label: 'Returned',
                        amount: totalReturns,
                        textColor: textColor,
                        labelColor: labelColor,
                      ),
                      _amountColumn(
                        context,
                        label: label,
                        amount: profitLoss.abs(),
                        amountColor: statusColor,
                        textColor: textColor,
                        labelColor: labelColor,
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  // Profit rate & expected ROI
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _stringColumn(
                        label: 'Profit Rate',
                        value: investment.profitRate.toString(),
                        textColor: textColor,
                        labelColor: labelColor,
                      ),
                      _amountColumn(
                        context,
                        label: 'Expected ROI',
                        amount: investment.expectedROI,
                        isPercentage: true,
                        textColor: textColor,
                        labelColor: labelColor,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _amountColumn(
    BuildContext context, {
    required String label,
    required double amount,
    Color? amountColor,
    bool isPercentage = false,
    required Color textColor,
    required Color labelColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 10.sp,
            fontFamily: 'Manrope',
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
            color: labelColor,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          isPercentage
              ? '${amount.toStringAsFixed(0)}%'
              : '${context.currency.symbol}${amount.toStringAsFixed(0)}',
          style: TextStyle(
            fontSize: 15.sp,
            fontFamily: 'Manrope',
            fontWeight: FontWeight.bold,
            color: amountColor ?? textColor,
          ),
        ),
      ],
    );
  }

  Widget _stringColumn({
    required String label,
    required String value,
    required Color textColor,
    required Color labelColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 10.sp,
            fontFamily: 'Manrope',
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
            color: labelColor,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          value,
          style: TextStyle(
            fontSize: 15.sp,
            fontFamily: 'Manrope',
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ],
    );
  }
}

