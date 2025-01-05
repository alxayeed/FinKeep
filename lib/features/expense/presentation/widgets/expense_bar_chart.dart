import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/expense_entity.dart';

class ExpenseBarChart extends StatelessWidget {
  final List<ExpenseEntity> expenses;

  const ExpenseBarChart({super.key, required this.expenses});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.3,
      child: Container(
        margin: const EdgeInsets.only(bottom: 60.0, top: 20),
        child: BarChart(
          _buildChartData(),
        ),
      ),
    );
  }

  BarChartData _buildChartData() {
    final List<BarChartGroupData> barGroups = _generateBarGroups(expenses);

    return BarChartData(
      barGroups: barGroups,
      titlesData: FlTitlesData(
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 40,
            interval: 5000,
            getTitlesWidget: (value, meta) {
              return Text(
                value == 0
                    ? '0'
                    : value >= 1000
                        ? '${(value / 1000).toStringAsFixed(0)}k'
                        : value.toStringAsFixed(0),
                style: const TextStyle(fontSize: 12),
              );
            },
          ),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
      gridData: const FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: 5000,
      ),
      borderData: FlBorderData(
        show: true, // Show borders
        border:
            Border.all(color: Colors.grey.withOpacity(0.5)), // Set border color
      ),
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
          getTooltipItem: (group, groupIndex, rod, rodIndex) {
            final date =
                DateTime(DateTime.now().year, DateTime.now().month, group.x);
            final formattedDate = DateFormat('d MMM, yyyy').format(date);
            return BarTooltipItem(
              '$formattedDate\nExpense: ${rod.toY.toInt()} ৳',
              const TextStyle(color: Colors.white),
            );
          },
        ),
        handleBuiltInTouches: true,
      ),
    );
  }

  List<BarChartGroupData> _generateBarGroups(List<ExpenseEntity> expenses) {
    final Map<int, double> dailyTotals = <int, double>{};

    for (var expense in expenses) {
      final int day = expense.date.day;
      dailyTotals[day] = (dailyTotals[day] ?? 0) + expense.amount;
    }

    return List.generate(31, (i) {
      final day = i + 1;
      final double total = dailyTotals[day] ?? 0.0;
      return BarChartGroupData(
        x: day,
        barRods: [
          BarChartRodData(
            toY: total,
            width: 10, // Reduced bar width
            color: total > 10000 ? Colors.redAccent : Colors.blueAccent,
          ),
        ],
      );
    });
  }
}
