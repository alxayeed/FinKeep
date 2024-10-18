import 'package:flutter/material.dart';
import 'package:spendly/core/extensions/date_time_formatter.dart';

class ExpenseFormWidget extends StatelessWidget {
  final TextEditingController amountController;
  final TextEditingController categoryController;
  final TextEditingController descriptionController;
  final DateTime? selectedDate; // Add selected date field
  final Function(DateTime) onDateSelected; // Callback for date selection
  final Function() onSubmit;
  final String buttonText;

  const ExpenseFormWidget({
    super.key,
    required this.amountController,
    required this.categoryController,
    required this.descriptionController,
    required this.onDateSelected,
    required this.onSubmit,
    this.selectedDate, // Allow null
    required this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
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
        GestureDetector(
          onTap: () async {
            final DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: selectedDate ?? DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2101),
            );
            if (pickedDate != null) {
              onDateSelected(pickedDate); // Call the callback
            }
          },
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  selectedDate != null
                      ? selectedDate!.formatDate() // Format without time
                      : 'Select Date',
                  style: const TextStyle(fontSize: 16),
                ),
                const Icon(Icons.calendar_today),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: onSubmit,
          child: Text(buttonText),
        ),
      ],
    );
  }
}
