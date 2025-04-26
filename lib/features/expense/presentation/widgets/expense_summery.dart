import 'package:flutter/material.dart';

import '../../domain/entities/expense_entity.dart';

class ExpenseSummery extends StatelessWidget {
  const ExpenseSummery({
    super.key,
    required this.expenses,
  });

  final List<ExpenseEntity> expenses;

  List<Map<String, dynamic>> _calculateCategorySpending(
      List<ExpenseEntity> expenses) {
    final Map<String, double> spendingByCategory = {};
    for (var expense in expenses) {
      final categoryKey = expense.category;
      if (spendingByCategory.containsKey(categoryKey)) {
        spendingByCategory[categoryKey] =
            spendingByCategory[categoryKey]! + expense.amount;
      } else {
        spendingByCategory[categoryKey] = expense.amount;
      }
    }

    return spendingByCategory.entries
        .map((entry) => {'category': entry.key, 'amount': entry.value})
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final categorySpending = _calculateCategorySpending(expenses);

    final sortedCategorySpending = [
      ...categorySpending
    ]..sort((a, b) => (b['amount'] as double).compareTo(a['amount'] as double));

    final double totalSpending = categorySpending.fold<double>(
        0.0, (sum, item) => sum + (item['amount'] as double));

    if (totalSpending == 0 && expenses.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(child: Text("No expenses recorded.")),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ...sortedCategorySpending.map((data) {
            final double currentAmount = data['amount'] as double;
            double spendingPercent = totalSpending == 0
                ? 0.0
                : (currentAmount / totalSpending) * 100;

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${data['category']}(${spendingPercent.toStringAsFixed(1)}%)",
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    "${currentAmount.toStringAsFixed(0)} ৳",
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 8),
          const Divider(
            height: 1,
            thickness: 1,
            color: Colors.grey,
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Total:",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              Text(
                "${totalSpending.toStringAsFixed(0)} ৳",
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
