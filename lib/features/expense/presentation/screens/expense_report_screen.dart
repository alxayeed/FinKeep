import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:spendly/core/responsive/responsive.dart';

import '../../../../core/common/widgets/date_selector_button.dart';
import '../../../../core/styles/app_colors.dart';
import '../controllers/expense_controller.dart';
import '../widgets/widgets.dart';
import 'expense_report_summary_screen.dart';
import 'expense_report_list_screen.dart';

class ExpenseReportScreen extends StatefulWidget {
  const ExpenseReportScreen({super.key});

  @override
  State<ExpenseReportScreen> createState() => _ExpenseReportScreenState();
}

class _ExpenseReportScreenState extends State<ExpenseReportScreen> {
  final ExpenseController controller = Get.find<ExpenseController>();
  int _selectedTab = 0; // 0 for Summary, 1 for Details

  @override
  void initState() {
    super.initState();

    controller.clearReportState();

    final now = DateTime.now();

    controller.startDate.value = DateTime(now.year, 1, 1);
    controller.endDate.value = DateTime(now.year, 12, 31, 23, 59, 59);

    controller.fetchExpensesInRange(
      controller.startDate.value!,
      controller.endDate.value!,
    );
  }

  Future<void> _selectDate(BuildContext context,
      {required bool isStartDate}) async {
    final DateTime now = DateTime.now();
    DateTime selectedDate = isStartDate
        ? controller.startDate.value ?? now
        : controller.endDate.value ?? now;

    final results = await showDialog<List<DateTime?>>(
      context: context,
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Dialog(
          backgroundColor: isDark ? AppColors.cardDark : AppColors.cardLight,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          insetPadding: EdgeInsets.symmetric(horizontal: 16.w),
          child: SizedBox(
            width: 360.w,
            height: 480.h,
            child: Column(
              children: [
                CalendarDatePicker2(
                  value: [selectedDate],
                  config: CalendarDatePicker2Config(
                    calendarType: CalendarDatePicker2Type.single,
                    firstDate: DateTime(now.year - 5),
                    lastDate: DateTime(now.year + 1, 12, 31),
                    selectedDayHighlightColor: AppColors.primaryTeal,
                    dayTextStyle: TextStyle(
                      fontFamily: 'Manrope',
                      color: isDark ? Colors.white70 : Colors.black87,
                    ),
                    selectedDayTextStyle: const TextStyle(
                      fontFamily: 'Manrope',
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onValueChanged: (dates) {
                    if (dates.isNotEmpty) {
                      Navigator.pop(context, dates);
                    }
                  },
                ),
                SizedBox(height: 8.h),
                ActionChip(
                  label: Text(
                    isStartDate ? 'YEAR START' : 'YEAR END',
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontFamily: 'Manrope',
                      color: AppColors.primaryTeal,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.6,
                    ),
                  ),
                  backgroundColor:
                      AppColors.primaryTeal.withValues(alpha: 0.08),
                  shape: StadiumBorder(
                    side: BorderSide(
                      color: AppColors.primaryTeal.withValues(alpha: 0.4),
                    ),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 8.h,
                  ),
                  onPressed: () {
                    Navigator.pop(
                      context,
                      [
                        isStartDate
                            ? DateTime(now.year, 1, 1)
                            : DateTime(now.year, 12, 31),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );

    if (results != null && results.first != null) {
      final picked = results.first!;

      if (isStartDate) {
        controller.startDate.value =
            DateTime(picked.year, picked.month, picked.day);
      } else {
        controller.endDate.value =
            DateTime(picked.year, picked.month, picked.day, 23, 59, 59);
      }

      _fetchReportIfDatesAreValid();
    }
  }

  void _fetchReportIfDatesAreValid() {
    final DateTime? start = controller.startDate.value;
    final DateTime? end = controller.endDate.value;

    if (start != null && end != null) {
      if (start.isAfter(end)) {
        Get.snackbar(
          'Invalid Range',
          'Start date cannot be after end date.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withValues(alpha: 0.8),
          colorText: Colors.white,
        );
        return;
      }

      controller.fetchExpensesInRange(start, end);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.bgDark : AppColors.bgLight,
      appBar: const CustomAppBar(
        title: 'Expense Report',
      ),
      body: Obx(() {
        final startDate = controller.startDate.value;
        final endDate = controller.endDate.value;

        return Column(
          children: [
            // 1. Modern date selector header
            _ReportHeader(
              startDate: startDate,
              endDate: endDate,
              totalExpense: controller.totalExpense.value,
              onStartDateSelect: () =>
                  _selectDate(context, isStartDate: true),
              onEndDateSelect: () => _selectDate(context, isStartDate: false),
            ),

            // 2. Sliding Segmented Tab Switcher (Summary & Details) identical to Expense UI
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
                  : startDate == null || endDate == null
                      ? Center(
                          child: Padding(
                            padding: EdgeInsets.all(32.r),
                            child: Text(
                              'Tap on the start and end dates above to select a custom range and generate your report.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontFamily: 'Manrope',
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        )
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

class _ReportHeader extends StatelessWidget {
  final DateTime? startDate;
  final DateTime? endDate;
  final double totalExpense;
  final VoidCallback onStartDateSelect;
  final VoidCallback onEndDateSelect;

  const _ReportHeader({
    required this.startDate,
    required this.endDate,
    required this.totalExpense,
    required this.onStartDateSelect,
    required this.onEndDateSelect,
  });

  String _formatDate(DateTime? date, {required bool isFrom}) {
    if (date == null) {
      if (isFrom) {
        return "Start Date";
      } else {
        return "End Date";
      }
    }
    return DateFormat('d MMM, yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        border: Border(
          bottom: BorderSide(
            color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              DateSelectorButton(
                title: 'START DATE',
                dateText: _formatDate(startDate, isFrom: true),
                onTap: onStartDateSelect,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: const Icon(Icons.arrow_right_alt, color: Colors.grey),
              ),
              DateSelectorButton(
                title: 'END DATE',
                dateText: _formatDate(endDate, isFrom: false),
                onTap: onEndDateSelect,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
