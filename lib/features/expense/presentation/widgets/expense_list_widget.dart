import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:spendly/core/common/widgets/no_data_widget.dart';
import 'package:spendly/core/extensions/double_ext.dart';

import '../../../../core/common/widgets/loader_widget.dart';
import '../../domain/entities/expense_entity.dart';
import '../controllers/expense_controller.dart';
import 'expense_card_widget.dart';

class ExpenseListWidget extends StatelessWidget {
  final ExpenseController controller;
  final bool isReport;

  const ExpenseListWidget({
    super.key,
    required this.controller,
    this.isReport = false,
  });

  List<ExpenseEntity> get _dataList {
    return isReport
        ? controller.reportFilteredExpenses
        : controller.filteredExpenses;
  }

  RxDouble get _totalExpense {
    return isReport ? controller.reportTotalExpense : controller.totalExpense;
  }

  Widget _buildExpenseSummary() {
    return Obx(() {
      final amount = _totalExpense.value;
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.teal.shade400,
            borderRadius: BorderRadius.circular(10)),
        child: Center(
          child: Text(
            '${amount.toCurrency()} ৳',
            style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.w400, color: Colors.white),
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: controller.categories.length,
            itemBuilder: (context, index) {
              final isAllCategory = index == 0;
              final category =
                  isAllCategory ? 'All' : controller.categories[index];

              return Obx(() {
                final isSelected =
                    controller.selectedCategory.value == category;

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: ChoiceChip(
                    label: Text(
                      category,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                      ),
                    ),
                    selected: isSelected,
                    selectedColor: Colors.teal,
                    onSelected: (selected) {
                      if (selected) {
                        controller.updateSelectedCategory(category);
                      }
                    },
                  ),
                );
              });
            },
          ),
        ),
        _buildExpenseSummary(),
        Expanded(
          child: Obx(() {
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
                return ExpenseCardWidget(
                  expense: expense,
                  onDismissed: () {
                    controller.removeExpense(expense.id);
                  },
                );
              },
            );
          }),
        ),
      ],
    );
  }
}
