import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spendly/core/constants/app_strings.dart';
import 'package:spendly/core/error/exceptions.dart';

import '../../../../core/config/app_config.dart';
import '../models/investment_model.dart';
import '../models/return_entry_model.dart';
import 'investment_data_source.dart';

class InvestmentFirestoreDataSource implements InvestmentDataSource {
  final FirebaseFirestore firestore;

  late final CollectionReference<Map<String, dynamic>> _investmentsCollection;

  InvestmentFirestoreDataSource({required this.firestore}) {
    _investmentsCollection = firestore.collection(
      AppConfig.isPersonal
          ? AppStrings.investmentsCollection
          : '${AppStrings.investmentsCollection}_dev',
    );
  }

  @override
  Future<void> addInvestment(InvestmentModel investment) async {
    try {
      final data = investment.toFirestoreMap();
      data.remove('id'); // Firestore generates ID
      await _investmentsCollection.add(data);
    } catch (e) {
      throw ServerException(message: '${AppStrings.operationFailed}: $e');
    }
  }

  @override
  Future<List<InvestmentModel>> getInvestments() async {
    try {
      final snapshot = await _investmentsCollection.get();

      if (snapshot.docs.isEmpty) return [];

      final list = snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return InvestmentModel.fromFirestoreMap(data);
      }).toList();

      // Sort in-memory to avoid needing composite indexes in Firestore
      list.sort((a, b) => b.startDate.compareTo(a.startDate));
      return list;
    } catch (e) {
      throw ServerException(message: '${AppStrings.fetchFailed}: $e');
    }
  }

  @override
  Future<InvestmentModel?> getInvestmentById(String id) async {
    try {
      final doc = await _investmentsCollection.doc(id).get();
      if (!doc.exists) return null;
      final data = doc.data()!;
      data['id'] = doc.id;
      return InvestmentModel.fromFirestoreMap(data);
    } catch (e) {
      throw ServerException(message: '${AppStrings.fetchFailed}: $e');
    }
  }

  @override
  Future<void> updateInvestment(InvestmentModel investment) async {
    try {
      final data = investment.toFirestoreMap();
      final String docId = data.remove('id');
      if (docId.isEmpty) {
        throw ArgumentError('Investment ID cannot be empty for update.');
      }
      await _investmentsCollection.doc(docId).update(data);
    } catch (e) {
      throw ServerException(message: '${AppStrings.updateFailed}: $e');
    }
  }

  @override
  Future<void> addReturnEntry(
    String investmentId,
    ReturnEntryModel returnEntry,
  ) async {
    try {
      final investmentDoc = _investmentsCollection.doc(investmentId);

      final snapshot = await investmentDoc.get();
      if (!snapshot.exists) {
        throw ServerException(message: 'Investment not found');
      }

      final data = snapshot.data()!;
      List returnsList = data['returns'] ?? [];
      returnsList.add(returnEntry.toFirestoreMap());

      final updates = <String, dynamic>{'returns': returnsList};
      if (data['status'] == 'active') {
        updates['status'] = 'returnsStarted';
      }

      await investmentDoc.update(updates);
    } catch (e) {
      throw ServerException(message: '${AppStrings.operationFailed}: $e');
    }
  }
}
