import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spendly/core/common/widgets/widgets.dart';
import 'package:spendly/core/styles/app_colors.dart';

import '../../domain/entity/lending/lending_entity.dart';
import '../controllers/lendings_controller.dart';

class UpdateLendingScreen extends StatefulWidget {
  final LendingEntity lending;

  const UpdateLendingScreen({super.key, required this.lending});

  @override
  State<UpdateLendingScreen> createState() => _UpdateLendingScreenState();
}

class _UpdateLendingScreenState extends State<UpdateLendingScreen> {
  final _formKey = GlobalKey<FormState>();
  final LendingsController controller = Get.find<LendingsController>();

  late TextEditingController personNameController;
  late TextEditingController personContactController;
  late TextEditingController amountController;
  late TextEditingController descriptionController;

  @override
  void initState() {
    super.initState();

    final l = widget.lending;

    personNameController = TextEditingController(text: l.person.name);
    personContactController =
        TextEditingController(text: l.person.contactNumber);
    amountController = TextEditingController(text: l.amount.toString());
    descriptionController = TextEditingController(text: l.description ?? '');

    controller.selectedTypeFilter.value = l.type;
    controller.selectedStatusFilter.value = l.status;
    controller.selectedMonthFilter.value = l.dueDate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Lending'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Obx(() {
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
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  /// Person Name
                  StyledTextFormField(
                    controller: personNameController,
                    readOnly: true,
                    labelText: 'Person Name',
                    prefixIcon: Icons.person_outline,
                  ),

                  const SizedBox(height: 15),

                  /// Contact
                  StyledTextFormField(
                    readOnly: true,
                    controller: personContactController,
                    keyboardType: TextInputType.phone,
                    labelText: 'Contact No',
                    prefixIcon: Icons.phone,
                  ),

                  const SizedBox(height: 15),

                  /// Amount
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

                  /// Type
                  StyledDropdownFormField<LendingType>(
                    value: controller.selectedTypeFilter.value,
                    labelText: 'Type',
                    items: LendingType.values
                        .map((type) => DropdownMenuItem(
                              value: type,
                              child:
                                  Text(type.name.capitalizeFirst ?? type.name),
                            ))
                        .toList(),
                    onChanged: (type) =>
                        controller.selectedTypeFilter.value = type,
                    prefixIcon: Icons.swap_horiz,
                    validator: (value) =>
                        value == null ? 'Please select type' : null,
                  ),

                  const SizedBox(height: 15),

                  /// Status
                  StyledDropdownFormField<LendingStatus>(
                    value: controller.selectedStatusFilter.value,
                    labelText: 'Status',
                    items: LendingStatus.values
                        .map((status) => DropdownMenuItem(
                              value: status,
                              child: Text(
                                  status.name.capitalizeFirst ?? status.name),
                            ))
                        .toList(),
                    onChanged: (status) =>
                        controller.selectedStatusFilter.value = status,
                    prefixIcon: Icons.check_circle_outline,
                    validator: (value) =>
                        value == null ? 'Please select status' : null,
                  ),

                  const SizedBox(height: 20),

                  /// Due date
                  StyledDatePickerButton(
                    labelText: 'Due Date',
                    hintText: 'Select Due Date (Optional)',
                    selectedDate: controller.selectedMonthFilter.value,
                    onDateSelected: (date) =>
                        controller.selectedMonthFilter.value = date,
                    isOptional: true,
                    firstDate:
                        DateTime.now().subtract(const Duration(days: 365)),
                    lastDate: DateTime(2101),
                  ),

                  const SizedBox(height: 15),

                  /// Description
                  StyledTextFormField(
                    controller: descriptionController,
                    labelText: 'Description (Optional)',
                    maxLines: 3,
                    keyboardType: TextInputType.multiline,
                    // prefixIcon: Icons.notes_rounded,
                  ),

                  const SizedBox(height: 25),

                  /// Submit button
                  StyledElevatedButton(
                    text: 'Update',
                    isLoading: controller.isLoading.value,
                    icon: Icons.update_rounded,
                    onPressed: () {
                      if (!_formKey.currentState!.validate()) return;

                      final updated = LendingEntity(
                        id: widget.lending.id,
                        userId: widget.lending.userId,
                        personId: widget.lending.person.id,
                        person: widget.lending.person,
                        amount: double.parse(amountController.text),
                        description: descriptionController.text.trim(),
                        type: controller.selectedTypeFilter.value!,
                        status: controller.selectedStatusFilter.value!,
                        dueDate: controller.selectedMonthFilter.value,
                        createdDate: widget.lending.createdDate,
                        repayments: widget.lending.repayments,
                      );

                      controller.updateLending(updated);
                      Get.back();
                    },
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
