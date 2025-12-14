import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:spendly/core/extensions/date_time_formatter.dart';

import '../../../../core/routes/app_router.dart';

class ExpenseCardWidget extends StatelessWidget {
  final dynamic expense;
  final VoidCallback onDismissed;

  const ExpenseCardWidget({
    super.key,
    required this.expense,
    required this.onDismissed,
  });

  @override
  Widget build(BuildContext context) {
    Color categoryColor;
    IconData categoryIcon;

    switch (expense.category.toLowerCase()) {
      case 'food':
        categoryColor = Colors.green;
        categoryIcon = Icons.restaurant;
        break;
      case 'transport':
        categoryColor = Colors.orange;
        categoryIcon = Icons.directions_car;
        break;
      case 'family':
        categoryColor = Colors.purple;
        categoryIcon = Icons.family_restroom;
        break;
      case 'personal':
        categoryColor = Colors.pink;
        categoryIcon = Icons.person;
        break;
      case 'lend':
        categoryColor = Colors.teal;
        categoryIcon = Icons.attach_money;
        break;
      case 'clothing':
        categoryColor = Colors.brown;
        categoryIcon = Icons.checkroom;
        break;
      case 'bill':
        categoryColor = Colors.indigo;
        categoryIcon = Icons.receipt;
        break;
      case 'utilities':
        categoryColor = Colors.red;
        categoryIcon = Icons.electrical_services;
        break;
      default:
        categoryColor = Colors.blueGrey;
        categoryIcon = Icons.category;
    }

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        context.pushNamed(
          AppRoutes.expenseDetails,
          extra: expense,
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: categoryColor,
                    child: Icon(categoryIcon, size: 18, color: Colors.white),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    expense.category,
                    style: const TextStyle(
                      fontSize: 10,
                      // fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (expense.description != null &&
                        expense.description!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          expense.description,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ),
                    const SizedBox(height: 4),
                    Text(
                      (expense.date as DateTime).formatToReadableShort(),
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Row(
                children: [
                  Text(
                    expense.amount.toStringAsFixed(2),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(width: 2),
                  const Icon(
                    FontAwesomeIcons.bangladeshiTakaSign,
                    size: 14,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _showConfirmationDialog(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Expense'),
        content: const Text('Are you sure you want to delete this expense?'),
        actions: [
          TextButton(
              onPressed: () => ctx.pop(false), child: const Text('Cancel')),
          TextButton(
              onPressed: () => ctx.pop(true), child: const Text('Confirm')),
        ],
      ),
    );
    return result ?? false;
  }
}
