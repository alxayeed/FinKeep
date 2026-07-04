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
  createdAt: _fromJsonDate(json['createdAt']),
);

Map<String, dynamic> _$IncomeModelToJson(_IncomeModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'amount': instance.amount,
      'description': instance.description,
      'date': _toJsonDate(instance.date),
      'categoryId': instance.categoryId,
      'createdAt': _toJsonDate(instance.createdAt),
    };
