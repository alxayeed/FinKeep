// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_data_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DashboardCategoryBreakdown _$DashboardCategoryBreakdownFromJson(
  Map<String, dynamic> json,
) => _DashboardCategoryBreakdown(
  categoryName: json['categoryName'] as String,
  amount: (json['amount'] as num).toDouble(),
  percentage: (json['percentage'] as num).toDouble(),
  emoji: json['emoji'] as String?,
);

Map<String, dynamic> _$DashboardCategoryBreakdownToJson(
  _DashboardCategoryBreakdown instance,
) => <String, dynamic>{
  'categoryName': instance.categoryName,
  'amount': instance.amount,
  'percentage': instance.percentage,
  'emoji': instance.emoji,
};

_DashboardTrendPoint _$DashboardTrendPointFromJson(Map<String, dynamic> json) =>
    _DashboardTrendPoint(
      date: DateTime.parse(json['date'] as String),
      income: (json['income'] as num).toDouble(),
      expense: (json['expense'] as num).toDouble(),
      balance: (json['balance'] as num).toDouble(),
    );

Map<String, dynamic> _$DashboardTrendPointToJson(
  _DashboardTrendPoint instance,
) => <String, dynamic>{
  'date': instance.date.toIso8601String(),
  'income': instance.income,
  'expense': instance.expense,
  'balance': instance.balance,
};

_DashboardRecentActivity _$DashboardRecentActivityFromJson(
  Map<String, dynamic> json,
) => _DashboardRecentActivity(
  id: json['id'] as String,
  title: json['title'] as String,
  category: json['category'] as String,
  amount: (json['amount'] as num).toDouble(),
  date: DateTime.parse(json['date'] as String),
  type: json['type'] as String,
  emoji: json['emoji'] as String?,
);

Map<String, dynamic> _$DashboardRecentActivityToJson(
  _DashboardRecentActivity instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'category': instance.category,
  'amount': instance.amount,
  'date': instance.date.toIso8601String(),
  'type': instance.type,
  'emoji': instance.emoji,
};

_DashboardDataEntity _$DashboardDataEntityFromJson(Map<String, dynamic> json) =>
    _DashboardDataEntity(
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

Map<String, dynamic> _$DashboardDataEntityToJson(
  _DashboardDataEntity instance,
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
  'expenseBreakdown': instance.expenseBreakdown,
  'incomeBreakdown': instance.incomeBreakdown,
  'trends': instance.trends,
  'recentActivities': instance.recentActivities,
};
