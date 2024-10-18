import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/entities/expense_entity.dart';
import '../controllers/expense_controller.dart';

class EditExpenseScreen extends StatefulWidget {
  final ExpenseEntity expense;

  const EditExpenseScreen({super.key, required this.expense});

  @override
  State<EditExpenseScreen> createState() => _EditExpenseScreenState();
}

class _EditExpenseScreenState extends State<EditExpenseScreen> {
  final ExpenseController controller = Get.find();
  late TextEditingController amountController;
  late TextEditingController categoryController;
  late TextEditingController descriptionController;

  @override
  void initState() {
    super.initState();
    amountController = TextEditingController(text: widget.expense.amount.toString());
    categoryController = TextEditingController(text: widget.expense.category);
    descriptionController = TextEditingController(text: widget.expense.description);
  }

  @override
  void dispose() {
    // Clean up the controllers when the widget is disposed
    amountController.dispose();
    categoryController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Expense')),
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
                final updatedExpense = widget.expense.copyWith(
                  amount: double.parse(amountController.text),
                  category: categoryController.text,
                  description: descriptionController.text,
                );
                controller.editExpense(updatedExpense);
                Get.back(); // Navigate back after updating
              },
              child: const Text('Update Expense'),
            ),
          ],
        ),
      ),
    );
  }
}
