import 'package:freezed_annotation/freezed_annotation.dart';

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
    String? description,
    required DateTime createdDate,
    DateTime? dueDate,
    required LendingStatus status,
    required String userId,
    List<RepaymentEntity>? repayments,
  }) = _LendingEntity;
}

extension LendingStatusX on LendingEntity {
  LendingStatus get smartStatus {
    final totalPaid = repayments?.fold(0.0, (sum, r) => sum + r.amount) ?? 0.0;

    if (totalPaid >= amount) {
      return LendingStatus.paid;
    } else if (totalPaid > 0 && totalPaid < amount) {
      if (dueDate != null && DateTime.now().isAfter(dueDate!)) {
        return LendingStatus.overdue;
      }
      return LendingStatus.partial;
    } else {
      if (dueDate != null && DateTime.now().isAfter(dueDate!)) {
        return LendingStatus.overdue;
      }
      return LendingStatus.due;
    }
  }
}
