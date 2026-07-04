// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_aggregate_stats_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DashboardAggregateStatsModel _$DashboardAggregateStatsModelFromJson(
  Map<String, dynamic> json,
) => _DashboardAggregateStatsModel(
  totalIncome: (json['totalIncome'] as num).toDouble(),
  totalExpense: (json['totalExpense'] as num).toDouble(),
  netSavings: (json['netSavings'] as num).toDouble(),
  savingsRate: (json['savingsRate'] as num).toDouble(),
  monthlyBudget: (json['monthlyBudget'] as num).toDouble(),
  totalGivenDue: (json['totalGivenDue'] as num).toDouble(),
  totalReceivedDue: (json['totalReceivedDue'] as num).toDouble(),
  totalInvested: (json['totalInvested'] as num).toDouble(),
  totalInvestmentProfit: (json['totalInvestmentProfit'] as num).toDouble(),
);

Map<String, dynamic> _$DashboardAggregateStatsModelToJson(
  _DashboardAggregateStatsModel instance,
) => <String, dynamic>{
  'totalIncome': instance.totalIncome,
  'totalExpense': instance.totalExpense,
  'netSavings': instance.netSavings,
  'savingsRate': instance.savingsRate,
  'monthlyBudget': instance.monthlyBudget,
  'totalGivenDue': instance.totalGivenDue,
  'totalReceivedDue': instance.totalReceivedDue,
  'totalInvested': instance.totalInvested,
  'totalInvestmentProfit': instance.totalInvestmentProfit,
};
