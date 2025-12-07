import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spendly/core/constants/app_strings.dart';
import 'package:spendly/core/error/exceptions.dart';
import 'package:spendly/features/lendings/data/models/lending/lending_model.dart';
import 'package:spendly/features/lendings/data/models/lending_person/lending_person_model.dart';
import 'package:spendly/features/lendings/data/models/repayment/repayment_model.dart';

import '../../../../core/config/app_config.dart';
import '../../domain/entity/lending/lending_entity.dart';
import 'lending_data_source.dart';

class LendingFirestoreDataSource implements LendingDataSource {
  final FirebaseFirestore firestore;

  late final CollectionReference<Map<String, dynamic>> _lendingsCollection;
  late final CollectionReference<Map<String, dynamic>> _personsCollection;
  late final CollectionReference<Map<String, dynamic>> _repaymentsCollection;

  LendingFirestoreDataSource({required this.firestore}) {
    _lendingsCollection = firestore.collection(
      AppConfig.isProd
          ? AppStrings.lendingsCollection
          : '${AppStrings.lendingsCollection}_dev',
    );
    _personsCollection = firestore.collection(
      AppConfig.isProd
          ? AppStrings.lendingPersonCollection
          : '${AppStrings.lendingPersonCollection}_dev',
    );
    _repaymentsCollection = firestore.collection(
      AppConfig.isProd
          ? AppStrings.repaymentsCollection
          : '${AppStrings.repaymentsCollection}_dev',
    );
  }

  // Lending Methods
  // --- Lending Methods ---
  @override
  Future<void> addLending(LendingModel lending) async {
    try {
      final data = {
        'type': lending.type.name,
        'personId': lending.person.id,
        'amount': lending.amount,
        'description': lending.description,
        'createdDate': Timestamp.fromDate(lending.createdDate),
        'dueDate': lending.dueDate != null
            ? Timestamp.fromDate(lending.dueDate!)
            : null,
        'status': lending.status.name,
        'userId': lending.userId,
        'repayments':
            lending.repayments?.map((r) => r.toJson()).toList(), // optional
      };
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
    String? personIdFilter,
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

      if (personIdFilter != null && personIdFilter.isNotEmpty) {
        query = query.where('personId', isEqualTo: personIdFilter);
      }

      if (monthFilter != null) {
        final startOfMonth = Timestamp.fromDate(
          DateTime(monthFilter.year, monthFilter.month, 1),
        );

        final endOfMonth = Timestamp.fromDate(
          (monthFilter.month < 12)
              ? DateTime(monthFilter.year, monthFilter.month + 1, 1)
                  .subtract(const Duration(milliseconds: 1))
              : DateTime(monthFilter.year + 1, 1, 1)
                  .subtract(const Duration(milliseconds: 1)),
        );

        query = query
            .where('createdDate', isGreaterThanOrEqualTo: startOfMonth)
            .where('createdDate', isLessThanOrEqualTo: endOfMonth);
      }

      query = query.orderBy('createdDate', descending: true);

      final snapshot = await query.get();

      // If no docs, return empty
      if (snapshot.docs.isEmpty) return [];

      final List<LendingModel> lendings = [];

      for (final doc in snapshot.docs) {
        final data = doc.data();
        data['id'] = doc.id;

        final String personId = data['personId'];

        final person = await getPersonById(personId);

        data['person'] = person.toJson();

        lendings.add(LendingModel.fromJson(data));
      }

      return lendings;
    } catch (e) {
      throw ServerException(message: '${AppStrings.fetchFailed}: $e');
    }
  }

  // @override
  // Future<void> updateLendingStatus(
  //     String lendingId, LendingStatus newStatus) async {
  //   try {
  //     await _lendingsCollection
  //         .doc(lendingId)
  //         .update({'status': newStatus.name});
  //   } catch (e) {
  //     throw ServerException(message: '${AppStrings.updateFailed}: $e');
  //   }
  // }

