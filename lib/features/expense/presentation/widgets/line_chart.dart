import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:spendly/core/extensions/date_time_formatter.dart';

import '../../domain/entities/expense_entity.dart';

class ExpenseLineChart extends StatelessWidget {
  final List<ExpenseEntity> expenses;

  const ExpenseLineChart({
    super.key,
    required this.expenses,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.30,
      child: Container(
        margin: const EdgeInsets.only(bottom: 60.0, top: 20),
        child: LineChart(_buildChartData()),
      ),
    );
  }

  LineChartData _buildChartData() {
    final List<FlSpot> spots = _generateSpots(expenses);

    return LineChartData(
      minY: 0,
      // Start Y-axis from 0
      maxY: 22000,
      // Ensure Y-axis goes up to slightly above 20k
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        drawHorizontalLine: true,
        horizontalInterval: 5000, // Fixed intervals: 1k, 5k, etc.
      ),
      titlesData: FlTitlesData(
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 40,
            interval: 5000, // Fixed intervals: 1k, 5k, etc.
            getTitlesWidget: (value, meta) => _buildFixedYAxisLabel(value),
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 5,
            getTitlesWidget: (value, meta) => Text(
              value.toInt().toString(),
              style: const TextStyle(fontSize: 10),
            ),
          ),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false), // Disable top labels
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false), // Disable right labels
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
      ),
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          preventCurveOverShooting: true,
          barWidth: 4,
          isStrokeCapRound: false,
          belowBarData: BarAreaData(
            show: true,
            gradient: const LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [Colors.blueAccent, Colors.redAccent],
            ),
          ),
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, barData, index) {
              return FlDotCirclePainter(
                radius: 4,
                color: Colors.blue,
                strokeWidth: 2,
                strokeColor: Colors.white,
              );
            },
          ),
        ),
      ],
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          fitInsideHorizontally: true,
          fitInsideVertically: true,
          getTooltipItems: (List<LineBarSpot> touchedSpots) {
            return touchedSpots.map((spot) {
              final int day = spot.x.toInt();
              final DateTime date = DateTime.now().copyWith(day: day);

              final double total = expenses
                  .where((expense) => expense.date.day == day)
                  .fold(0.0, (sum, expense) => sum + expense.amount);

              return LineTooltipItem(
                '${date.formatDate()}\nAmount: ${total.toStringAsFixed(0)} ৳',
                const TextStyle(color: Colors.white, fontSize: 12),
              );
            }).toList();
          },
        ),
        handleBuiltInTouches: true,
      ),
    );
  }

  List<FlSpot> _generateSpots(List<ExpenseEntity> expenses) {
    final Map<int, double> dailyTotals = <int, double>{};

    for (var expense in expenses) {
      final int day = expense.date.day;
      dailyTotals[day] = (dailyTotals[day] ?? 0) + expense.amount;
    }

    final spots = <FlSpot>[];
    for (int i = 1; i <= 31; i++) {
      final double total = dailyTotals[i] ?? 0;
      spots.add(FlSpot(i.toDouble(), _transformYValue(total)));
    }

    return spots;
  }

  double _transformYValue(double value) {
    if (value > 20000) {
      return 21000 +
          (value - 20000) / 1000; // Slightly above 20k for values > 20k
    }
    return value;
  }

  Widget _buildFixedYAxisLabel(double value) {
    const fixedLabels = {
      1000: '1k',
      5000: '5k',
      10000: '10k',
      15000: '15k',
      20000: '20k+',
    };

    final label = fixedLabels[value.toInt()] ?? '';
    return Text(
      label,
      style: const TextStyle(fontSize: 12, color: Colors.black),
    );
  }
}
