import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spendly/core/common/widgets/custom_divider.dart';
import 'package:spendly/core/extensions/double_ext.dart';

import '../../../features/expense/domain/entities/expense_entity.dart';

class ExpenseMonthlyAnalysis extends StatelessWidget {
  final List<ExpenseEntity> expenses;

  const ExpenseMonthlyAnalysis({
    super.key,
    required this.expenses,
  });

  Map<String, double> _getMonthlyAggregates() {
    final Map<String, double> monthlyTotals = {};

    final DateFormat formatter = DateFormat('MMM yyyy');

    for (var expense in expenses) {
      final monthYearKey = formatter.format(expense.date);
      monthlyTotals.update(
        monthYearKey,
        (value) => value + expense.amount,
        ifAbsent: () => expense.amount,
      );
    }
    return monthlyTotals;
  }

  Map<String, dynamic> _getSummary(Map<String, double> monthlyTotals) {
    if (monthlyTotals.isEmpty) {
      return {
        'highestMonth': 'N/A',
        'highestAmount': 0.0,
        'lowestMonth': 'N/A',
        'lowestAmount': 0.0,
        'average': 0.0,
      };
    }

    double maxAmount = -1;
    String maxMonth = '';

    double minAmount = double.infinity;
    String minMonth = '';

    double totalSum = 0;
    int count = monthlyTotals.length;

    monthlyTotals.forEach((month, amount) {
      if (amount > maxAmount) {
        maxAmount = amount;
        maxMonth = month;
      }
      if (amount < minAmount) {
        minAmount = amount;
        minMonth = month;
      }
      totalSum += amount;
    });

    return {
      'highestMonth': maxMonth,
      'highestAmount': maxAmount,
      'lowestMonth': minMonth,
      'lowestAmount': minAmount,
      'average': count > 0 ? totalSum / count : 0.0,
    };
  }

  Widget _buildBreakdownRow(String label, double amount, Color amountColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          Text(
            "${amount.toCurrency()} ৳",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: amountColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryStatRow(String label, double amount, Color amountColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          Text(
            "${amount.toCurrency()} ৳",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: amountColor,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final monthlyData = _getMonthlyAggregates();
    final summary = _getSummary(monthlyData);
    final theme = Theme.of(context);

    if (monthlyData.isEmpty) {
      return const SizedBox.shrink();
    }

    final List<MapEntry<String, double>> sortedMonthlyData =
        monthlyData.entries.toList();

    final DateFormat keyParser = DateFormat('MMM yyyy');
    sortedMonthlyData.sort((a, b) {
      final DateTime dateA = keyParser.parse(a.key);
      final DateTime dateB = keyParser.parse(b.key);
      return dateA.compareTo(dateB);
    });

    return Padding(
      padding: const EdgeInsets.all(0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const CustomDivider(),
          Text(
            'Summary By Month',
            style: theme.textTheme.titleMedium!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          const CustomDivider(),
          // Use the sorted list here
          ...sortedMonthlyData.map((entry) {
            return _buildBreakdownRow(
              entry.key,
              entry.value,
              theme.colorScheme.onSurface,
            );
          }),
          const CustomDivider(),
          Text(
            'Period Analysis',
            style: theme.textTheme.titleMedium!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          const CustomDivider(),
          const SizedBox(height: 4),
          _buildSummaryStatRow(
            'Highest Spend (${summary['highestMonth']})',
            summary['highestAmount'],
            theme.colorScheme.error,
          ),
          _buildSummaryStatRow(
            'Lowest Spend (${summary['lowestMonth']})',
            summary['lowestAmount'],
            theme.colorScheme.tertiary,
          ),
          _buildSummaryStatRow(
            'Average Monthly Spend',
            summary['average'],
            theme.colorScheme.onSurfaceVariant,
          ),
        ],
      ),
    );
  }
}
