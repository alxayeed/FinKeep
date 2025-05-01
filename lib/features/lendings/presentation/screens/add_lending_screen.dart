import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spendly/features/lendings/presentation/controllers/add_lending_controller.dart';
import 'package:spendly/features/lendings/presentation/widgets/custom_date_picker_form_field.dart';
import 'package:spendly/features/lendings/presentation/widgets/custom_dropdown_form_field.dart';
import 'package:spendly/features/lendings/presentation/widgets/custom_elevated_button.dart';
import 'package:spendly/features/lendings/presentation/widgets/custom_text_form_field.dart';

import '../../domain/entity/lend_entity.dart';

class AddLendingScreen extends GetView<AddLendingController> {
  const AddLendingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Lending'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Person Name
                CustomTextFormField(
                  controller: controller.personNameController,
                  labelText: 'Person Name',
                  validator: (value) => (value == null || value.isEmpty)
                      ? 'Please enter a name'
                      : null,
                ),
                const SizedBox(height: 16),

                // Amount
                CustomTextFormField(
                  controller: controller.amountController,
                  labelText: 'Amount',
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
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
                const SizedBox(height: 16),

                // Lending Type Dropdown
                Obx(() => CustomDropdownFormField<LendingType>(
                      labelText: 'Type',
                      value: controller.selectedType.value,
                      items: LendingType.values
                          .map((type) => DropdownMenuItem(
                                value: type,
                                child: Text(type.name.capitalizeFirst ??
                                    type.name), // Simple capitalize
                              ))
                          .toList(),
                      onChanged: controller.updateType,
                      validator: (value) =>
                          value == null ? 'Please select a type' : null,
                    )),
                const SizedBox(height: 16),

                // Status Dropdown (Consider if this should be editable on add)
                // If always 'Due' on add, hide this or make it non-editable display
                Obx(() => CustomDropdownFormField<LendingStatus>(
                      labelText: 'Status',
                      value: controller.selectedStatus.value,
                      items: LendingStatus.values
                          .map((status) => DropdownMenuItem(
                                value: status,
                                child: Text(
                                    status.name.capitalizeFirst ?? status.name),
                              ))
                          .toList(),
                      onChanged: controller.updateStatus,
                      validator: (value) =>
                          value == null ? 'Please select a status' : null,
                    )),
                const SizedBox(height: 16),

                // Created Date Picker
                Obx(() => CustomDatePickerFormField(
                      labelText: 'Date',
                      selectedDate: controller.selectedCreatedDate.value,
                      onDateSelected: controller.updateCreatedDate,
                      firstDate: DateTime(2000),
                      // Adjust range as needed
                      lastDate: DateTime(2101),
                      validator: (value) =>
                          value == null ? 'Please select a date' : null,
                    )),
                const SizedBox(height: 16),

                // Due Date Picker (Optional)
                Obx(() => CustomDatePickerFormField(
                      labelText: 'Due Date (Optional)',
                      selectedDate: controller.selectedDueDate.value,
                      onDateSelected: controller.updateDueDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                      isOptional: true, // Allows clearing
                      // No validator needed if optional, or add custom logic
                    )),
                const SizedBox(height: 16),

                // Description (Optional)
                CustomTextFormField(
                  controller: controller.descriptionController,
                  labelText: 'Description (Optional)',
                  maxLines: 3,
                  keyboardType: TextInputType.multiline,
                  // No validator needed if optional
                ),
                const SizedBox(height: 24),

                // Error Message Display
                Obx(() {
                  if (controller.errorMessage.value != null) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        controller.errorMessage.value!,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.error),
                        textAlign: TextAlign.center,
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                }),

                // Submit Button
                Obx(() => CustomElevatedButton(
                      text: 'Add Lending',
                      isLoading: controller.isLoading.value,
                      onPressed: controller.submitLending,
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
