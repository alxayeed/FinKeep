// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lending_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LendingModel _$LendingModelFromJson(Map<String, dynamic> json) =>
    _LendingModel(
      id: json['id'] as String,
      type: $enumDecode(_$LendingTypeEnumMap, json['type']),
      person:
          LendingPersonModel.fromJson(json['person'] as Map<String, dynamic>),
      amount: (json['amount'] as num).toDouble(),
      description: json['description'] as String?,
      createdDate: DateTime.parse(json['createdDate'] as String),
      dueDate: json['dueDate'] == null
          ? null
          : DateTime.parse(json['dueDate'] as String),
      status: $enumDecode(_$LendingStatusEnumMap, json['status']),
      userId: json['userId'] as String,
      repayments: (json['repayments'] as List<dynamic>?)
          ?.map((e) => RepaymentModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$LendingModelToJson(_LendingModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$LendingTypeEnumMap[instance.type]!,
      'person': instance.person,
      'amount': instance.amount,
      'description': instance.description,
      'createdDate': instance.createdDate.toIso8601String(),
      'dueDate': instance.dueDate?.toIso8601String(),
      'status': _$LendingStatusEnumMap[instance.status]!,
      'userId': instance.userId,
      'repayments': instance.repayments,
    };

const _$LendingTypeEnumMap = {
  LendingType.given: 'given',
  LendingType.taken: 'taken',
};

const _$LendingStatusEnumMap = {
  LendingStatus.due: 'due',
  LendingStatus.partial: 'partial',
  LendingStatus.overdue: 'overdue',
  LendingStatus.paid: 'paid',
};
