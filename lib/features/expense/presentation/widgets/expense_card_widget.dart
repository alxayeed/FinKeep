import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:spendly/core/extensions/date_time_formatter.dart';
import 'package:spendly/core/routes/app_router.dart';
import 'package:spendly/features/expense/domain/entities/expense_entity.dart';

class ExpenseCardWidget extends StatelessWidget {
  final ExpenseEntity expense;

  const ExpenseCardWidget({
    super.key,
    required this.expense,
  });

  @override
  Widget build(BuildContext context) {
    Color categoryBgColor;
    Color categoryColor;
    IconData categoryIcon;

    switch (expense.category.toLowerCase()) {
      case 'food':
        categoryBgColor = const Color(0xFFE8F5E9); // green-50
        categoryColor = const Color(0xFF4CAF50); // accent-green
        categoryIcon = Icons.restaurant;
        break;
      case 'transport':
        categoryBgColor = const Color(0xFFFFF3E0); // orange-50
        categoryColor = const Color(0xFFFF9800); // accent-orange
        categoryIcon = Icons.directions_car;
        break;
      case 'family':
        categoryBgColor = const Color(0xFFF3E5F5); // purple-50
        categoryColor = const Color(0xFF9C27B0); // accent-purple
        categoryIcon = Icons.family_restroom;
        break;
      case 'personal':
        categoryBgColor = const Color(0xFFFCE4EC); // pink-50
        categoryColor = const Color(0xFFE91E63); // accent-pink
        categoryIcon = Icons.person;
        break;
      case 'lend':
        categoryBgColor = const Color(0xFFE0F2F1); // teal-50
        categoryColor = const Color(0xFF009688); // accent-teal
        categoryIcon = Icons.attach_money;
        break;
      case 'clothing':
        categoryBgColor = const Color(0xFFEFEBE9); // brown-50
        categoryColor = const Color(0xFF795548); // accent-brown
        categoryIcon = Icons.checkroom;
        break;
      case 'bill':
        categoryBgColor = const Color(0xFFE8EAF6); // indigo-50
        categoryColor = const Color(0xFF3F51B5); // accent-indigo
        categoryIcon = Icons.receipt;
        break;
      case 'utilities':
        categoryBgColor = const Color(0xFFFFEBEE); // red-50
        categoryColor = const Color(0xFFF44336); // accent-red
        categoryIcon = Icons.electrical_services;
        break;
      default:
        categoryBgColor = const Color(0xFFECEFF1); // slate-100
        categoryColor = const Color(0xFF607D8B); // accent-gray
        categoryIcon = Icons.category;
    }

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () {
        context.pushNamed(
          AppRoutes.expenseDetails,
          extra: expense,
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade200, width: 0.5),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.05),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: categoryBgColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(categoryIcon, size: 28, color: categoryColor),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    expense.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    expense.category,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    (expense.date as DateTime).formatToReadableShort(),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade400,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Text(
              '${expense.amount.toStringAsFixed(2)} ৳',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
