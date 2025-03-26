import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spendly/core/enums/lending_type.dart';
import 'package:spendly/features/lendings/domain/entity/lend_entity.dart';

class LendingModel extends LendingEntity {
  const LendingModel({
    required super.id,
    required super.amount,
    required super.date,
    required super.dueDate,
    required super.lenderId,
    required super.borrowerName,
    required super.type,
    super.note,
  });

  factory LendingModel.fromJson(Map<String, dynamic> json) {
    return LendingModel(
      id: json['id'] as String,
      amount: json['amount'] as int,
      date: (json['date'] as Timestamp).toDate(),
      dueDate: (json['dueDate'] as Timestamp).toDate(),
      lenderId: json['lenderId'] as String,
      borrowerName: json['borrowerName'] as String,
      type: LendingType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
        orElse: () => LendingType.given,
      ),
      note: json['note'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'date': Timestamp.fromDate(date),
      'dueDate': Timestamp.fromDate(date),
      'lenderId': lenderId,
      'borrowerName': borrowerName,
      'type': type.toString().split('.').last,
      'note': note,
    };
  }

  LendingEntity toEntity() {
    return LendingEntity(
      id: id,
      amount: amount,
      date: date,
      dueDate: dueDate,
      lenderId: lenderId,
      borrowerName: borrowerName,
      type: type,
      note: note,
    );
  }
}
