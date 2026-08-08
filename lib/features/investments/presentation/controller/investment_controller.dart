import 'dart:ui';

import 'package:get/get.dart';
import '../../../../core/common/models/timeframe_selection.dart';

import '../../domain/entities/investment.dart';
import '../../domain/entities/return_entry.dart';
import '../../domain/enums/investment_status.dart';
import '../../domain/usecases/add_investment_usecase.dart';
import '../../domain/usecases/add_return_entry_usecase.dart';
import '../../domain/usecases/get_investments_usecase.dart';
import '../../domain/usecases/update_investment_usecase.dart';
import 'package:finkeep/features/dashboard/presentation/controllers/dashboard_controller.dart';

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
  Rx<TimeframeSelection> timeframe = TimeframeSelection(
    type: TimeframeType.allTime,
    referenceDate: DateTime.now(),
  ).obs;

  List<Investment> get filteredInvestments {
    final range = timeframe.value.dateRange;
    if (range == null) return investments;
    return investments.where((inv) {
      final date = inv.startDate;
      return (date.isAfter(range.start) || date.isAtSameMomentAs(range.start)) &&
             (date.isBefore(range.end) || date.isAtSameMomentAs(range.end));
    }).toList();
  }

  void updateTimeframe(TimeframeSelection newTimeframe) {
    timeframe.value = newTimeframe;
  }

  @override
  void onInit() {
    super.onInit();
    fetchInvestments();
  }

  /// Fetch all investments
  Future<void> fetchInvestments() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final result = await getInvestmentsUseCase();
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
      DashboardController.refreshIfRegistered();
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
      DashboardController.refreshIfRegistered();
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
      DashboardController.refreshIfRegistered();
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
        DashboardController.refreshIfRegistered();
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
        DashboardController.refreshIfRegistered();
      }
      onSuccess?.call();
    } catch (e) {
      errorMessage.value = 'Failed to update return entry: $e';
      onError?.call(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  int get totalInvestmentsCount => filteredInvestments.length;

  int get ongoingInvestmentsCount => filteredInvestments
      .where((i) =>
          i.status == InvestmentStatus.active ||
          i.status == InvestmentStatus.returnsStarted)
      .length;

  int get completedInvestmentsCount => filteredInvestments
      .where((i) => i.status == InvestmentStatus.completed)
      .length;

  int get lossInvestmentsCount => filteredInvestments
      .where((i) => i.status == InvestmentStatus.loss)
      .length;

  double get totalMoneyInvested =>
      filteredInvestments.fold(0.0, (sum, i) => sum + i.amountInvested);

  double get totalMoneyReceived => filteredInvestments.fold(
      0.0,
      (sum, i) =>
          sum +
          i.returns.fold(0.0, (rSum, r) => rSum + r.amountReceived));

  double get netProfit {
    double totalProfit = 0.0;
    for (final i in filteredInvestments) {
      final returnsSum = i.returns.fold(0.0, (sum, r) => sum + r.amountReceived);
      if (i.status == InvestmentStatus.completed || i.status == InvestmentStatus.loss) {
        totalProfit += (returnsSum - i.amountInvested);
      } else {
        // For ongoing investments, only count as profit if returns exceed invested capital (break-even exceeded)
        if (returnsSum > i.amountInvested) {
          totalProfit += (returnsSum - i.amountInvested);
        }
      }
    }
    return totalProfit;
  }

  double get activeMoneyInvested => filteredInvestments
      .where((i) =>
          i.status == InvestmentStatus.active ||
          i.status == InvestmentStatus.returnsStarted)
      .fold(0.0, (sum, i) => sum + i.amountInvested);

  double get totalExpectedROI => filteredInvestments
      .where((i) =>
          i.status == InvestmentStatus.active ||
          i.status == InvestmentStatus.returnsStarted)
      .fold(0.0, (sum, i) => sum + (i.amountInvested * (i.expectedROI / 100)));

  double get capitalAtRisk => filteredInvestments
      .where((i) =>
          i.status == InvestmentStatus.active ||
          i.status == InvestmentStatus.returnsStarted)
      .fold(0.0, (sum, i) {
        final returnsSum = i.returns.fold(0.0, (rSum, r) => rSum + r.amountReceived);
        return sum + (i.amountInvested - returnsSum).clamp(0.0, double.infinity);
      });

  double get activeMoneyReceived => filteredInvestments
      .where((i) =>
          i.status == InvestmentStatus.active ||
          i.status == InvestmentStatus.returnsStarted)
      .fold(0.0, (sum, i) => sum + i.returns.fold(0.0, (rSum, r) => rSum + r.amountReceived));

  double get totalCompletedProfit {
    return filteredInvestments
        .where((i) => i.status == InvestmentStatus.completed)
        .fold(0.0, (sum, i) {
          final returnsSum = i.returns.fold(0.0, (rSum, r) => rSum + r.amountReceived);
          final profit = returnsSum - i.amountInvested;
          return sum + (profit > 0 ? profit : 0.0);
        });
  }

  double get totalCompletedLoss {
    return filteredInvestments
        .where((i) => i.status == InvestmentStatus.loss)
        .fold(0.0, (sum, i) {
          final returnsSum = i.returns.fold(0.0, (rSum, r) => rSum + r.amountReceived);
          final loss = i.amountInvested - returnsSum;
          return sum + (loss > 0 ? loss : 0.0);
        });
  }
}
