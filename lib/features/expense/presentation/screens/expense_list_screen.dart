import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spendly/core/common/widgets/custom_app_bar.dart';
import 'package:spendly/features/expense/presentation/widgets/custom_fab.dart';

import '../../../../core/common/widgets/app_drawer.dart';
import '../controllers/expense_controller.dart';
import '../widgets/expense_card_widget.dart';

class ExpenseListScreen extends StatelessWidget {
  final ExpenseController controller = Get.find();

  ExpenseListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      drawer: const AppDrawer(),
      floatingActionButton: const CustomFAB(),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (controller.expenses.isEmpty) {
          return const Center(child: Text('No expenses found.'));
        }
        return RefreshIndicator(
          onRefresh: () {
            return controller.fetchMonthlyExpenses();
          },
          child: Column(
            children: [
              _buildExpenseSummary(),
              Expanded(
                child: ListView.builder(
                  itemCount: controller.expenses.length,
                  itemBuilder: (context, index) {
                    final expense = controller.expenses[index];
                    return ExpenseCardWidget(
                        expense: expense,
                        onDismissed: () {
                          controller.removeExpense(expense.id);
                        });
                  },
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildExpenseSummary() {
    double totalExpenses =
        controller.expenses.fold(0, (sum, item) => sum + item.amount);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        'Total Expenses: ${totalExpenses.toStringAsFixed(2)} ৳',
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}
