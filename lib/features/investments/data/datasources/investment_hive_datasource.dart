import 'package:spendly/features/investments/data/models/investment_model.dart';
import 'package:spendly/features/investments/data/models/return_entry_model.dart';
import 'package:spendly/features/investments/data/datasources/investment_local_datasource.dart';
import 'package:spendly/core/services/local_db_service.dart';

class InvestmentHiveDataSource implements InvestmentLocalDataSource {
  final LocalDbService localDb;

  InvestmentHiveDataSource({required this.localDb});

  @override
  Future<void> addInvestment(InvestmentModel investment) async {
    await localDb.investmentsBox.put(investment.id, investment.toJson());
  }

  @override
  Future<List<InvestmentModel>> getInvestments(String userId) async {
    final list = localDb.investmentsBox.values
        .map((raw) => InvestmentModel.fromJson(Map<String, dynamic>.from(raw)))
        .where((inv) => inv.userId == userId)
        .toList();
    list.sort((a, b) => b.startDate.compareTo(a.startDate));
    return list;
  }

  @override
  Future<InvestmentModel?> getInvestmentById(String id) async {
    final raw = localDb.investmentsBox.get(id);
    if (raw != null) {
      return InvestmentModel.fromJson(Map<String, dynamic>.from(raw));
    }
    return null;
  }

  @override
  Future<void> updateInvestment(InvestmentModel investment) async {
    await localDb.investmentsBox.put(investment.id, investment.toJson());
  }

  @override
  Future<void> addReturnEntry(
    String investmentId,
    ReturnEntryModel returnEntry,
  ) async {
    final raw = localDb.investmentsBox.get(investmentId);
    if (raw == null) {
      throw Exception('Investment not found');
    }

    final data = Map<String, dynamic>.from(raw);
    List returnsList = data['returns'] ?? [];
    returnsList.add(returnEntry.toJson());
    data['returns'] = returnsList;

    if (data['status'] == 'active') {
      data['status'] = 'returnsStarted';
    }

    await localDb.investmentsBox.put(investmentId, data);
  }
}
