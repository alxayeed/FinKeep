import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/enums/expense_category.dart';
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
  late TextEditingController descriptionController;

  DateTime? selectedDate;
  ExpenseCategory? selectedCategory;

  @override
  void initState() {
    super.initState();
    amountController = TextEditingController(text: widget.expense.amount.toString());
    descriptionController = TextEditingController(text: widget.expense.description);
    selectedDate = widget.expense.date;
    selectedCategory = ExpenseCategory.values.firstWhere(
          (category) => category.displayName == widget.expense.category,
    );
  }

  @override
  void dispose() {
    amountController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

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
          selectedCategory: selectedCategory,
          onDateSelected: (date) {
            setState(() {
              selectedDate = date;
            });
          },
          onCategorySelected: (category) {
            setState(() {
              selectedCategory = category;
            });
          },
          onSubmit: () {
            if (selectedCategory == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please select a category.')),
              );
              return;
            }
        
            final updatedExpense = widget.expense.copyWith(
              amount: double.parse(amountController.text),
              category: selectedCategory!.displayName,
              date: DateTime(
                selectedDate?.year ?? widget.expense.date.year,
                selectedDate?.month ?? widget.expense.date.month,
                selectedDate?.day ?? widget.expense.date.day,
              ),
              description: descriptionController.text,
            );
            controller.editExpense(updatedExpense);
            Get.back();
          },
          buttonText: 'Update Expense',
        ),
      ),
    );
  }
}
