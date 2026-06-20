import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:spendly/core/enums/expense_category.dart';
import 'package:spendly/core/responsive/responsive.dart';
import 'package:spendly/core/routes/app_router.dart';
import 'package:spendly/core/styles/app_colors.dart';

import '../controllers/monthly_expense_controller.dart';
import '../widgets/widgets.dart';

class MonthlyExpenseSummaryScreen extends StatelessWidget {
  final MonthlyExpenseController controller;
  final ValueChanged<ExpenseCategory> onCategoryTap;

  const MonthlyExpenseSummaryScreen({
    super.key,
    required this.controller,
    required this.onCategoryTap,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final double totalSpent = controller.totalExpense.value;
      final double totalBudget = controller.monthlyBudget.value;

      // Compute dynamic category totals from raw controller.expenses
      final Map<ExpenseCategory, double> spentByCategory = {};
      final Map<ExpenseCategory, double> budgetsByCategory = {};

      for (var category in ExpenseCategory.values) {
        final spent = controller.expenses
            .where(
              (e) =>
                  e.category.toLowerCase() ==
                  category.displayName.toLowerCase(),
            )
            .fold(0.0, (sum, item) => sum + item.amount);
        spentByCategory[category] = spent;

        // Retrieve user-configured budget limit from controller
        final limit = controller.categoryBudgets[category];
        if (limit != null) {
          budgetsByCategory[category] = limit;
        }
      }

      return RefreshIndicator(
        onRefresh: () async {
          controller.shouldRefresh = true;
          await controller.fetchMonthlyExpenses();
        },
        color: AppColors.primaryTeal,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              // Total budget vs spent slider card (clickable)
              GestureDetector(
                onTap: () {
                  final now = DateTime.now();
                  final currentMonthStart = DateTime(now.year, now.month);
                  final selected = DateTime(
                    controller.selectedMonth.value.year,
                    controller.selectedMonth.value.month,
                  );
                  final targetMonth = selected.isBefore(currentMonthStart)
                      ? now
                      : controller.selectedMonth.value;
                  context.pushNamed(
                    AppRoutes.setMonthlyBudget,
                    extra: targetMonth,
                  );
                },
                child: BudgetProgressCard(
                  spent: totalSpent,
                  budget: totalBudget,
                ),
              ),
              SizedBox(height: 8.h),
              // Spending by medium pie chart
              PaymentMediumChart(expenses: controller.expenses),
              SizedBox(height: 8.h),

              // Category spending checklist
              CategorySummaryList.detailed(
                spentByCategory: spentByCategory,
                budgetsByCategory: budgetsByCategory,
                onCategoryTap: onCategoryTap,
              ),
              SizedBox(height: 100.h),
              // Safe spacing for bottom navigation overlap
            ],
          ),
        ),
      );
    });
  }
}
