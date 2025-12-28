import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/enums/expense_category.dart';
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
  final TextEditingController descriptionController = TextEditingController();

  DateTime? selectedDate;
  ExpenseCategory? selectedCategory;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      child: SingleChildScrollView(
        child: ExpenseFormWidget(
          amountController: amountController,
          descriptionController: descriptionController,
          selectedDate: selectedDate ?? DateTime.now(),
          onDateSelected: (date) {
            setState(() {
              selectedDate = date;
            });
          },
          onSubmit: () async {
            if (selectedCategory == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please select a category.')),
              );
              return;
            }

            final newExpense = ExpenseEntity(
              id: DateTime.now().toString(),
              amount: double.parse(amountController.text),
              category: selectedCategory!.displayName,
              date: selectedDate ?? DateTime.now().toLocal(),
              description: descriptionController.text,
              userId: controller.userId,
            );

            await controller.createExpense(
              newExpense,
              onSuccess: () {
                if (!context.mounted) return;

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Expense successfully recorded!'),
                    backgroundColor: Colors.green,
                  ),
                );
                context.pop();
              },
              onError: (e) {
                if (!context.mounted) return;

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Failed to save expense: ${e.toString()}'),
                    backgroundColor: Colors.red,
                  ),
                );
              },
            );
          },
          selectedCategory: selectedCategory,
          onCategorySelected: (category) {
            setState(() {
              selectedCategory = category;
            });
          },
          buttonText: 'Create Expense',
        ),
      ),
    );
  }
}
