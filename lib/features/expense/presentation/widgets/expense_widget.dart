import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:spendly/features/expense/presentation/pages/expense_details_screen.dart';

import '../../domain/entities/expense_entity.dart';
import '../pages/edit_expense_screen.dart';

class ExpenseWidget extends StatelessWidget {
  const ExpenseWidget({
    super.key,
    required this.expense,
  });

  final ExpenseEntity expense;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Get.to(ExpenseDetailsScreen(expense: expense));
      },
      child: ListTile(
        title: Text(expense.category),
        subtitle: Text('${expense.amount} on ${expense.date}'),
        trailing: IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () {
            Get.to(EditExpenseScreen(expense: expense));
          },
        ),
      ),
    );
  }
}
