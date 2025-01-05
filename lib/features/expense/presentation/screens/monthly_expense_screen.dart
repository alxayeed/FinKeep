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
        body: Column(
          children: [
            Obx(() => MonthSelector(
                  onMonthChanged: (selectedMonth) {
                    controller.selectedMonth.value = selectedMonth;
                    controller.fetchMonthlyExpenses();
                  },
                  totalExpense: controller.totalExpense.value,
                )),
            Expanded(
              child: TabBarView(
                children: [
                  ChartTabWidget(controller: controller),
                  ListTabWidget(controller: controller),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


