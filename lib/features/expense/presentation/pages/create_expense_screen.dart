import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/entities/expense_entity.dart';
import '../controllers/expense_controller.dart';

class CreateExpenseScreen extends StatelessWidget {
  final ExpenseController controller = Get.find();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  CreateExpenseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Expense')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: amountController,
              decoration: const InputDecoration(labelText: 'Amount'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: categoryController,
              decoration: const InputDecoration(labelText: 'Category'),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final newExpense = ExpenseEntity(
                  id: DateTime.now().toString(),
                  amount: double.parse(amountController.text),
                  category: categoryController.text,
                  date: DateTime.now(),
                  description: descriptionController.text,
                  userId: 'dummy_user_id', // Replace with actual user ID
                );
                controller.createExpense(newExpense);
                Get.back(); // Navigate back after adding
              },
              child: const Text('Create Expense'),
            ),
          ],
        ),
      ),
    );
  }
}
