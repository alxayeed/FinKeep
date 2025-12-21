import '../entities/return_entry.dart';
import '../repositories/investment_repository.dart';

class AddReturnEntryUseCase {
  final InvestmentRepository repository;

  AddReturnEntryUseCase(this.repository);

  Future<void> call(String investmentId, ReturnEntry returnEntry) async {
    await repository.addReturnEntry(investmentId, returnEntry);
  }
}
