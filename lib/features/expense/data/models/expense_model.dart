import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finkeep/core/utils/date_parser.dart';
import 'package:finkeep/core/enums/payment_type.dart';
import '../../domain/entities/expense_entity.dart';

class ExpenseModel extends ExpenseEntity {
  ExpenseModel({
    required super.id,
    required super.amount,
    required super.category,
    required super.date,
    super.description,
    super.paymentMethod,
    super.createdAt,
  });

  factory ExpenseModel.fromJson(Map<String, dynamic> json) {
    return ExpenseModel(
      id: json['id'] as String,
      amount: (json['amount'] as num).toDouble(),
      category: json['category'] as String,
      date: DateParser.parse(json['date']),
      description: json['description'] as String? ?? '',
      paymentMethod: PaymentTypeExtension.fromString(json['paymentMethod'] as String? ?? 'CASH'),
      createdAt: DateParser.parse(json['createdAt']),
    );
  }

  /// Firestore-specific deserialization: reads Firestore Timestamps.
  factory ExpenseModel.fromFirestoreMap(Map<String, dynamic> json) {
    return ExpenseModel(
      id: json['id'] as String,
      amount: (json['amount'] as num).toDouble(),
      category: json['category'] as String,
      date: DateParser.parse(json['date']),
      description: json['description'] as String? ?? '',
      paymentMethod: PaymentTypeExtension.fromString(json['paymentMethod'] as String? ?? 'CASH'),
      createdAt: DateParser.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'category': category,
      'date': date,
      'description': description,
      'paymentMethod': paymentMethod.value,
      'createdAt': createdAt,
    };
  }

  /// Firestore-specific map: dates are stored as Timestamps.
  Map<String, dynamic> toFirestoreMap() {
    return {
      'id': id,
      'amount': amount,
      'category': category,
      'date': Timestamp.fromDate(date),
      'description': description,
      'paymentMethod': paymentMethod.value,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  ExpenseEntity toEntity() {
    return ExpenseEntity(
      id: id,
      amount: amount,
      category: category,
      date: date,
      description: description,
      paymentMethod: paymentMethod,
      createdAt: createdAt,
    );
  }
}
