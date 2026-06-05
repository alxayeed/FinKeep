import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:spendly/core/extensions/double_ext.dart';
import 'package:spendly/core/routes/app_router.dart';

import '../../../../core/common/widgets/custom_fab.dart';
import '../../../../core/enums/expense_category.dart';
import '../../../../core/responsive/responsive.dart';
import '../../../../core/styles/app_colors.dart';
import '../controllers/expense_controller.dart';
import '../widgets/widgets.dart';

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
          // Compute dynamic category totals from raw controller.expenses
          final Map<ExpenseCategory, double> spentByCategory = {};
          final Map<ExpenseCategory, double> budgetsByCategory = {};

          final totalBudget = controller.monthlyBudget.value;

          for (var category in ExpenseCategory.values) {
            final spent = controller.expenses
                .where(
                  (e) =>
                      e.category.toLowerCase() ==
                      category.displayName.toLowerCase(),
                )
                .fold(0.0, (sum, item) => sum + item.amount);
            spentByCategory[category] = spent;

            // Dynamically allocate budget percentage for beautiful aesthetics
            switch (category) {
              case ExpenseCategory.food:
                budgetsByCategory[category] = totalBudget * 0.20;
                break;
              case ExpenseCategory.transport:
                budgetsByCategory[category] = totalBudget * 0.10;
                break;
              case ExpenseCategory.family:
                budgetsByCategory[category] = totalBudget * 0.30;
                break;
              case ExpenseCategory.utilities:
                budgetsByCategory[category] = totalBudget * 0.15;
                break;
              default:
                budgetsByCategory[category] = totalBudget * 0.05;
            }
          }

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
                  // Aesthetic search pop-up
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
                child: controller.isLoading.value
                    ? (_selectedTab == 0
                          ? const MonthlyExpenseShimmer(selectedTab: 0)
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // Category Horizontal Filter Pills - only shown in Details UI
                                Padding(
                                  padding: EdgeInsets.only(bottom: 8.h),
                                  child: CategoryFilterPills(
                                    selectedCategory:
                                        controller.selectedCategory.value ==
                                            'All'
                                        ? null
                                        : ExpenseCategoryExtension.fromString(
                                            controller.selectedCategory.value,
                                          ),
                                    onCategorySelected: (cat) {
                                      controller.updateSelectedCategory(
                                        cat?.displayName ?? 'All',
                                      );
                                    },
                                  ),
                                ),
                                const Expanded(
                                  child: MonthlyExpenseShimmer(selectedTab: 1),
                                ),
                              ],
                            ))
                    : _selectedTab == 0
                    ? _buildSummaryTab(spentByCategory, budgetsByCategory)
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Category Horizontal Filter Pills - only shown in Details UI
                          Padding(
                            padding: EdgeInsets.only(bottom: 8.h),
                            child: CategoryFilterPills(
                              selectedCategory:
                                  controller.selectedCategory.value == 'All'
                                  ? null
                                  : ExpenseCategoryExtension.fromString(
                                      controller.selectedCategory.value,
                                    ),
                              onCategorySelected: (cat) {
                                controller.updateSelectedCategory(
                                  cat?.displayName ?? 'All',
                                );
                              },
                            ),
                          ),
                          Expanded(child: _buildDetailsTab()),
                        ],
                      ),
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

  // --- Visual Summary Dashboard Tab ---
  Widget _buildSummaryTab(
    Map<ExpenseCategory, double> spentByCategory,
    Map<ExpenseCategory, double> budgetsByCategory,
  ) {
    final double totalSpent = controller.totalExpense.value;
    final double totalBudget = controller.monthlyBudget.value;

    if (controller.expenses.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: () async {
        controller.shouldRefresh = true;
        await controller.fetchMonthlyExpenses();
      },
      color: AppColors.primaryTeal,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          // Total budget vs spent slider card
          BudgetProgressCard(spent: totalSpent, budget: totalBudget),
          // Smart dynamic insights banner
          // Obx(() => SmartInsightBanner(
          //   customText: controller.getDynamicInsight(),
          // )),
          // Category spending checklist
          CategorySpendingList(
            spentByCategory: spentByCategory,
            budgetsByCategory: budgetsByCategory,
            onCategoryTap: (category) {
              setState(() {
                _selectedTab = 1; // Switch to Details tab
              });
              controller.updateSelectedCategory(category.displayName);
            },
          ),
          SizedBox(height: 100.h), // Safe spacing for bottom navigation overlap
        ],
      ),
    );
  }

  // --- Details Transaction Feed Tab ---
  Widget _buildDetailsTab() {
    final groupedList = controller.groupedExpenses;

    if (groupedList.isEmpty) {
      return _buildEmptyState();
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return RefreshIndicator(
      onRefresh: () async {
        controller.shouldRefresh = true;
        await controller.fetchMonthlyExpenses();
      },
      color: AppColors.primaryTeal,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.only(bottom: 100.h),
        itemCount: groupedList.length,
        itemBuilder: (context, index) {
          final item = groupedList[index];

          if (item is Map<String, dynamic>) {
            // This is a daily header item
            final DateTime date = item['date'] as DateTime;
            final double dailyTotal = item['total'] as double;
            final formattedDate = DateFormat('EEEE, MMM dd').format(date);

            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    formattedDate,
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white30 : const Color(0xFF94A3B8),
                      letterSpacing: 0.5,
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        dailyTotal.toCurrency(),
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontFamily: 'Manrope',
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? Colors.white30
                              : const Color(0xFF64748B),
                        ),
                      ),
                      SizedBox(width: 2.w),
                      FaIcon(
                        FontAwesomeIcons.bangladeshiTakaSign,
                        size: 8.sp,
                        color: isDark
                            ? Colors.white30
                            : const Color(0xFF64748B),
                      ),
                    ],
                  ),
                ],
              ),
            );
          } else {
            // This is a transaction card item
            return ExpenseCardWidget(expense: item as dynamic);
          }
        },
      ),
    );
  }

  // --- Premium empty state helper ---
  Widget _buildEmptyState() {
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
                        // Filter dynamically
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
