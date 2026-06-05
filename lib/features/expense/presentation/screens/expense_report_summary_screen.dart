import 'package:flutter/material.dart';
import '../controllers/expense_controller.dart';
import '../widgets/expense_report_components.dart';

class ExpenseReportSummaryScreen extends StatelessWidget {
  final ExpenseController controller;

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
