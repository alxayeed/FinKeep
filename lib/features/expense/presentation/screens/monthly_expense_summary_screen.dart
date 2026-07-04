import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:finkeep/core/config/app_config.dart';
import 'package:finkeep/core/responsive/responsive.dart';
import 'package:finkeep/core/routes/app_router.dart';
import 'package:finkeep/core/styles/app_colors.dart';
import '../../../../core/enums/expense_category.dart';

import '../controllers/monthly_expense_controller.dart';
import '../controllers/expense_category_controller.dart';
import '../widgets/widgets.dart';

class MonthlyExpenseSummaryScreen extends StatelessWidget {
  final MonthlyExpenseController controller;
  final ValueChanged<String> onCategoryTap;

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
      final ExpenseCategoryController categoryController = Get.find();

      // Compute dynamic category totals from raw controller.expenses
      final Map<String, double> spentByCategory = {};
      final Map<String, double> budgetsByCategory = {};

      for (var category in categoryController.categories.where((c) => !c.isDeleted)) {
        final spent = controller.expenses
            .where(
              (e) =>
                  e.category.toLowerCase() ==
                  category.displayLabel.toLowerCase(),
            )
            .fold(0.0, (sum, item) => sum + item.amount);
        spentByCategory[category.id] = spent;

        // Retrieve user-configured budget limit from controller matching core category enum
        final coreEnum = ExpenseCategory.values.firstWhereOrNull(
          (e) => e.displayName.toLowerCase() == category.displayLabel.toLowerCase(),
        );
        if (coreEnum != null) {
          final limit = controller.categoryBudgets[coreEnum];
          if (limit != null) {
            budgetsByCategory[category.id] = limit;
          }
        }
      }

      return RefreshIndicator(
        onRefresh: () async {
          controller.shouldRefresh = true;
          await controller.fetchMonthlyExpenses();
        },
        color: AppColors.primaryTeal,
        notificationPredicate: (notification) =>
            AppConfig.useRemote &&
            defaultScrollNotificationPredicate(notification),
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
