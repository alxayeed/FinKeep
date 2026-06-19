// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lending_person_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LendingPersonModel _$LendingPersonModelFromJson(Map<String, dynamic> json) =>
    _LendingPersonModel(
      id: json['id'] as String,
      name: json['name'] as String,
      contactNumber: json['contactNumber'] as String?,
      email: json['email'] as String?,
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$LendingPersonModelToJson(_LendingPersonModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'contactNumber': instance.contactNumber,
      'email': instance.email,
      'notes': instance.notes,
    };
