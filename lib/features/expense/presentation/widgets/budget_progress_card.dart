import 'package:flutter/material.dart';
import '../../../../core/responsive/responsive.dart';
import '../../../../core/styles/app_colors.dart';
import '../../../../core/utils/app_localizations.dart';
import 'package:spendly/core/extensions/double_ext.dart';

class BudgetProgressCard extends StatelessWidget {
  final double spent;
  final double budget;

  const BudgetProgressCard({
    super.key,
    required this.spent,
    required this.budget,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final remaining = (budget - spent).clamp(0.0, double.infinity);
    final usagePercent = budget > 0 ? (spent / budget).clamp(0.0, 1.0) : 0.0;
    final usageText = '${(usagePercent * 100).toStringAsFixed(0)}%';

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      padding: EdgeInsets.all(16.r),
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
          // Row containing columns
          Row(
            children: [
              // Col 1: Spent vs Budget
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.translate('spent_vs_budget').toUpperCase(),
                      style: TextStyle(
                        fontSize: 9.sp,
                        fontFamily: 'Manrope',
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white38 : const Color(0xFF64748B),
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          '${spent.toCurrency()} ৳',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontFamily: 'Manrope',
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : const Color(0xFF0F172A),
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          '${AppLocalizations.translate('of')} ${budget.toCurrency()} ৳',
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontFamily: 'Manrope',
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white30 : const Color(0xFF94A3B8),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Divider
              Container(
                width: 1.w,
                height: 32.h,
                color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
              ),
              SizedBox(width: 12.w),

              // Col 2: Remaining
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.translate('remaining').toUpperCase(),
                      style: TextStyle(
                        fontSize: 9.sp,
                        fontFamily: 'Manrope',
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white38 : const Color(0xFF64748B),
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          '${remaining.toCurrency()} ৳',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontFamily: 'Manrope',
                            fontWeight: FontWeight.bold,
                            color: AppColors.success,
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          AppLocalizations.translate('left'),
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontFamily: 'Manrope',
                            fontWeight: FontWeight.bold,
                            color: AppColors.success.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Divider
              Container(
                width: 1.w,
                height: 32.h,
                color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
              ),
              SizedBox(width: 12.w),

              // Col 3: Usage
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    AppLocalizations.translate('usage').toUpperCase(),
                    style: TextStyle(
                      fontSize: 9.sp,
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white38 : const Color(0xFF64748B),
                      letterSpacing: 0.5,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    usageText,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          SizedBox(height: 16.h),

          // Linear progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(9999.r),
            child: SizedBox(
              height: 8.h,
              width: double.infinity,
              child: LinearProgressIndicator(
                value: usagePercent,
                backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.success),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
