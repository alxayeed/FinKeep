import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:finkeep/core/enums/payment_type.dart';

part 'repayment_entity.freezed.dart';

@freezed
abstract class RepaymentEntity with _$RepaymentEntity {
  const factory RepaymentEntity({
    required String id,
    required String lendingId,
    required double amount,
    required DateTime paidDate,
    String? notes,
    @Default(PaymentType.cash) PaymentType paymentMethod,
  }) = _RepaymentEntity;
}

