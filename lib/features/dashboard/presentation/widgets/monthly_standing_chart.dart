import 'package:fl_chart/fl_chart.dart';
import '../../../../core/common/widgets/privacy_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:finkeep/core/extensions/double_ext.dart';
import 'package:finkeep/core/styles/currency_provider.dart';
import 'package:finkeep/core/providers/privacy_provider.dart';
import '../../../../core/styles/app_colors.dart';
import '../../domain/entities/monthly_standing_entity.dart';

class MonthlyStandingChart extends StatelessWidget {
  final MonthlyStandingEntity data;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;
  final bool showMonthSwitcher;
  final String title;

  const MonthlyStandingChart({
    super.key,
    required this.data,
    this.onPrevious,
    this.onNext,
    this.showMonthSwitcher = true,
    this.title = 'MONTHLY STANDING',
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: PrivacyProvider(),
      builder: (context, isMasked, _) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final symbol = context.currency.symbol;
    final monthLabel = DateFormat('MMMM yyyy').format(data.month);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      padding: const EdgeInsets.all(16),
      height: 220,
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Title and Optional Month Navigation Controls
          if (showMonthSwitcher) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.grey,
                      letterSpacing: 1.1,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left, size: 20),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: onPrevious,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      monthLabel,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    const SizedBox(width: 4),
                    IconButton(
                      icon: const Icon(Icons.chevron_right, size: 20),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: onNext,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],

          Expanded(
            child: Row(
              children: [
                // Bar Chart
                Expanded(
                  flex: 4,
                  child: Builder(
                    builder: (context) {
                      final double maxVal = [
                        data.totalIncome,
                        data.totalExpense,
                        data.totalLendGiven,
                        data.totalLendTaken,
                      ].reduce((a, b) => a > b ? a : b);

                      final double maxY = maxVal > 0 ? maxVal * 1.15 : 100.0;

                      final barItems = [
                        (0, data.totalIncome, AppColors.success),
                        (1, data.totalExpense, AppColors.error),
                        (2, data.totalLendGiven, Colors.amber),
                        (3, data.totalLendTaken, Colors.indigo),
                      ];

                      return BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceAround,
                          maxY: maxY,
                          gridData: const FlGridData(show: false),
                          borderData: FlBorderData(show: false),
                          titlesData: FlTitlesData(
                            show: true,
                            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 22,
                                getTitlesWidget: (value, meta) {
                                  const style = TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.grey,
                                  );
                                  String label;
                                  switch (value.toInt()) {
                                    case 0:
                                      label = 'Inc';
                                      break;
                                    case 1:
                                      label = 'Exp';
                                      break;
                                    case 2:
                                      label = 'Given';
                                      break;
                                    case 3:
                                      label = 'Taken';
                                      break;
                                    default:
                                      label = '';
                                  }
                                  return SideTitleWidget(
                                    meta: meta,
                                    space: 4,
                                    child: Text(label, style: style),
                                  );
                                },
                              ),
                            ),
                          ),
                          barTouchData: BarTouchData(
                            touchTooltipData: BarTouchTooltipData(
                              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                                final labels = ['Income', 'Expenses', 'Lend Given', 'Lend Taken'];
                                final label = labels[groupIndex % labels.length];
                                return BarTooltipItem(
                                  '$label\n${rod.toY.toCurrency()} $symbol',
                                  const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11,
                                  ),
                                );
                              },
                            ),
                          ),
                          barGroups: barItems.map((item) {
                            return BarChartGroupData(
                              x: item.$1,
                              barRods: [
                                BarChartRodData(
                                  toY: item.$2,
                                  color: item.$3,
                                  width: 14,
                                  borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                                  backDrawRodData: BackgroundBarChartRodData(
                                    show: true,
                                    toY: maxY,
                                    color: isDark
                                        ? Colors.white.withValues(alpha: 0.05)
                                        : Colors.black.withValues(alpha: 0.04),
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 20),
                // Legend
                Expanded(
                  flex: 6,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildLegendRow(
                        color: AppColors.success,
                        label: 'Income',
                        amount: data.totalIncome,
                        symbol: symbol,
                        isDark: isDark,
                      ),
                      _buildLegendRow(
                        color: AppColors.error,
                        label: 'Expenses',
                        amount: data.totalExpense,
                        symbol: symbol,
                        isDark: isDark,
                      ),
                      _buildLegendRow(
                        color: Colors.amber,
                        label: 'Lend Given',
                        amount: data.totalLendGiven,
                        symbol: symbol,
                        isDark: isDark,
                      ),
                      _buildLegendRow(
                        color: Colors.indigo,
                        label: 'Lend Taken',
                        amount: data.totalLendTaken,
                        symbol: symbol,
                        isDark: isDark,
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
      },
    );
  }

  Widget _buildLegendRow({
    required Color color,
    required String label,
    required double amount,
    required String symbol,
    required bool isDark,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white70 : Colors.black87,
            ),
          ),
          const Spacer(),
          PrivacyText(
            amount,
            suffix: ' $symbol',
            style: TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

class MonthlyStandingChartShimmer extends StatelessWidget {
  const MonthlyStandingChartShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0);
    final highlightColor = isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9);
    final itemBg = isDark ? AppColors.cardDark : AppColors.cardLight;

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        height: 220,
        decoration: BoxDecoration(
          color: itemBg,
          borderRadius: BorderRadius.circular(24),
        ),
      ),
    );
  }
}
