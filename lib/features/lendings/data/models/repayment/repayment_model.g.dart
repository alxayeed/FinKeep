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
      paidDate: _fromJsonDate(json['paidDate']),
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$RepaymentModelToJson(_RepaymentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'lendingId': instance.lendingId,
      'userId': instance.userId,
      'amount': instance.amount,
      'paidDate': _toJsonDate(instance.paidDate),
      'notes': instance.notes,
    };
