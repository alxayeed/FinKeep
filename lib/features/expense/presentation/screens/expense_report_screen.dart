import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:finkeep/core/routes/app_router.dart';

import 'package:finkeep/core/common/widgets/custom_fab.dart';
import 'package:finkeep/core/common/widgets/date_range_header.dart';
import 'package:finkeep/core/styles/app_colors.dart';

import '../controllers/expense_report_controller.dart';
import '../widgets/missing_budget_dialog.dart';
import '../widgets/monthly_expense_shimmer.dart';
import '../widgets/segmented_tab_bar.dart';
import '../widgets/expense_report_filter_menu.dart';
import 'expense_report_summary_screen.dart';
import 'expense_report_list_screen.dart';

class ExpenseReportScreen extends StatefulWidget {
  const ExpenseReportScreen({super.key});

  @override
  State<ExpenseReportScreen> createState() => _ExpenseReportScreenState();
}

class _ExpenseReportScreenState extends State<ExpenseReportScreen> {
  final ExpenseReportController controller = Get.find<ExpenseReportController>();
  int _selectedTab = 0; // 0 for Summary, 1 for Details
  late final Worker _missingBudgetWorker;

  @override
  void initState() {
    super.initState();

    final range = controller.dateFilter.value.dateRange;
    if (range != null) {
      controller.fetchExpensesInRange(range.start, range.end);
    } else {
      final now = DateTime.now();
      controller.fetchExpensesInRange(
        DateTime(now.year, 1, 1),
        DateTime(now.year, 12, 31, 23, 59, 59),
      );
    }

    _missingBudgetWorker = ever(controller.missingBudgetMonths, (List<DateTime> missing) {
      if (missing.isNotEmpty && mounted) {
        showDialog(
          context: context,
          barrierDismissible: true,
          builder: (context) => MissingBudgetDialog(
            missingMonths: missing,
            onSave: (amount) {
              controller.saveBudgetForMonths(missing, amount);
            },
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _missingBudgetWorker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.bgDark : AppColors.bgLight,
      floatingActionButton: CustomFAB(
        icon: Icons.picture_as_pdf_rounded,
        onPressed: () => showExpenseReportFilterMenu(
          context,
          dateFilter: controller.dateFilter.value,
        ),
      ),
      body: SafeArea(
        child: Obx(() {
          final dateFilter = controller.dateFilter.value;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Top Date Filter Header
              DateRangeHeader(
                dateFilter: dateFilter,
                onDateFilterChanged: (newFilter) {
                  controller.updateDateFilter(newFilter);
                },
                onSettingsPressed: () {
                  context.pushNamed(AppRoutes.settings);
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
                    ? MonthlyExpenseShimmer(selectedTab: _selectedTab)
                    : (_selectedTab == 0
                        ? ExpenseReportSummaryScreen(
                            controller: controller,
                          )
                        : ExpenseReportListScreen(
                            controller: controller,
                          )),
              ),
            ],
          );
        }),
      ),
    );
  }
}
