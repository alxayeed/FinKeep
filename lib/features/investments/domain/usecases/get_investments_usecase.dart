import '../entities/investment.dart';
import '../repositories/investment_repository.dart';

class GetInvestmentsUseCase {
  final InvestmentRepository repository;

  GetInvestmentsUseCase(this.repository);

  Future<List<Investment>> call() async {
    return repository.getInvestments();
  }
}
