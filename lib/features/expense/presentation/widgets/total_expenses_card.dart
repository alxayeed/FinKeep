import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spendly/core/extensions/double_ext.dart';
import '../controllers/expense_controller.dart';

class TotalExpensesCard extends StatelessWidget {
  final ExpenseController controller;
  final bool isReport;

  const TotalExpensesCard({
    super.key,
    required this.controller,
    this.isReport = false,
  });

  RxDouble get _totalExpense {
    return isReport ? controller.reportTotalExpense : controller.totalExpense;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final amount = _totalExpense.value;
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            colors: [Color(0xFF009688), Color(0xFF26A69A)], // primary to teal-500
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Total Expenses',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            Text(
              '${amount.toCurrency()} ৳',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      );
    });
  }
}
