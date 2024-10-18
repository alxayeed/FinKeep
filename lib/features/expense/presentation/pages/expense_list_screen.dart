import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../controllers/expense_controller.dart';
import '../widgets/expense_card_widget.dart';
import 'create_expense_screen.dart';

class ExpenseListScreen extends StatelessWidget {
  final ExpenseController controller = Get.find();

  ExpenseListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Spendly'),
        foregroundColor: Colors.white,
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.circlePlus),
            onPressed: () {
              Get.to(const CreateExpenseScreen());
            },
          ),
        ],
      ),
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
            return controller.fetchExpenses();
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
                          Get.snackbar(
                            "Expense Deleted",
                            "${expense.category} has been removed from your list.",
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                          );
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
