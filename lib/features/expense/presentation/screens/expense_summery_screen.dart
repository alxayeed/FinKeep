import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:spendly/core/common/widgets/loader_widget.dart';

import '../../../../core/common/widgets/no_data_widget.dart';
import '../controllers/expense_controller.dart';
import '../widgets/expense_summery.dart';
import '../widgets/widgets.dart';

class ExpenseSummeryScreen extends StatelessWidget {
  const ExpenseSummeryScreen({
    super.key,
    required this.controller,
  });

  final ExpenseController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: LoaderWidget());
        } else if (controller.expenses.isEmpty) {
          return const Center(child: NoDataWidget());
        } else {
          return SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height *
                      0.33, // Adjust height as needed
                  child: ExpenseSummery(expenses: controller.expenses),
                ),
                // SizedBox(
                //   height: MediaQuery.of(context).size.height *
                //       0.4, // Adjust height as needed
                //   child: DonutChart(expenses: controller.expenses),
                // ),
                SizedBox(
                  height: MediaQuery.of(context).size.height *
                      0.35, // Adjust height as needed
                  child: ExpenseBarChart(expenses: controller.expenses),
                ),
              ],
            ),
          );
        }
      }),
    );
  }
}
