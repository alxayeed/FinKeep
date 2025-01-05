import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../controllers/expense_controller.dart';
import 'expense_card_widget.dart';

class ListTabWidget extends StatelessWidget {
  final ExpenseController controller;

  const ListTabWidget({
    super.key,
    required this.controller,
  });

  Widget _buildExpenseSummary() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.teal.shade400, borderRadius: BorderRadius.circular(10)),
      child: Center(
        child: Text(
          '${controller.totalExpense.value.toStringAsFixed(2)} ৳',
          style: const TextStyle(
              fontSize: 18, fontWeight: FontWeight.w400, color: Colors.white),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Category list
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
        Obx(() => _buildExpenseSummary()),
        Expanded(
          child: Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            } else if (controller.filteredExpenses.isEmpty) {
              return const Center(child: Text('No expenses found.'));
            }
            return ListView.builder(
              itemCount: controller.filteredExpenses.length,
              itemBuilder: (context, index) {
                final expense = controller.filteredExpenses[index];
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
