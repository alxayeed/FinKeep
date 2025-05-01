import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spendly/features/lendings/domain/usecases/add_lending_usecase.dart';
import 'package:spendly/features/lendings/presentation/controllers/lending_list_controller.dart';

import '../../domain/entity/lend_entity.dart';

class AddLendingController extends GetxController {
  final AddLendingUseCase addLendingUseCase;

  AddLendingController({
    required this.addLendingUseCase,
  });

  final formKey = GlobalKey<FormState>();
  final personNameController = TextEditingController();
  final amountController = TextEditingController();
  final descriptionController = TextEditingController();

  final selectedType = Rx<LendingType?>(null);
  final selectedStatus = Rx<LendingStatus?>(null);
  final selectedDueDate = Rx<DateTime?>(null);

  final isLoading = false.obs;
  final errorMessage = Rx<String?>(null);

  @override
  void onClose() {
    personNameController.dispose();
    amountController.dispose();
    descriptionController.dispose();
    super.onClose();
  }

  void updateType(LendingType? type) {
    selectedType.value = type;
  }

  void updateStatus(LendingStatus? status) {
    selectedStatus.value = status;
  }

  void updateDueDate(DateTime? date) {
    selectedDueDate.value = date;
  }

  Future<void> submitLending() async {
    errorMessage.value = null;
    if (!(formKey.currentState?.validate() ?? false)) {
      return;
    }

    if (selectedType.value == null) {
      errorMessage.value = "Please select a lending type.";
      return;
    }
    if (selectedStatus.value == null) {
      errorMessage.value = "Please select a lending status.";
      return;
    }

    isLoading.value = true;

    final amount = double.tryParse(amountController.text);
    if (amount == null || amount <= 0) {
      errorMessage.value = "Please enter a valid positive amount.";
      isLoading.value = false;
      return;
    }

    const userId = "placeholder_user_id";

    final newLending = LendingEntity(
      id: '',
      type: selectedType.value!,
      personName: personNameController.text.trim(),
      amount: amount,
      description: descriptionController.text.trim().isEmpty
          ? null
          : descriptionController.text.trim(),
      createdDate: DateTime.now(),
      dueDate: selectedDueDate.value,
      status: selectedStatus.value!,
      userId: userId,
    );

    final result = await addLendingUseCase(newLending);

    isLoading.value = false;

    result.fold(
      (failure) {
        errorMessage.value = failure.message;
      },
      (_) {
        try {
          if (Get.isRegistered<LendingListController>()) {
            final listController = Get.find<LendingListController>();
            listController.fetchLendings(showLoading: false);
          }
        } catch (e) {
          print(
              "LendingListController not found or error triggering refresh: $e");
        }

        Get.back();
        Get.snackbar('Success', 'Lending added successfully!');
      },
    );
  }
}
