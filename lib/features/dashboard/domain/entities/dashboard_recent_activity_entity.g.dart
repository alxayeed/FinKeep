// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_recent_activity_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DashboardRecentActivityEntity _$DashboardRecentActivityEntityFromJson(
  Map<String, dynamic> json,
) => _DashboardRecentActivityEntity(
  id: json['id'] as String,
  title: json['title'] as String,
  category: json['category'] as String,
  amount: (json['amount'] as num).toDouble(),
  date: DateTime.parse(json['date'] as String),
  type: json['type'] as String,
  emoji: json['emoji'] as String?,
);

Map<String, dynamic> _$DashboardRecentActivityEntityToJson(
  _DashboardRecentActivityEntity instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'category': instance.category,
  'amount': instance.amount,
  'date': instance.date.toIso8601String(),
  'type': instance.type,
  'emoji': instance.emoji,
};
