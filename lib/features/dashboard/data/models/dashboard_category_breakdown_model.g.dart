// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_category_breakdown_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DashboardCategoryBreakdownModel _$DashboardCategoryBreakdownModelFromJson(
  Map<String, dynamic> json,
) => _DashboardCategoryBreakdownModel(
  categoryName: json['categoryName'] as String,
  amount: (json['amount'] as num).toDouble(),
  percentage: (json['percentage'] as num).toDouble(),
  emoji: json['emoji'] as String?,
);

Map<String, dynamic> _$DashboardCategoryBreakdownModelToJson(
  _DashboardCategoryBreakdownModel instance,
) => <String, dynamic>{
  'categoryName': instance.categoryName,
  'amount': instance.amount,
  'percentage': instance.percentage,
  'emoji': instance.emoji,
};
