import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/dashboard_category_breakdown_entity.dart';

part 'dashboard_category_breakdown_model.freezed.dart';
part 'dashboard_category_breakdown_model.g.dart';

@freezed
abstract class DashboardCategoryBreakdownModel
    with _$DashboardCategoryBreakdownModel {
  const DashboardCategoryBreakdownModel._();

  const factory DashboardCategoryBreakdownModel({
    required String categoryName,
    required double amount,
    required double percentage,
    String? emoji,
  }) = _DashboardCategoryBreakdownModel;

  factory DashboardCategoryBreakdownModel.fromJson(
          Map<String, dynamic> json) =>
      _$DashboardCategoryBreakdownModelFromJson(json);

  DashboardCategoryBreakdownEntity toEntity() {
    return DashboardCategoryBreakdownEntity(
      categoryName: categoryName,
      amount: amount,
      percentage: percentage,
      emoji: emoji,
    );
  }
}
