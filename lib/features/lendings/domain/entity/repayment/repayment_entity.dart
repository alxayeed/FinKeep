import 'package:freezed_annotation/freezed_annotation.dart';

part 'repayment_entity.freezed.dart';

@freezed
abstract class RepaymentEntity with _$RepaymentEntity {
  const factory RepaymentEntity({
    required String id,
    required String lendingId,
    required double amount,
    required DateTime paidDate,
    String? notes,
  }) = _RepaymentEntity;
}
