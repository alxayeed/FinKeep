import 'package:get/get.dart';

import '../../domain/entities/investment.dart';
import '../../domain/usecases/add_investment_usecase.dart';
import '../../domain/usecases/get_investments_usecase.dart';
import '../../domain/usecases/update_investment_usecase.dart';

class InvestmentController extends GetxController {
  final GetInvestmentsUseCase getInvestmentsUseCase;
  final AddInvestmentUseCase addInvestmentUseCase;
  final UpdateInvestmentUseCase updateInvestmentUseCase;

  InvestmentController({
    required this.getInvestmentsUseCase,
    required this.addInvestmentUseCase,
    required this.updateInvestmentUseCase,
  });

  /// Observables
  var investments = <Investment>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

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
}
