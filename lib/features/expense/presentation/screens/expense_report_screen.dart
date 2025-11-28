import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/expense_controller.dart';
import '../widgets/widgets.dart';
import 'expense_list_screen.dart';

class ExpenseReportScreen extends StatefulWidget {
  const ExpenseReportScreen({super.key});

  @override
  State<ExpenseReportScreen> createState() => _ExpenseReportScreenState();
}

class _ExpenseReportScreenState extends State<ExpenseReportScreen> {
  final ExpenseController controller = Get.find<ExpenseController>();

  @override
  void initState() {
    // Clear any previous report data and date selections when the screen opens
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
          backgroundColor: Colors.red.withOpacity(0.8),
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
                    ? const Center(child: CircularProgressIndicator())
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
                              ExpenseSummeryScreen(
                                controller: controller,
                                isReport: true,
                              ),
                              ExpenseListScreen(
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

  String _formatDate(DateTime? date) {
    if (date == null) return 'Select Date';
    return DateFormat('d MMM, yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16.0),
      color: theme.colorScheme.surfaceContainerHigh,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _DateSelectorButton(
                title: 'START DATE',
                dateText: _formatDate(startDate),
                onTap: onStartDateSelect,
              ),
              const Icon(Icons.arrow_right_alt, color: Colors.grey),
              _DateSelectorButton(
                title: 'END DATE',
                dateText: _formatDate(endDate),
                onTap: onEndDateSelect,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DateSelectorButton extends StatelessWidget {
  final String title;
  final String dateText;
  final VoidCallback onTap;

  const _DateSelectorButton({
    required this.title,
    required this.dateText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Card(
        elevation: 1,
        color: theme.colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.calendar_month,
                    size: 24,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: theme.colorScheme.primary,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    dateText,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.onSurface),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
