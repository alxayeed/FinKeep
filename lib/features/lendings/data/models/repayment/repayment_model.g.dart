// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'repayment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RepaymentModel _$RepaymentModelFromJson(Map<String, dynamic> json) =>
    _RepaymentModel(
      id: json['id'] as String,
      lendingId: json['lendingId'] as String,
      userId: json['userId'] as String,
      amount: (json['amount'] as num).toDouble(),
      paidDate: DateTime.parse(json['paidDate'] as String),
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$RepaymentModelToJson(_RepaymentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'lendingId': instance.lendingId,
      'userId': instance.userId,
      'amount': instance.amount,
      'paidDate': instance.paidDate.toIso8601String(),
      'notes': instance.notes,
    };
