import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/expense_controller.dart';
import '../widgets/month_selector.dart';
import '../widgets/widgets.dart';

class MonthlyExpenseScreen extends StatefulWidget {
  const MonthlyExpenseScreen({super.key});

  @override
  State<MonthlyExpenseScreen> createState() => _MonthlyExpenseScreenState();
}

class _MonthlyExpenseScreenState extends State<MonthlyExpenseScreen> {
  final ExpenseController controller = Get.find();

  DateTime _selectedMonth = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: const CustomAppBar(
          bottom: CustomTabBar(),
        ),
        drawer: const AppDrawer(),
        floatingActionButton: const CustomFAB(),
        body: TabBarView(
          children: [
            Column(
              children: [
                Obx(() => MonthSelector(
                  onMonthChanged: (selectedMonth) {
                    _selectedMonth = selectedMonth;
                    controller.fetchMonthlyExpenses(selectedMonth);
                  },
                  totalExpense: controller.totalExpense.value,
                )),

                // Display loading indicator or chart based on `isLoading`
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Obx(() {
                      if (controller.isLoading.value) {
                        return const Center(child: CircularProgressIndicator());
                      } else {
                        return DonutChart(expenses: controller.expenses);
                      }
                    }),
                  ),
                ),
              ],
            ),

            Column(
              children: [
                MonthSelector(
                  onMonthChanged: (selectedMonth) {
                    _selectedMonth = selectedMonth;
                    controller.fetchMonthlyExpenses(selectedMonth);
                  },
                  totalExpense: controller.getTotalExpense(),
                ),
                Obx(() => _buildExpenseSummary()),
                Expanded(
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (controller.expenses.isEmpty) {
                      return const Center(child: Text('No expenses found.'));
                    }
                    return RefreshIndicator(
                      onRefresh: () =>
                          controller.fetchMonthlyExpenses(_selectedMonth),
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
                    );
                  }),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpenseSummary() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.teal.shade400, borderRadius: BorderRadius.circular(30)),
      child: Center(
        child: Text(
          '${controller.totalExpense.value.toStringAsFixed(2)} ৳',
          style: const TextStyle(
              fontSize: 18, fontWeight: FontWeight.w400, color: Colors.white),
        ),
      ),
    );
  }
}
