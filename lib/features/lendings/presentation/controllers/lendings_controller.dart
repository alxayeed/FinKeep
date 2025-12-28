import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spendly/features/lendings/domain/usecases/repayment/get_repayments_for_lending_usecase.dart';

import '../../../auth/presentation/controller/auth_controller.dart';
import '../../domain/entity/lending/lending_entity.dart';
import '../../domain/entity/lending_person/lending_person_entity.dart';
import '../../domain/entity/repayment/repayment_entity.dart';
import '../../domain/usecases/lending/add_lending_usecase.dart';
import '../../domain/usecases/lending/delete_lending_usecase.dart';
import '../../domain/usecases/lending/get_lendings_usecase.dart';
import '../../domain/usecases/lending/update_lending_usecase.dart';
import '../../domain/usecases/lending_params.dart';
import '../../domain/usecases/lending_person/add_person_usecase.dart';
import '../../domain/usecases/lending_person/delete_person_usecase.dart';
import '../../domain/usecases/lending_person/get_user_persons_usecase.dart';
import '../../domain/usecases/lending_person/update_person_usecase.dart';
import '../../domain/usecases/repayment/add_repayment_usecase.dart';
import '../../domain/usecases/repayment/delete_repayment_usecase.dart';
import '../../domain/usecases/repayment/update_repayment_usecase.dart';

class LendingsController extends GetxController {
  final GetLendingsUseCase getLendingsUseCase;
  final DeleteLendingUseCase deleteLendingUseCase;
  final UpdateLendingUseCase updateLendingUseCase;
  final AddLendingUseCase addLendingUseCase;
  final AddPersonUseCase addPersonUseCase;
  final GetUserPersonsUseCase getUserPersonsUseCase;
  final UpdatePersonUseCase updatePersonUseCase;
  final DeletePersonUseCase deletePersonUseCase;
  final AddRepaymentUseCase addRepaymentUseCase;
  final GetRepaymentsForLendingUseCase getRepaymentsUseCase;
  final UpdateRepaymentUseCase updateRepaymentUseCase;
  final DeleteRepaymentUseCase deleteRepaymentUseCase;

  LendingsController({
    required this.getLendingsUseCase,
    required this.deleteLendingUseCase,
    required this.updateLendingUseCase,
    required this.addLendingUseCase,
    required this.addPersonUseCase,
    required this.getUserPersonsUseCase,
    required this.updatePersonUseCase,
    required this.deletePersonUseCase,
    required this.addRepaymentUseCase,
    required this.getRepaymentsUseCase,
    required this.updateRepaymentUseCase,
    required this.deleteRepaymentUseCase,
  });

  final isLoading = true.obs;
  final lendingsList = RxList<LendingEntity>([]);
  final personsList = RxList<LendingPersonEntity>([]);
  final repaymentsList = RxList<RepaymentEntity>([]);
  final errorMessage = Rx<String?>(null);

  final selectedTypeFilter = Rx<LendingType?>(null);
  final selectedStatusFilter = Rx<LendingStatus?>(null);
  final selectedPersonFilter = Rx<String?>(null);
  final selectedMonthFilter = Rx<DateTime?>(null);

  final AuthController authController = Get.find();

  late String userId;

  @override
  void onInit() {
    userId = authController.user?.email ?? 'unknown_user';

    super.onInit();
    _setupFilterListeners();
    fetchLendings();
    fetchUserPersons();
  }

  void _setupFilterListeners() {
    debounce(
      selectedTypeFilter,
      (_) => fetchLendings(),
      time: const Duration(milliseconds: 300),
    );
    debounce(
      selectedStatusFilter,
      (_) => fetchLendings(),
      time: const Duration(milliseconds: 300),
    );
    debounce(
      selectedPersonFilter,
      (_) => fetchLendings(),
      time: const Duration(milliseconds: 500),
    );
    debounce(
      selectedMonthFilter,
      (_) => fetchLendings(),
      time: const Duration(milliseconds: 300),
    );
  }

  // --- Filter Methods ---
  void applyTypeFilter(LendingType? type) => selectedTypeFilter.value = type;

  void applyStatusFilter(LendingStatus? status) =>
      selectedStatusFilter.value = status;

  void applyPersonFilter(String? personName) => selectedPersonFilter.value =
      (personName?.isEmpty ?? true) ? null : personName;

  void applyMonthFilter(DateTime? month) => selectedMonthFilter.value = month;

