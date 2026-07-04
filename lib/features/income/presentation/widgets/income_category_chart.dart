import 'package:finkeep/core/extensions/double_ext.dart';
import 'package:finkeep/core/responsive/responsive.dart';
import 'package:finkeep/core/styles/app_colors.dart';
import 'package:finkeep/core/styles/currency_provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/entities/income/income_entity.dart';
import '../controllers/income_category_controller.dart';

class IncomeCategoryChart extends StatelessWidget {
  final List<IncomeEntity> incomes;

  const IncomeCategoryChart({super.key, required this.incomes});

  Color _getColorForIndex(int index) {
    final List<Color> colors = [
      AppColors.primaryTeal,
      const Color(0xFF10B981),
      Colors.green.shade600,
      Colors.teal.shade700,
      Colors.cyan.shade600,
      Colors.blue.shade600,
      Colors.indigo.shade600,
      Colors.purple.shade600,
      Colors.orange.shade600,
      Colors.amber.shade700,
      Colors.pink.shade600,
      Colors.grey.shade600,
    ];
    return colors[index % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final IncomeCategoryController categoryController = Get.find();

    // Aggregate incomes by category
    final Map<String, double> categoryTotals = {};
    double totalIncome = 0.0;

    for (var income in incomes) {
      categoryTotals[income.categoryId] = (categoryTotals[income.categoryId] ?? 0.0) + income.amount;
      totalIncome += income.amount;
    }

    // Sort category keys by amount descending
    final sortedKeys = categoryTotals.keys.toList()
      ..sort((a, b) => (categoryTotals[b] ?? 0.0).compareTo(categoryTotals[a] ?? 0.0));

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
            'INCOME BY CATEGORY',
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
              // Pie Chart
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
                        sections: totalIncome == 0.0
                            ? [
                                PieChartSectionData(
                                  color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                                  value: 1.0,
                                  title: '',
                                  radius: 16.r,
                                ),
                              ]
                            : sortedKeys.asMap().entries.map((entry) {
                                final index = entry.key;
                                final catId = entry.value;
                                final value = categoryTotals[catId] ?? 0.0;
                                final percentage = (value / totalIncome) * 100;

                                return PieChartSectionData(
                                  color: _getColorForIndex(index),
                                  value: value,
                                  title: value > 0 ? '${percentage.toStringAsFixed(0)}%' : '',
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
                        totalIncome.toCurrency(),
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontFamily: 'Manrope',
                          fontWeight: FontWeight.bold,
                          color: AppColors.success,
                        ),
                      ),
                      Text(
                        'Total (${context.currency.symbol})',
                        style: TextStyle(
                          fontSize: 8.sp,
                          fontFamily: 'Manrope',
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white30 : const Color(0xFF94A3B8),
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
                  children: totalIncome == 0.0
                      ? [
                          Text(
                            'No income recorded this month.',
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontFamily: 'Manrope',
                              color: isDark ? Colors.white38 : const Color(0xFF94A3B8),
                            ),
                          )
                        ]
                      : sortedKeys.asMap().entries.map((entry) {
                          final index = entry.key;
                          final catId = entry.value;
                          final value = categoryTotals[catId] ?? 0.0;
                          final cat = categoryController.categories.firstWhereOrNull((c) => c.id == catId);
                          final isDeleted = cat?.isDeleted ?? false;
                          final catLabel = cat != null
                              ? (isDeleted ? '${cat.displayLabel} (Deleted)' : cat.displayLabel)
                              : 'Other';
                          final catEmoji = cat?.emoji ?? '💰';

                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 4.h),
                            child: Row(
                              children: [
                                Container(
                                  width: 8.r,
                                  height: 8.r,
                                  decoration: BoxDecoration(
                                    color: _getColorForIndex(index),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                Expanded(
                                  child: Text(
                                    '$catEmoji $catLabel',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 11.sp,
                                      fontFamily: 'Manrope',
                                      fontWeight: FontWeight.w500,
                                      fontStyle: isDeleted ? FontStyle.italic : FontStyle.normal,
                                      color: isDeleted
                                          ? (isDark ? Colors.white38 : const Color(0xFF94A3B8))
                                          : (isDark ? Colors.white70 : const Color(0xFF334155)),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  value.toCurrency(),
                                  style: TextStyle(
                                    fontSize: 11.sp,
                                    fontFamily: 'Manrope',
                                    fontWeight: FontWeight.bold,
                                    color: isDark ? Colors.white54 : const Color(0xFF64748B),
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
