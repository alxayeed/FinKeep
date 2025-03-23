import 'package:spendly/core/enums/lending_type.dart';
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

  // fromJson method to parse the JSON map into a LendingModel
  factory LendingModel.fromJson(Map<String, dynamic> json) {
    return LendingModel(
      id: json['id'] as String,
      amount: json['amount'] as int,
      date: DateTime.parse(json['date'] as String),
      dueDate: DateTime.parse(json['dueDate'] as String),
      lenderId: json['lenderId'] as String,
      borrowerName: json['borrowerName'] as String,
      type: LendingType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
        orElse: () => LendingType.given,
      ),
      note: json['note'] as String?,
    );
  }
}
