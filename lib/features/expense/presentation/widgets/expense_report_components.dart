import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:finkeep/core/config/app_config.dart';
import 'package:finkeep/core/common/widgets/expense_monthly_analysis.dart';
import 'package:finkeep/core/common/widgets/loader_widget.dart';
import 'package:finkeep/core/responsive/responsive.dart';
import 'package:finkeep/core/styles/app_colors.dart';
import 'package:finkeep/core/extensions/double_ext.dart';
import 'package:finkeep/core/styles/currency_provider.dart';

import '../../domain/entities/expense_entity.dart';
import '../controllers/budget_controller.dart';
import '../controllers/expense_report_controller.dart';
import '../controllers/expense_category_controller.dart';
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
          final scrollView = SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
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

          if (isReport) {
            return RefreshIndicator(
              onRefresh: () async {
                final start = controller.startDate.value;
                final end = controller.endDate.value;
                if (start != null && end != null) {
                  await controller.fetchExpensesInRange(start, end);
                }
              },
              color: AppColors.primaryTeal,
              notificationPredicate: (notification) =>
                  AppConfig.useRemote &&
                  defaultScrollNotificationPredicate(notification),
              child: scrollView,
            );
          }
          return scrollView;
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

  Future<void> _showBudgetBreakdownBottomSheet(
    BuildContext context,
    double totalBudget,
    DateTime start,
    DateTime end,
  ) async {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textCol = isDark ? Colors.white : const Color(0xFF0F172A);
    final borderCol = isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0);
    final subtitleColor = isDark ? Colors.white60 : const Color(0xFF64748B);

    final budgetController = Get.find<BudgetController>();

    // Calculate month breakdown
    final List<Map<String, dynamic>> breakdown = [];
    var current = DateTime(start.year, start.month, 1);
    final limitDate = DateTime(end.year, end.month, 1);

    while (!current.isAfter(limitDate)) {
      final overallBudget = await budgetController.getBudgetForMonth(current);

      breakdown.add({
        'monthLabel': DateFormat('MMMM yyyy').format(current),
        'monthlyBudget': overallBudget,
      });

      current = DateTime(current.year, current.month + 1, 1);
    }

    if (!context.mounted) return;
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppColors.bgDark : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20.r,
            right: 20.r,
            top: 20.r,
            bottom: MediaQuery.of(context).padding.bottom + 20.r,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Budget Breakdown',
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: textCol,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              Text(
                'Range: ${DateFormat('dd MMM yyyy').format(start)} - ${DateFormat('dd MMM yyyy').format(end)}',
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 12.sp,
                  color: subtitleColor,
                ),
              ),
              SizedBox(height: 16.h),
              ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 250.h),
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: breakdown.length,
                  separatorBuilder: (context, index) => Divider(color: borderCol),
                  itemBuilder: (context, index) {
                    final item = breakdown[index];
                    final monthLabel = item['monthLabel'] as String;
                    final monthlyBudget = item['monthlyBudget'] as double;

                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 6.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            monthLabel,
                            style: TextStyle(
                              fontFamily: 'Manrope',
                              fontSize: 13.sp,
                              fontWeight: FontWeight.bold,
                              color: textCol,
                            ),
                          ),
                          Text(
                            '${monthlyBudget.toCurrency()} ${context.currency.symbol}',
                            style: TextStyle(
                              fontFamily: 'Manrope',
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primaryTeal,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Divider(color: borderCol, thickness: 1.5),
              SizedBox(height: 8.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Budget',
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: textCol,
                    ),
                  ),
                  Text(
                    '${totalBudget.toCurrency()} ${context.currency.symbol}',
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primaryTeal,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

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
        GestureDetector(
          onTap: isReport
              ? () async {
                  final start = reportController.startDate.value;
                  final end = reportController.endDate.value;
                  if (start != null && end != null) {
                    await _showBudgetBreakdownBottomSheet(
                      context,
                      calculatedBudget,
                      start,
                      end,
                    );
                  }
                }
              : null,
          child: Obx(() {
            final budgetVal = isReport
                ? reportController.reportRangeBudget.value
                : budgetController.monthlyBudget.value;
            return BudgetProgressCard(spent: totalSpending, budget: budgetVal);
          }),
        ),

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
  Map<String, double> _calculateCategorySpending() {
    final Map<String, double> spending = {};
    final categoryController = Get.find<ExpenseCategoryController>();

    for (final expense in expenses) {
      final resolved = categoryController.resolveCategory(expense.category);
      spending.update(
        resolved.id,
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
