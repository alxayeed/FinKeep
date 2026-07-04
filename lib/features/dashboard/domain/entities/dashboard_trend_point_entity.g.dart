// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_trend_point_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DashboardTrendPointEntity _$DashboardTrendPointEntityFromJson(
  Map<String, dynamic> json,
) => _DashboardTrendPointEntity(
  date: DateTime.parse(json['date'] as String),
  income: (json['income'] as num).toDouble(),
  expense: (json['expense'] as num).toDouble(),
  balance: (json['balance'] as num).toDouble(),
);

Map<String, dynamic> _$DashboardTrendPointEntityToJson(
  _DashboardTrendPointEntity instance,
) => <String, dynamic>{
  'date': instance.date.toIso8601String(),
  'income': instance.income,
  'expense': instance.expense,
  'balance': instance.balance,
};
