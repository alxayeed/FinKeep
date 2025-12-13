import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:spendly/core/extensions/date_time_formatter.dart';

import '../../../../core/routes/app_router.dart';
import '../../domain/entities/expense_entity.dart';
import '../controllers/expense_controller.dart';
import 'edit_expense_screen.dart';

class ExpenseDetailsScreen extends StatefulWidget {
  final ExpenseEntity expense;

  const ExpenseDetailsScreen({super.key, required this.expense});

  @override
  State<ExpenseDetailsScreen> createState() => _ExpenseDetailsScreenState();
}

class _ExpenseDetailsScreenState extends State<ExpenseDetailsScreen> {
  final ExpenseController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Details'),
        actions: [
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.filePen, color: Colors.green),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (BuildContext context) {
                  return EditExpenseScreen(expense: widget.expense);
                },
              );
            },
          ),
          IconButton(
            icon: const FaIcon(
              FontAwesomeIcons.trash,
              color: Colors.red,
            ),
            onPressed: () async {
              final bool? confirm = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Delete Expense'),
                  content: const Text(
                      'Are you sure you want to delete this expense?'),
                  actions: [
                    TextButton(
                      onPressed: () => context.pop(false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => context.pop(true),
                      child: const Text('Delete'),
                    ),
                  ],
                ),
              );

              if (confirm == true) {
                await controller.removeExpense(
                  widget.expense.id,
                  onSuccess: () {
                    if (!context.mounted) return;
                    context.pushReplacementNamed(AppRoutes.expenses);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Expense successfully deleted.'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                  onError: (e) {
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content:
                            Text('Failed to delete expense: ${e.toString()}'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  },
                );
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
            _buildDetailText('Amount', widget.expense.amount.toString(),
                FontAwesomeIcons.bangladeshiTakaSign),
            const Divider(thickness: 1),
            _buildDetailText(
                'Category', widget.expense.category, Icons.category),
            const Divider(thickness: 1),
            _buildDetailText('Date', widget.expense.date.formatToReadable(),
                FontAwesomeIcons.calendarDays),
            const Divider(thickness: 1),
            _buildDetailText(
                'Description', widget.expense.description, Icons.description),
            const Divider(thickness: 1),
            _buildDetailText('User ID', widget.expense.userId, Icons.person),
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
          FaIcon(icon, color: Colors.grey[700]),
          const SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
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
