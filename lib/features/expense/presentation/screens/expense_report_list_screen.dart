import 'package:finkeep/core/common/widgets/no_data_widget.dart';
import 'package:finkeep/core/config/app_config.dart';
import 'package:finkeep/core/common/widgets/privacy_text.dart';
import 'package:finkeep/core/enums/payment_type.dart';
import 'package:finkeep/core/responsive/responsive.dart';
import 'package:finkeep/core/styles/app_colors.dart';
import 'package:finkeep/core/styles/currency_provider.dart';
import 'package:finkeep/features/expense/domain/entities/expense_entity.dart';
import 'package:finkeep/features/expense/domain/entities/expense_pdf_report_config.dart';
import 'package:finkeep/features/expense/presentation/controllers/expense_report_controller.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../widgets/widgets.dart';

class ExpenseReportListScreen extends StatelessWidget {
  final ExpenseReportController controller;

  const ExpenseReportListScreen({super.key, required this.controller});

  Future<void> _handleRefresh() async {
    if (controller.startDate.value != null &&
        controller.endDate.value != null) {
      await controller.fetchExpensesInRange(
        controller.startDate.value!,
        controller.endDate.value!,
      );
    }
  }



  Widget _buildTopSummaryBar(
    BuildContext context,
    bool isDark,
    int count,
    double total, {
    bool isGrouped = false,
  }) {
    final countLabel = isGrouped
        ? '$count ${count == 1 ? "Category Group" : "Category Groups"}'
        : '$count ${count == 1 ? "Transaction" : "Transactions"}';

    final cardBorder = isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0);

    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: cardBorder),
      ),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Icon(
                  Icons.receipt_long_rounded,
                  size: 15.sp,
                  color: AppColors.primaryTeal,
                ),
                SizedBox(width: 6.w),
                Expanded(
                  child: Text(
                    countLabel,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 11.5.sp,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white70 : const Color(0xFF475569),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Total: ',
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 11.5.sp,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white70 : const Color(0xFF475569),
                ),
              ),
              PrivacyText(
                total,
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 12.5.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primaryTeal,
                ),
              ),
              SizedBox(width: 2.w),
              FaIcon(
                context.currency.icon,
                size: 8.5.sp,
                color: AppColors.primaryTeal,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCompactListView(
    BuildContext context,
    bool isDark,
    List<CompactExpenseRow> groupedRows,
    double totalAmount,
  ) {
    final textColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final mutedColor = isDark ? Colors.white60 : const Color(0xFF64748B);
    final cardBorder = isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0);

    return RefreshIndicator(
      onRefresh: _handleRefresh,
      color: AppColors.primaryTeal,
      notificationPredicate: (notification) =>
          AppConfig.useRemote &&
          defaultScrollNotificationPredicate(notification),
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.only(bottom: 100.h, left: 16.w, right: 16.w, top: 4.h),
        itemCount: groupedRows.length + 2,
        itemBuilder: (context, index) {
          if (index == 0) {
            return _buildTopSummaryBar(
              context,
              isDark,
              groupedRows.length,
              totalAmount,
              isGrouped: true,
            );
          }

          if (index == 1) {
            // Table Column Headers
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 9.h),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.r),
                  topRight: Radius.circular(10.r),
                ),
                border: Border.all(color: cardBorder),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 70.w,
                    child: Text(
                      'Date',
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 11.sp,
                        fontWeight: FontWeight.bold,
                        color: mutedColor,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Category (Grouped)',
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 11.sp,
                        fontWeight: FontWeight.bold,
                        color: mutedColor,
                      ),
                    ),
                  ),
                  Text(
                    'Total Amount',
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 11.sp,
                      fontWeight: FontWeight.bold,
                      color: mutedColor,
                    ),
                  ),
                ],
              ),
            );
          }

          final row = groupedRows[index - 2];
          final isEven = (index - 2) % 2 == 1;
          final isLast = index == groupedRows.length + 1;

          return Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: isEven
                  ? (isDark ? const Color(0xFF161E2E).withValues(alpha: 0.6) : const Color(0xFFF8FAFC))
                  : (isDark ? const Color(0xFF0F172A).withValues(alpha: 0.4) : Colors.white),
              borderRadius: isLast
                  ? BorderRadius.only(
                      bottomLeft: Radius.circular(10.r),
                      bottomRight: Radius.circular(10.r),
                    )
                  : BorderRadius.zero,
              border: Border(
                left: BorderSide(color: cardBorder),
                right: BorderSide(color: cardBorder),
                bottom: BorderSide(color: cardBorder),
              ),
            ),
            child: Row(
              children: [
                // Date
                SizedBox(
                  width: 70.w,
                  child: Text(
                    DateFormat('dd MMM').format(row.date),
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 11.5.sp,
                      fontWeight: FontWeight.w600,
                      color: mutedColor,
                    ),
                  ),
                ),
                // Category
                Expanded(
                  child: Text(
                    row.category,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 12.5.sp,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                ),
                // Total Amount
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    PrivacyText(
                      row.totalAmount,
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 12.5.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryTeal,
                      ),
                    ),
                    SizedBox(width: 2.w),
                    FaIcon(
                      context.currency.icon,
                      size: 9.sp,
                      color: AppColors.primaryTeal,
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailsListView(
    BuildContext context,
    bool isDark,
    List<ExpenseEntity> expenses,
    double totalAmount,
  ) {
    final textColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final mutedColor = isDark ? Colors.white60 : const Color(0xFF64748B);
    final cardBorder = isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0);

    return RefreshIndicator(
      onRefresh: _handleRefresh,
      color: AppColors.primaryTeal,
      notificationPredicate: (notification) =>
          AppConfig.useRemote &&
          defaultScrollNotificationPredicate(notification),
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.only(bottom: 100.h, left: 16.w, right: 16.w, top: 4.h),
        itemCount: expenses.length + 2,
        itemBuilder: (context, index) {
          if (index == 0) {
            return _buildTopSummaryBar(
              context,
              isDark,
              expenses.length,
              totalAmount,
              isGrouped: false,
            );
          }

          if (index == 1) {
            // Table Column Headers
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.r),
                  topRight: Radius.circular(10.r),
                ),
                border: Border.all(color: cardBorder),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 56.w,
                    child: Text(
                      'Date',
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 11.sp,
                        fontWeight: FontWeight.bold,
                        color: mutedColor,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Category / Note',
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 11.sp,
                        fontWeight: FontWeight.bold,
                        color: mutedColor,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 58.w,
                    child: Text(
                      'Payment',
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 11.sp,
                        fontWeight: FontWeight.bold,
                        color: mutedColor,
                      ),
                    ),
                  ),
                  Text(
                    'Amount',
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 11.sp,
                      fontWeight: FontWeight.bold,
                      color: mutedColor,
                    ),
                  ),
                ],
              ),
            );
          }

          final expense = expenses[index - 2];
          final isEven = (index - 2) % 2 == 1;
          final isLast = index == expenses.length + 1;

          return Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 9.h),
            decoration: BoxDecoration(
              color: isEven
                  ? (isDark ? const Color(0xFF161E2E).withValues(alpha: 0.6) : const Color(0xFFF8FAFC))
                  : (isDark ? const Color(0xFF0F172A).withValues(alpha: 0.4) : Colors.white),
              borderRadius: isLast
                  ? BorderRadius.only(
                      bottomLeft: Radius.circular(10.r),
                      bottomRight: Radius.circular(10.r),
                    )
                  : BorderRadius.zero,
              border: Border(
                left: BorderSide(color: cardBorder),
                right: BorderSide(color: cardBorder),
                bottom: BorderSide(color: cardBorder),
              ),
            ),
            child: Row(
              children: [
                // Date
                SizedBox(
                  width: 56.w,
                  child: Text(
                    DateFormat('dd MMM').format(expense.date),
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: mutedColor,
                    ),
                  ),
                ),
                // Category & optional description
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        expense.category,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'Manrope',
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      if (expense.description.trim().isNotEmpty) ...[
                        SizedBox(height: 1.h),
                        Text(
                          expense.description.trim(),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                            fontFamily: 'Manrope',
                            fontSize: 10.sp,
                            color: mutedColor,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                // Payment Medium Tag
                SizedBox(
                  width: 58.w,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFEEF2F6),
                        borderRadius: BorderRadius.circular(5.r),
                      ),
                      child: Text(
                        expense.paymentMethod.displayName,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'Manrope',
                          fontSize: 9.5.sp,
                          fontWeight: FontWeight.w600,
                          color: mutedColor,
                        ),
                      ),
                    ),
                  ),
                ),
                // Amount
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    PrivacyText(
                      expense.amount,
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryTeal,
                      ),
                    ),
                    SizedBox(width: 2.w),
                    FaIcon(
                      context.currency.icon,
                      size: 8.5.sp,
                      color: AppColors.primaryTeal,
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Obx(() {
      if (controller.isLoading.value) {
        return const MonthlyExpenseShimmer(selectedTab: 1);
      }

      final filteredExpenses = controller.reportFilteredExpenses;

      if (filteredExpenses.isEmpty) {
        return RefreshIndicator(
          onRefresh: _handleRefresh,
          color: AppColors.primaryTeal,
          notificationPredicate: (notification) =>
              AppConfig.useRemote &&
              defaultScrollNotificationPredicate(notification),
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              SizedBox(height: 150.h),
              const Center(child: NoDataWidget()),
            ],
          ),
        );
      }

      final totalAmount = filteredExpenses.fold(0.0, (sum, e) => sum + e.amount);

      // 1. Compact Mode -> Grouped Records Table (Date + Category + Total Amount)
      if (controller.listMode.value == ExpenseReportPdfMode.compact) {
        final groupedRows = groupExpensesForCompactMode(filteredExpenses);
        return _buildCompactListView(context, isDark, groupedRows, totalAmount);
      }

      // 2. Details Mode -> All Itemized Records Table (Date + Category/Note + Payment + Amount)
      return _buildDetailsListView(context, isDark, filteredExpenses, totalAmount);
    });
  }
}
