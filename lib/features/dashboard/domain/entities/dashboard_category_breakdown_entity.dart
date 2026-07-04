import 'package:freezed_annotation/freezed_annotation.dart';

part 'dashboard_category_breakdown_entity.freezed.dart';
part 'dashboard_category_breakdown_entity.g.dart';

@freezed
abstract class DashboardCategoryBreakdownEntity
    with _$DashboardCategoryBreakdownEntity {
  const factory DashboardCategoryBreakdownEntity({
    required String categoryName,
    required double amount,
    required double percentage,
    String? emoji,
  }) = _DashboardCategoryBreakdownEntity;

  factory DashboardCategoryBreakdownEntity.fromJson(
          Map<String, dynamic> json) =>
      _$DashboardCategoryBreakdownEntityFromJson(json);
}
