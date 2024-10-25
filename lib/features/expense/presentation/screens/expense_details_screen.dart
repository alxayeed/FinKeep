import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:spendly/core/extensions/date_time_formatter.dart';
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
            icon: const FaIcon(FontAwesomeIcons.filePen, color: Colors.green),
            onPressed: () {
              // Navigate to EditExpenseScreen
              Get.bottomSheet(
                EditExpenseScreen(expense: expense),
                isScrollControlled: true,
              );
              // Get.to(() => EditExpenseScreen(expense: expense));
            },
          ),
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.trash, color: Colors.red,),
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
                      onPressed: (){
                        controller.deleteExpense(expense.id);
                    },
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
            _buildDetailText('Amount', expense.amount.toString(), FontAwesomeIcons.bangladeshiTakaSign),
            const Divider(thickness: 1),
            _buildDetailText('Category', expense.category, Icons.category),
            const Divider(thickness: 1),
            _buildDetailText('Date', expense.date.formatToReadable(), FontAwesomeIcons.calendarDays),
            const Divider(thickness: 1),
            _buildDetailText('Description', expense.description, Icons.description),
            const Divider(thickness: 1),
            _buildDetailText('User ID', expense.userId, Icons.person),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailText(String title, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          FaIcon(icon, color: Colors.grey[700]), // Icon for the field
          const SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 4.0),
                Text(
                  value,
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
