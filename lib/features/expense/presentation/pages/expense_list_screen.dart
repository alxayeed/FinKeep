import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../controllers/expense_controller.dart';
import '../widgets/app_drawer.dart';
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
      ),
      drawer: const AppDrawer(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        onPressed: () {
          Get.bottomSheet(
            const CreateExpenseScreen(),
            isScrollControlled: true,
          );
        },
        child: const FaIcon(FontAwesomeIcons.plus),
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
