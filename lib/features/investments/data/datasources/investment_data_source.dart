import '../models/investment_model.dart';
import '../models/return_entry_model.dart';

abstract class InvestmentDataSource {
  /// Fetch all investments
  Future<List<InvestmentModel>> getInvestments();

  /// Add a new investment
  Future<void> addInvestment(InvestmentModel investment);

  /// Update an existing investment
  Future<void> updateInvestment(InvestmentModel investment);

  /// Add a return entry to a specific investment
  Future<void> addReturnEntry(
    String investmentId,
    ReturnEntryModel returnEntry,
  );

  /// Optional: fetch single investment by id
  Future<InvestmentModel?> getInvestmentById(String id);
}
