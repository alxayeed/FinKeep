import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/monthly_standing_entity.dart';

part 'monthly_standing_model.freezed.dart';
part 'monthly_standing_model.g.dart';

@freezed
abstract class MonthlyStandingModel with _$MonthlyStandingModel {
  const MonthlyStandingModel._();

  const factory MonthlyStandingModel({
    required DateTime month,
    required double totalIncome,
    required double totalExpense,
    required double totalLendGiven,
    required double totalLendTaken,
  }) = _MonthlyStandingModel;

  factory MonthlyStandingModel.fromJson(Map<String, dynamic> json) =>
      _$MonthlyStandingModelFromJson(json);

  MonthlyStandingEntity toEntity() {
    return MonthlyStandingEntity(
      month: month,
      totalIncome: totalIncome,
      totalExpense: totalExpense,
      totalLendGiven: totalLendGiven,
      totalLendTaken: totalLendTaken,
    );
  }
}
