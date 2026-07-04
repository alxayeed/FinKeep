import 'package:freezed_annotation/freezed_annotation.dart';

part 'dashboard_trend_point_entity.freezed.dart';
part 'dashboard_trend_point_entity.g.dart';

@freezed
abstract class DashboardTrendPointEntity with _$DashboardTrendPointEntity {
  const factory DashboardTrendPointEntity({
    required DateTime date,
    required double income,
    required double expense,
    required double balance,
  }) = _DashboardTrendPointEntity;

  factory DashboardTrendPointEntity.fromJson(Map<String, dynamic> json) =>
      _$DashboardTrendPointEntityFromJson(json);
}
