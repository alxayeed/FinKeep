import 'package:finkeep/features/lendings/data/models/lending/lending_model.dart';
import 'package:finkeep/features/lendings/data/models/repayment/repayment_model.dart';
import 'package:finkeep/features/lendings/domain/entity/lending/lending_entity.dart';
import 'package:finkeep/features/lendings/data/models/lending_person/lending_person_model.dart';
import 'package:finkeep/features/lendings/data/datasources/lending_local_datasource.dart';
import 'package:finkeep/core/services/local_db_service.dart';

class LendingHiveDataSource implements LendingLocalDataSource {
  final LocalDbService localDb;

  LendingHiveDataSource({required this.localDb});

  // --- Lending Methods ---
  @override
  Future<void> addLending(LendingModel lending) async {
    await localDb.lendingsBox.put(lending.id, lending.toJson());
  }

  @override
  Future<List<LendingModel>> getLendings({
    LendingType? typeFilter,
    DateTime? monthFilter,
    LendingStatus? statusFilter,
    String? personIdFilter,
  }) async {
    final list = <LendingModel>[];
    for (final raw in localDb.lendingsBox.values) {
      final data = Map<String, dynamic>.from(raw);

      if (typeFilter != null && data['type'] != typeFilter.name) continue;
      if (statusFilter != null && data['status'] != statusFilter.name) continue;
      if (personIdFilter != null && personIdFilter.isNotEmpty && data['personId'] != personIdFilter) continue;

      if (monthFilter != null) {
        final raw = data['createdDate'];
        final createdDate = raw is DateTime
            ? raw
            : DateTime.parse(raw as String);
        if (createdDate.year != monthFilter.year ||
            createdDate.month != monthFilter.month) {
          continue;
        }
      }

      // Populate person object
      final String personId = data['personId'];
      final person = await getPersonById(personId);
      data['person'] = person.toJson();

      list.add(LendingModel.fromJson(data));
    }

    list.sort((a, b) => b.createdDate.compareTo(a.createdDate));
    return list;
  }

  @override
  Future<void> updateLending(LendingModel lending) async {
    await localDb.lendingsBox.put(lending.id, lending.toJson());
  }

  @override
  Future<void> deleteLending(String lendingId) async {
    await localDb.lendingsBox.delete(lendingId);
  }

  @override
  Future<double> getTotalLendingAmount({
    LendingType? typeFilter,
    LendingStatus? statusFilter,
    String? personNameFilter,
  }) async {
    final lendings = await getLendings(
      typeFilter: typeFilter,
      statusFilter: statusFilter,
      personIdFilter: personNameFilter,
    );
    return lendings.fold<double>(0.0, (sum, lending) => sum + lending.amount);
  }

  @override
  Future<int> getLendingsCount({
    LendingType? typeFilter,
    LendingStatus? statusFilter,
    String? personNameFilter,
  }) async {
    final lendings = await getLendings(
      typeFilter: typeFilter,
      statusFilter: statusFilter,
      personIdFilter: personNameFilter,
    );
    return lendings.length;
  }

  // --- LendingPerson Methods ---
  @override
  Future<void> addPerson(LendingPersonModel person) async {
    await localDb.personsBox.put(person.id, person.toJson());
  }

  @override
  Future<LendingPersonModel> getPersonById(String personId) async {
    final raw = localDb.personsBox.get(personId);
    if (raw == null) {
      throw Exception('Person not found');
    }
    return LendingPersonModel.fromJson(Map<String, dynamic>.from(raw));
  }

  @override
  Future<List<LendingPersonModel>> getUserPersons({
    String? nameFilter,
  }) async {
    final list = localDb.personsBox.values
        .map((raw) => LendingPersonModel.fromJson(Map<String, dynamic>.from(raw)))
        .toList();

    if (nameFilter != null && nameFilter.isNotEmpty) {
      return list.where((person) => person.name == nameFilter).toList();
    }
    return list;
  }

  @override
  Future<void> updatePerson(LendingPersonModel person) async {
    await localDb.personsBox.put(person.id, person.toJson());
  }

  @override
  Future<void> deletePerson(String personId) async {
    await localDb.personsBox.delete(personId);
  }

  // --- Repayment Methods ---
  @override
  Future<void> addRepayment(RepaymentModel repayment) async {
    await localDb.repaymentsBox.put(repayment.id, repayment.toJson());
  }

  @override
  Future<List<RepaymentModel>> getRepaymentsForLending(String lendingId) async {
    final list = localDb.repaymentsBox.values
        .map((raw) => RepaymentModel.fromJson(Map<String, dynamic>.from(raw)))
        .where((repayment) => repayment.lendingId == lendingId)
        .toList();
    list.sort((a, b) => b.paidDate.compareTo(a.paidDate));
    return list;
  }

  @override
  Future<void> updateRepayment(RepaymentModel repayment) async {
    await localDb.repaymentsBox.put(repayment.id, repayment.toJson());
  }

  @override
  Future<void> deleteRepayment(String repaymentId) async {
    await localDb.repaymentsBox.delete(repaymentId);
  }
}
