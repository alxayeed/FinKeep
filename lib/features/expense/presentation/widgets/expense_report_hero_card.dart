import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/common/models/date_filter.dart';
import '../../domain/entities/expense_entity.dart';
import '../controllers/budget_controller.dart';
import '../controllers/expense_report_controller.dart';
import 'budget_progress_card.dart';
import 'category_focus_card.dart';
import 'period_summary_card.dart';

/// Context-aware hero card that dynamically renders:
/// 1. [CategoryFocusCard] when specific category filters are active.
/// 2. [PeriodSummaryCard] when an arbitrary custom date range is active.
/// 3. [BudgetProgressCard] when viewing all categories over standard periods (Month / Year / Fiscal Year).
class ExpenseReportHeroCard extends StatelessWidget {
  final List<ExpenseEntity> expenses;
  final bool isReport;
  final VoidCallback? onBudgetTap;

  const ExpenseReportHeroCard({
    super.key,
    required this.expenses,
    this.isReport = false,
    this.onBudgetTap,
  });

  @override
  Widget build(BuildContext context) {
    if (!isReport) {
      // Normal Monthly Expense Screen -> standard budget progress card
      final budgetController = Get.find<BudgetController>();
      return Obx(() {
        final double totalSpending =
            expenses.fold(0.0, (sum, e) => sum + e.amount);
        return BudgetProgressCard(
          spent: totalSpending,
          budget: budgetController.monthlyBudget.value,
        );
      });
    }

    final reportController = Get.find<ExpenseReportController>();

    return Obx(() {
      final double totalSpending =
          expenses.fold(0.0, (sum, e) => sum + e.amount);
      final List<String> selectedCats = reportController.selectedCategories;
      final DateFilter filter = reportController.dateFilter.value;

      // 1. Specific Category/Categories Selected -> Category Focus Card
      if (selectedCats.isNotEmpty) {
        final double totalPeriod = reportController.reportExpenses
            .fold(0.0, (sum, e) => sum + e.amount);
        return CategoryFocusCard(
          categoryExpenses: expenses,
          totalPeriodSpending: totalPeriod,
          selectedCategories: selectedCats.toList(),
        );
      }

      // 2. Custom Date Range -> Period Summary Card
      if (filter.type == DateFilterType.custom) {
        final now = DateTime.now();
        final start = reportController.startDate.value ??
            filter.dateRange?.start ??
            DateTime(now.year, now.month, 1);
        final end = reportController.endDate.value ??
            filter.dateRange?.end ??
            DateTime(now.year, now.month, now.day);

        return PeriodSummaryCard(
          expenses: expenses,
          startDate: start,
          endDate: end,
        );
      }

      // 3. Standard Period with All Categories -> Budget Progress Card
      final double budgetVal = reportController.reportRangeBudget.value;
      return GestureDetector(
        onTap: onBudgetTap,
        child: BudgetProgressCard(
          spent: totalSpending,
          budget: budgetVal,
        ),
      );
    });
  }
}
