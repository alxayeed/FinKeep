import '../entities/investment.dart';
import '../repositories/investment_repository.dart';

class AddInvestmentUseCase {
  final InvestmentRepository repository;

  AddInvestmentUseCase(this.repository);

  Future<void> call(Investment investment) async {
    await repository.addInvestment(investment);
  }
}
