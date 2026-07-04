import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/styles/app_colors.dart';
import '../controllers/dashboard_controller.dart';
import '../widgets/cash_flow_line_chart.dart';
import '../widgets/expense_doughnut_chart.dart';
import '../widgets/income_expense_bar_chart.dart';
import '../widgets/recent_activity_list.dart';
import '../widgets/summary_cards.dart';
import '../widgets/timeframe_selector.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final DashboardController controller = Get.find();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Dashboard',
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          controller.fetchAllDashboardData();
        },
        color: AppColors.primaryTeal,
        child: Column(
          children: [
            const TimeframeSelector(),
            Expanded(
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 24),
                children: [
                  // 1. Stats and Overview Hero Card
                  Obx(() {
                    if (controller.statsLoading.value) {
                      return const SummaryCardsShimmer();
                    }
                    if (controller.statsError.isNotEmpty) {
                      return _buildErrorTile(
                        context,
                        title: 'Summary Stats',
                        error: controller.statsError.value,
                        onRetry: () => controller.fetchAllDashboardData(),
                      );
                    }
                    final data = controller.stats.value;
                    if (data == null) {
                      return const SizedBox(
                        height: 220,
                        child: Center(child: Text('No overview stats loaded')),
                      );
                    }
                    return SummaryCards(data: data);
                  }),
                  const SizedBox(height: 12),

                  // 2. Inflow vs Outflow Bar Chart
                  Obx(() {
                    if (controller.statsLoading.value) {
                      return const IncomeExpenseBarChartShimmer();
                    }
                    if (controller.statsError.isNotEmpty) {
                      return const SizedBox();
                    }
                    final data = controller.stats.value;
                    if (data == null) return const SizedBox();
                    return IncomeExpenseBarChart(data: data);
                  }),

                  // 3. Expense Allocation Doughnut Chart
                  Obx(() {
                    if (controller.expenseBreakdownLoading.value) {
                      return const ExpenseDoughnutChartShimmer();
                    }
                    if (controller.expenseBreakdownError.isNotEmpty) {
                      return _buildErrorTile(
                        context,
                        title: 'Expense Allocation',
                        error: controller.expenseBreakdownError.value,
                        onRetry: () => controller.fetchAllDashboardData(),
                      );
                    }
                    final breakdown = controller.expenseBreakdown;
                    final totalExpense = controller.stats.value?.totalExpense ?? 0.0;
                    return ExpenseDoughnutChart(
                      breakdown: breakdown,
                      totalExpense: totalExpense,
                    );
                  }),
                  const SizedBox(height: 12),

                  // 4. Cumulative Trend Line Chart
                  Obx(() {
                    if (controller.trendsLoading.value) {
                      return const CashFlowLineChartShimmer();
                    }
                    if (controller.trendsError.isNotEmpty) {
                      return _buildErrorTile(
                        context,
                        title: 'Balance Trend',
                        error: controller.trendsError.value,
                        onRetry: () => controller.fetchAllDashboardData(),
                      );
                    }
                    final trends = controller.trends;
                    return CashFlowLineChart(trends: trends);
                  }),
                  const SizedBox(height: 12),

                  // 5. Recent Activity Feed
                  Obx(() {
                    if (controller.recentActivitiesLoading.value) {
                      return const RecentActivityListShimmer();
                    }
                    if (controller.recentActivitiesError.isNotEmpty) {
                      return _buildErrorTile(
                        context,
                        title: 'Recent Activities',
                        error: controller.recentActivitiesError.value,
                        onRetry: () => controller.fetchAllDashboardData(),
                      );
                    }
                    final activities = controller.recentActivities;
                    return RecentActivityList(activities: activities);
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorTile(
    BuildContext context, {
    required String title,
    required String error,
    required VoidCallback onRetry,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                title.toUpperCase(),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.grey,
                  letterSpacing: 1.1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            error,
            style: const TextStyle(color: Colors.red, fontSize: 13),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh, size: 16, color: AppColors.primaryTeal),
            label: const Text(
              'Retry',
              style: TextStyle(color: AppColors.primaryTeal, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
