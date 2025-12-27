import 'package:flutter/material.dart';

import '../../../../core/common/widgets/custom_divider.dart';
import '../../domain/entities/expense_entity.dart';
import '../widgets/summary_by_category_widget.dart';
import '../widgets/total_spent_card.dart';

class ExpenseSummery extends StatelessWidget {
  const ExpenseSummery({super.key, required this.expenses});

  final List<ExpenseEntity> expenses;

  double _calculateTotalSpending() {
    return expenses.fold(0.0, (sum, e) => sum + e.amount);
  }

  @override
  Widget build(BuildContext context) {
    final double totalSpending = _calculateTotalSpending();

    if (expenses.isEmpty || totalSpending == 0) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Center(child: Text("No expenses recorded.")),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 💳 Total Spent Card (new)
          TotalSpentCard(),

          const SizedBox(height: 16),

          // 📊 Summary by Category
          SummaryByCategoryWidget(expenses: expenses),

          const SizedBox(height: 8),
          const CustomDivider(),
        ],
      ),
    );
  }
}
