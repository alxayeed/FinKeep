import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/entities/expense_entity.dart';
import '../controllers/expense_controller.dart';
import '../widgets/expense_form_widget.dart';

class CreateExpenseScreen extends StatefulWidget {
  const CreateExpenseScreen({super.key});

  @override
  State<CreateExpenseScreen> createState() => _CreateExpenseScreenState();
}

class _CreateExpenseScreenState extends State<CreateExpenseScreen> {
  final ExpenseController controller = Get.find();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  DateTime? selectedDate; // Keep only selectedDate

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Expense')),
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
              final newExpense = ExpenseEntity(
                id: DateTime.now().toString(),
                amount: double.parse(amountController.text),
                category: categoryController.text,
                date: DateTime(
                  selectedDate?.year ?? DateTime.now().year,
                  selectedDate?.month ?? DateTime.now().month,
                  selectedDate?.day ?? DateTime.now().day,
                ),
                description: descriptionController.text,
                userId: 'dummy_user_id', // Replace with actual user ID
              );
              controller.createExpense(newExpense);
              Get.back(); // Navigate back after adding
            },
            buttonText: 'Create Expense',
          ),
        ),
      ),
    );
  }
}
