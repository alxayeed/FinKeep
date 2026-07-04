import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/dashboard_aggregate_stats_entity.dart';

part 'dashboard_aggregate_stats_model.freezed.dart';
part 'dashboard_aggregate_stats_model.g.dart';

@freezed
abstract class DashboardAggregateStatsModel
    with _$DashboardAggregateStatsModel {
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

  DashboardAggregateStatsEntity toEntity() {
    return DashboardAggregateStatsEntity(
      totalIncome: totalIncome,
      totalExpense: totalExpense,
      netSavings: netSavings,
      savingsRate: savingsRate,
      monthlyBudget: monthlyBudget,
      totalGivenDue: totalGivenDue,
      totalReceivedDue: totalReceivedDue,
      totalInvested: totalInvested,
      totalInvestmentProfit: totalInvestmentProfit,
    );
  }
}
