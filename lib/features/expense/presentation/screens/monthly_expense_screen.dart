import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:spendly/core/routes/app_router.dart';
import '../../../../core/responsive/responsive.dart';
import '../../../../core/enums/expense_category.dart';

import '../../../../core/common/widgets/custom_fab.dart';
import '../../../../core/styles/app_colors.dart';
import '../controllers/expense_controller.dart';
import '../widgets/widgets.dart';
import 'monthly_expense_summary_screen.dart';
import 'monthly_expense_list_screen.dart';

class MonthlyExpenseScreen extends StatefulWidget {
  const MonthlyExpenseScreen({super.key});

  @override
  State<MonthlyExpenseScreen> createState() => _MonthlyExpenseScreenState();
}

class _MonthlyExpenseScreenState extends State<MonthlyExpenseScreen> {
  final ExpenseController controller = Get.find();
  int _selectedTab = 0; // 0 for Summary, 1 for Details

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.bgDark : AppColors.bgLight,
      body: SafeArea(
        child: Obx(() {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Month Selector Header
              MonthSelector(
                showSearchButton: _selectedTab == 1,
                onMonthChanged: (selectedMonth) {
                  controller.updateSelectedMonth(selectedMonth);
                },
                onSearchPressed: () {
                  _showSearchDialog(context);
                },
                onFilterPressed: () {
                  _showFilterBottomSheet(context);
                },
              ),

              // 2. Sliding Segmented Tab Switcher (Summary & Details)
              SegmentedTabBar(
                selectedIndex: _selectedTab,
                onTabChanged: (index) {
                  setState(() {
                    _selectedTab = index;
                  });
                },
              ),

              // 3. Tab Contents
              Expanded(
                child: _selectedTab == 0
                    ? (controller.isLoading.value
                        ? const MonthlyExpenseShimmer(selectedTab: 0)
                        : MonthlyExpenseSummaryScreen(
                            controller: controller,
                            onCategoryTap: (category) {
                              setState(() {
                                _selectedTab = 1; // Switch to Details tab
                              });
                              controller.updateSelectedCategory(category.displayName);
                            },
                          ))
                    : MonthlyExpenseListScreen(controller: controller),
              ),
            ],
          );
        }),
      ),
      floatingActionButton: CustomFAB(
        onPressed: () {
          context.pushNamed(AppRoutes.addExpense);
        },
      ),
    );
  }

  // --- Aesthetic interactive search popup ---
  void _showSearchDialog(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (context) {
        String query = "";
        return Dialog(
          backgroundColor: isDark ? AppColors.cardDark : AppColors.cardLight,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Padding(
            padding: EdgeInsets.all(16.r),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Search Expenses',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
                SizedBox(height: 12.h),
                TextField(
                  onChanged: (val) {
                    query = val;
                  },
                  autofocus: true,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                  decoration: InputDecoration(
                    hintText: 'Type keyword...',
                    hintStyle: TextStyle(
                      color: isDark ? Colors.white30 : const Color(0xFF94A3B8),
                    ),
                    filled: true,
                    fillColor: isDark
                        ? const Color(0xFF0F172A)
                        : const Color(0xFFF8FAFC),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 14.w,
                      vertical: 10.h,
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        if (query.isNotEmpty) {
                          controller.filteredExpenses.value = controller
                              .expenses
                              .where(
                                (e) =>
                                    e.category.toLowerCase().contains(
                                      query.toLowerCase(),
                                    ) ||
                                    e.description.toLowerCase().contains(
                                      query.toLowerCase(),
                                    ),
                              )
                              .toList();
                        } else {
                          controller.filterExpensesByCategory();
                        }
                      },
                      child: const Text('Search'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // --- Aesthetic dynamic filter bottom sheet ---
  void _showFilterBottomSheet(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppColors.cardDark : AppColors.cardLight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) {
        return SafeArea(
          top: false,
          bottom: true,
          child: Padding(
            padding: EdgeInsets.all(20.r),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 38.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF334155)
                          : const Color(0xFFE2E8F0),
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  'Configure Limit & Budget',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
                SizedBox(height: 12.h),
                TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Monthly Budget Limit (৳)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  onSubmitted: (val) {
                    final parsed = double.tryParse(val);
                    if (parsed != null && parsed > 0) {
                      controller.monthlyBudget.value = parsed;
                    }
                    Navigator.pop(context);
                  },
                ),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        );
      },
    );
  }
}
