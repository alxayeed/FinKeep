import 'package:flutter/material.dart';
import '../controllers/expense_report_controller.dart';
import '../widgets/expense_report_components.dart';

class ExpenseReportSummaryScreen extends StatelessWidget {
  final ExpenseReportController controller;

  const ExpenseReportSummaryScreen({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return ExpenseSummeryWidget(
      controller: controller,
      isReport: true,
    );
  }
}