  @override
  Future<void> updateLending(LendingModel lending) async {
    try {
      final data = lending.toJson();
      final String docId = data.remove('id');
      if (docId.isEmpty) {
        throw ArgumentError('Lending ID cannot be empty for update.');
      }
      await _lendingsCollection.doc(docId).update(data);
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
        query = query.where('personId', isEqualTo: personNameFilter);
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
      if (typeFilter != null) {
        query = query.where('type', isEqualTo: typeFilter.name);
      }
      if (statusFilter != null) {
        query = query.where('status', isEqualTo: statusFilter.name);
      }
      if (personNameFilter != null && personNameFilter.isNotEmpty) {
        query = query.where('personId', isEqualTo: personNameFilter);
      }

      final snapshot = await query.aggregate(count()).get();
      return snapshot.count ?? 0;
    } catch (e) {
      throw ServerException(message: '${AppStrings.fetchFailed}: $e');
    }
  }

  // LendingPerson Methods
  @override
  Future<void> addPerson(LendingPersonModel person) async {
    try {
      await _personsCollection.add(person.toJson());
    } catch (e) {
      throw ServerException(message: '${AppStrings.operationFailed}: $e');
    }
  }

  @override
  Future<LendingPersonModel> getPersonById(String personId) async {
    try {
      final doc = await _personsCollection.doc(personId).get();
      if (!doc.exists) throw ServerException(message: 'Person not found');
      final data = doc.data()!;
      data['id'] = doc.id;
      return LendingPersonModel.fromJson(data);
    } catch (e) {
      throw ServerException(message: '${AppStrings.fetchFailed}: $e');
    }
  }

  @override
  Future<List<LendingPersonModel>> getUserPersons(String userId,
      {String? nameFilter}) async {
    try {
      Query<Map<String, dynamic>> query =
          _personsCollection.where('userId', isEqualTo: userId);
      if (nameFilter != null && nameFilter.isNotEmpty) {
        query = query.where('name', isEqualTo: nameFilter);
      }

      final snapshot = await query.get();
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return LendingPersonModel.fromJson(data);
      }).toList();
    } catch (e) {
      throw ServerException(message: '${AppStrings.fetchFailed}: $e');
    }
  }

  @override
  Future<void> updatePerson(LendingPersonModel person) async {
    try {
      final data = person.toJson();
      final String docId = data.remove('id');
      if (docId.isEmpty) {
        throw ArgumentError('Person ID cannot be empty for update.');
      }
      await _personsCollection.doc(docId).update(data);
    } catch (e) {
      throw ServerException(message: '${AppStrings.updateFailed}: $e');
    }
  }

  @override
  Future<void> deletePerson(String personId) async {
    try {
      await _personsCollection.doc(personId).delete();
    } catch (e) {
      throw ServerException(message: '${AppStrings.deleteFailed}: $e');
    }
  }

  // Repayment Methods
  @override
  Future<void> addRepayment(RepaymentModel repayment) async {
    try {
      await _repaymentsCollection.add(repayment.toJson());
    } catch (e) {
      throw ServerException(message: '${AppStrings.operationFailed}: $e');
    }
  }

  @override
  Future<List<RepaymentModel>> getRepaymentsForLending(String lendingId) async {
    try {
      final snapshot = await _repaymentsCollection
          .where('lendingId', isEqualTo: lendingId)
          .orderBy('paidDate', descending: true)
          .get();
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return RepaymentModel.fromJson(data);
      }).toList();
    } catch (e) {
      throw ServerException(message: '${AppStrings.fetchFailed}: $e');
    }
  }

  @override
  Future<void> updateRepayment(RepaymentModel repayment) async {
    try {
      final data = repayment.toJson();
      final String docId = data.remove('id');
      if (docId.isEmpty) {
        throw ArgumentError('Repayment ID cannot be empty for update.');
      }
      await _repaymentsCollection.doc(docId).update(data);
    } catch (e) {
      throw ServerException(message: '${AppStrings.updateFailed}: $e');
    }
  }

  @override
  Future<void> deleteRepayment(String repaymentId) async {
    try {
      await _repaymentsCollection.doc(repaymentId).delete();
    } catch (e) {
      throw ServerException(message: '${AppStrings.deleteFailed}: $e');
    }
  }
}
