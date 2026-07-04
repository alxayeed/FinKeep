import 'package:freezed_annotation/freezed_annotation.dart';

part 'dashboard_recent_activity_entity.freezed.dart';
part 'dashboard_recent_activity_entity.g.dart';

@freezed
abstract class DashboardRecentActivityEntity
    with _$DashboardRecentActivityEntity {
  const factory DashboardRecentActivityEntity({
    required String id,
    required String title,
    required String category,
    required double amount,
    required DateTime date,
    required String type, // 'income', 'expense', 'lending'
    String? emoji,
  }) = _DashboardRecentActivityEntity;

  factory DashboardRecentActivityEntity.fromJson(Map<String, dynamic> json) =>
      _$DashboardRecentActivityEntityFromJson(json);
}
