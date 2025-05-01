import 'package:flutter/material.dart'; // Import material for colors in snackbar
import 'package:get/get.dart';
import 'package:spendly/features/lendings/domain/usecases/delete_lending_usecase.dart';
import 'package:spendly/features/lendings/domain/usecases/get_lendings_usecase.dart';
import 'package:spendly/features/lendings/domain/usecases/lending_params.dart';
import 'package:spendly/features/lendings/domain/usecases/update_lending_usecase.dart';

import '../../domain/entity/lend_entity.dart';

// Renamed class
class LendingsController extends GetxController {
  final GetLendingsUseCase getLendingsUseCase;
  final DeleteLendingUseCase deleteLendingUseCase;
  final UpdateLendingUseCase updateLendingUseCase;

  // Renamed constructor
  LendingsController({
    required this.getLendingsUseCase,
    required this.deleteLendingUseCase,
    required this.updateLendingUseCase,
  });

  final isLoading = true.obs;
  final lendingsList = RxList<LendingEntity>([]);
  final errorMessage = Rx<String?>(null);

  final selectedTypeFilter = Rx<LendingType?>(null);
  final selectedStatusFilter = Rx<LendingStatus?>(null);
  final selectedPersonFilter = Rx<String?>(null);
  final selectedMonthFilter = Rx<DateTime?>(null);

  String get _userId {
    return "placeholder_user_id";
  }

  @override
  void onInit() {
    super.onInit();
    _setupFilterListeners();
    fetchLendings();
  }

  void _setupFilterListeners() {
    debounce(selectedTypeFilter, (_) => fetchLendings(),
        time: const Duration(milliseconds: 300));
    debounce(selectedStatusFilter, (_) => fetchLendings(),
        time: const Duration(milliseconds: 300));
    debounce(selectedPersonFilter, (_) => fetchLendings(),
        time: const Duration(milliseconds: 500));
    debounce(selectedMonthFilter, (_) => fetchLendings(),
        time: const Duration(milliseconds: 300));
  }

  void applyTypeFilter(LendingType? type) {
    selectedTypeFilter.value = type;
  }

  void applyStatusFilter(LendingStatus? status) {
    selectedStatusFilter.value = status;
  }

  void applyPersonFilter(String? personName) {
    selectedPersonFilter.value =
        (personName?.isEmpty ?? true) ? null : personName;
  }

  void applyMonthFilter(DateTime? month) {
    selectedMonthFilter.value = month;
  }

  void clearFilters() {
    selectedTypeFilter.value = null;
    selectedStatusFilter.value = null;
    selectedPersonFilter.value = null;
    selectedMonthFilter.value = null;
    fetchLendings();
  }

  Future<void> fetchLendings({bool showLoading = true}) async {
    if (showLoading) {
      isLoading.value = true;
    }
    errorMessage.value = null;

    final params = GetLendingsParams(
      userId: _userId,
      typeFilter: selectedTypeFilter.value,
      statusFilter: selectedStatusFilter.value,
      personNameFilter: selectedPersonFilter.value,
      monthFilter: selectedMonthFilter.value,
    );

    final result = await getLendingsUseCase(params);

    if (!showLoading && result.isRight()) {
      lendingsList.clear();
    }

    result.fold(
      (failure) {
        errorMessage.value = failure.message;
        if (showLoading) lendingsList.clear();
      },
      (lendings) {
        lendingsList.assignAll(lendings);
      },
    );

    if (showLoading) {
      isLoading.value = false;
    }
  }

  Future<void> refreshLendings() async {
    await fetchLendings(showLoading: false);
  }

  Future<bool> deleteLending(String lendingId) async {
    final result = await deleteLendingUseCase(lendingId);
    bool success = false;
    result.fold(
      (failure) {
        Get.snackbar('Error', failure.message ?? "Unknown Error",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.redAccent,
            colorText: Colors.white);
        success = false;
      },
      (_) {
        Get.back();
        Get.snackbar('Success', 'Lending deleted successfully!',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white);
        fetchLendings(showLoading: false);
        success = true;
      },
    );
    return success;
  }

  Future<bool> updateLending(LendingEntity lending) async {
    final result = await updateLendingUseCase(lending);
    bool success = false;
    result.fold(
      (failure) {
        Get.snackbar('Error', failure.message ?? "Unknown Error",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.redAccent,
            colorText: Colors.white);
        success = false;
      },
      (_) {
        Get.snackbar('Success', 'Lending updated successfully!',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white);
        fetchLendings(showLoading: false);
        success = true;
      },
    );
    return success;
  }
}
