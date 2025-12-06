import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/entity/repayment/repayment_entity.dart';

part 'repayment_model.freezed.dart';
part 'repayment_model.g.dart';

@freezed
abstract class RepaymentModel with _$RepaymentModel {
  const RepaymentModel._();

  const factory RepaymentModel({
    required String id,
    required String lendingId,
    required String userId,
    required double amount,
    required DateTime paidDate,
    String? notes,
  }) = _RepaymentModel;

  factory RepaymentModel.fromJson(Map<String, dynamic> json) =>
      _$RepaymentModelFromJson(json);

  /// Create Model from Domain Entity
  factory RepaymentModel.fromEntity(RepaymentEntity entity) {
    return RepaymentModel(
      id: entity.id,
      lendingId: entity.lendingId,
      userId: entity.userId,
      amount: entity.amount,
      paidDate: entity.paidDate,
      notes: entity.notes,
    );
  }

  /// Convert Model to Domain Entity
  RepaymentEntity toEntity() {
    return RepaymentEntity(
      id: id,
      lendingId: lendingId,
      userId: userId,
      amount: amount,
      paidDate: paidDate,
      notes: notes,
    );
  }
}
