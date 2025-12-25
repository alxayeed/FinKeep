import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/expense_controller.dart';
import '../widgets/expense_list_widget.dart';
import '../widgets/month_selector.dart';
import 'create_expense_screen.dart';

class MonthlyExpenseScreen extends StatefulWidget {
  const MonthlyExpenseScreen({super.key});

  @override
  State<MonthlyExpenseScreen> createState() => _MonthlyExpenseScreenState();
}

class _MonthlyExpenseScreenState extends State<MonthlyExpenseScreen> {
  final ExpenseController controller = Get.find();
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 1,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Spendly',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
          centerTitle: true,
          backgroundColor: const Color(0xFF009688),
          elevation: 0,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(24),
            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(60.0),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: TabBar(
                tabs: const [
                  Tab(text: 'Overview'),
                  Tab(text: 'Expenses'),
                ],
                labelColor: const Color(0xFF009688),
                unselectedLabelColor: Colors.white.withOpacity(0.8),
                indicatorSize: TabBarIndicatorSize.label,
                indicator: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                  color: Color(0xFFF3F4F6), // background-light
                ),
                dividerColor: Colors.transparent,
              ),
            ),
          ),
        ),
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
                  Container(), // Overview screen
                  ExpenseListWidget(controller: controller),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: Container(
          height: 64,
          width: 64,
          margin: const EdgeInsets.only(bottom: 10),
          child: FloatingActionButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (BuildContext context) {
                  return const CreateExpenseScreen();
                },
              );
            },
            backgroundColor: const Color(0xFF009688),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: const Icon(Icons.add, color: Colors.white, size: 32),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            color: Color(0xFF009688),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.attach_money),
                label: 'Expenses',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.handshake),
                label: 'Lendings',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.bar_chart),
                label: 'Reports',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.monetization_on),
                label: 'Invest',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white.withOpacity(0.6),
            onTap: _onItemTapped,
            backgroundColor: Colors.transparent,
            type: BottomNavigationBarType.fixed,
            elevation: 0,
            showUnselectedLabels: true,
            selectedLabelStyle:
                const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
            unselectedLabelStyle:
                const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}
