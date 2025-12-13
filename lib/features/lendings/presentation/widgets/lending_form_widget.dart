import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:spendly/core/common/widgets/widgets.dart';
import 'package:spendly/features/lendings/presentation/controllers/lendings_controller.dart';

import '../../../../core/styles/app_colors.dart';
import '../../domain/entity/lending/lending_entity.dart';
import '../../domain/entity/lending_person/lending_person_entity.dart';

class LendingFormWidget extends StatefulWidget {
  final LendingsController controller;
  final GlobalKey<FormState>? formKey;
  final String buttonText;

  const LendingFormWidget({
    super.key,
    required this.controller,
    this.formKey,
    this.buttonText = 'Save',
  });

  @override
  State<LendingFormWidget> createState() => _LendingFormWidgetState();
}

class _LendingFormWidgetState extends State<LendingFormWidget> {
  final personNameController = TextEditingController();
  final personContactController = TextEditingController();
  final amountController = TextEditingController();
  final descriptionController = TextEditingController();

  Future<void> _saveLending(BuildContext context) async {
    if (!(widget.formKey?.currentState?.validate() ?? false)) {
      return;
    }

    if (widget.controller.selectedTypeFilter.value == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a lending type.')),
      );
      return;
    }

    final personName = personNameController.text.trim();
    final personContact = personContactController.text.trim();

    final lending = LendingEntity(
      id: '',
      personId: "",
      userId: widget.controller.userId,
      person: LendingPersonEntity(
        id: '',
        userId: widget.controller.userId,
        name: personName,
        contactNumber: personContact,
      ),
      amount: double.tryParse(amountController.text) ?? 0,
      description: descriptionController.text.trim(),
      type: widget.controller.selectedTypeFilter.value!,
      status: widget.controller.selectedStatusFilter.value!,
      dueDate: widget.controller.selectedMonthFilter.value,
      createdDate: DateTime.now(),
    );

    await widget.controller.addLending(
      lending,
      onSuccess: () {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Lending added successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        context.pop();
      },
      onError: (e) {
        if (!context.mounted) return;

        final errorMessage = e?.toString() ?? 'An unknown error occurred.';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add lending: $errorMessage'),
            backgroundColor: Colors.red,
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    personNameController.dispose();
    personContactController.dispose();
    amountController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
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
          key: widget.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // --- Person Name (manual for now) ---
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
                controller: personContactController,
                keyboardType: TextInputType.phone,
                labelText: 'Contact No',
                prefixIcon: Icons.phone,
                validator: (value) => (value == null || value.isEmpty)
                    ? 'Please enter a phone no'
                    : null,
              ),
              const SizedBox(height: 15),

              // --- Amount ---
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

              // --- Lending Type ---
              StyledDropdownFormField<LendingType>(
                value: widget.controller.selectedTypeFilter.value,
                labelText: 'Type',
                items: LendingType.values
                    .map((type) => DropdownMenuItem(
                          value: type,
                          child: Text(type.name.capitalizeFirst ?? type.name),
                        ))
                    .toList(),
                onChanged: (type) =>
                    widget.controller.selectedTypeFilter.value = type,
                prefixIcon: Icons.swap_horiz,
                validator: (value) =>
                    value == null ? 'Please select a type' : null,
              ),
              const SizedBox(height: 15),

              // --- Lending Status ---
              StyledDropdownFormField<LendingStatus>(
                value: widget.controller.selectedStatusFilter.value,
                labelText: 'Status',
                items: LendingStatus.values
                    .map((status) => DropdownMenuItem(
                          value: status,
                          child:
                              Text(status.name.capitalizeFirst ?? status.name),
                        ))
                    .toList(),
                onChanged: (status) =>
                    widget.controller.selectedStatusFilter.value = status,
                prefixIcon: Icons.check_circle_outline,
                validator: (value) =>
                    value == null ? 'Please select a status' : null,
              ),
              const SizedBox(height: 20),

              // --- Due Date ---
              StyledDatePickerButton(
                labelText: 'Due Date',
                hintText: 'Select Due Date (Optional)',
                selectedDate: widget.controller.selectedMonthFilter.value,
                onDateSelected: (date) =>
                    widget.controller.selectedMonthFilter.value = date,
                isOptional: true,
                firstDate: DateTime.now().subtract(const Duration(days: 365)),
                lastDate: DateTime(2101),
              ),
              const SizedBox(height: 15),

              // --- Description ---
              StyledTextFormField(
                controller: descriptionController,
                labelText: 'Description (Optional)',
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                prefixIcon: Icons.notes_rounded,
              ),
              const SizedBox(height: 25),

              // --- Submit Button ---
              StyledElevatedButton(
                text: widget.buttonText,
                onPressed: () => _saveLending(context),
                isLoading: widget.controller.isLoading.value,
                icon: Icons.save_alt_rounded,
              ),
            ],
          ),
        ),
      );
    });
  }
}
