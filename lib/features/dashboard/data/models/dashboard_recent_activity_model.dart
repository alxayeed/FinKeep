import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/dashboard_data_entity.dart';

part 'dashboard_recent_activity_model.freezed.dart';
part 'dashboard_recent_activity_model.g.dart';

@freezed
abstract class DashboardRecentActivityModel with _$DashboardRecentActivityModel {
  const DashboardRecentActivityModel._();

  const factory DashboardRecentActivityModel({
    required String id,
    required String title,
    required String category,
    required double amount,
    required DateTime date,
    required String type,
    String? emoji,
  }) = _DashboardRecentActivityModel;

  factory DashboardRecentActivityModel.fromJson(Map<String, dynamic> json) =>
      _$DashboardRecentActivityModelFromJson(json);

  factory DashboardRecentActivityModel.fromEntity(DashboardRecentActivity entity) {
    return DashboardRecentActivityModel(
      id: entity.id,
      title: entity.title,
      category: entity.category,
      amount: entity.amount,
      date: entity.date,
      type: entity.type,
      emoji: entity.emoji,
    );
  }

  DashboardRecentActivity toEntity() {
    return DashboardRecentActivity(
      id: id,
      title: title,
      category: category,
      amount: amount,
      date: date,
      type: type,
      emoji: emoji,
    );
  }
}
