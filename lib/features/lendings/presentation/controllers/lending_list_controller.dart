import 'package:get/get.dart';
import 'package:spendly/features/lendings/domain/usecases/get_lendings_usecase.dart';
import 'package:spendly/features/lendings/domain/usecases/lending_params.dart';

import '../../domain/entity/lend_entity.dart';
// import 'package:spendly/services/auth_service.dart'; // Placeholder for getting user ID

class LendingListController extends GetxController {
  final GetLendingsUseCase getLendingsUseCase;

  // final AuthService authService; // Example: Inject service to get user ID

  LendingListController({
    required this.getLendingsUseCase,
    // required this.authService,
  });

  // Data & Operation State
  final isLoading = true.obs; // Start loading initially
  final lendingsList = RxList<LendingEntity>([]);
  final errorMessage = Rx<String?>(null);

  // Filter State
  final selectedTypeFilter = Rx<LendingType?>(null);
  final selectedStatusFilter = Rx<LendingStatus?>(null);
  final selectedPersonFilter = Rx<String?>(null);
  final selectedMonthFilter = Rx<DateTime?>(null);

  // --- Get Current User ID (Needs implementation) ---
  String get _userId {
    // return authService.getCurrentUserId(); // Example
    return "placeholder_user_id"; // Replace with actual logic
  }

  // ---------------------------------------------------

  @override
  void onInit() {
    super.onInit();
    _setupFilterListeners();
    fetchLendings(); // Initial fetch
  }

  void _setupFilterListeners() {
    // Use debounce to avoid rapid firing if filters change quickly
    debounce(selectedTypeFilter, (_) => fetchLendings(),
        time: const Duration(milliseconds: 300));
    debounce(selectedStatusFilter, (_) => fetchLendings(),
        time: const Duration(milliseconds: 300));
    debounce(selectedPersonFilter, (_) => fetchLendings(),
        time: const Duration(milliseconds: 500)); // Longer for typing
    debounce(selectedMonthFilter, (_) => fetchLendings(),
        time: const Duration(milliseconds: 300));
  }

  // Methods to update filters from UI
  void applyTypeFilter(LendingType? type) {
    selectedTypeFilter.value = type;
    // Listener will trigger fetchLendings
  }

  void applyStatusFilter(LendingStatus? status) {
    selectedStatusFilter.value = status;
    // Listener will trigger fetchLendings
  }

  void applyPersonFilter(String? personName) {
    // Check if empty string should clear filter or filter by empty
    selectedPersonFilter.value =
        (personName?.isEmpty ?? true) ? null : personName;
    // Listener will trigger fetchLendings
  }

  void applyMonthFilter(DateTime? month) {
    selectedMonthFilter.value = month;
    // Listener will trigger fetchLendings
  }

  void clearFilters() {
    selectedTypeFilter.value = null;
    selectedStatusFilter.value = null;
    selectedPersonFilter.value = null;
    selectedMonthFilter.value = null;
    // Listener will trigger fetchLendings (or call fetchLendings directly if no debounce)
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

    result.fold(
      (failure) {
        errorMessage.value = failure.message;
        lendingsList.clear(); // Clear list on error
      },
      (lendings) {
        lendingsList.assignAll(lendings);
      },
    );

    if (showLoading) {
      isLoading.value = false;
    }
  }

  // Method for pull-to-refresh or manual refresh button
  Future<void> refreshLendings() async {
    await fetchLendings(showLoading: false);
  }
}