  void clearFilters() {
    selectedTypeFilter.value = null;
    selectedStatusFilter.value = null;
    selectedPersonFilter.value = null;
    selectedMonthFilter.value = null;
    fetchLendings();
  }

  // --- Lending Methods ---
  Future<void> fetchLendings({bool showLoading = true}) async {
    if (showLoading) isLoading.value = true;
    errorMessage.value = null;

    final params = GetLendingsParams(
      userId: userId,
      typeFilter: selectedTypeFilter.value,
      statusFilter: selectedStatusFilter.value,
      personNameFilter: selectedPersonFilter.value,
      monthFilter: selectedMonthFilter.value,
    );

    final result = await getLendingsUseCase(userId: params.userId);

    if (!showLoading && result.isRight()) lendingsList.clear();

    result.fold((failure) {
      errorMessage.value = failure.message;
      if (showLoading) lendingsList.clear();
    }, (lendings) => lendingsList.assignAll(lendings));

    if (showLoading) isLoading.value = false;
  }

  Future<void> refreshLendings() async => fetchLendings(showLoading: false);

  Future<void> addLending(
    LendingEntity lending, {
    VoidCallback? onSuccess,
    Function(dynamic)? onError,
  }) async {
    isLoading.value = true;
    errorMessage.value = null;

    lending = lending.copyWith(userId: userId);

    final result = await addLendingUseCase(lending);

    await result.fold(
      (failure) async {
        errorMessage.value = failure.message;
        onError?.call(failure.message);
      },
      (_) async {
        await fetchLendings(showLoading: true);
        onSuccess?.call();
      },
    );

    isLoading.value = false;
  }

  Future<bool> deleteLending(
    String lendingId, {
    VoidCallback? onSuccess,
    Function(dynamic)? onError,
  }) async {
    final result = await deleteLendingUseCase(lendingId);
    bool success = false;

    await result.fold(
      (failure) async {
        onError?.call(failure.message);
        success = false;
      },
      (_) async {
        await fetchLendings(showLoading: true);
        onSuccess?.call();
        success = true;
      },
    );

    return success;
  }

  Future<bool> updateLending(
    LendingEntity lending, {
    VoidCallback? onSuccess,
    Function(dynamic)? onError,
  }) async {
    final result = await updateLendingUseCase(lending);
    bool success = false;

    await result.fold(
      (failure) async {
        onError?.call(failure.message);
        success = false;
      },
      (_) async {
        await fetchLendings(showLoading: true);
        onSuccess?.call();
        success = true;
      },
    );

    return success;
  }

  // --- Person Methods ---
  Future<void> fetchUserPersons() async {
    final result = await getUserPersonsUseCase(userId);
    result.fold(
      (failure) {
        errorMessage.value = failure.message;
      },
      (list) {
        personsList.assignAll(list);
      },
    );
  }

  Future<void> updatePerson(LendingPersonEntity person) async {
    final result = await updatePersonUseCase(person);
    result.fold(
      (failure) {
        errorMessage.value = failure.message;
      },
      (_) async {
        await fetchUserPersons();
      },
    );
  }

  Future<void> deletePerson(String personId) async {
    final result = await deletePersonUseCase(personId);
    result.fold(
      (failure) {
        errorMessage.value = failure.message;
      },
      (_) async {
        await fetchUserPersons();
      },
    );
  }

  // --- Repayment Methods ---
  Future<void> fetchRepayments(String lendingId) async {
    final result = await getRepaymentsUseCase(lendingId);
    result.fold(
      (failure) {
        errorMessage.value = failure.message;
      },
      (list) {
        repaymentsList.assignAll(list);
      },
    );
  }

  Future<void> addRepayment(RepaymentEntity repayment) async {
    final result = await addRepaymentUseCase(repayment);
    result.fold(
      (failure) {
        errorMessage.value = failure.message;
      },
      (_) async {
        await fetchRepayments(repayment.lendingId);
      },
    );
  }

  Future<void> updateRepayment(RepaymentEntity repayment) async {
    final result = await updateRepaymentUseCase(repayment);
    result.fold(
      (failure) {
        errorMessage.value = failure.message;
      },
      (_) async {
        await fetchRepayments(repayment.lendingId);
      },
    );
  }

  Future<void> deleteRepayment(RepaymentEntity repayment) async {
    final result = await deleteRepaymentUseCase(repayment.id);
    result.fold(
      (failure) {
        errorMessage.value = failure.message;
      },
      (_) async {
        await fetchRepayments(repayment.lendingId);
      },
    );
  }
}
