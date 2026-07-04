import 'package:freezed_annotation/freezed_annotation.dart';

part 'dashboard_data_entity.freezed.dart';
part 'dashboard_data_entity.g.dart';

@freezed
abstract class DashboardCategoryBreakdown with _$DashboardCategoryBreakdown {
  const factory DashboardCategoryBreakdown({
    required String categoryName,
    required double amount,
    required double percentage,
    String? emoji,
  }) = _DashboardCategoryBreakdown;

  factory DashboardCategoryBreakdown.fromJson(Map<String, dynamic> json) =>
      _$DashboardCategoryBreakdownFromJson(json);
}

@freezed
abstract class DashboardTrendPoint with _$DashboardTrendPoint {
  const factory DashboardTrendPoint({
    required DateTime date,
    required double income,
    required double expense,
    required double balance,
  }) = _DashboardTrendPoint;

  factory DashboardTrendPoint.fromJson(Map<String, dynamic> json) =>
      _$DashboardTrendPointFromJson(json);
}

@freezed
abstract class DashboardRecentActivity with _$DashboardRecentActivity {
  const factory DashboardRecentActivity({
    required String id,
    required String title,
    required String category,
    required double amount,
    required DateTime date,
    required String type, // 'income', 'expense', 'lending', 'investment'
    String? emoji,
  }) = _DashboardRecentActivity;

  factory DashboardRecentActivity.fromJson(Map<String, dynamic> json) =>
      _$DashboardRecentActivityFromJson(json);
}

@freezed
abstract class DashboardDataEntity with _$DashboardDataEntity {
  const factory DashboardDataEntity({
    required double totalIncome,
    required double totalExpense,
    required double netSavings,
    required double savingsRate,
    required double monthlyBudget,
    required double totalGivenDue,
    required double totalReceivedDue,
    required double totalInvested,
    required double totalInvestmentProfit,
    required List<DashboardCategoryBreakdown> expenseBreakdown,
    required List<DashboardCategoryBreakdown> incomeBreakdown,
    required List<DashboardTrendPoint> trends,
    required List<DashboardRecentActivity> recentActivities,
  }) = _DashboardDataEntity;

  factory DashboardDataEntity.fromJson(Map<String, dynamic> json) =>
      _$DashboardDataEntityFromJson(json);
}
