import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/entity/lending/lending_entity.dart';
import '../lending_person/lending_person_model.dart';
import '../repayment/repayment_model.dart';

part 'lending_model.freezed.dart';
part 'lending_model.g.dart';

@freezed
abstract class LendingModel with _$LendingModel {
  const LendingModel._();

  const factory LendingModel({
    required String id,
    required LendingType type,
    required LendingPersonModel person,
    required double amount,
    String? description,
    required DateTime createdDate,
    DateTime? dueDate,
    required LendingStatus status,
    required String userId,
    List<RepaymentModel>? repayments,
  }) = _LendingModel;

  factory LendingModel.fromJson(Map<String, dynamic> json) =>
      _$LendingModelFromJson(json);

  /// Convert entity to model
  factory LendingModel.fromEntity(LendingEntity entity) {
    return LendingModel(
      id: entity.id,
      type: entity.type,
      person: LendingPersonModel.fromEntity(entity.person),
      amount: entity.amount,
      description: entity.description,
      createdDate: entity.createdDate,
      dueDate: entity.dueDate,
      status: entity.status,
      userId: entity.userId,
      repayments: entity.repayments
          ?.map((repayment) => RepaymentModel.fromEntity(repayment))
          .toList(),
    );
  }

  /// Convert model to entity
  LendingEntity toEntity() {
    return LendingEntity(
      id: id,
      type: type,
      person: person.toEntity(),
      amount: amount,
      description: description,
      createdDate: createdDate,
      dueDate: dueDate,
      status: status,
      userId: userId,
      repayments: repayments?.map((repayment) => repayment.toEntity()).toList(),
    );
  }
}
