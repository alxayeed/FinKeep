import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spendly/core/constants/app_strings.dart';
import 'package:spendly/core/error/exceptions.dart';
import 'package:spendly/features/lendings/data/models/lending_model.dart';

import '../../../../core/config/app_config.dart';
import '../../domain/entity/lend_entity.dart';
import 'lending_data_source.dart';

class LendingFirestoreDataSource implements LendingDataSource {
  final FirebaseFirestore firestore;
  late final CollectionReference<Map<String, dynamic>> _lendingsCollection;

  LendingFirestoreDataSource({required this.firestore}) {
    final baseName = AppStrings.lendingsCollection;
    final collectionName = AppConfig.isProd ? baseName : '${baseName}_dev';
    _lendingsCollection = firestore.collection(collectionName);
  }

  @override
  Future<void> addLending(LendingModel lending) async {
    try {
      await _lendingsCollection.add(lending.toJson());
    } catch (e) {
      throw ServerException(message: '${AppStrings.operationFailed}: $e');
    }
  }

  @override
  Future<List<LendingModel>> getLendings({
    required String userId,
    LendingType? typeFilter,
    DateTime? monthFilter,
    LendingStatus? statusFilter,
    String? personNameFilter,
  }) async {
    try {
      Query<Map<String, dynamic>> query =
          _lendingsCollection.where('userId', isEqualTo: userId);

      if (typeFilter != null)
        query = query.where('type', isEqualTo: typeFilter.name);
      if (statusFilter != null)
        query = query.where('status', isEqualTo: statusFilter.name);
      if (personNameFilter != null && personNameFilter.isNotEmpty)
        query = query.where('personName', isEqualTo: personNameFilter);
      if (monthFilter != null) {
        final startOfMonth = Timestamp.fromDate(
            DateTime(monthFilter.year, monthFilter.month, 1));
        final endOfMonth = Timestamp.fromDate((monthFilter.month < 12)
            ? DateTime(monthFilter.year, monthFilter.month + 1, 1)
                .subtract(const Duration(milliseconds: 1))
            : DateTime(monthFilter.year + 1, 1, 1)
                .subtract(const Duration(milliseconds: 1)));
        query = query
            .where('createdDate', isGreaterThanOrEqualTo: startOfMonth)
            .where('createdDate', isLessThanOrEqualTo: endOfMonth);
      }

      query = query.orderBy('createdDate', descending: true);
      final querySnapshot = await query.get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return LendingModel.fromJson(data);
      }).toList();
    } catch (e) {
      throw ServerException(message: '${AppStrings.fetchFailed}: $e');
    }
  }

  @override
  Future<void> updateLendingStatus(
      String lendingId, LendingStatus newStatus) async {
    try {
      await _lendingsCollection
          .doc(lendingId)
          .update({'status': newStatus.name});
    } catch (e) {
      throw ServerException(message: '${AppStrings.updateFailed}: $e');
    }
  }

  @override
  Future<void> deleteLending(String lendingId) async {
    try {
      await _lendingsCollection.doc(lendingId).delete();
    } catch (e) {
      throw ServerException(message: '${AppStrings.deleteFailed}: $e');
    }
  }

  @override
  Future<double> getTotalLendingAmount({
    required String userId,
    LendingType? typeFilter,
    LendingStatus? statusFilter,
    String? personNameFilter,
  }) async {
    try {
      Query<Map<String, dynamic>> query =
          _lendingsCollection.where('userId', isEqualTo: userId);

      if (typeFilter != null)
        query = query.where('type', isEqualTo: typeFilter.name);
      if (statusFilter != null)
        query = query.where('status', isEqualTo: statusFilter.name);
      if (personNameFilter != null && personNameFilter.isNotEmpty) {
        query = query.where('personName', isEqualTo: personNameFilter);
      }

      final snapshot = await query.aggregate(sum('amount')).get();
      return (snapshot.getSum('amount') ?? 0.0).toDouble();
    } catch (e) {
      throw ServerException(message: '${AppStrings.fetchFailed}: $e');
    }
  }

  @override
  Future<int> getLendingsCount({
    required String userId,
    LendingType? typeFilter,
    LendingStatus? statusFilter,
    String? personNameFilter,
  }) async {
    try {
      Query<Map<String, dynamic>> query =
          _lendingsCollection.where('userId', isEqualTo: userId);

      if (typeFilter != null)
        query = query.where('type', isEqualTo: typeFilter.name);
      if (statusFilter != null)
        query = query.where('status', isEqualTo: statusFilter.name);
      if (personNameFilter != null && personNameFilter.isNotEmpty) {
        query = query.where('personName', isEqualTo: personNameFilter);
      }

      final snapshot = await query.aggregate(count()).get();
      return snapshot.count ?? 0;
    } catch (e) {
      throw ServerException(message: '${AppStrings.fetchFailed}: $e');
    }
  }

  @override
  Future<void> updateLending(LendingModel lending) async {
    try {
      final data = lending.toJson();
      final String docId = data.remove('id');
      if (docId.isEmpty)
        throw ArgumentError('Lending ID cannot be empty for update.');
      await _lendingsCollection.doc(docId).update(data);
    } catch (e) {
      throw ServerException(message: '${AppStrings.updateFailed}: $e');
    }
  }
}
