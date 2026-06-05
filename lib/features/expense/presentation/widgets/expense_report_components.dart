import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:spendly/core/common/widgets/custom_divider.dart';
import 'package:spendly/core/common/widgets/expense_monthly_analysis.dart';
import 'package:spendly/core/common/widgets/loader_widget.dart';
import 'package:spendly/core/common/widgets/no_data_widget.dart';
import 'package:spendly/core/extensions/double_ext.dart';
import 'package:spendly/core/responsive/responsive.dart';
import 'package:spendly/core/styles/app_colors.dart';

import '../../../../core/enums/expense_category.dart';
import '../../domain/entities/expense_entity.dart';
import '../controllers/expense_controller.dart';
import 'category_summary_list.dart';
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
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Obx(() {
        final data = _dataList;

        if (controller.isLoading.value) {
          return const Center(child: LoaderWidget());
        } else if (data.isEmpty) {
          return const Center(child: NoDataWidget());
        } else {
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                ExpenseSummery(expenses: data, isReport: isReport),
                if (isReport) ...[
                  SizedBox(height: 16.h),
                  ExpenseMonthlyAnalysis(expenses: data),
                ],
                if (!isReport) ...[
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.35,
                    child: ExpenseBarChart(expenses: data),
                  ),
                ],
                SizedBox(height: 100.h),
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
      return Padding(
        padding: EdgeInsets.all(16.r),
        child: Center(
          child: Text(
            "No expenses recorded.",
            style: TextStyle(
              fontSize: 13.sp,
              fontFamily: 'Manrope',
              color: Colors.grey,
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 💳 Total Spent Card
        TotalSpentCard(isReport: isReport),

        SizedBox(height: 16.h),

        // 📊 Summary by Category
        SummaryByCategoryWidget(expenses: expenses),

        SizedBox(height: 12.h),
        const CustomDivider(),
      ],
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
    final isDark = theme.brightness == Brightness.dark;
    final controller = Get.find<ExpenseController>();

    return Obx(() {
      final double totalSpent = isReport
          ? controller.reportExpenses.fold(0.0, (sum, e) => sum + e.amount)
          : controller.totalExpense.value;

      final double budget = controller.monthlyBudget.value;
      final bool isOverBudget = totalSpent > budget;
      final double remaining = (budget - totalSpent).clamp(0.0, budget);
      final double overAmount = isOverBudget ? (totalSpent - budget) : 0;

      final Color totalSpentColor = isDark
          ? Colors.white
          : const Color(0xFF0F172A);

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
        padding: EdgeInsets.all(compact ? 12.r : 16.r),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : AppColors.cardLight,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10.r,
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
                  style: TextStyle(
                    fontSize: 11,
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white38 : const Color(0xFF64748B),
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
            SizedBox(height: compact ? 8.h : 12.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: .center,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      totalSpent.toCurrency(),
                      style: TextStyle(
                        fontSize: compact ? 18 : 28,
                        fontFamily: 'Manrope',
                        fontWeight: FontWeight.bold,
                        color: totalSpentColor,
                      ),
                    ),
                    SizedBox(width: 3.w),
                    FaIcon(
                      FontAwesomeIcons.bangladeshiTakaSign,
                      size: compact ? 12 : 18,
                      color: isDark ? Colors.white70 : const Color(0xFF0F172A),
                    ),
                  ],
                ),
                if (!isReport)
                  Row(
                    children: [
                      Container(
                        width: 8.r,
                        height: 8.r,
                        decoration: BoxDecoration(
                          color: healthColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        healthLabel,
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'Manrope',
                          fontWeight: FontWeight.w600,
                          color: healthColor,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
            if (!isReport) ...[
              SizedBox(height: compact ? 10.h : 14.h),
              BudgetProgressBar(
                budget: budget,
                expense: totalSpent,
                height: compact ? 6.h : 8.h,
              ),
              SizedBox(height: compact ? 8.h : 12.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Budget: ${budget.toCurrency()} ৳",
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: 'Manrope',
                      color: isDark ? Colors.white54 : const Color(0xFF64748B),
                    ),
                  ),
                  Text(
                    isOverBudget
                        ? "Over budget: ${overAmount.toCurrency()} ৳"
                        : "Remaining: ${remaining.toCurrency()} ৳",
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: 'Manrope',
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
      borderRadius: BorderRadius.circular(6.r),
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
          horizontal: compact ? 8.w : 10.w,
          vertical: compact ? 4.h : 6.h,
        ),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: color.withValues(alpha: 0.4)),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w600,
            fontSize: compact ? 10.sp : 11.sp,
          ),
        ),
      ),
    );
  }
}

class SummaryByCategoryWidget extends StatelessWidget {
  const SummaryByCategoryWidget({super.key, required this.expenses});

  final List<ExpenseEntity> expenses;

  // Calculate total spending per category
  Map<ExpenseCategory, double> _calculateCategorySpending() {
    final Map<ExpenseCategory, double> spending = {};

    for (final expense in expenses) {
      final cat = ExpenseCategoryExtension.fromString(expense.category);
      spending.update(
        cat,
        (value) => value + expense.amount,
        ifAbsent: () => expense.amount,
      );
    }

    return spending;
  }

  @override
  Widget build(BuildContext context) {
    final categorySpending = _calculateCategorySpending();

    return CategorySummaryList.compact(spentByCategory: categorySpending);
  }
}
