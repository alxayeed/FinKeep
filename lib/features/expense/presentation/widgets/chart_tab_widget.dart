import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../controllers/expense_controller.dart';
import 'widgets.dart';

class ChartTabWidget extends StatelessWidget {
  const ChartTabWidget({
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
          return const Center(child: CircularProgressIndicator());
        } else {
          return Column(
            children: [
              Expanded(
                child: DonutChart(expenses: controller.expenses),
              ),
              Expanded(
                child: ExpenseBarChart(expenses: controller.expenses),
              ),
            ],
          );
        }
      }),
    );
  }
}
