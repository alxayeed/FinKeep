import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spendly/features/lendings/presentation/controllers/add_lending_controller.dart';
import 'package:spendly/features/lendings/presentation/widgets/lending_form_widget.dart'; // Import the new form widget

class AddLendingScreen extends GetView<AddLendingController> {
  const AddLendingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Consider making AppBar reusable if consistent across screens
      appBar: AppBar(
        title: const Text('Add New Lending'),
        // Optional: Add consistent AppBar styling if needed
        // backgroundColor: AppColors.primaryTeal,
        // foregroundColor: AppColors.white,
      ),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Obx(() => Column(
              children: [
                if (controller.errorMessage.value != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 20.0),
                    child: Text(
                      controller.errorMessage.value!,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                          fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ),
                // Use the LendingFormWidget
                LendingFormWidget(
                  formKey: controller.formKey,
                  personNameController: controller.personNameController,
                  amountController: controller.amountController,
                  descriptionController: controller.descriptionController,
                  selectedType: controller.selectedType.value,
                  onTypeSelected: controller.updateType,
                  selectedStatus: controller.selectedStatus.value,
                  onStatusSelected: controller.updateStatus,
                  selectedDueDate: controller.selectedDueDate.value,
                  onDueDateSelected: controller.updateDueDate,
                  onSubmit: controller.submitLending,
                  buttonText: 'Add Lending',
                  isLoading: controller.isLoading.value,
                ),
              ],
            )),
      ),
    );
  }
}
