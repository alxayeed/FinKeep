// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'income_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_IncomeModel _$IncomeModelFromJson(Map<String, dynamic> json) => _IncomeModel(
  id: json['id'] as String,
  amount: (json['amount'] as num).toDouble(),
  description: json['description'] as String,
  date: _fromJsonDate(json['date']),
  categoryId: json['categoryId'] as String,
  paymentMethod:
      $enumDecodeNullable(_$PaymentTypeEnumMap, json['paymentMethod']) ??
      PaymentType.cash,
  createdAt: _fromJsonDate(json['createdAt']),
);

Map<String, dynamic> _$IncomeModelToJson(_IncomeModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'amount': instance.amount,
      'description': instance.description,
      'date': _toJsonDate(instance.date),
      'categoryId': instance.categoryId,
      'paymentMethod': _$PaymentTypeEnumMap[instance.paymentMethod]!,
      'createdAt': _toJsonDate(instance.createdAt),
    };

const _$PaymentTypeEnumMap = {
  PaymentType.cash: 'cash',
  PaymentType.mfs: 'mfs',
  PaymentType.card: 'card',
  PaymentType.transfer: 'transfer',
};
