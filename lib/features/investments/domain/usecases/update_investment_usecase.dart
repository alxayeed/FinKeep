import '../entities/investment.dart';
import '../repositories/investment_repository.dart';

class UpdateInvestmentUseCase {
  final InvestmentRepository repository;

  UpdateInvestmentUseCase(this.repository);

  Future<void> call(Investment investment) async {
    await repository.updateInvestment(investment);
  }
}
