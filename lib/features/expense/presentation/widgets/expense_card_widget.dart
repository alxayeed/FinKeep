import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:spendly/core/extensions/date_time_formatter.dart';
import 'package:spendly/core/routes/app_routes.dart';

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

    // Define colors and icons for different categories
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
      case 'other':
        categoryColor = Colors.blueGrey;
        categoryIcon = Icons.category;
        break;
      default:
        categoryColor = Colors.blueAccent;
        categoryIcon = Icons.attach_money; // Default icon
    }

    return Dismissible(
      key: Key(expense.id.toString()),
      background: Container(color: Colors.red),
      confirmDismiss: (direction) async {
        return await _showConfirmationDialog();
      },
      onDismissed: (direction) {
        onDismissed();
      },
      child: GestureDetector(
        onTap: () {
          Get.toNamed(AppRoutes.expenseDetails, arguments: expense);
        },
        child: Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Category Circle Avatar
                CircleAvatar(
                  backgroundColor: categoryColor,
                  child: Icon(
                    categoryIcon,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 16.0),
                // Category, Description, and Amount
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        expense.category,
                        style:
                            const TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        expense.description ?? "No description provided",
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      // Use the extension to format the date
                      Text(
                        (expense.date as DateTime).formatToReadable(),
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                // Amount Section
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Text(
                          '${expense.amount.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const Icon(
                          FontAwesomeIcons.bangladeshiTakaSign,
                          size: 16,
                        )
                      ],
                    ),
                    const SizedBox(height: 8.0),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _showConfirmationDialog() async {
    return await Get.defaultDialog<bool>(
          title: 'Delete Expense',
          middleText: 'Are you sure you want to delete this expense?',
          onConfirm: () {
            Get.back(result: true);
          },
          onCancel: () {
            Get.back(result: false);
          },
        ) ??
        false;
  }
}
