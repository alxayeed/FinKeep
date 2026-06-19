import 'package:spendly/features/investments/data/models/investment_model.dart';
import 'package:spendly/features/investments/data/models/return_entry_model.dart';

abstract class InvestmentLocalDataSource {
  Future<void> addInvestment(InvestmentModel investment);

  Future<List<InvestmentModel>> getInvestments(String userId);

  Future<InvestmentModel?> getInvestmentById(String id);

  Future<void> updateInvestment(InvestmentModel investment);

  Future<void> addReturnEntry(
    String investmentId,
    ReturnEntryModel returnEntry,
  );
}
