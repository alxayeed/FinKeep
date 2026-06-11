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
    required String userId,
    @JsonKey(fromJson: _fromJsonPaymentMethod, toJson: _toJsonPaymentMethod)
    @Default(PaymentType.cash) PaymentType paymentMethod,
    List<RepaymentModel>? repayments,
  }) = _LendingModel;

  factory LendingModel.fromJson(Map<String, dynamic> json) =>
      _$LendingModelFromJson(json);

  /// Convert entity to model
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
      userId: entity.userId,
      paymentMethod: entity.paymentMethod,
      repayments: entity.repayments
          ?.map((repayment) => RepaymentModel.fromEntity(repayment))
          .toList(),
    );
  }

  /// Convert model to entity
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
      userId: userId,
      paymentMethod: paymentMethod,
      repayments: repayments?.map((repayment) => repayment.toEntity()).toList(),
    );
  }
}

DateTime _fromJsonDate(dynamic value) {
  if (value is Timestamp) return value.toDate();
  if (value is String) return DateTime.parse(value);
  throw Exception('Invalid date: $value');
}

dynamic _toJsonDate(DateTime value) {
  return Timestamp.fromDate(value);
}

DateTime? _fromJsonNullableDate(dynamic value) {
  if (value == null) return null;
  if (value is Timestamp) return value.toDate();
  if (value is String) return DateTime.parse(value);
  throw Exception('Invalid nullable date: $value');
}

dynamic _toJsonNullableDate(DateTime? value) {
  return value == null ? null : Timestamp.fromDate(value);
}

PaymentType _fromJsonPaymentMethod(dynamic value) {
  if (value is String) return PaymentTypeExtension.fromString(value);
  return PaymentType.cash;
}

dynamic _toJsonPaymentMethod(PaymentType value) {
  return value.value;
}
