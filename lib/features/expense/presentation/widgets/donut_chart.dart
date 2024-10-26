import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/expense_entity.dart';

class DonutChart extends StatefulWidget {
  final List<ExpenseEntity> expenses;

  const DonutChart({
    super.key,
    required this.expenses,
  });

  @override
  _DonutChartState createState() => _DonutChartState();
}

class _DonutChartState extends State<DonutChart> {
  int? _tappedIndex;

  @override
  Widget build(BuildContext context) {
    final categorySpending = _calculateCategorySpending(widget.expenses);
    final totalSpending = categorySpending.fold<double>(0, (sum, item) => sum + item['amount']);
    final colors = [Colors.teal, Colors.orange, Colors.blue, Colors.purple, Colors.amber];

    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              height: 250,
              child: PieChart(
                PieChartData(
                  sections: _generateSections(categorySpending, totalSpending, colors),
                  centerSpaceRadius: 60,  // Adjust for compact text display in the center
                  sectionsSpace: 2,
                  startDegreeOffset: -90,
                  borderData: FlBorderData(show: false),
                  pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                      setState(() {
                        // Set _tappedIndex only if a section was actually touched
                        _tappedIndex = pieTouchResponse?.touchedSection?.touchedSectionIndex ?? -1;
                      });
                    },
                  ),
                ),
              ),
            ),
            // Centered total expense text
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Total",
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
                Text(
                  "${totalSpending.toStringAsFixed(2)} ৳",
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Show selected category amount or default text
        Text(
          (_tappedIndex != null && _tappedIndex! >= 0 && _tappedIndex! < categorySpending.length)
              ? "${categorySpending[_tappedIndex!]['category']}: ${categorySpending[_tappedIndex!]['amount']} ৳"
              : "Tap a category to see the total amount",
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        // Legend for categories and colors
        Wrap(
          spacing: 10,
          runSpacing: 8,
          children: List.generate(categorySpending.length, (index) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: colors[index % colors.length],
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  categorySpending[index]['category'],
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            );
          }),
        ),
      ],
    );
  }

  List<PieChartSectionData> _generateSections(
      List<Map<String, dynamic>> categorySpending, double totalSpending, List<Color> colors) {
    return categorySpending.asMap().entries.map((entry) {
      final index = entry.key;
      final data = entry.value;
      final spendingPercent = (data['amount'] / totalSpending) * 100;

      return PieChartSectionData(
        color: colors[index % colors.length],
        value: data['amount'],
        title: '${spendingPercent.toStringAsFixed(1)}%',
        radius: _tappedIndex == index ? 90 : 80,  // Increase radius when selected
        titleStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
      );
    }).toList();
  }

  List<Map<String, dynamic>> _calculateCategorySpending(List<ExpenseEntity> expenses) {
    final Map<String, double> spendingByCategory = {};
    for (var expense in expenses) {
      if (spendingByCategory.containsKey(expense.category)) {
        spendingByCategory[expense.category] = spendingByCategory[expense.category]! + expense.amount;
      } else {
        spendingByCategory[expense.category] = expense.amount;
      }
    }

    return spendingByCategory.entries
        .map((entry) => {'category': entry.key, 'amount': entry.value})
        .toList();
  }
}
