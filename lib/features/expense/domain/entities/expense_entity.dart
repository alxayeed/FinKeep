import 'package:equatable/equatable.dart';

class ExpenseEntity extends Equatable {
  final String id;
  final double amount;
  final String category;
  final DateTime date;
  final String description;
  final String userId;
  final DateTime createdAt;

  ExpenseEntity({
    required this.id,
    required this.amount,
    required this.category,
    required this.date,
    this.description = '',
    this.userId = '',
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  @override
  List<Object?> get props =>
      [id, amount, category, date, description, userId, createdAt];
}
