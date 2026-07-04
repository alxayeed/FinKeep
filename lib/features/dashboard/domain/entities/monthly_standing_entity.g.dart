// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'monthly_standing_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MonthlyStandingEntity _$MonthlyStandingEntityFromJson(
  Map<String, dynamic> json,
) => _MonthlyStandingEntity(
  month: DateTime.parse(json['month'] as String),
  totalIncome: (json['totalIncome'] as num).toDouble(),
  totalExpense: (json['totalExpense'] as num).toDouble(),
  totalLendGiven: (json['totalLendGiven'] as num).toDouble(),
  totalLendTaken: (json['totalLendTaken'] as num).toDouble(),
);

Map<String, dynamic> _$MonthlyStandingEntityToJson(
  _MonthlyStandingEntity instance,
) => <String, dynamic>{
  'month': instance.month.toIso8601String(),
  'totalIncome': instance.totalIncome,
  'totalExpense': instance.totalExpense,
  'totalLendGiven': instance.totalLendGiven,
  'totalLendTaken': instance.totalLendTaken,
};
