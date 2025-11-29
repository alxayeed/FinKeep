import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:spendly/core/common/widgets/loader_widget.dart';

import '../../../../core/common/widgets/expense_monthly_analysis.dart';
import '../../../../core/common/widgets/no_data_widget.dart';
import '../../domain/entities/expense_entity.dart';
import '../controllers/expense_controller.dart';
import '../widgets/expense_summery.dart';
import '../widgets/widgets.dart';

class ExpenseSummeryScreen extends StatelessWidget {
  const ExpenseSummeryScreen(
      {super.key, required this.controller, this.isReport = false});

  final ExpenseController controller;
  final bool isReport;

  List<ExpenseEntity> get _dataList {
    return isReport ? controller.reportExpenses : controller.expenses;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Obx(() {
        final data = _dataList;

        if (controller.isLoading.value) {
          return const Center(child: LoaderWidget());
        } else if (data.isEmpty) {
          return const Center(child: NoDataWidget());
        } else {
          return SingleChildScrollView(
            child: Column(
              children: [
                ExpenseSummery(expenses: data),
                if (isReport) ...[
                  const SizedBox(height: 16),
                  ExpenseMonthlyAnalysis(expenses: data),
                ],
                if (!isReport) ...[
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.35,
                    child: ExpenseBarChart(expenses: data),
                  ),
                ]
              ],
            ),
          );
        }
      }),
    );
  }
}
