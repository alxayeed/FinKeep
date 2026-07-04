import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/dashboard_data_entity.dart';

part 'dashboard_data_model.freezed.dart';
part 'dashboard_data_model.g.dart';

@freezed
abstract class DashboardDataModel with _$DashboardDataModel {
  const DashboardDataModel._();

  const factory DashboardDataModel({
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
  }) = _DashboardDataModel;

  factory DashboardDataModel.fromJson(Map<String, dynamic> json) =>
      _$DashboardDataModelFromJson(json);

  factory DashboardDataModel.fromEntity(DashboardDataEntity entity) {
    return DashboardDataModel(
      totalIncome: entity.totalIncome,
      totalExpense: entity.totalExpense,
      netSavings: entity.netSavings,
      savingsRate: entity.savingsRate,
      monthlyBudget: entity.monthlyBudget,
      totalGivenDue: entity.totalGivenDue,
      totalReceivedDue: entity.totalReceivedDue,
      totalInvested: entity.totalInvested,
      totalInvestmentProfit: entity.totalInvestmentProfit,
      expenseBreakdown: entity.expenseBreakdown,
      incomeBreakdown: entity.incomeBreakdown,
      trends: entity.trends,
      recentActivities: entity.recentActivities,
    );
  }

  DashboardDataEntity toEntity() {
    return DashboardDataEntity(
      totalIncome: totalIncome,
      totalExpense: totalExpense,
      netSavings: netSavings,
      savingsRate: savingsRate,
      monthlyBudget: monthlyBudget,
      totalGivenDue: totalGivenDue,
      totalReceivedDue: totalReceivedDue,
      totalInvested: totalInvested,
      totalInvestmentProfit: totalInvestmentProfit,
      expenseBreakdown: expenseBreakdown,
      incomeBreakdown: incomeBreakdown,
      trends: trends,
      recentActivities: recentActivities,
    );
  }
}
