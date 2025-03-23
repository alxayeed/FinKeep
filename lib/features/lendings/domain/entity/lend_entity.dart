import 'package:equatable/equatable.dart';

import '../../../../core/enums/lending_type.dart';

class LendingEntity extends Equatable {
  final int amount;
  final DateTime date;
  final DateTime dueDate;
  final String lenderId;
  final String borrowerName;
  final LendingType type;
  final String? note;

  const LendingEntity({
    required this.amount,
    required this.date,
    required this.dueDate,
    required this.lenderId,
    required this.borrowerName,
    required this.type,
    this.note,
  });

  @override
  List<Object?> get props => [
        amount,
        date,
        dueDate,
        lenderId,
        borrowerName,
        type,
        note,
      ];
}
