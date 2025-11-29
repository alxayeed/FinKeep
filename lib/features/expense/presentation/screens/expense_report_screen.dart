import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:spendly/core/common/widgets/loader_widget.dart';

import '../../../../core/common/widgets/date_selector_button.dart';
import '../controllers/expense_controller.dart';
import '../widgets/expense_list_widget.dart';
import '../widgets/widgets.dart';

class ExpenseReportScreen extends StatefulWidget {
  const ExpenseReportScreen({super.key});

  @override
  State<ExpenseReportScreen> createState() => _ExpenseReportScreenState();
}

class _ExpenseReportScreenState extends State<ExpenseReportScreen> {
  final ExpenseController controller = Get.find<ExpenseController>();

  @override
  void initState() {
    controller.clearReportState();
    super.initState();
  }

  Future<void> _selectDate(BuildContext context,
      {required bool isStartDate}) async {
    final DateTime now = DateTime.now();

    DateTime initialDate = isStartDate
        ? controller.startDate.value ?? now.subtract(const Duration(days: 30))
        : controller.endDate.value ?? now;

    DateTime firstDate = isStartDate
        ? DateTime(now.year - 5)
        : controller.startDate.value ?? DateTime(now.year - 5);

    if (initialDate.isBefore(firstDate)) {
      initialDate = firstDate;
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: DateTime(now.year + 1),
      helpText: isStartDate ? 'Select Start Date' : 'Select End Date',
    );

    if (picked != null) {
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
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: const CustomAppBar(
          title: 'Expense Report',
          bottom: CustomTabBar(),
        ),
        drawer: AppDrawer(),
        body: Obx(() {
          final startDate = controller.startDate.value;
          final endDate = controller.endDate.value;

          return Column(
            children: [
              _ReportHeader(
                startDate: startDate,
                endDate: endDate,
                totalExpense: controller.totalExpense.value,
                onStartDateSelect: () =>
                    _selectDate(context, isStartDate: true),
                onEndDateSelect: () => _selectDate(context, isStartDate: false),
              ),
              Expanded(
                child: controller.isLoading.value
                    ? const Center(child: LoaderWidget())
                    : startDate == null || endDate == null
                        ? const Center(
                            child: Padding(
                              padding: EdgeInsets.all(32.0),
                              child: Text(
                                'Tap on the start and end dates above to select a custom range and generate your report.',
                                textAlign: TextAlign.center,
                                style:
                                    TextStyle(fontSize: 16, color: Colors.grey),
                              ),
                            ),
                          )
                        : TabBarView(
                            children: [
                              ExpenseSummeryWidget(
                                controller: controller,
                                isReport: true,
                              ),
                              ExpenseListWidget(
                                controller: controller,
                                isReport: true,
                              ),
                            ],
                          ),
              ),
            ],
          );
        }),
      ),
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
    final ThemeData theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(8.0),
      color: theme.colorScheme.surfaceContainerHigh,
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
              const Icon(Icons.arrow_right_alt, color: Colors.grey),
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
