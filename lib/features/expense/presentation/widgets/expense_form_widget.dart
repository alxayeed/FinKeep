import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/enums/expense_category.dart';

class ExpenseFormWidget extends StatefulWidget {
  final TextEditingController amountController;
  final TextEditingController descriptionController;
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;
  final Function() onSubmit;
  final String buttonText;
  final ExpenseCategory? selectedCategory;
  final Function(ExpenseCategory) onCategorySelected;

  const ExpenseFormWidget({
    super.key,
    required this.amountController,
    required this.descriptionController,
    required this.onDateSelected,
    required this.onSubmit,
    required this.selectedDate,
    required this.selectedCategory,
    required this.onCategorySelected,
    required this.buttonText,
  });

  @override
  State<ExpenseFormWidget> createState() => _ExpenseFormWidgetState();
}

class _ExpenseFormWidgetState extends State<ExpenseFormWidget> {
  late List<ExpenseCategory> dropdownItems;
  late ExpenseCategory? currentCategory;

  @override
  void initState() {
    super.initState();
    dropdownItems = List.from(ExpenseCategory.values);
    currentCategory = widget.selectedCategory;
  }

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
            controller: widget.amountController,
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
          DropdownButtonFormField<ExpenseCategory>(
            value: currentCategory,
            decoration: InputDecoration(
              labelText: "Category",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            items: dropdownItems.map((ExpenseCategory category) {
              return DropdownMenuItem<ExpenseCategory>(
                value: category,
                child: Text(category.displayName),
              );
            }).toList(),
            onChanged: (ExpenseCategory? newValue) {
              if (newValue != null) {
                setState(() {
                  currentCategory = newValue;
                });
                widget.onCategorySelected(newValue);
              }
            },
          ),
          const SizedBox(height: 10),
          TextField(
            controller: widget.descriptionController,
            maxLines: 3,
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
                initialDate: widget.selectedDate,
                firstDate: DateTime(2000),
                lastDate: DateTime(2101),
              );
              if (pickedDate != null) {
                widget.onDateSelected(pickedDate);
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
                    DateFormat('d\'th\' MMMM').format(widget.selectedDate),
                    style: const TextStyle(fontSize: 16, color: Colors.blueAccent),
                  ),
                  const Icon(Icons.calendar_today, color: Colors.blueAccent),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                widget.onSubmit();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: Text(
                widget.buttonText,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
