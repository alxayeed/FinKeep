import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ExpenseFormWidget extends StatelessWidget {
  final TextEditingController amountController;
  final TextEditingController categoryController;
  final TextEditingController descriptionController;
  final DateTime selectedDate; // Make it non-nullable
  final Function(DateTime) onDateSelected; // Callback for date selection
  final Function() onSubmit;
  final String buttonText;

  ExpenseFormWidget({
    super.key,
    required this.amountController,
    required this.categoryController,
    required this.descriptionController,
    required this.onDateSelected,
    required this.onSubmit,
    DateTime? selectedDate, // Allow null, but set a default
    required this.buttonText,
  }) : selectedDate = selectedDate ?? DateTime.now(); // Default to today

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10.0,
            spreadRadius: 1.0,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: amountController,
            decoration: InputDecoration(
              labelText: 'Amount',
              labelStyle: const TextStyle(color: Colors.blueAccent),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 10),
          TextField(
            controller: categoryController,
            decoration: InputDecoration(
              labelText: 'Category',
              labelStyle: const TextStyle(color: Colors.blueAccent),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: descriptionController,
            decoration: InputDecoration(
              labelText: 'Description',
              labelStyle: const TextStyle(color: Colors.blueAccent),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () async {
              final DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: selectedDate,
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
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(color: Colors.blueAccent),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    DateFormat('d\'th\' MMMM').format(selectedDate), // Format date as "12th March"
                    style: const TextStyle(fontSize: 16, color: Colors.blueAccent),
                  ),
                  const Icon(Icons.calendar_today, color: Colors.blueAccent),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity, // Full-width button
            child: ElevatedButton(
              onPressed: onSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal, // Updated background color
                foregroundColor: Colors.white, // Updated text color
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: Text(
                buttonText,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
