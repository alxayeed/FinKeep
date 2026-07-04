import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/dashboard_data_entity.dart';

part 'dashboard_trend_point_model.freezed.dart';
part 'dashboard_trend_point_model.g.dart';

@freezed
abstract class DashboardTrendPointModel with _$DashboardTrendPointModel {
  const DashboardTrendPointModel._();

  const factory DashboardTrendPointModel({
    required DateTime date,
    required double income,
    required double expense,
    required double balance,
  }) = _DashboardTrendPointModel;

  factory DashboardTrendPointModel.fromJson(Map<String, dynamic> json) =>
      _$DashboardTrendPointModelFromJson(json);

  factory DashboardTrendPointModel.fromEntity(DashboardTrendPoint entity) {
    return DashboardTrendPointModel(
      date: entity.date,
      income: entity.income,
      expense: entity.expense,
      balance: entity.balance,
    );
  }

  DashboardTrendPoint toEntity() {
    return DashboardTrendPoint(
      date: date,
      income: income,
      expense: expense,
      balance: balance,
    );
  }
}
