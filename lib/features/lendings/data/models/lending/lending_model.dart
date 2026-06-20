import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:spendly/core/enums/payment_type.dart';

import '../../../domain/entity/lending/lending_entity.dart';
import '../lending_person/lending_person_model.dart';
import '../repayment/repayment_model.dart';

part 'lending_model.freezed.dart';
part 'lending_model.g.dart';

@freezed
abstract class LendingModel with _$LendingModel {
  const LendingModel._();

  const factory LendingModel({
    required String id,
    required LendingType type,
    required String personId,
    @JsonKey(includeToJson: false) required LendingPersonModel person,
    required double amount,
    @Default(0.0) double repaidAmount,
    String? description,
    @JsonKey(fromJson: _fromJsonDate, toJson: _toJsonDate)
    required DateTime createdDate,
    @JsonKey(fromJson: _fromJsonNullableDate, toJson: _toJsonNullableDate)
    DateTime? dueDate,
    required LendingStatus status,
    @JsonKey(fromJson: _fromJsonPaymentMethod, toJson: _toJsonPaymentMethod)
    @Default(PaymentType.cash) PaymentType paymentMethod,
    List<RepaymentModel>? repayments,
  }) = _LendingModel;

  /// Plain Dart deserialization — used by Hive (via json_serializable).
  factory LendingModel.fromJson(Map<String, dynamic> json) =>
      _$LendingModelFromJson(json);

  /// Firestore-specific deserialization — reads Firestore Timestamps.
  factory LendingModel.fromFirestoreMap(Map<String, dynamic> json) {
    return LendingModel(
      id: json['id'] as String,
      type: $enumDecode(_$LendingTypeEnumMap, json['type']),
      personId: json['personId'] as String,
      person: LendingPersonModel.fromJson(
          Map<String, dynamic>.from(json['person'] as Map)),
      amount: (json['amount'] as num).toDouble(),
      repaidAmount: (json['repaidAmount'] as num?)?.toDouble() ?? 0.0,
      description: json['description'] as String?,
      createdDate: (json['createdDate'] as Timestamp).toDate(),
      dueDate: json['dueDate'] != null
          ? (json['dueDate'] as Timestamp).toDate()
          : null,
      status: $enumDecode(_$LendingStatusEnumMap, json['status']),
      paymentMethod: _fromJsonPaymentMethod(json['paymentMethod']),
      repayments: (json['repayments'] as List<dynamic>?)
          ?.map((e) => RepaymentModel.fromFirestoreMap(
              Map<String, dynamic>.from(e as Map)))
          .toList(),
    );
  }

  /// Convert entity to model.
  factory LendingModel.fromEntity(LendingEntity entity) {
    return LendingModel(
      id: entity.id,
      type: entity.type,
      personId: entity.personId,
      person: LendingPersonModel.fromEntity(entity.person),
      amount: entity.amount,
      repaidAmount: entity.repaidAmount,
      description: entity.description,
      createdDate: entity.createdDate,
      dueDate: entity.dueDate,
      status: entity.status,
      paymentMethod: entity.paymentMethod,
      repayments: entity.repayments
          ?.map((repayment) => RepaymentModel.fromEntity(repayment))
          .toList(),
    );
  }

  /// Convert model to entity.
  LendingEntity toEntity() {
    return LendingEntity(
      id: id,
      type: type,
      personId: personId,
      person: person.toEntity(),
      amount: amount,
      repaidAmount: repaidAmount,
      description: description,
      createdDate: createdDate,
      dueDate: dueDate,
      status: status,
      paymentMethod: paymentMethod,
      repayments: repayments?.map((repayment) => repayment.toEntity()).toList(),
    );
  }

  /// Firestore-specific serialization — stores dates as Timestamps.
  Map<String, dynamic> toFirestoreMap() {
    return {
      'id': id,
      'type': _$LendingTypeEnumMap[type]!,
      'personId': personId,
      'amount': amount,
      'repaidAmount': repaidAmount,
      'description': description,
      'createdDate': Timestamp.fromDate(createdDate),
      'dueDate': dueDate != null ? Timestamp.fromDate(dueDate!) : null,
      'status': _$LendingStatusEnumMap[status]!,
      'paymentMethod': _toJsonPaymentMethod(paymentMethod),
      'repayments': repayments?.map((r) => r.toFirestoreMap()).toList(),
    };
  }
}

// ---------------------------------------------------------------------------
// @JsonKey converter helpers — plain Dart types (Hive-safe).
// ---------------------------------------------------------------------------

/// Reads a DateTime from Hive (DateTime) or legacy formats (Timestamp, String).
DateTime _fromJsonDate(dynamic value) {
  if (value is DateTime) return value;
  if (value is Timestamp) return value.toDate();
  if (value is String) return DateTime.parse(value);
  throw Exception('Invalid date: $value');
}

/// Writes a plain DateTime — safe for Hive.
DateTime _toJsonDate(DateTime value) => value;

DateTime? _fromJsonNullableDate(dynamic value) {
  if (value == null) return null;
  if (value is DateTime) return value;
  if (value is Timestamp) return value.toDate();
  if (value is String) return DateTime.parse(value);
  throw Exception('Invalid nullable date: $value');
}

DateTime? _toJsonNullableDate(DateTime? value) => value;

PaymentType _fromJsonPaymentMethod(dynamic value) {
  if (value is String) return PaymentTypeExtension.fromString(value);
  return PaymentType.cash;
}

String _toJsonPaymentMethod(PaymentType value) => value.value;
