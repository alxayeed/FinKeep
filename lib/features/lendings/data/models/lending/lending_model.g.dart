// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lending_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LendingModel _$LendingModelFromJson(Map<String, dynamic> json) =>
    _LendingModel(
      id: json['id'] as String,
      type: $enumDecode(_$LendingTypeEnumMap, json['type']),
      personId: json['personId'] as String,
      person: LendingPersonModel.fromJson(
        json['person'] as Map<String, dynamic>,
      ),
      amount: (json['amount'] as num).toDouble(),
      repaidAmount: (json['repaidAmount'] as num?)?.toDouble() ?? 0.0,
      description: json['description'] as String?,
      createdDate: _fromJsonDate(json['createdDate']),
      dueDate: _fromJsonNullableDate(json['dueDate']),
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
      'personId': instance.personId,
      'amount': instance.amount,
      'repaidAmount': instance.repaidAmount,
      'description': instance.description,
      'createdDate': _toJsonDate(instance.createdDate),
      'dueDate': _toJsonNullableDate(instance.dueDate),
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
