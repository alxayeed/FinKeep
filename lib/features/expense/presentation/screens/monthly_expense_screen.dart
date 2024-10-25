import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/expense_controller.dart';
import '../widgets/month_selector.dart';
import '../widgets/widgets.dart';

class MonthlyExpenseScreen extends StatelessWidget {
  MonthlyExpenseScreen({super.key});
  final ExpenseController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: const CustomAppBar(
          bottom: CustomTabBar(),
        ),
        floatingActionButton: const CustomFAB(),
        body: TabBarView(
          children: [
            Center(
              child: Column(
                children: [
                  MonthSelector(
                    onMonthChanged: (selectedMonth) {
                      // controller.fetchExpensesForMonth(selectedMonth);
                    },
                  ),
                  _buildExpenseSummary(),
                  const Text("Chart view will be here"),
                ],
              ),
            ),
            Center(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (controller.expenses.isEmpty) {
                  return const Center(child: Text('No expenses found.'));
                }
                return RefreshIndicator(
                  onRefresh: () => controller.fetchExpenses(),
                  child: Column(
                    children: [
                      MonthSelector(
                        onMonthChanged: (selectedMonth) {
                          // controller.fetchExpensesForMonth(selectedMonth);
                        },
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: controller.expenses.length,
                          itemBuilder: (context, index) {
                            final expense = controller.expenses[index];
                            return ExpenseCardWidget(
                              expense: expense,
                              onDismissed: () {
                                controller.removeExpense(expense.id);
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpenseSummary() {
    double totalExpenses = controller.expenses.fold(0, (sum, item) => sum + item.amount);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        'Total Expenses: ${totalExpenses.toStringAsFixed(2)} ৳',
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}
