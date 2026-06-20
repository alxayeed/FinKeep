import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spendly/core/common/widgets/expense_monthly_analysis.dart';
import 'package:spendly/core/common/widgets/loader_widget.dart';
import 'package:spendly/core/responsive/responsive.dart';

import '../../../../core/enums/expense_category.dart';
import '../../domain/entities/expense_entity.dart';
import '../controllers/budget_controller.dart';
import '../controllers/expense_report_controller.dart';
import 'budget_progress_card.dart';
import 'category_summary_list.dart';
import 'expense_bar_chart.dart';
import 'payment_medium_chart.dart';

// ==========================================
// 1. Unified Main Summary Widget Container
// ==========================================
class ExpenseSummeryWidget extends StatelessWidget {
  const ExpenseSummeryWidget({
    super.key,
    required this.controller,
    this.isReport = false,
  });

  final ExpenseReportController controller;
  final bool isReport;

  List<ExpenseEntity> get _dataList {
    return isReport ? controller.reportExpenses : [];
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Obx(() {
        final data = _dataList;

        if (controller.isLoading.value) {
          return const Center(child: LoaderWidget());
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

    final reportController = Get.find<ExpenseReportController>();
    final budgetController = Get.find<BudgetController>();
    final calculatedBudget = isReport
        ? reportController.reportRangeBudget.value
        : budgetController.monthlyBudget.value;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 8.h,
      children: [
        // 💳 Total Spent Card
        BudgetProgressCard(spent: totalSpending, budget: calculatedBudget),

        // 💳 Spending Medium Chart
        PaymentMediumChart(expenses: expenses),

        // 📊 Summary by Category
        SummaryByCategoryWidget(expenses: expenses),
      ],
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
