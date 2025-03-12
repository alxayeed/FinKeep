import '../../../../core/enums/lending_type.dart';

class LendingEntity {
  final String id;
  final double amount;
  final DateTime date;
  final DateTime dueDate;
  final String userId;
  final String personName;
  final LendingType type;
  final String? note;

  LendingEntity({
    required this.id,
    required this.amount,
    required this.date,
    required this.dueDate,
    required this.userId,
    required this.personName,
    required this.type,
    this.note,
  });
}
