import 'package:freezed_annotation/freezed_annotation.dart';

part 'income_entity.freezed.dart';

@freezed
abstract class IncomeEntity with _$IncomeEntity {
  const factory IncomeEntity({
    required String id,
    required double amount,
    required String description,
    required DateTime date,
    required String categoryId,
    required DateTime createdAt,
  }) = _IncomeEntity;
}
