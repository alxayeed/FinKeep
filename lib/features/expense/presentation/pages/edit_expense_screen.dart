import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/entities/expense_entity.dart';
import '../controllers/expense_controller.dart';
import '../widgets/expense_form_widget.dart';

class EditExpenseScreen extends StatefulWidget {
  final ExpenseEntity expense;

  const EditExpenseScreen({super.key, required this.expense});

  @override
  State<EditExpenseScreen> createState() => _EditExpenseScreenState();
}

class _EditExpenseScreenState extends State<EditExpenseScreen> {
  final ExpenseController controller = Get.find();
  late TextEditingController amountController;
  late TextEditingController categoryController;
  late TextEditingController descriptionController;

  DateTime? selectedDate; // Remove selectedTime

  @override
  void initState() {
    super.initState();
    amountController = TextEditingController(text: widget.expense.amount.toString());
    categoryController = TextEditingController(text: widget.expense.category);
    descriptionController = TextEditingController(text: widget.expense.description);
    selectedDate = widget.expense.date; // Keep only selectedDate
  }

  @override
  void dispose() {
    amountController.dispose();
    categoryController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Expense')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ExpenseFormWidget(
            amountController: amountController,
            categoryController: categoryController,
            descriptionController: descriptionController,
            selectedDate: selectedDate,
            onDateSelected: (date) {
              setState(() {
                selectedDate = date; // Update selectedDate on date selection
              });
            },
            onSubmit: () {
              final updatedExpense = widget.expense.copyWith(
                amount: double.parse(amountController.text),
                category: categoryController.text,
                date: DateTime(
                  selectedDate?.year ?? widget.expense.date.year,
                  selectedDate?.month ?? widget.expense.date.month,
                  selectedDate?.day ?? widget.expense.date.day,
                ),
                description: descriptionController.text,
              );
              controller.editExpense(updatedExpense);
              Get.back(); // Navigate back after updating
            },
            buttonText: 'Update Expense',
          ),
        ),
      ),
    );
  }
}
