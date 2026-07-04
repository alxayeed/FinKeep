// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_category_breakdown_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DashboardCategoryBreakdownEntity _$DashboardCategoryBreakdownEntityFromJson(
  Map<String, dynamic> json,
) => _DashboardCategoryBreakdownEntity(
  categoryName: json['categoryName'] as String,
  amount: (json['amount'] as num).toDouble(),
  percentage: (json['percentage'] as num).toDouble(),
  emoji: json['emoji'] as String?,
);

Map<String, dynamic> _$DashboardCategoryBreakdownEntityToJson(
  _DashboardCategoryBreakdownEntity instance,
) => <String, dynamic>{
  'categoryName': instance.categoryName,
  'amount': instance.amount,
  'percentage': instance.percentage,
  'emoji': instance.emoji,
};
