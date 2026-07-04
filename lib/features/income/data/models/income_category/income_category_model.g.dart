// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'income_category_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_IncomeCategoryModel _$IncomeCategoryModelFromJson(Map<String, dynamic> json) =>
    _IncomeCategoryModel(
      id: json['id'] as String,
      displayLabel: json['displayLabel'] as String,
      emoji: json['emoji'] as String,
      isCustom: json['isCustom'] as bool? ?? false,
      isDeleted: json['isDeleted'] as bool? ?? false,
    );

Map<String, dynamic> _$IncomeCategoryModelToJson(
  _IncomeCategoryModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'displayLabel': instance.displayLabel,
  'emoji': instance.emoji,
  'isCustom': instance.isCustom,
  'isDeleted': instance.isDeleted,
};
