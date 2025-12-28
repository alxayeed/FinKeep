import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spendly/core/extensions/double_ext.dart';

import '../controllers/expense_controller.dart';

class TotalSpentCard extends StatelessWidget {
  const TotalSpentCard({
    super.key,
    this.compact = false,
    this.isReport = false,
  });

  final bool compact;
  final bool isReport;

  String _budgetHealthLabel(double spent, double budget) {
    if (spent <= budget * 0.85) return "Healthy";
    if (spent <= budget) return "Warning";
    return "Over Budget";
  }

  Color _budgetHealthColor(double spent, double budget) {
    if (spent <= budget * 0.85) return Colors.green.shade600;
    if (spent <= budget) return Colors.orange.shade700;
    return Colors.red.shade600;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = Get.find<ExpenseController>();

    return Obx(() {
      final double totalSpent = isReport
          ? controller.reportExpenses.fold(0.0, (sum, e) => sum + e.amount)
          : controller.totalExpense.value;

      final double budget = controller.monthlyBudget.value;
      final bool isOverBudget = totalSpent > budget;
      final double remaining = (budget - totalSpent).clamp(0.0, budget);
      final double overAmount = isOverBudget ? (totalSpent - budget) : 0;

      final Color totalSpentColor = isReport
          ? theme.colorScheme.primary
          : isOverBudget
          ? Colors.red.shade600
          : Colors.green.shade600;

      final Color remainingColor = isOverBudget
          ? Colors.red.shade600
          : Colors.orange.shade700;

      final double lastMonthTotal = controller.lastMonthTotal.value;
      final double percentChange = lastMonthTotal == 0
          ? 0.0
          : ((totalSpent - lastMonthTotal) / lastMonthTotal) * 100;

      final String healthLabel = _budgetHealthLabel(totalSpent, budget);
      final Color healthColor = _budgetHealthColor(totalSpent, budget);

      return Container(
        padding: EdgeInsets.all(compact ? 12 : 16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: theme.dividerColor.withValues(alpha: 0.4)),
          boxShadow: compact
              ? []
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "TOTAL SPENT",
                  style: theme.textTheme.labelLarge!.copyWith(
                    letterSpacing: 1.1,
                  ),
                ),
                if (!isReport)
                  _VsLastMonthChip(
                    percentChange: percentChange,
                    lastMonthTotal: lastMonthTotal,
                    compact: compact,
                  ),
              ],
            ),
            SizedBox(height: compact ? 8 : 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${totalSpent.toCurrency()} ৳",
                  style:
                      (compact
                              ? theme.textTheme.titleLarge
                              : theme.textTheme.displaySmall)!
                          .copyWith(
                            color: totalSpentColor,
                            fontWeight: FontWeight.bold,
                          ),
                ),
                if (!isReport)
                  Row(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: healthColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        healthLabel,
                        style: theme.textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.w600,
                          color: healthColor,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
            if (!isReport) ...[
              SizedBox(height: compact ? 10 : 14),
              BudgetProgressBar(
                budget: budget,
                expense: totalSpent,
                height: compact ? 6 : 8,
              ),
              SizedBox(height: compact ? 8 : 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Budget: ${budget.toCurrency()} ৳",
                    style: theme.textTheme.bodyMedium,
                  ),
                  Text(
                    isOverBudget
                        ? "Over budget: ${overAmount.toCurrency()} ৳"
                        : "Remaining: ${remaining.toCurrency()} ৳",
                    style: theme.textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.w600,
                      color: remainingColor,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      );
    });
  }
}

class BudgetProgressBar extends StatelessWidget {
  const BudgetProgressBar({
    super.key,
    required this.budget,
    required this.expense,
    this.height = 8,
  });

  final double budget;
  final double expense;
  final double height;

  @override
  Widget build(BuildContext context) {
    final double total = expense > budget ? expense : budget;
    final double spentWithinBudget = expense <= budget ? expense : budget;
    final double remainingBudget = expense < budget ? budget - expense : 0;
    final double overBudget = expense > budget ? expense - budget : 0;

    final double greenFrac = spentWithinBudget / total;
    final double yellowFrac = remainingBudget / total;
    final double redFrac = overBudget / total;

    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: SizedBox(
        height: height,
        child: Row(
          children: [
            if (greenFrac > 0)
              Expanded(
                flex: (greenFrac * 1000).round(),
                child: Container(color: Colors.green.shade600),
              ),
            if (yellowFrac > 0)
              Expanded(
                flex: (yellowFrac * 1000).round(),
                child: Container(color: Colors.orange.shade700),
              ),
            if (redFrac > 0)
              Expanded(
                flex: (redFrac * 1000).round(),
                child: Container(color: Colors.red.shade600),
              ),
          ],
        ),
      ),
    );
  }
}

class _VsLastMonthChip extends StatelessWidget {
  const _VsLastMonthChip({
    required this.percentChange,
    required this.compact,
    required this.lastMonthTotal,
  });

  final double percentChange;
  final double lastMonthTotal;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final bool isIncrease = percentChange > 0;
    final bool isSame = percentChange == 0;

    final Color color = isSame
        ? Colors.grey.shade600
        : isIncrease
        ? Colors.red.shade600
        : Colors.green.shade600;

    final String label = isSame
        ? "No change vs last month"
        : isIncrease
        ? "Spent ↑ ${percentChange.toStringAsFixed(0)}% vs last month"
        : "Spent ↓ ${percentChange.abs().toStringAsFixed(0)}% vs last month";

    return Tooltip(
      message: "Last month total: ${lastMonthTotal.toCurrency()} ৳",
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: compact ? 8 : 10,
          vertical: compact ? 4 : 6,
        ),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withValues(alpha: 0.4)),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w600,
            fontSize: compact ? 11 : 12,
          ),
        ),
      ),
    );
  }
}
