import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../controllers/expense_controller.dart';
import 'expenses_list.dart';
import 'total_expenses_card.dart';

class ExpenseListWidget extends StatelessWidget {
  final ExpenseController controller;
  final bool isReport;

  const ExpenseListWidget({
    super.key,
    required this.controller,
    this.isReport = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 40,
          margin: const EdgeInsets.only(top: 8, left: 4, bottom: 8),
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
                return GestureDetector(
                  onTap: () => controller.updateSelectedCategory(category),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4.0),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 10.0),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFF009688) : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected
                            ? Colors.transparent
                            : Colors.grey.shade300,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: const Color(0xFF009688).withOpacity(0.3),
                                blurRadius: 5,
                                offset: const Offset(0, 2),
                              )
                            ]
                          : [],
                    ),
                    child: Row(
                      children: [
                        if (isSelected && isAllCategory)
                          const Icon(Icons.check, color: Colors.white, size: 16),
                        if (isSelected && isAllCategory)
                          const SizedBox(width: 4),
                        Text(
                          category,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              });
            },
          ),
        ),
        TotalExpensesCard(controller: controller, isReport: isReport),
        Expanded(
          child: ExpensesList(controller: controller, isReport: isReport),
        ),
      ],
    );
  }
}
