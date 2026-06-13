import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:spendly/core/enums/expense_category.dart';
import 'package:spendly/core/responsive/responsive.dart';
import 'package:spendly/core/styles/app_colors.dart';
import 'package:spendly/core/extensions/double_ext.dart';
import '../controllers/budget_controller.dart';

class SetMonthlyBudgetScreen extends StatelessWidget {
  final DateTime month;

  const SetMonthlyBudgetScreen({
    super.key,
    required this.month,
  });

  IconData _getIconForCategory(ExpenseCategory category) {
    switch (category) {
      case ExpenseCategory.food:
        return Icons.restaurant_rounded;
      case ExpenseCategory.transport:
        return Icons.directions_car_rounded;
      case ExpenseCategory.family:
        return Icons.family_restroom_rounded;
      case ExpenseCategory.personal:
        return Icons.person_rounded;
      case ExpenseCategory.lend:
        return Icons.handshake_rounded;
      case ExpenseCategory.clothing:
        return Icons.shopping_bag_rounded;
      case ExpenseCategory.hangout:
        return Icons.local_activity_rounded;
      case ExpenseCategory.utilities:
        return Icons.bolt_rounded;
      case ExpenseCategory.other:
        return Icons.category_rounded;
    }
  }

  Color _getColorForCategory(ExpenseCategory category) {
    switch (category) {
      case ExpenseCategory.food:
        return Colors.orange.shade600;
      case ExpenseCategory.transport:
        return const Color(0xFF059669);
      case ExpenseCategory.family:
        return Colors.blue.shade600;
      case ExpenseCategory.personal:
        return Colors.purple.shade600;
      case ExpenseCategory.lend:
        return Colors.teal.shade600;
      case ExpenseCategory.clothing:
        return Colors.pink.shade600;
      case ExpenseCategory.hangout:
        return Colors.amber.shade700;
      case ExpenseCategory.utilities:
        return Colors.indigo.shade600;
      case ExpenseCategory.other:
        return const Color(0xFF475569);
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BudgetController>();
    controller.initUi(month);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final monthLabel = DateFormat('MMMM yyyy').format(month);

    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          controller.disposeUi();
        }
      },
      child: Scaffold(
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
          'Set Monthly Budget',
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
          SingleChildScrollView(
            padding: EdgeInsets.only(
              left: 16.w,
              right: 16.w,
              top: 16.h,
              bottom: 100.h,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Month Label Banner
                Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: AppColors.primaryTeal.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(99.r),
                    ),
                    child: Text(
                      'Target Month: $monthLabel',
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        fontWeight: FontWeight.bold,
                        fontSize: 12.sp,
                        color: AppColors.primaryTeal,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16.h),

                // Overall Budget Card
                Container(
                  padding: EdgeInsets.all(20.r),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.cardDark : Colors.white,
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(
                      color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.02),
                        blurRadius: 10.r,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Total Monthly Budget',
                        style: TextStyle(
                          fontFamily: 'Manrope',
                          fontWeight: FontWeight.w800,
                          fontSize: 16.sp,
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        "What's your overall spending limit?",
                        style: TextStyle(
                          fontFamily: 'Manrope',
                          fontSize: 11.sp,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: 20.h),
                      Container(
                        height: 64.h,
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                          ),
                        ),
                        child: Row(
                          children: [
                            Text(
                              '৳',
                              style: TextStyle(
                                fontSize: 24.sp,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white60 : Colors.black45,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: TextField(
                                controller: controller.overallTextController,
                                keyboardType: TextInputType.number,
                                style: TextStyle(
                                  fontSize: 22.sp,
                                  fontFamily: 'Manrope',
                                  fontWeight: FontWeight.w800,
                                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                                ),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: '30,000',
                                  hintStyle: TextStyle(color: Colors.grey),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24.h),

                // Real-time Sum / Validation Alert
                Obx(() {
                  if (controller.isExceeded) {
                    return Container(
                      margin: EdgeInsets.only(bottom: 24.h),
                      padding: EdgeInsets.all(14.r),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50.withValues(alpha: 0.8),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(color: Colors.orange.shade200),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.warning_amber_rounded, color: Colors.orange.shade800, size: 20.sp),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: Text(
                              'Category budgets (${controller.totalCategorySum.toCurrency()} ৳) exceed overall budget (${controller.overallBudget.value.toCurrency()} ৳). Overall budget will be auto-increased on save.',
                              style: TextStyle(
                                fontSize: 10.5.sp,
                                fontFamily: 'Manrope',
                                fontWeight: FontWeight.w500,
                                color: Colors.orange.shade900,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                }),

                // Recurring switch
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.cardDark : Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Recurring Budget',
                            style: TextStyle(
                              fontFamily: 'Manrope',
                              fontWeight: FontWeight.bold,
                              fontSize: 13.sp,
                              color: isDark ? Colors.white : const Color(0xFF0F172A),
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            'Apply these settings to following months',
                            style: TextStyle(
                              fontFamily: 'Manrope',
                              fontSize: 10.sp,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      Obx(() => Switch.adaptive(
                            value: controller.isRecurring.value,
                            activeTrackColor: AppColors.primaryTeal,
                            onChanged: (val) {
                              controller.isRecurring.value = val;
                            },
                          )),
                    ],
                  ),
                ),
                SizedBox(height: 24.h),

                // Category Section Header
                Text(
                  'Category Budgets',
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.w800,
                    fontSize: 16.sp,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  'Enable specific limits for categories to track spending habits.',
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 11.sp,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 12.h),

                // Category List
                Container(
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.cardDark : Colors.white,
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(
                      color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                    ),
                  ),
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: ExpenseCategory.values.length,
                    separatorBuilder: (context, index) => Divider(
                      height: 1.h,
                      color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                    ),
                    itemBuilder: (context, index) {
                      final category = ExpenseCategory.values[index];
                      final catColor = _getColorForCategory(category);
                      final catIcon = _getIconForCategory(category);

                      return Padding(
                        padding: EdgeInsets.all(16.r),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 36.r,
                                      height: 36.r,
                                      decoration: BoxDecoration(
                                        color: catColor.withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(8.r),
                                      ),
                                      child: Icon(
                                        catIcon,
                                        color: catColor,
                                        size: 18.sp,
                                      ),
                                    ),
                                    SizedBox(width: 12.w),
                                    Text(
                                      category.displayName,
                                      style: TextStyle(
                                        fontFamily: 'Manrope',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13.sp,
                                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                                      ),
                                    ),
                                  ],
                                ),
                                Obx(() => Switch.adaptive(
                                      value: controller.enabledCategories[category] ?? false,
                                      activeTrackColor: AppColors.primaryTeal,
                                      onChanged: (val) {
                                        controller.toggleCategory(category, val);
                                      },
                                    )),
                              ],
                            ),
                            Obx(() {
                              final isEnabled = controller.enabledCategories[category] ?? false;
                              if (isEnabled) {
                                return Column(
                                  children: [
                                    SizedBox(height: 12.h),
                                    Container(
                                      height: 44.h,
                                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                                      decoration: BoxDecoration(
                                        color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                                        borderRadius: BorderRadius.circular(8.r),
                                        border: Border.all(
                                          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Text(
                                            '৳',
                                            style: TextStyle(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.bold,
                                              color: isDark ? Colors.white60 : Colors.black45,
                                            ),
                                          ),
                                          SizedBox(width: 6.w),
                                          Expanded(
                                            child: TextField(
                                              controller: controller.categoryTextControllers[category],
                                              keyboardType: TextInputType.number,
                                              style: TextStyle(
                                                fontSize: 14.sp,
                                                fontFamily: 'Manrope',
                                                fontWeight: FontWeight.bold,
                                                color: isDark ? Colors.white : const Color(0xFF0F172A),
                                              ),
                                              decoration: const InputDecoration(
                                                border: InputBorder.none,
                                                hintText: '0.00',
                                                hintStyle: TextStyle(color: Colors.grey),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              } else {
                                return Column(
                                  children: [
                                    SizedBox(height: 12.h),
                                    Container(
                                      height: 44.h,
                                      width: double.infinity,
                                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                                      decoration: BoxDecoration(
                                        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                                        borderRadius: BorderRadius.circular(8.r),
                                      ),
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'No limit set',
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          fontFamily: 'Manrope',
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }
                            }),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Obx(() {
              final isLoading = controller.isBudgetLoading.value;
              return Container(
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.bgDark.withValues(alpha: 0.9) : Colors.white.withValues(alpha: 0.9),
                  border: Border(
                    top: BorderSide(
                      color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
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
                              await controller.saveBudget();
                              Get.snackbar(
                                'Success',
                                'Monthly budget saved successfully!',
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
                                'Failed to save budget: $e',
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
                              Icon(Icons.check_circle_outline_rounded, size: 18.sp),
                              SizedBox(width: 8.w),
                              Text(
                                'Save Monthly Budget',
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
              );
            }),
          ),
        ],
      ),
    ),
    );
  }
}
