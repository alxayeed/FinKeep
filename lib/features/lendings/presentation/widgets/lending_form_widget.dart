import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spendly/core/common/widgets/widgets.dart';
import 'package:spendly/features/lendings/presentation/controllers/lendings_controller.dart';

import '../../../../core/styles/app_colors.dart';
import '../../domain/entity/lending/lending_entity.dart';
import '../../domain/entity/lending_person/lending_person_entity.dart';

class LendingFormWidget extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final personNameController = TextEditingController();
    final personContactController = TextEditingController();
    final amountController = TextEditingController();
    final descriptionController = TextEditingController();

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
          key: formKey,
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
                value: controller.selectedTypeFilter.value,
                labelText: 'Type',
                items: LendingType.values
                    .map((type) => DropdownMenuItem(
                          value: type,
                          child: Text(type.name.capitalizeFirst ?? type.name),
                        ))
                    .toList(),
                onChanged: (type) => controller.selectedTypeFilter.value = type,
                prefixIcon: Icons.swap_horiz,
                validator: (value) =>
                    value == null ? 'Please select a type' : null,
              ),
              const SizedBox(height: 15),

              // --- Lending Status ---
              StyledDropdownFormField<LendingStatus>(
                value: controller.selectedStatusFilter.value,
                labelText: 'Status',
                items: LendingStatus.values
                    .map((status) => DropdownMenuItem(
                          value: status,
                          child:
                              Text(status.name.capitalizeFirst ?? status.name),
                        ))
                    .toList(),
                onChanged: (status) =>
                    controller.selectedStatusFilter.value = status,
                prefixIcon: Icons.check_circle_outline,
                validator: (value) =>
                    value == null ? 'Please select a status' : null,
              ),
              const SizedBox(height: 20),

              // --- Due Date ---
              StyledDatePickerButton(
                labelText: 'Due Date',
                hintText: 'Select Due Date (Optional)',
                selectedDate: controller.selectedMonthFilter.value,
                onDateSelected: (date) =>
                    controller.selectedMonthFilter.value = date,
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
                text: buttonText,
                onPressed: () {
                  if (formKey?.currentState?.validate() ?? true) {
                    final personName = personNameController.text.trim();
                    final personContact = personContactController.text.trim();

                    final lending = LendingEntity(
                      id: '',
                      personId: "",
                      userId: "dummy_user",
                      person: LendingPersonEntity(
                        id: '', // Will be created if new
                        userId: "dummy_user",
                        name: personName,
                        contactNumber: personContact,
                      ),
                      amount: double.tryParse(amountController.text) ?? 0,
                      description: descriptionController.text.trim(),
                      type: controller.selectedTypeFilter.value!,
                      status: controller.selectedStatusFilter.value!,
                      dueDate: controller.selectedMonthFilter.value,
                      createdDate: DateTime.now(),
                    );

                    controller.addLending(lending);
                  }
                },
                isLoading: controller.isLoading.value,
                icon: Icons.save_alt_rounded,
              ),
            ],
          ),
        ),
      );
    });
  }
}
