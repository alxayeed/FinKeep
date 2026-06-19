import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:spendly/core/enums/payment_type.dart';

import '../lending_person/lending_person_entity.dart';
import '../repayment/repayment_entity.dart';

part 'lending_entity.freezed.dart';

enum LendingType { given, taken }

enum LendingStatus { due, partial, overdue, paid }

@freezed
abstract class LendingEntity with _$LendingEntity {
  const factory LendingEntity({
    required String id,
    required LendingType type,
    required String personId,
    required LendingPersonEntity person,
    required double amount,
    required double repaidAmount,
    String? description,
    required DateTime createdDate,
    DateTime? dueDate,
    required LendingStatus status,
    @Default(PaymentType.cash) PaymentType paymentMethod,
    List<RepaymentEntity>? repayments,
  }) = _LendingEntity;
}

extension LendingStatusLabelX on LendingStatus {
  String get label {
    switch (this) {
      case LendingStatus.due:
        return 'Due / Unpaid';
      case LendingStatus.partial:
        return 'Partially Repaid';
      case LendingStatus.overdue:
        return 'Overdue';
      case LendingStatus.paid:
        return 'Fully Repaid';
    }
  }
}

