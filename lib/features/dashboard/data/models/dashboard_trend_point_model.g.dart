// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_trend_point_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DashboardTrendPointModel _$DashboardTrendPointModelFromJson(
  Map<String, dynamic> json,
) => _DashboardTrendPointModel(
  date: DateTime.parse(json['date'] as String),
  income: (json['income'] as num).toDouble(),
  expense: (json['expense'] as num).toDouble(),
  balance: (json['balance'] as num).toDouble(),
);

Map<String, dynamic> _$DashboardTrendPointModelToJson(
  _DashboardTrendPointModel instance,
) => <String, dynamic>{
  'date': instance.date.toIso8601String(),
  'income': instance.income,
  'expense': instance.expense,
  'balance': instance.balance,
};
