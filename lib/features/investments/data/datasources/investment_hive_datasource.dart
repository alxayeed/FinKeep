import 'package:finkeep/features/investments/data/models/investment_model.dart';
import 'package:finkeep/features/investments/data/models/return_entry_model.dart';
import 'package:finkeep/features/investments/data/datasources/investment_local_datasource.dart';
import 'package:finkeep/core/services/local_db_service.dart';

class InvestmentHiveDataSource implements InvestmentLocalDataSource {
  final LocalDbService localDb;

  InvestmentHiveDataSource({required this.localDb});

  @override
  Future<void> addInvestment(InvestmentModel investment) async {
    await localDb.investmentsBox.put(investment.id, investment.toJson());
  }

  @override
  Future<List<InvestmentModel>> getInvestments() async {
    final list = <InvestmentModel>[];
    for (final raw in localDb.investmentsBox.values) {
      final data = Map<String, dynamic>.from(raw);
      if (data['returns'] != null) {
        data['returns'] = (data['returns'] as List<dynamic>)
            .map((e) => Map<String, dynamic>.from(e as Map))
            .toList();
      }
      list.add(InvestmentModel.fromJson(data));
    }
    list.sort((a, b) => b.startDate.compareTo(a.startDate));
    return list;
  }

  @override
  Future<InvestmentModel?> getInvestmentById(String id) async {
    final raw = localDb.investmentsBox.get(id);
    if (raw != null) {
      final data = Map<String, dynamic>.from(raw);
      if (data['returns'] != null) {
        data['returns'] = (data['returns'] as List<dynamic>)
            .map((e) => Map<String, dynamic>.from(e as Map))
            .toList();
      }
      return InvestmentModel.fromJson(data);
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
