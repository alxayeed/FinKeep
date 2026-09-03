import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:finkeep/core/common/models/date_filter.dart';
import 'package:finkeep/core/common/widgets/app_toast.dart';
import 'package:finkeep/core/common/widgets/custom_app_bar.dart';
import 'package:finkeep/core/responsive/responsive.dart';
import 'package:finkeep/core/styles/app_colors.dart';
import 'package:finkeep/core/styles/currency_provider.dart';

import '../../data/services/expense_pdf_service.dart';
import '../../domain/entities/expense_pdf_report_config.dart';
import '../controllers/expense_report_controller.dart';
import '../widgets/missing_budget_dialog.dart';
import '../widgets/monthly_expense_shimmer.dart';
import '../widgets/segmented_tab_bar.dart';
import '../widgets/expense_report_filter_menu.dart';
import 'expense_report_pdf_viewer_screen.dart';
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
            onSkip: () {
              controller.ignoreMissingBudgetPrompt();
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

  Future<void> _handleExportPdf(BuildContext context) async {
    final currency = context.currency;
    final expenses = controller.reportFilteredExpenses;
    final filter = controller.dateFilter.value;
    final range = filter.dateRange;

    DateTime start = controller.startDate.value ?? DateTime(DateTime.now().year, 1, 1);
    DateTime end = controller.endDate.value ?? DateTime(DateTime.now().year, 12, 31, 23, 59, 59);

    if (range != null) {
      start = range.start;
      end = range.end;
    }

    final isMultiMonth = filter.type != DateFilterType.monthly &&
        (start.year != end.year || start.month != end.month);

    final config = ExpensePdfReportConfig(
      startDate: start,
      endDate: end,
      selectedCategory: controller.selectedCategories.length == 1
          ? controller.selectedCategories.first
          : 'All',
      selectedCategories: controller.selectedCategories.toList(),
      mode: controller.listMode.value,
      currencySymbol: currency.symbol,
      includeCategorySummary: controller.includeCategorySummary.value,
      includeMonthlyBreakdown: isMultiMonth && controller.includeMonthlyBreakdown.value,
      includePaymentMethodBreakdown: controller.includePaymentMethodBreakdown.value,
      includeHighLowAvgMetrics: isMultiMonth && controller.includeHighLowAvgMetrics.value,
    );

    try {
      final pdfService = ExpensePdfService();
      final pdfBytes = await pdfService.generateExpensePdf(
        expenses: expenses.toList(),
        config: config,
      );

      if (context.mounted) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ExpenseReportPdfViewerScreen(
              pdfBytes: pdfBytes,
              config: config,
            ),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        AppToast.showError(context, message: 'Failed to generate PDF report: $e');
      }
    }
  }

  Widget _buildActivePeriodBanner(BuildContext context, bool isDark) {
    final filter = controller.dateFilter.value;
    final start = controller.startDate.value;
    final end = controller.endDate.value;
    final activeCategories = controller.selectedCategories;

    String dateText = filter.displayTitle;
    if (filter.type == DateFilterType.custom && start != null && end != null) {
      dateText = '${DateFormat('dd MMM yyyy').format(start)} – ${DateFormat('dd MMM yyyy').format(end)}';
    } else if (filter.type == DateFilterType.fiscalYearly) {
      dateText = '${filter.displayTitle} · ${filter.fiscalYearPeriodSubtitle}';
    }

    final categorySubtitle = activeCategories.isEmpty
        ? 'All Categories'
        : (activeCategories.length == 1
            ? activeCategories.first
            : '${activeCategories.length} Categories');

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      child: InkWell(
        onTap: () => showExpenseReportFilterMenu(
          context,
          dateFilter: controller.dateFilter.value,
          initialCategories: controller.selectedCategories.toList(),
        ),
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.calendar_today_rounded,
                size: 14.sp,
                color: AppColors.primaryTeal,
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  '$dateText  •  $categorySubtitle',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
              ),
              Icon(
                Icons.tune_rounded,
                size: 14.sp,
                color: isDark ? Colors.white54 : const Color(0xFF94A3B8),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.bgDark : AppColors.bgLight,
      appBar: CustomAppBar(
        title: 'Expense Report',
        showBackButton: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.picture_as_pdf_rounded,
              size: 22.sp,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
            tooltip: 'Export PDF Report',
            onPressed: () => _handleExportPdf(context),
          ),
        ],
      ),
      body: Obx(() {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Active Period & Scope Indicator Banner
            _buildActivePeriodBanner(context, isDark),

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
    );
  }
}
