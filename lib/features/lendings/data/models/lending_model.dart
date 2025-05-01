import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entity/lend_entity.dart';

class LendingModel extends LendingEntity {
  const LendingModel({
    required super.id,
    required super.type,
    required super.personName,
    required super.amount,
    super.description,
    required super.createdDate,
    super.dueDate,
    required super.status,
    required super.userId,
  });

  factory LendingModel.fromJson(Map<String, dynamic> json) {
    return LendingModel(
      id: json['id'] as String,
      type: LendingType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => LendingType.given,
      ),
      personName: json['personName'] as String,
      amount: (json['amount'] as num).toDouble(),
      description: json['description'] as String?,
      createdDate: (json['createdDate'] as Timestamp).toDate(),
      dueDate: json['dueDate'] == null
          ? null
          : (json['dueDate'] as Timestamp).toDate(),
      status: LendingStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => LendingStatus.due,
      ),
      userId: json['userId'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'personName': personName,
      'amount': amount,
      'description': description,
      'createdDate': Timestamp.fromDate(createdDate),
      'dueDate': dueDate == null ? null : Timestamp.fromDate(dueDate!),
      'status': status.name,
      'userId': userId,
    };
  }

  LendingEntity toEntity() {
    return LendingEntity(
      id: id,
      type: type,
      personName: personName,
      amount: amount,
      description: description,
      createdDate: createdDate,
      dueDate: dueDate,
      status: status,
      userId: userId,
    );
  }
}
