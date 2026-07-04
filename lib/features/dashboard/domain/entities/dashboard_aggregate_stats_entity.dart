import 'package:freezed_annotation/freezed_annotation.dart';

part 'dashboard_aggregate_stats_entity.freezed.dart';
part 'dashboard_aggregate_stats_entity.g.dart';

@freezed
abstract class DashboardAggregateStatsEntity
    with _$DashboardAggregateStatsEntity {
  const factory DashboardAggregateStatsEntity({
    required double totalIncome,
    required double totalExpense,
    required double netSavings,
    required double savingsRate,
    required double monthlyBudget,
    required double totalGivenDue,
    required double totalReceivedDue,
    required double totalInvested,
    required double totalInvestmentProfit,
  }) = _DashboardAggregateStatsEntity;

  factory DashboardAggregateStatsEntity.fromJson(Map<String, dynamic> json) =>
      _$DashboardAggregateStatsEntityFromJson(json);
}
