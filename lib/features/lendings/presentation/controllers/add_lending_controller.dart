import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spendly/features/lendings/domain/usecases/add_lending_usecase.dart';

import '../../domain/entity/lend_entity.dart';
// import 'package:spendly/services/auth_service.dart'; // Placeholder for getting user ID

class AddLendingController extends GetxController {
  final AddLendingUseCase addLendingUseCase;

  // final AuthService authService; // Example: Inject service to get user ID

  AddLendingController({
    required this.addLendingUseCase,
    // required this.authService,
  });

  // Form State
  final formKey = GlobalKey<FormState>();
  final personNameController = TextEditingController();
  final amountController = TextEditingController();
  final descriptionController = TextEditingController();

  final selectedType = Rx<LendingType>(LendingType.given);
  final selectedStatus = Rx<LendingStatus>(LendingStatus.due);
  final selectedCreatedDate = Rx<DateTime>(DateTime.now());
  final selectedDueDate = Rx<DateTime?>(null);

  // Operation State
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
    if (type != null) {
      selectedType.value = type;
    }
  }

  void updateStatus(LendingStatus? status) {
    if (status != null) {
      selectedStatus.value = status;
    }
  }

  void updateCreatedDate(DateTime? date) {
    if (date != null) {
      selectedCreatedDate.value = date;
    }
  }

  void updateDueDate(DateTime? date) {
    // Allow setting it to null or a specific date
    selectedDueDate.value = date;
  }

  Future<void> submitLending() async {
    errorMessage.value = null;
    if (!(formKey.currentState?.validate() ?? false)) {
      return;
    }

    isLoading.value = true;

    final amount = double.tryParse(amountController.text);
    if (amount == null || amount <= 0) {
      errorMessage.value = "Please enter a valid positive amount.";
      isLoading.value = false;
      return;
    }

    const userId = "placeholder_user_id"; // Replace with actual logic

    // Firestore generates the ID, so we pass an entity without a real ID here
    // Or adjust UseCase/Repo if ID isn't required in Entity for adding
    final newLending = LendingEntity(
      id: '',
      // Firestore will generate this
      type: selectedType.value,
      personName: personNameController.text.trim(),
      amount: amount,
      description: descriptionController.text.trim().isEmpty
          ? null
          : descriptionController.text.trim(),
      createdDate: selectedCreatedDate.value,
      dueDate: selectedDueDate.value,
      status: selectedStatus.value,
      userId: userId,
    );

    final result = await addLendingUseCase(newLending);

    result.fold(
      (failure) {
        errorMessage.value = failure.message;
      },
      (_) {
        // Success
        Get.back();
        Get.snackbar('Success', 'Lending added successfully!');
        // TODO: Potentially trigger a refresh on the list screen
      },
    );

    isLoading.value = false;
  }
}
