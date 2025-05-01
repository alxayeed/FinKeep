import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spendly/core/constants/app_strings.dart';
import 'package:spendly/core/error/exceptions.dart';
import 'package:spendly/features/lendings/data/models/lending_model.dart';

import '../../domain/entity/lend_entity.dart';
import 'lending_data_source.dart';

class LendingFirestoreDataSource implements LendingDataSource {
  final FirebaseFirestore firestore;
  late final CollectionReference<Map<String, dynamic>> _lendingsCollection;

  LendingFirestoreDataSource({required this.firestore}) {
    _lendingsCollection = firestore.collection(AppStrings.lendingsCollection);
  }

  @override
  Future<void> addLending(LendingModel lending) async {
    try {
      // Assuming Firestore generates the ID, we ideally wouldn't include
      // the model's 'id' field in the data sent to .add().
      // However, sticking to the provided model's toJson() for now.
      // A better toJson() in the model would exclude 'id'.
      final data = lending.toJson();
      // Consider removing 'id' if it causes issues or isn't intended
      // data.remove('id');
      await _lendingsCollection.add(data);
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

      if (typeFilter != null) {
        query = query.where('type', isEqualTo: typeFilter.name);
      }
      if (statusFilter != null) {
        query = query.where('status', isEqualTo: statusFilter.name);
      }
      if (personNameFilter != null && personNameFilter.isNotEmpty) {
        query = query.where('personName', isEqualTo: personNameFilter);
      }
      if (monthFilter != null) {
        final startOfMonth = Timestamp.fromDate(
            DateTime(monthFilter.year, monthFilter.month, 1));
        // Calculate end of month correctly (start of next month minus 1ms)
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

      final lendings = querySnapshot.docs.map((doc) {
        // Manually combine doc.id with doc.data() for fromJson
        final data = doc.data();
        data['id'] = doc.id; // Add the document ID to the map
        return LendingModel.fromJson(data);
      }).toList();

      return lendings;
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

      if (typeFilter != null) {
        query = query.where('type', isEqualTo: typeFilter.name);
      }
      if (statusFilter != null) {
        query = query.where('status', isEqualTo: statusFilter.name);
      }
      if (personNameFilter != null && personNameFilter.isNotEmpty) {
        query = query.where('personName', isEqualTo: personNameFilter);
      }

      final AggregateQuerySnapshot snapshot =
          await query.aggregate(sum('amount')).get();
      final double total = (snapshot.getSum('amount') ?? 0.0).toDouble();
      return total;
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

      if (typeFilter != null) {
        query = query.where('type', isEqualTo: typeFilter.name);
      }
      if (statusFilter != null) {
        query = query.where('status', isEqualTo: statusFilter.name);
      }
      if (personNameFilter != null && personNameFilter.isNotEmpty) {
        query = query.where('personName', isEqualTo: personNameFilter);
      }

      final AggregateQuerySnapshot snapshot =
          await query.aggregate(count()).get();
      return snapshot.count ?? 0;
    } catch (e) {
      throw ServerException(message: '${AppStrings.fetchFailed}: $e');
    }
  }
}
