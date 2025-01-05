import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../core/styles/app_colors.dart';
import '../../domain/entities/expense_entity.dart';

class DonutChart extends StatefulWidget {
  final List<ExpenseEntity> expenses;

  const DonutChart({
    super.key,
    required this.expenses,
  });

  @override
  State<DonutChart> createState() => _DonutChartState();
}

class _DonutChartState extends State<DonutChart> {
  int? _tappedIndex;

  @override
  Widget build(BuildContext context) {
    final categorySpending = _calculateCategorySpending(widget.expenses);
    final totalSpending =
        categorySpending.fold<double>(0, (sum, item) => sum + item['amount']);

    return Column(
      children: [
        const SizedBox(height: 10),
        Expanded(
          child: Stack(
            alignment: Alignment.center,
            children: [
              PieChart(
                swapAnimationCurve: Curves.easeOutExpo,
                PieChartData(
                  sections: _generateSections(categorySpending, totalSpending),
                  centerSpaceRadius: 80,
                  sectionsSpace: 2,
                  // startDegreeOffset: -120,
                  titleSunbeamLayout: true,
                  borderData: FlBorderData(show: false),
                  pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                      setState(() {
                        _tappedIndex = pieTouchResponse
                                ?.touchedSection?.touchedSectionIndex ??
                            -1;
                      });
                    },
                  ),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Total",
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                  Text(
                    "${totalSpending.toStringAsFixed(2)} ৳",
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    (_tappedIndex != null &&
                            _tappedIndex! >= 0 &&
                            _tappedIndex! < categorySpending.length)
                        ? "${categorySpending[_tappedIndex!]['category']}: ${categorySpending[_tappedIndex!]['amount']} ৳"
                        : "",
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            ],
          ),
        ),
        // const SizedBox(height: 10),
      ],
    );
  }

  List<PieChartSectionData> _generateSections(
      List<Map<String, dynamic>> categorySpending, double totalSpending) {
    return categorySpending.asMap().entries.map((entry) {
      final index = entry.key;
      final data = entry.value;
      final category = data['category'];
      final spendingPercent = (data['amount'] / totalSpending) * 100;

      return PieChartSectionData(
        color: AppColors.getColorForCategory(category),
        value: data['amount'],
        title: '${spendingPercent.toStringAsFixed(1)}%',
        radius: _tappedIndex == index ? 90 : 80,
        titleStyle: const TextStyle(
            fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
      );
    }).toList();
  }

  List<Map<String, dynamic>> _calculateCategorySpending(
      List<ExpenseEntity> expenses) {
    final Map<String, double> spendingByCategory = {};
    for (var expense in expenses) {
      if (spendingByCategory.containsKey(expense.category)) {
        spendingByCategory[expense.category] =
            spendingByCategory[expense.category]! + expense.amount;
      } else {
        spendingByCategory[expense.category] = expense.amount;
      }
    }

    return spendingByCategory.entries
        .map((entry) => {'category': entry.key, 'amount': entry.value})
        .toList();
  }
}
