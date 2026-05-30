import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spendly/core/common/widgets/loader_widget.dart';
import 'package:spendly/core/common/widgets/no_data_widget.dart';
import 'package:spendly/core/common/widgets/expense_monthly_analysis.dart';
import 'package:spendly/core/common/widgets/custom_divider.dart';
import 'package:spendly/core/extensions/double_ext.dart';

import '../../domain/entities/expense_entity.dart';
import '../controllers/expense_controller.dart';
import 'expense_bar_chart.dart';

// ==========================================
// 1. Unified Main Summary Widget Container
// ==========================================
class ExpenseSummeryWidget extends StatelessWidget {
  const ExpenseSummeryWidget({
    super.key,
    required this.controller,
    this.isReport = false,
  });

  final ExpenseController controller;
  final bool isReport;

  List<ExpenseEntity> get _dataList {
    return isReport ? controller.reportExpenses : controller.expenses;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Obx(() {
        final data = _dataList;

        if (controller.isLoading.value) {
          return const Center(child: LoaderWidget());
        } else if (data.isEmpty) {
          return const Center(child: NoDataWidget());
        } else {
          return SingleChildScrollView(
            child: Column(
              children: [
                ExpenseSummery(expenses: data, isReport: isReport),
                if (isReport) ...[
                  const SizedBox(height: 16),
                  ExpenseMonthlyAnalysis(expenses: data),
                ],
                if (!isReport) ...[
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.35,
                    child: ExpenseBarChart(expenses: data),
                  ),
                ],
              ],
            ),
          );
        }
      }),
    );
  }
}

// ==========================================
// 2. Cohesive Expense Report Layout Sheet
// ==========================================
class ExpenseSummery extends StatelessWidget {
  const ExpenseSummery({
    super.key,
    required this.expenses,
    this.isReport = false,
  });

  final List<ExpenseEntity> expenses;
  final bool isReport;

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
          // 💳 Total Spent Card
          TotalSpentCard(isReport: isReport),

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

// ==========================================
// 3. Premium Interactive Balance/Spent Card
// ==========================================
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
          color: theme.colorScheme.primary.withValues(alpha: 0.25),
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
                  style: (compact
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

// ==========================================
// 4. Progress Bar helper for Budgets
// ==========================================
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

// ==========================================
// 5. vs Last Month comparative pill chip
// ==========================================
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
            ? " ↑ ${percentChange.toStringAsFixed(0)}% "
            : " ↓ ${percentChange.abs().toStringAsFixed(0)}% ";

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

// ==========================================
// 6. Category breakdown Summary Card
// ==========================================
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
          final percent = totalSpending == 0 ? 0 : (entry.value / totalSpending) * 100;

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

// ==========================================
// 7. Internal category breakdown row item
// ==========================================
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
