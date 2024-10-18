import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../pages/expense_details_screen.dart';

class ExpenseCardWidget extends StatelessWidget {
  final dynamic expense;
  final VoidCallback onDismissed;

  const ExpenseCardWidget(
      {super.key, required this.expense, required this.onDismissed});

  @override
  Widget build(BuildContext context) {
    Color categoryColor;

    switch (expense.category.toLowerCase()) {
      case 'food':
        categoryColor = Colors.green;
        break;
      case 'transport':
        categoryColor = Colors.orange;
        break;
      case 'utilities':
        categoryColor = Colors.red;
        break;
      default:
        categoryColor = Colors.blueAccent;
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
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: categoryColor,
            child: const Icon(
              Icons.food_bank,
              color: Colors.white,
            ),
          ),
          title: Text(
            expense.category,
            style: const TextStyle(fontSize: 16),
          ),
          subtitle: Text(
            _formatDate(expense.date),
            style: const TextStyle(color: Colors.grey),
          ),
          trailing: Text(
            '${expense.amount.toStringAsFixed(2)} ৳',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          onTap: () {
            Get.to(() => ExpenseDetailsScreen(expense: expense));
          },
        ),
      ),
    );
  }

  String _formatDate(dynamic date) {
    DateTime dateTime;
    if (date is DateTime) {
      dateTime = date;
    } else if (date is String) {
      dateTime = DateTime.parse(date); // Assuming the date string is in ISO 8601 format
    } else {
      return ''; // Return empty string if date is neither DateTime nor String
    }

    final dayWithSuffix = '${dateTime.day}${_getDaySuffix(dateTime.day)}';
    final month = _getMonthName(dateTime.month);
    final year = dateTime.year;

    return '$dayWithSuffix $month, $year';
  }

  String _getDaySuffix(int day) {
    if (day >= 11 && day <= 13) {
      return 'th';
    }
    switch (day % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }

  String _getMonthName(int month) {
    const monthNames = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return monthNames[month - 1];
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
