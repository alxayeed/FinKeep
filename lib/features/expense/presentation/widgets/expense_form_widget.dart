import 'package:flutter/material.dart';
import 'package:spendly/core/common/widgets/widgets.dart';
import 'package:spendly/core/enums/expense_category.dart';

import '../../../../core/styles/app_colors.dart';

class ExpenseFormWidget extends StatelessWidget {
  final TextEditingController amountController;
  final TextEditingController descriptionController;
  final DateTime? selectedDate; // Changed to nullable
  final Function(DateTime?) onDateSelected; // Changed signature
  final Function() onSubmit;
  final String buttonText;
  final ExpenseCategory? selectedCategory;
  final Function(ExpenseCategory?) onCategorySelected;
  final GlobalKey<FormState>? formKey;
  final bool isLoading;

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
    this.formKey,
    this.isLoading = false,
  });

  List<DropdownMenuItem<ExpenseCategory>> _buildStyledDropdownItems(
      List<ExpenseCategory> items) {
    return items.map((item) {
      return DropdownMenuItem<ExpenseCategory>(
        value: item,
        child: Text(
          item.displayName,
          style: const TextStyle(
            fontSize: 15,
            color: AppColors.primaryTealDark,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final List<DropdownMenuItem<ExpenseCategory>> categoryDropdownItems =
        _buildStyledDropdownItems(ExpenseCategory.values);

    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: AppColors.white,
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
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            StyledTextFormField(
              controller: amountController,
              labelText: 'Amount',
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              prefixIcon: Icons.currency_rupee,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an amount';
                }
                if (double.tryParse(value) == null ||
                    double.parse(value) <= 0) {
                  return 'Please enter a valid positive amount';
                }
                return null;
              },
            ),
            const SizedBox(height: 15),
            StyledDropdownFormField<ExpenseCategory>(
              value: selectedCategory,
              labelText: "Category",
              items: categoryDropdownItems,
              onChanged: onCategorySelected,
              prefixIcon: Icons.category_outlined,
              validator: (value) =>
                  value == null ? 'Please select a category' : null,
              itemHeight: 55, // Add itemHeight for consistency
            ),
            const SizedBox(height: 15),
            StyledTextFormField(
              controller: descriptionController,
              labelText: 'Description',
              maxLines: 3,
              keyboardType: TextInputType.multiline,
              prefixIcon: Icons.notes_rounded,
            ),
            const SizedBox(height: 20),
            StyledDatePickerButton(
              labelText: 'Date',
              hintText: 'Select Expense Date',
              selectedDate: selectedDate,
              // Pass nullable date
              onDateSelected: onDateSelected,
              // Pass nullable callback
              isOptional: false,
              // Expense date is typically required
              firstDate: DateTime(2000),
              lastDate: DateTime.now()
                  .add(const Duration(days: 365)), // Example range
            ),
            const SizedBox(height: 25),
            StyledElevatedButton(
              text: buttonText,
              onPressed: onSubmit,
              isLoading: isLoading,
              icon: Icons.save_alt_rounded,
            ),
          ],
        ),
      ),
    );
  }
}
