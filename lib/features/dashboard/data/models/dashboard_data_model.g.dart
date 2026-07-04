// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DashboardDataModel _$DashboardDataModelFromJson(Map<String, dynamic> json) =>
    _DashboardDataModel(
      totalIncome: (json['totalIncome'] as num).toDouble(),
      totalExpense: (json['totalExpense'] as num).toDouble(),
      netSavings: (json['netSavings'] as num).toDouble(),
      savingsRate: (json['savingsRate'] as num).toDouble(),
      monthlyBudget: (json['monthlyBudget'] as num).toDouble(),
      totalGivenDue: (json['totalGivenDue'] as num).toDouble(),
      totalReceivedDue: (json['totalReceivedDue'] as num).toDouble(),
      totalInvested: (json['totalInvested'] as num).toDouble(),
      totalInvestmentProfit: (json['totalInvestmentProfit'] as num).toDouble(),
      expenseBreakdown: (json['expenseBreakdown'] as List<dynamic>)
          .map(
            (e) =>
                DashboardCategoryBreakdown.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      incomeBreakdown: (json['incomeBreakdown'] as List<dynamic>)
          .map(
            (e) =>
                DashboardCategoryBreakdown.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      trends: (json['trends'] as List<dynamic>)
          .map((e) => DashboardTrendPoint.fromJson(e as Map<String, dynamic>))
          .toList(),
      recentActivities: (json['recentActivities'] as List<dynamic>)
          .map(
            (e) => DashboardRecentActivity.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
    );

Map<String, dynamic> _$DashboardDataModelToJson(_DashboardDataModel instance) =>
    <String, dynamic>{
      'totalIncome': instance.totalIncome,
      'totalExpense': instance.totalExpense,
      'netSavings': instance.netSavings,
      'savingsRate': instance.savingsRate,
      'monthlyBudget': instance.monthlyBudget,
      'totalGivenDue': instance.totalGivenDue,
      'totalReceivedDue': instance.totalReceivedDue,
      'totalInvested': instance.totalInvested,
      'totalInvestmentProfit': instance.totalInvestmentProfit,
      'expenseBreakdown': instance.expenseBreakdown,
      'incomeBreakdown': instance.incomeBreakdown,
      'trends': instance.trends,
      'recentActivities': instance.recentActivities,
    };
