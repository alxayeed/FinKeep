import 'package:flutter/material.dart';
import 'package:spendly/core/extensions/double_ext.dart';

import '../../domain/entities/expense_entity.dart';

class SummaryByCategoryWidget extends StatelessWidget {
  const SummaryByCategoryWidget({super.key, required this.expenses});

  final List<ExpenseEntity> expenses;

  // Calculate total spending per category
  Map<String, double> _calculateCategorySpending() {
    final Map<String, double> spending = {};

    for (final expense in expenses) {
      spending.update(
        expense.category,
        (value) => value + expense.amount,
        ifAbsent: () => expense.amount,
      );
    }

    return spending;
  }

  // Category → color mapping
  Color _categoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'family':
        return const Color(0xFF3B82F6); // Blue
      case 'other':
        return const Color(0xFF9CA3AF); // Gray
      case 'transport':
        return const Color(0xFF8B5CF6); // Purple
      case 'food':
        return const Color(0xFFF59E0B); // Orange
      case 'personal':
        return const Color(0xFF10B981); // Green
      case 'utilities':
        return const Color(0xFF6366F1); // Indigo
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final categorySpending = _calculateCategorySpending();

    if (categorySpending.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Center(child: Text("No expenses recorded.")),
      );
    }

    final double totalSpending = categorySpending.values.fold(
      0.0,
      (sum, e) => sum + e,
    );

    final sortedEntries = categorySpending.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Summary by Category",
          style: theme.textTheme.titleMedium!.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),

        ...sortedEntries.map((entry) {
          final percent = totalSpending == 0
              ? 0
              : (entry.value / totalSpending) * 100;

          return _CategorySummaryRow(
            color: _categoryColor(entry.key),
            category: entry.key,
            percentage: percent.toDouble(),
            amount: entry.value,
          );
        }),
      ],
    );
  }
}

/// Internal widget – not exposed outside this file
class _CategorySummaryRow extends StatelessWidget {
  const _CategorySummaryRow({
    required this.color,
    required this.category,
    required this.percentage,
    required this.amount,
  });

  final Color color;
  final String category;
  final double percentage;
  final double amount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          // ● Colored dot
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 10),

          // Category name + percentage
          Expanded(
            child: Text(
              "$category (${percentage.toStringAsFixed(0)}%)",
              style: theme.textTheme.bodyMedium!.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          // Amount
          Text(
            "${amount.toCurrency()} ৳",
            style: theme.textTheme.bodyMedium!.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
