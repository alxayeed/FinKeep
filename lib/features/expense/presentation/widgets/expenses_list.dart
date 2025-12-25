import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spendly/core/common/widgets/loader_widget.dart';
import 'package:spendly/core/common/widgets/no_data_widget.dart';
import 'package:spendly/features/expense/domain/entities/expense_entity.dart';
import '../controllers/expense_controller.dart';
import 'expense_card_widget.dart';

class ExpensesList extends StatelessWidget {
  final ExpenseController controller;
  final bool isReport;

  const ExpensesList({
    super.key,
    required this.controller,
    this.isReport = false,
  });

  List<ExpenseEntity> get _dataList {
    return isReport
        ? controller.reportFilteredExpenses
        : controller.filteredExpenses;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final data = _dataList;

      if (controller.isLoading.value) {
        return const Center(child: LoaderWidget());
      } else if (data.isEmpty) {
        return const Center(child: NoDataWidget());
      }
      return ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          final expense = data[index];
          return Dismissible(
            key: Key(expense.id),
            onDismissed: (direction) {
              controller.removeExpense(expense.id);
            },
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20.0),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            child: ExpenseCardWidget(
              expense: expense,
            ),
          );
        },
      );
    });
  }
}
