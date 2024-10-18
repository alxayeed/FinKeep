import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/entities/expense_entity.dart';
import '../controllers/expense_controller.dart';
import 'edit_expense_screen.dart';

class ExpenseDetailsScreen extends StatelessWidget {
  final ExpenseEntity expense;
  final ExpenseController controller = Get.find();

  ExpenseDetailsScreen({super.key, required this.expense});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // Navigate to EditExpenseScreen
              Get.to(() => EditExpenseScreen(expense: expense));
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              // Show a confirmation dialog before deleting
              final confirm = await showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Delete Expense'),
                  content: const Text('Are you sure you want to delete this expense?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, true),
                      child: const Text('Delete'),
                    ),
                  ],
                ),
              );

              // If the user confirmed, delete the expense
              if (confirm) {
                await controller.removeExpense(expense.id);
                Get.back(); // Go back after deletion
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Amount', expense.amount.toString()),
            _buildDetailRow('Category', expense.category),
            _buildDetailRow('Date', expense.date.toString()),
            _buildDetailRow('Description', expense.description),
            _buildDetailRow('User ID', expense.userId),
            _buildDetailRow('Created At', expense.createdAt.toString()),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(
            '$title: ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
