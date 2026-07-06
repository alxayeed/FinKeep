import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:finkeep/core/utils/date_parser.dart';
import 'package:finkeep/core/enums/payment_type.dart';
import '../../../domain/entities/income/income_entity.dart';

part 'income_model.freezed.dart';
part 'income_model.g.dart';

@freezed
abstract class IncomeModel with _$IncomeModel {
  const IncomeModel._();

  const factory IncomeModel({
    required String id,
    required double amount,
    required String description,
    @JsonKey(fromJson: _fromJsonDate, toJson: _toJsonDate)
    required DateTime date,
    required String categoryId,
    @Default(PaymentType.cash) PaymentType paymentMethod,
    @JsonKey(fromJson: _fromJsonDate, toJson: _toJsonDate)
    required DateTime createdAt,
  }) = _IncomeModel;

  factory IncomeModel.fromJson(Map<String, dynamic> json) =>
      _$IncomeModelFromJson(json);

  factory IncomeModel.fromFirestoreMap(Map<String, dynamic> json) {
    return IncomeModel(
      id: (json['id'] ?? '').toString(),
      amount: (json['amount'] as num? ?? 0.0).toDouble(),
      description: (json['description'] ?? '').toString(),
      date: DateParser.parse(json['date']),
      categoryId: (json['categoryId'] ?? '').toString(),
      paymentMethod: PaymentTypeExtension.fromString(json['paymentMethod'] as String? ?? 'CASH'),
      createdAt: DateParser.parse(json['createdAt'] ?? json['date']),
    );
  }

  factory IncomeModel.fromEntity(IncomeEntity entity) {
    return IncomeModel(
      id: entity.id,
      amount: entity.amount,
      description: entity.description,
      date: entity.date,
      categoryId: entity.categoryId,
      paymentMethod: entity.paymentMethod,
      createdAt: entity.createdAt,
    );
  }

  IncomeEntity toEntity() {
    return IncomeEntity(
      id: id,
      amount: amount,
      description: description,
      date: date,
      categoryId: categoryId,
      paymentMethod: paymentMethod,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toFirestoreMap() {
    return {
      'id': id,
      'amount': amount,
      'description': description,
      'date': Timestamp.fromDate(date),
      'categoryId': categoryId,
      'paymentMethod': paymentMethod.value,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}

DateTime _fromJsonDate(dynamic value) => DateParser.parse(value);
DateTime _toJsonDate(DateTime value) => value;

