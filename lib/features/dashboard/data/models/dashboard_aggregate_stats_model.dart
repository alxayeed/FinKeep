import 'package:freezed_annotation/freezed_annotation.dart';

part 'dashboard_aggregate_stats_model.freezed.dart';
part 'dashboard_aggregate_stats_model.g.dart';

@freezed
abstract class DashboardAggregateStatsModel with _$DashboardAggregateStatsModel {
  const DashboardAggregateStatsModel._();

  const factory DashboardAggregateStatsModel({
    required double totalIncome,
    required double totalExpense,
    required double netSavings,
    required double savingsRate,
    required double monthlyBudget,
    required double totalGivenDue,
    required double totalReceivedDue,
    required double totalInvested,
    required double totalInvestmentProfit,
  }) = _DashboardAggregateStatsModel;

  factory DashboardAggregateStatsModel.fromJson(Map<String, dynamic> json) =>
      _$DashboardAggregateStatsModelFromJson(json);
}
