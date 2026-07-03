import 'package:finkeep/core/extensions/double_ext.dart';
import 'package:finkeep/core/responsive/responsive.dart';
import 'package:finkeep/core/styles/app_colors.dart';
import 'package:finkeep/core/styles/currency_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/budget_controller.dart';
import '../widgets/historical_budget_shimmer.dart';

class MissingBudgetScreen extends StatelessWidget {
  const MissingBudgetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BudgetController>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadPastMonthsBudgets();
    });
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.bgDark : AppColors.bgLight,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.bgDark : Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: isDark ? Colors.white : const Color(0xFF0F172A),
            size: 20.sp,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Historical Budgets',
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF0F172A),
            fontFamily: 'Manrope',
            fontWeight: FontWeight.bold,
            fontSize: 16.sp,
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.h),
          child: Container(
            color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
            height: 1.h,
          ),
        ),
      ),
      body: Stack(
        children: [
          Obx(() {
            if (controller.isPastMonthsLoading.value) {
              return const HistoricalBudgetShimmer();
            }

            final items = controller.pastMonthsBudgets;

            if (items.isEmpty) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(32.r),
                  child: Text(
                    'No previous months with expenses found.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontFamily: 'Manrope',
                      color: Colors.grey,
                    ),
                  ),
                ),
              );
            }

            return ListView.separated(
              padding: EdgeInsets.only(
                left: 16.w,
                right: 16.w,
                top: 16.h,
                bottom: 100.h,
              ),
              itemCount: items.length,
              separatorBuilder: (context, index) => SizedBox(height: 12.h),
              itemBuilder: (context, index) {
                final item = items[index];
                final monthName = DateFormat('MMMM yyyy').format(item.month);

                return Container(
                  padding: EdgeInsets.all(16.r),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.cardDark : Colors.white,
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(
                      color: isDark
                          ? const Color(0xFF334155)
                          : const Color(0xFFE2E8F0),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.02),
                        blurRadius: 10.r,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              monthName,
                              style: TextStyle(
                                fontFamily: 'Manrope',
                                fontWeight: FontWeight.bold,
                                fontSize: 13.sp,
                                color: isDark
                                    ? Colors.white
                                    : const Color(0xFF0F172A),
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              'Spent: ${item.totalExpense.toCurrency()} ${context.currency.symbol}',
                              style: TextStyle(
                                fontFamily: 'Manrope',
                                fontSize: 11.sp,
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        flex: 2,
                        child: Container(
                          height: 44.h,
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF0F172A)
                                : const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(10.r),
                            border: Border.all(
                              color: isDark
                                  ? const Color(0xFF1E293B)
                                  : const Color(0xFFE2E8F0),
                            ),
                          ),
                          child: Row(
                            children: [
                              Text(
                                context.currency.symbol,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                  color: isDark
                                      ? Colors.white60
                                      : Colors.black45,
                                ),
                              ),
                              SizedBox(width: 6.w),
                              Expanded(
                                child: TextField(
                                  controller: item.budgetTextController,
                                  keyboardType: TextInputType.number,
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    fontFamily: 'Manrope',
                                    fontWeight: FontWeight.bold,
                                    color: isDark
                                        ? Colors.white
                                        : const Color(0xFF0F172A),
                                  ),
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Budget',
                                    hintStyle: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }),
          Obx(() {
            final isLoading = controller.isPastMonthsLoading.value;

            if (isLoading) return const SizedBox.shrink();

            return Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.bgDark.withValues(alpha: 0.9)
                      : Colors.white.withValues(alpha: 0.9),
                  border: Border(
                    top: BorderSide(
                      color: isDark
                          ? const Color(0xFF1E293B)
                          : const Color(0xFFF1F5F9),
                    ),
                  ),
                ),
                child: SafeArea(
                  child: ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : () async {
                            final navigator = Navigator.of(context);
                            try {
                              await controller.savePastMonthsBudgets();
                              Get.snackbar(
                                'Success',
                                'Historical budgets saved successfully!',
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.green.shade600,
                                colorText: Colors.white,
                                margin: EdgeInsets.all(16.r),
                                borderRadius: 12.r,
                              );
                              navigator.pop();
                            } catch (e) {
                              Get.snackbar(
                                'Error',
                                'Failed to save historical budgets: $e',
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.red.shade600,
                                colorText: Colors.white,
                                margin: EdgeInsets.all(16.r),
                                borderRadius: 12.r,
                              );
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryTeal,
                      foregroundColor: Colors.white,
                      minimumSize: Size(double.infinity, 48.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      elevation: 2,
                    ),
                    child: isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.check_circle_outline_rounded,
                                size: 18.sp,
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                'Save Historical Budgets',
                                style: TextStyle(
                                  fontFamily: 'Manrope',
                                  fontWeight: FontWeight.w800,
                                  fontSize: 14.sp,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
