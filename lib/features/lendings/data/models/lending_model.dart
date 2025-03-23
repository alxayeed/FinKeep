import 'package:spendly/features/lendings/domain/entity/lend_entity.dart';

class LendingModel extends LendingEntity {
  final String id;

  const LendingModel({
    required this.id,
    required super.amount,
    required super.date,
    required super.dueDate,
    required super.lenderId,
    required super.borrowerName,
    required super.type,
    super.note,
  });
}
