import 'package:finkeep/features/investments/data/models/investment_model.dart';
import 'package:finkeep/features/investments/data/models/return_entry_model.dart';

abstract class InvestmentLocalDataSource {
  Future<void> addInvestment(InvestmentModel investment);

  Future<List<InvestmentModel>> getInvestments();

  Future<InvestmentModel?> getInvestmentById(String id);

  Future<void> updateInvestment(InvestmentModel investment);

  Future<void> addReturnEntry(
    String investmentId,
    ReturnEntryModel returnEntry,
  );
}
