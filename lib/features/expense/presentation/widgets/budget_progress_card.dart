import 'package:flutter/material.dart';
import 'package:spendly/core/extensions/double_ext.dart';

import '../../../../core/responsive/responsive.dart';
import '../../../../core/styles/app_colors.dart';
import '../../../../core/utils/app_localizations.dart';

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
    final isOverspent = spent > budget;
    final remainingVal = budget - spent;
    final usagePercent = budget > 0 ? (spent / budget) : 0.0;
    final usageText = '${(usagePercent * 100).toStringAsFixed(0)}%';

    return Container(
      // margin: EdgeInsets.symmetric(vertical: 10.h),
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: isOverspent
            ? (isDark ? const Color(0x1AFF4444) : const Color(0xFFFEF2F2))
            : (isDark ? AppColors.cardDark : AppColors.cardLight),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isOverspent
              ? (isDark ? const Color(0xFF991B1B) : const Color(0xFFFCA5A5))
              : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
          width: isOverspent ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isOverspent
                ? Colors.red.withOpacity(0.04)
                : Colors.black.withOpacity(0.03),
            blurRadius: 10.r,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double cardWidth = constraints.maxWidth;
          final String spentText = spent.toCurrency();
          final String budgetText = budget.toCurrency();
          final String remainingText = remainingVal.abs().toCurrency();

          // Decide adaptively whether to use the column layout
          final bool useVerticalLayout =
              cardWidth < 300.w ||
              (spentText.length + budgetText.length + remainingText.length >
                  20);

          Widget infoLayout;

          if (useVerticalLayout) {
            infoLayout = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Row 1: Spent vs Budget
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.translate(
                        'spent_vs_budget',
                      ).toUpperCase(),
                      style: const TextStyle(
                        fontSize: 10,
                        fontFamily: 'Manrope',
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                        letterSpacing: 0.5,
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          spentText,
                          style: TextStyle(
                            fontSize: 15,
                            fontFamily: 'Manrope',
                            fontWeight: FontWeight.bold,
                            color: isDark
                                ? Colors.white
                                : const Color(0xFF0F172A),
                          ),
                        ),
                        Text(
                          '/$budgetText ৳',
                          style: TextStyle(
                            fontSize: 10,
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
                Divider(
                  height: 16.h,
                  color: isDark
                      ? const Color(0xFF334155)
                      : const Color(0xFFF1F5F9),
                  thickness: 1,
                ),
                // Row 2: Remaining / Overspent
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isOverspent
                          ? 'OVERSPENT'
                          : AppLocalizations.translate(
                              'remaining',
                            ).toUpperCase(),
                      style: TextStyle(
                        fontSize: 10,
                        fontFamily: 'Manrope',
                        fontWeight: FontWeight.bold,
                        color: isOverspent ? AppColors.error : Colors.grey,
                        letterSpacing: 0.5,
                      ),
                    ),
                    Text(
                      '$remainingText ৳',
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'Manrope',
                        fontWeight: FontWeight.bold,
                        color: isOverspent
                            ? AppColors.error
                            : AppColors.success,
                      ),
                    ),
                  ],
                ),
                Divider(
                  height: 16.h,
                  color: isDark
                      ? const Color(0xFF334155)
                      : const Color(0xFFF1F5F9),
                  thickness: 1,
                ),
                // Row 3: Usage
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.translate('usage').toUpperCase(),
                      style: const TextStyle(
                        fontSize: 10,
                        fontFamily: 'Manrope',
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                        letterSpacing: 0.5,
                      ),
                    ),
                    Text(
                      usageText,
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Manrope',
                        fontWeight: FontWeight.bold,
                        color: isOverspent
                            ? AppColors.error
                            : (isDark ? Colors.white : const Color(0xFF0F172A)),
                      ),
                    ),
                  ],
                ),
              ],
            );
          } else {
            // Horizontal row (original design)
            infoLayout = Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.translate(
                          'spent_vs_budget',
                        ).toUpperCase(),
                        style: const TextStyle(
                          fontSize: 10,
                          fontFamily: 'Manrope',
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                          letterSpacing: 0.5,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            spentText,
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'Manrope',
                              fontWeight: FontWeight.bold,
                              color: isDark
                                  ? Colors.white
                                  : const Color(0xFF0F172A),
                            ),
                          ),
                          Text(
                            '/$budgetText ৳',
                            style: TextStyle(
                              fontSize: 11,
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
                ),
                Container(
                  width: 1.w,
                  height: 32.h,
                  color: isDark
                      ? const Color(0xFF334155)
                      : const Color(0xFFF1F5F9),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isOverspent
                            ? 'OVERSPENT'
                            : AppLocalizations.translate(
                                'remaining',
                              ).toUpperCase(),
                        style: TextStyle(
                          fontSize: 10,
                          fontFamily: 'Manrope',
                          fontWeight: FontWeight.bold,
                          color: isOverspent ? AppColors.error : Colors.grey,
                          letterSpacing: 0.5,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        '$remainingText ৳',
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'Manrope',
                          fontWeight: FontWeight.bold,
                          color: isOverspent
                              ? AppColors.error
                              : AppColors.success,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 1.w,
                  height: 32.h,
                  color: isDark
                      ? const Color(0xFF334155)
                      : const Color(0xFFF1F5F9),
                ),
                SizedBox(width: 12.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      AppLocalizations.translate('usage').toUpperCase(),
                      style: const TextStyle(
                        fontSize: 10,
                        fontFamily: 'Manrope',
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      usageText,
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'Manrope',
                        fontWeight: FontWeight.bold,
                        color: isOverspent
                            ? AppColors.error
                            : (isDark ? Colors.white : const Color(0xFF0F172A)),
                      ),
                    ),
                  ],
                ),
              ],
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              infoLayout,
              SizedBox(height: 16.h),
              ClipRRect(
                borderRadius: BorderRadius.circular(9999.r),
                child: SizedBox(
                  height: 8.h,
                  width: double.infinity,
                  child: LinearProgressIndicator(
                    value: usagePercent.clamp(0.0, 1.0),
                    backgroundColor: isDark
                        ? const Color(0xFF1E293B)
                        : const Color(0xFFF1F5F9),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isOverspent ? AppColors.error : AppColors.success,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
