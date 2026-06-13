import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:spendly/core/enums/expense_category.dart';
import 'package:spendly/core/responsive/responsive.dart';
import 'package:spendly/core/routes/app_router.dart';
import 'package:spendly/core/styles/app_colors.dart';

import '../controllers/expense_controller.dart';
import '../widgets/widgets.dart';

class MonthlyExpenseSummaryScreen extends StatelessWidget {
  final ExpenseController controller;
  final ValueChanged<ExpenseCategory> onCategoryTap;

  const MonthlyExpenseSummaryScreen({
    super.key,
    required this.controller,
    required this.onCategoryTap,
  });

  Widget _buildEmptyState(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return RefreshIndicator(
      onRefresh: () async {
        controller.shouldRefresh = true;
        await controller.fetchMonthlyExpenses();
      },
      color: AppColors.primaryTeal,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(height: 150.h),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.receipt_long_rounded,
                  size: 64.sp,
                  color: isDark ? Colors.white10 : Colors.black12,
                ),
                SizedBox(height: 16.h),
                Text(
                  'No Expenses Registered',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white38 : const Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final double totalSpent = controller.totalExpense.value;
      final double totalBudget = controller.monthlyBudget.value;

      if (controller.expenses.isEmpty) {
        return _buildEmptyState(context);
      }

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
              // Spending by medium pie chart
              PaymentMediumChart(expenses: controller.expenses),
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
