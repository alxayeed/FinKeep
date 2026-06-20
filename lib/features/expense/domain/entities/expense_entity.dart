import 'package:equatable/equatable.dart';
import 'package:finkeep/core/enums/payment_type.dart';
import 'package:finkeep/features/expense/data/models/expense_model.dart';

class ExpenseEntity extends Equatable {
  final String id;
  final double amount;
  final String category;
  final DateTime date;
  final String description;
  final PaymentType paymentMethod;
  final DateTime createdAt;

  ExpenseEntity({
    required this.id,
    required this.amount,
    required this.category,
    required this.date,
    this.description = '',
    this.paymentMethod = PaymentType.cash,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  @override
  List<Object?> get props =>
      [id, amount, category, date, description, paymentMethod, createdAt];

  ExpenseModel toModel() {
    return ExpenseModel(
      id: id,
      amount: amount,
      category: category,
      date: date,
      description: description,
      paymentMethod: paymentMethod,
      createdAt: createdAt,
    );
  }

  ExpenseEntity copyWith({
    String? id,
    double? amount,
    String? category,
    DateTime? date,
    String? description,
    PaymentType? paymentMethod,
    DateTime? createdAt,
  }) {
    return ExpenseEntity(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      date: date ?? this.date,
      description: description ?? this.description,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
