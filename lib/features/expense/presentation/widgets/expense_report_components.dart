import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spendly/core/common/widgets/custom_divider.dart';
import 'package:spendly/core/common/widgets/expense_monthly_analysis.dart';
import 'package:spendly/core/common/widgets/loader_widget.dart';
import 'package:spendly/core/common/widgets/no_data_widget.dart';
import 'package:spendly/core/responsive/responsive.dart';

import '../../../../core/enums/expense_category.dart';
import '../../domain/entities/expense_entity.dart';
import '../controllers/expense_report_controller.dart';
import '../controllers/budget_controller.dart';
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

    final reportController = Get.find<ExpenseReportController>();
    final budgetController = Get.find<BudgetController>();
    final startDate = reportController.startDate.value;
    final endDate = reportController.endDate.value;
    double calculatedBudget = budgetController.monthlyBudget.value;
    if (isReport && startDate != null && endDate != null) {
      final days = endDate.difference(startDate).inDays + 1;
      calculatedBudget = (budgetController.monthlyBudget.value / 30.0) * days;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 💳 Total Spent Card
        BudgetProgressCard(spent: totalSpending, budget: calculatedBudget),

        SizedBox(height: 16.h),

        // 💳 Spending Medium Chart
        PaymentMediumChart(expenses: expenses),

        SizedBox(height: 16.h),

        // 📊 Summary by Category
        SummaryByCategoryWidget(expenses: expenses),

        SizedBox(height: 12.h),
        const CustomDivider(),
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
