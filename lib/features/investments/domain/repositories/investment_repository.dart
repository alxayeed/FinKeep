import '../entities/investment.dart';
import '../entities/return_entry.dart';

abstract class InvestmentRepository {
  Future<List<Investment>> getInvestments();

  Future<void> addInvestment(Investment investment);

  Future<void> updateInvestment(Investment investment);

  Future<void> addReturnEntry(String investmentId, ReturnEntry returnEntry);
}
