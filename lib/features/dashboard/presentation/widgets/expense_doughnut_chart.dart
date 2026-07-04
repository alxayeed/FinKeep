import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:finkeep/core/extensions/double_ext.dart';
import 'package:finkeep/core/styles/currency_provider.dart';
import '../../../../core/styles/app_colors.dart';
import '../../domain/entities/dashboard_category_breakdown_entity.dart';

class ExpenseDoughnutChart extends StatelessWidget {
  final List<DashboardCategoryBreakdownEntity> breakdown;
  final double totalExpense;

  const ExpenseDoughnutChart({
    super.key,
    required this.breakdown,
    required this.totalExpense,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final symbol = context.currency.symbol;

    if (breakdown.isEmpty || totalExpense == 0) {
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
            'No expense data to display',
            style: TextStyle(color: AppColors.grey, fontSize: 13),
          ),
        ),
      );
    }

    // Limit to top 5 categories, group the rest into 'Other'
    final List<DashboardCategoryBreakdownEntity> displayBreakdown = [];
    if (breakdown.length <= 5) {
      displayBreakdown.addAll(breakdown);
    } else {
      displayBreakdown.addAll(breakdown.take(4));
      double otherSum = 0;
      for (int i = 4; i < breakdown.length; i++) {
        otherSum += breakdown[i].amount;
      }
      displayBreakdown.add(DashboardCategoryBreakdownEntity(
        categoryName: 'Other',
        amount: otherSum,
        percentage: (otherSum / totalExpense) * 100,
        emoji: '⚙️',
      ));
    }

    final colors = [
      AppColors.primaryTeal,
      Colors.blue,
      Colors.purple,
      Colors.orange,
      Colors.pink,
      Colors.grey,
    ];

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
                'EXPENSE ALLOCATION',
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
                onPressed: () => _showExpenseAllocationInfo(context),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                flex: 4,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Stack(
                    children: [
                      PieChart(
                        PieChartData(
                          sectionsSpace: 2,
                          centerSpaceRadius: 40,
                          startDegreeOffset: -90,
                          sections: List.generate(displayBreakdown.length, (index) {
                            final item = displayBreakdown[index];
                            final color = colors[index % colors.length];
                            return PieChartSectionData(
                              color: color,
                              value: item.amount,
                              radius: 18,
                              title: '${item.percentage.toStringAsFixed(0)}%',
                              titleStyle: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            );
                          }),
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
                              '${totalExpense.toCurrency()} $symbol',
                              style: TextStyle(
                                fontSize: 11,
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
              Expanded(
                flex: 5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(displayBreakdown.length, (index) {
                    final item = displayBreakdown[index];
                    final color = colors[index % colors.length];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              '${item.emoji ?? "💸"} ${item.categoryName}',
                              style: TextStyle(
                                fontSize: 11,
                                color: isDark ? Colors.white.withValues(alpha: 0.8) : Colors.black.withValues(alpha: 0.8),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
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

  void _showExpenseAllocationInfo(BuildContext context) {
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
                      'Expense Allocation Info',
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
                  'This doughnut chart displays a percentage breakdown of your total spending by category for the selected timeframe.',
                  style: TextStyle(fontSize: 13),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Top categories are displayed individually, while smaller categories are grouped into "Other" to keep your view clean and actionable. Reviewing this chart helps you track where your money goes and identify categories where you can optimize your budget.',
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

class ExpenseDoughnutChartShimmer extends StatelessWidget {
  const ExpenseDoughnutChartShimmer({super.key});

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
