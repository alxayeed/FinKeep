import 'dart:ui';

import 'package:get/get.dart';

import '../../../auth/presentation/controller/auth_controller.dart';
import '../../domain/entities/investment.dart';
import '../../domain/entities/return_entry.dart';
import '../../domain/usecases/add_investment_usecase.dart';
import '../../domain/usecases/add_return_entry_usecase.dart';
import '../../domain/usecases/get_investments_usecase.dart';
import '../../domain/usecases/update_investment_usecase.dart';

class InvestmentController extends GetxController {
  final GetInvestmentsUseCase getInvestmentsUseCase;
  final AddInvestmentUseCase addInvestmentUseCase;
  final UpdateInvestmentUseCase updateInvestmentUseCase;
  final AddReturnEntryUseCase addReturnEntryUseCase;

  InvestmentController({
    required this.getInvestmentsUseCase,
    required this.addInvestmentUseCase,
    required this.updateInvestmentUseCase,
    required this.addReturnEntryUseCase,
  });

  /// Observables
  var investments = <Investment>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  final AuthController authController = Get.find();

  late String userId;

  @override
  void onInit() {
    userId = authController.user?.email ?? 'unknown_user';
    super.onInit();
    fetchInvestments();
  }

  /// Fetch all investments
  Future<void> fetchInvestments() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final result = await getInvestmentsUseCase(userId: userId);
      investments.assignAll(result);
    } catch (e) {
      errorMessage.value = 'Failed to load investments: $e';
    } finally {
      isLoading.value = false;
    }
  }

  /// Add a new investment
  Future<void> addInvestment(Investment investment) async {
    try {
      isLoading.value = true;
      await addInvestmentUseCase(investment);
      investments.add(investment); // update local list
    } catch (e) {
      errorMessage.value = 'Failed to add investment: $e';
    } finally {
      isLoading.value = false;
    }
  }

  /// Update an existing investment
  Future<void> updateInvestment(Investment investment) async {
    try {
      isLoading.value = true;
      await updateInvestmentUseCase(investment);
      final index = investments.indexWhere((i) => i.id == investment.id);
      if (index != -1) {
        investments[index] = investment;
        investments.refresh(); // notify listeners
      }
    } catch (e) {
      errorMessage.value = 'Failed to update investment: $e';
    } finally {
      isLoading.value = false;
    }
  }

  /// Add a return entry to an investment
  Future<void> addReturnEntry(
    String investmentId,
    ReturnEntry returnEntry, {
    VoidCallback? onSuccess,
    Function(String)? onError,
  }) async {
    try {
      isLoading.value = true;
      await addReturnEntryUseCase(investmentId, returnEntry);
      await fetchInvestments(); // Refresh from API to get updated state
      onSuccess?.call();
    } catch (e) {
      errorMessage.value = 'Failed to add return entry: $e';
      onError?.call(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// Delete a return entry from an investment
  Future<void> deleteReturnEntry(
    String investmentId,
    String returnEntryId, {
    VoidCallback? onSuccess,
    Function(String)? onError,
  }) async {
    try {
      isLoading.value = true;
      final index = investments.indexWhere((i) => i.id == investmentId);
      if (index != -1) {
        final investment = investments[index];
        final updatedReturns = investment.returns.where((r) => r.id != returnEntryId).toList();
        final updatedInvestment = investment.copyWith(returns: updatedReturns);
        await updateInvestmentUseCase(updatedInvestment);
        await fetchInvestments(); // Refresh from API to get updated state
      }
      onSuccess?.call();
    } catch (e) {
      errorMessage.value = 'Failed to delete return entry: $e';
      onError?.call(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// Update a return entry in an investment
  Future<void> updateReturnEntry(
    String investmentId,
    ReturnEntry returnEntry, {
    VoidCallback? onSuccess,
    Function(String)? onError,
  }) async {
    try {
      isLoading.value = true;
      final index = investments.indexWhere((i) => i.id == investmentId);
      if (index != -1) {
        final investment = investments[index];
        final updatedReturns = investment.returns
            .map((r) => r.id == returnEntry.id ? returnEntry : r)
            .toList();
        final updatedInvestment = investment.copyWith(returns: updatedReturns);
        await updateInvestmentUseCase(updatedInvestment);
        await fetchInvestments(); // Refresh from API to get updated state
      }
      onSuccess?.call();
    } catch (e) {
      errorMessage.value = 'Failed to update return entry: $e';
      onError?.call(e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
