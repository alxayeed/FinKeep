import 'package:flutter/material.dart';
import 'package:spendly/core/common/widgets/widgets.dart';

import '../../../../core/styles/app_colors.dart';
import '../../domain/entity/lend_entity.dart';

class LendingFormWidget extends StatelessWidget {
  final TextEditingController personNameController;
  final TextEditingController amountController;
  final TextEditingController descriptionController;
  final DateTime? selectedDueDate;
  final Function(DateTime?) onDueDateSelected;
  final LendingType? selectedType;
  final Function(LendingType?) onTypeSelected;
  final LendingStatus? selectedStatus;
  final Function(LendingStatus?) onStatusSelected;
  final Function() onSubmit;
  final String buttonText;
  final GlobalKey<FormState>? formKey;
  final bool isLoading;

  const LendingFormWidget({
    super.key,
    required this.personNameController,
    required this.amountController,
    required this.descriptionController,
    required this.selectedDueDate,
    required this.onDueDateSelected,
    required this.selectedType,
    required this.onTypeSelected,
    required this.selectedStatus,
    required this.onStatusSelected,
    required this.onSubmit,
    required this.buttonText,
    this.formKey,
    this.isLoading = false,
  });

  List<DropdownMenuItem<T>> _buildStyledDropdownItems<T>(
      List<T> items, String Function(T) displayText) {
    return items.map((item) {
      return DropdownMenuItem<T>(
        value: item,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
          child: Text(
            displayText(item),
            style: const TextStyle(
              fontSize: 15,
              color: AppColors.primaryTealDark,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final List<DropdownMenuItem<LendingType>> typeDropdownItems =
        _buildStyledDropdownItems<LendingType>(LendingType.values,
            (type) => type.name.capitalizeFirst ?? type.name);

    final List<DropdownMenuItem<LendingStatus>> statusDropdownItems =
        _buildStyledDropdownItems<LendingStatus>(LendingStatus.values,
            (status) => status.name.capitalizeFirst ?? status.name);

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
              controller: personNameController,
              labelText: 'Person Name',
              prefixIcon: Icons.person_outline,
              validator: (value) => (value == null || value.isEmpty)
                  ? 'Please enter a name'
                  : null,
            ),
            const SizedBox(height: 15),
            StyledTextFormField(
              controller: amountController,
              labelText: 'Amount',
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              prefixIcon: Icons.currency_lira,
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
            StyledDropdownFormField<LendingType>(
              value: selectedType,
              labelText: "Type",
              items: typeDropdownItems,
              onChanged: onTypeSelected,
              prefixIcon: Icons.swap_horiz,
              validator: (value) =>
                  value == null ? 'Please select a type' : null,
              itemHeight: 55,
            ),
            const SizedBox(height: 15),
            StyledDropdownFormField<LendingStatus>(
              value: selectedStatus,
              labelText: "Status",
              items: statusDropdownItems,
              onChanged: onStatusSelected,
              prefixIcon: Icons.check_circle_outline,
              validator: (value) =>
                  value == null ? 'Please select a status' : null,
              itemHeight: 55,
            ),
            const SizedBox(height: 20),
            StyledDatePickerButton(
              labelText: 'Due Date',
              hintText: 'Select Due Date (Optional)',
              selectedDate: selectedDueDate,
              onDateSelected: onDueDateSelected,
              isOptional: true,
              firstDate: DateTime.now().subtract(const Duration(days: 365)),
              lastDate: DateTime(2101),
            ),
            const SizedBox(height: 15),
            StyledTextFormField(
              controller: descriptionController,
              labelText: 'Description (Optional)',
              maxLines: 3,
              keyboardType: TextInputType.multiline,
              prefixIcon: Icons.notes_rounded,
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

extension StringExtension on String {
  String? get capitalizeFirst {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}
