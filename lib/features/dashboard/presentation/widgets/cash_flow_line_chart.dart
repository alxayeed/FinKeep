import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:intl/intl.dart';
import 'package:finkeep/core/extensions/double_ext.dart';
import 'package:finkeep/core/styles/currency_provider.dart';
import '../../../../core/styles/app_colors.dart';
import '../../domain/entities/dashboard_trend_point_entity.dart';

class CashFlowLineChart extends StatelessWidget {
  final List<DashboardTrendPointEntity> trends;

  const CashFlowLineChart({super.key, required this.trends});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final symbol = context.currency.symbol;

    if (trends.isEmpty) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : AppColors.cardLight,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
          ),
        ),
        child: const Center(
          child: Text(
            'No trend data to display',
            style: TextStyle(color: AppColors.grey, fontSize: 13),
          ),
        ),
      );
    }

    // Convert trends to FlSpot
    final List<FlSpot> spots = [];
    double minBalance = 0.0;
    double maxBalance = 0.0;

    for (int i = 0; i < trends.length; i++) {
      final val = trends[i].balance;
      if (val < minBalance) minBalance = val;
      if (val > maxBalance) maxBalance = val;
      spots.add(FlSpot(i.toDouble(), val));
    }

    // Set some padding on Y axis limits
    final yRangePadding = (maxBalance - minBalance).abs() * 0.1;
    final double minY = minBalance - yRangePadding;
    final double maxY = maxBalance + yRangePadding;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      padding: const EdgeInsets.all(16),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'CUMULATIVE CASH BALANCE TREND',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.grey,
                  letterSpacing: 1.1,
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.info_outline,
                  color: AppColors.grey,
                  size: 16,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () => _showCashFlowTrendInfo(context),
              ),
            ],
          ),
          const SizedBox(height: 16),
          AspectRatio(
            aspectRatio: 1.8,
            child: LineChart(
              LineChartData(
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((spot) {
                        final index = spot.x.toInt();
                        if (index >= 0 && index < trends.length) {
                          final dateStr = DateFormat('d MMM').format(trends[index].date);
                          return LineTooltipItem(
                            '$dateStr\nBalance: ${spot.y.toCurrency()} $symbol',
                            const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          );
                        }
                        return null;
                      }).toList();
                    },
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                    strokeWidth: 1,
                  ),
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 45,
                      getTitlesWidget: (value, meta) {
                        if (value == minY || value == maxY) return const SizedBox();
                        return Text(
                          value >= 1000
                              ? '${(value / 1000).toCurrency()}k'
                              : value.toCurrency(),
                          style: TextStyle(
                            fontSize: 10,
                            color: isDark ? Colors.white60 : Colors.black54,
                          ),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final int index = value.toInt();
                        if (index == 0 || index == trends.length - 1 || (trends.length > 5 && index == (trends.length / 2).floor())) {
                          if (index >= 0 && index < trends.length) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                DateFormat('d MMM').format(trends[index].date),
                                style: const TextStyle(fontSize: 9),
                              ),
                            );
                          }
                        }
                        return const SizedBox();
                      },
                    ),
                  ),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: (trends.length - 1).toDouble(),
                minY: minY,
                maxY: maxY == minY ? minY + 100.0 : maxY,
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    color: AppColors.primaryTeal,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: AppColors.primaryTeal.withValues(alpha: 0.15),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showCashFlowTrendInfo(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppColors.cardDark : AppColors.cardLight,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Cash Flow Trend Info',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Tracks your cumulative cash balance over time.',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Every day, the chart calculates your daily net change (Incomes - Expenses) and adds/subtracts it from the running total. An upward slope indicates you are generating savings, while a downward slope indicates you are spending more than your intake.',
                  style: TextStyle(fontSize: 13, color: AppColors.grey),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class CashFlowLineChartShimmer extends StatelessWidget {
  const CashFlowLineChartShimmer({super.key});

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
        height: 200,
        decoration: BoxDecoration(
          color: itemBg,
          borderRadius: BorderRadius.circular(24),
        ),
      ),
    );
  }
}
