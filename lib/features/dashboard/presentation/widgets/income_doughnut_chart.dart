import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:finkeep/core/common/widgets/privacy_text.dart';
import '../../../../core/routes/app_router.dart';
import '../../../../core/styles/app_colors.dart';
import '../../../../core/styles/currency_provider.dart';
import '../../../../core/providers/privacy_provider.dart';
import '../../domain/entities/dashboard_category_breakdown_entity.dart';

class IncomeDoughnutChart extends StatefulWidget {
  final List<DashboardCategoryBreakdownEntity> breakdown;
  final double totalIncome;

  const IncomeDoughnutChart({
    super.key,
    required this.breakdown,
    required this.totalIncome,
  });

  @override
  State<IncomeDoughnutChart> createState() => _IncomeDoughnutChartState();
}

class _IncomeDoughnutChartState extends State<IncomeDoughnutChart> {
  int _touchedIndex = -1;

  String _formatCategoryName(String rawName) {
    if (rawName.isEmpty) return 'Other';
    String cleaned = rawName;
    if (cleaned.startsWith('cat_') || cleaned.startsWith('cat-')) {
      cleaned = cleaned.substring(4);
    }
    cleaned = cleaned.replaceAll('_', ' ').replaceAll('-', ' ').trim();
    if (cleaned.isEmpty) return 'Other';
    return cleaned[0].toUpperCase() + cleaned.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: PrivacyProvider(),
      builder: (context, isMasked, _) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final symbol = context.currency.symbol;

    // Filter out breakdown items with 0 or negative amount to prevent fl_chart assertions
    final validBreakdown = widget.breakdown.where((e) => e.amount > 0).toList();

    final double effectiveTotal = widget.totalIncome > 0
        ? widget.totalIncome
        : validBreakdown.fold(0.0, (sum, item) => sum + item.amount);

    if (validBreakdown.isEmpty || effectiveTotal <= 0) {
      return GestureDetector(
        onTap: () => context.go(AppRoutes.income),
        child: Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardDark : AppColors.cardLight,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
            ),
          ),
          child: AspectRatio(
            aspectRatio: 1,
            child: Stack(
              children: [
                PieChart(
                  PieChartData(
                    sectionsSpace: 0,
                    centerSpaceRadius: 46,
                    sections: [
                      PieChartSectionData(
                        color: isDark
                            ? const Color(0xFF334155)
                            : const Color(0xFFE2E8F0),
                        value: 1,
                        radius: 19,
                        title: '',
                      ),
                    ],
                  ),
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'INCOME',
                        style: TextStyle(
                          fontSize: 9,
                          color: AppColors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '0 $symbol',
                        style: TextStyle(
                          fontSize: 12,
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
      );
    }

    // Limit to top 5 categories, group the rest into 'Other'
    final List<DashboardCategoryBreakdownEntity> displayBreakdown = [];
    if (validBreakdown.length <= 5) {
      displayBreakdown.addAll(validBreakdown);
    } else {
      displayBreakdown.addAll(validBreakdown.take(4));
      double otherSum = 0;
      for (int i = 4; i < validBreakdown.length; i++) {
        otherSum += validBreakdown[i].amount;
      }
      displayBreakdown.add(DashboardCategoryBreakdownEntity(
        categoryName: 'Other',
        amount: otherSum,
        percentage: (otherSum / effectiveTotal) * 100,
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

    final isItemSelected = _touchedIndex >= 0 && _touchedIndex < displayBreakdown.length;
    final selectedItem = isItemSelected ? displayBreakdown[_touchedIndex] : null;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (_touchedIndex != -1) {
          setState(() => _touchedIndex = -1);
        } else {
          context.go(AppRoutes.income);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : AppColors.cardLight,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
          ),
        ),
        child: AspectRatio(
          aspectRatio: 1,
          child: Stack(
            children: [
              PieChart(
                PieChartData(
                  pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                      if (event is FlTapUpEvent) {
                        if (pieTouchResponse != null &&
                            pieTouchResponse.touchedSection != null &&
                            pieTouchResponse.touchedSection!.touchedSectionIndex >= 0 &&
                            pieTouchResponse.touchedSection!.touchedSectionIndex < displayBreakdown.length) {
                          final index = pieTouchResponse.touchedSection!.touchedSectionIndex;
                          setState(() {
                            _touchedIndex = index;
                          });
                        } else {
                          if (_touchedIndex != -1) {
                            setState(() {
                              _touchedIndex = -1;
                            });
                          } else {
                            context.go(AppRoutes.income);
                          }
                        }
                      }
                    },
                  ),
                  sectionsSpace: 2,
                  centerSpaceRadius: 46,
                  startDegreeOffset: -90,
                  sections: List.generate(displayBreakdown.length, (index) {
                    final isTouched = index == _touchedIndex;
                    final item = displayBreakdown[index];
                    final color = colors[index % colors.length];
                    return PieChartSectionData(
                      color: color,
                      value: item.amount,
                      radius: isTouched ? 24 : 19,
                      title: '${item.percentage.toStringAsFixed(0)}%',
                      titleStyle: TextStyle(
                        fontSize: isTouched ? 10 : 9,
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
                    Text(
                      selectedItem != null
                          ? '${selectedItem.emoji ?? "💰"} ${_formatCategoryName(selectedItem.categoryName).toUpperCase()}'
                          : 'INCOME',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 9,
                        color: AppColors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: PrivacyText(
                          selectedItem != null ? selectedItem.amount : effectiveTotal,
                          suffix: ' $symbol',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                      ),
                    ),
                    if (selectedItem != null) ...[
                      const SizedBox(height: 1),
                      Text(
                        '${selectedItem.percentage.toStringAsFixed(1)}%',
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF10B981),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
      },
    );
  }
}

class IncomeDoughnutChartShimmer extends StatelessWidget {
  const IncomeDoughnutChartShimmer({super.key});

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
        height: 165,
        decoration: BoxDecoration(
          color: itemBg,
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
