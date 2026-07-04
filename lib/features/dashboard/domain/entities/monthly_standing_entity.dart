import 'package:freezed_annotation/freezed_annotation.dart';

part 'monthly_standing_entity.freezed.dart';
part 'monthly_standing_entity.g.dart';

@freezed
abstract class MonthlyStandingEntity with _$MonthlyStandingEntity {
  const factory MonthlyStandingEntity({
    required DateTime month,
    required double totalIncome,
    required double totalExpense,
    required double totalLendGiven,
    required double totalLendTaken,
  }) = _MonthlyStandingEntity;

  factory MonthlyStandingEntity.fromJson(Map<String, dynamic> json) =>
      _$MonthlyStandingEntityFromJson(json);
}
