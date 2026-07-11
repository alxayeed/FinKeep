import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:finkeep/core/extensions/double_ext.dart';
import 'package:finkeep/core/styles/currency_provider.dart';
import '../../../../core/styles/app_colors.dart';
import '../../domain/entities/monthly_standing_entity.dart';

class MonthlyStandingChart extends StatelessWidget {
  final MonthlyStandingEntity data;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  const MonthlyStandingChart({
    super.key,
    required this.data,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final symbol = context.currency.symbol;
    final monthLabel = DateFormat('MMMM yyyy').format(data.month);

    final double total = data.totalIncome +
        data.totalExpense +
        data.totalLendGiven +
        data.totalLendTaken;

    final hasData = total > 0;

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
          // Header with Title and Navigation Controls (Info button removed)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Text(
                  'MONTHLY STANDING',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
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

          if (!hasData)
            const Expanded(
              child: Center(
                child: Text(
                  'No transactions recorded for this month',
                  style: TextStyle(color: AppColors.grey, fontSize: 13),
                ),
              ),
            )
          else
            Expanded(
              child: Row(
                children: [
                  // Donut Chart
                  Expanded(
                    flex: 4,
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Stack(
                        children: [
                          PieChart(
                            PieChartData(
                              sectionsSpace: 2,
                              centerSpaceRadius: 36,
                              startDegreeOffset: -90,
                              sections: [
                                if (data.totalIncome > 0)
                                  PieChartSectionData(
                                    color: AppColors.success,
                                    value: data.totalIncome,
                                    radius: 16,
                                    title: '${((data.totalIncome / total) * 100).toStringAsFixed(0)}%',
                                    titleStyle: const TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                if (data.totalExpense > 0)
                                  PieChartSectionData(
                                    color: AppColors.error,
                                    value: data.totalExpense,
                                    radius: 16,
                                    title: '${((data.totalExpense / total) * 100).toStringAsFixed(0)}%',
                                    titleStyle: const TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                if (data.totalLendGiven > 0)
                                  PieChartSectionData(
                                    color: Colors.amber,
                                    value: data.totalLendGiven,
                                    radius: 16,
                                    title: '${((data.totalLendGiven / total) * 100).toStringAsFixed(0)}%',
                                    titleStyle: const TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                if (data.totalLendTaken > 0)
                                  PieChartSectionData(
                                    color: Colors.indigo,
                                    value: data.totalLendTaken,
                                    radius: 16,
                                    title: '${((data.totalLendTaken / total) * 100).toStringAsFixed(0)}%',
                                    titleStyle: const TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'TOTAL',
                                  style: TextStyle(fontSize: 8, color: AppColors.grey, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '${total.toCurrency()} $symbol',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: isDark ? Colors.white : Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Legend
                  Expanded(
                    flex: 5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLegendRow(
                          color: AppColors.success,
                          label: 'Income',
                          amount: data.totalIncome,
                          symbol: symbol,
                          isDark: isDark,
                        ),
                        const SizedBox(height: 4),
                        _buildLegendRow(
                          color: AppColors.error,
                          label: 'Expenses',
                          amount: data.totalExpense,
                          symbol: symbol,
                          isDark: isDark,
                        ),
                        const SizedBox(height: 4),
                        _buildLegendRow(
                          color: Colors.amber,
                          label: 'Lend Given',
                          amount: data.totalLendGiven,
                          symbol: symbol,
                          isDark: isDark,
                        ),
                        const SizedBox(height: 4),
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
  }

  Widget _buildLegendRow({
    required Color color,
    required String label,
    required double amount,
    required String symbol,
    required bool isDark,
  }) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            '$label: ${amount.toCurrency()} $symbol',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white70 : Colors.black87,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
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
