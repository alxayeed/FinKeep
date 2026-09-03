import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/common/widgets/custom_app_bar.dart';
import '../../../../core/common/widgets/custom_fab.dart';
import '../../../../core/common/widgets/quick_add_modal_sheet.dart';
import '../../../../core/responsive/responsive.dart';
import '../../../../core/routes/app_router.dart';
import '../../../../core/styles/app_colors.dart';
import '../controllers/dashboard_controller.dart';
import '../widgets/cash_flow_line_chart.dart';
import '../widgets/expense_doughnut_chart.dart';
import '../widgets/income_doughnut_chart.dart';
// import '../widgets/recent_activity_list.dart';
import '../../domain/entities/dashboard_timeframe.dart';
import '../widgets/summary_cards.dart';
import '../widgets/timeframe_selector.dart';
import '../widgets/monthly_standing_chart.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final DashboardController controller = Get.find();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Dashboard',
        centerTitle: false,
        titleSpacing: 16.w,
        actions: [
          IconButton(
            icon: const Icon(Icons.analytics_outlined),
            tooltip: 'Reports & Analytics',
            onPressed: () => context.pushNamed(AppRoutes.expenseReport),
          ),
          IconButton(
            icon: const Icon(Icons.settings_rounded),
            tooltip: 'Settings',
            onPressed: () => context.pushNamed(AppRoutes.settings),
          ),
        ],
      ),
      floatingActionButton: CustomFAB(
        onPressed: () => showQuickAddModalSheet(context),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          controller.fetchAllDashboardData();
          controller.fetchMonthlyStanding();
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
                  // 0. Standing Chart Overview
                  Obx(() {
                    if (controller.monthlyStandingLoading.value) {
                      return const MonthlyStandingChartShimmer();
                    }
                    if (controller.monthlyStandingError.isNotEmpty) {
                      return _buildErrorTile(
                        context,
                        title: 'Current Standing',
                        error: controller.monthlyStandingError.value,
                        onRetry: () => controller.fetchMonthlyStanding(),
                      );
                    }
                    final data = controller.monthlyStanding.value;
                    if (data == null) {
                      return const SizedBox.shrink();
                    }
                    final isCurrentMonth = controller.timeframe.value == DashboardTimeframe.currentMonth;
                    return MonthlyStandingChart(
                      data: data,
                      showMonthSwitcher: isCurrentMonth,
                      onPrevious: () => controller.prevMonthStanding(),
                      onNext: () => controller.nextMonthStanding(),
                    );
                  }),
                  const SizedBox(height: 12),

                  // 1. Expense & Income Doughnut Charts Side-by-Side (Right below Monthly Standing)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Obx(() {
                            if (controller.expenseBreakdownLoading.value) {
                              return const ExpenseDoughnutChartShimmer();
                            }
                            if (controller.expenseBreakdownError.isNotEmpty) {
                              return const SizedBox();
                            }
                            final breakdown = controller.expenseBreakdown;
                            final totalExpense = controller.stats.value?.totalExpense ?? 0.0;
                            return ExpenseDoughnutChart(
                              breakdown: breakdown,
                              totalExpense: totalExpense,
                            );
                          }),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Obx(() {
                            if (controller.incomeBreakdownLoading.value) {
                              return const IncomeDoughnutChartShimmer();
                            }
                            if (controller.incomeBreakdownError.isNotEmpty) {
                              return const SizedBox();
                            }
                            final breakdown = controller.incomeBreakdown;
                            final totalIncome = controller.stats.value?.totalIncome ?? 0.0;
                            return IncomeDoughnutChart(
                              breakdown: breakdown,
                              totalIncome: totalIncome,
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // 2. Feature Cards (Net Lendings, Investments, Savings)
                  Obx(() {
                    if (controller.statsLoading.value) {
                      return const SummaryCardsShimmer(showOnlyLendingAndInvesting: true);
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
                        height: 98,
                        child: Center(child: Text('No overview stats loaded')),
                      );
                    }
                    return SummaryCards(
                      data: data,
                      showOnlyLendingAndInvesting: true,
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

                  // 5. Recent Activity Feed (Hidden for now)
                  /*
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
                  */
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportsBannerCard(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => context.pushNamed(AppRoutes.expenseReport),
          borderRadius: BorderRadius.circular(16.r),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [
                        AppColors.primaryTeal.withValues(alpha: 0.15),
                        const Color(0xFF131D2E),
                      ]
                    : [
                        AppColors.primaryTeal.withValues(alpha: 0.1),
                        Colors.white,
                      ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: isDark
                    ? AppColors.primaryTeal.withValues(alpha: 0.35)
                    : AppColors.primaryTeal.withValues(alpha: 0.25),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 8.r,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 36.r,
                  height: 36.r,
                  decoration: BoxDecoration(
                    color: AppColors.primaryTeal.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.analytics_rounded,
                    size: 20.sp,
                    color: AppColors.primaryTeal,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Expense Reports & Analytics',
                        style: TextStyle(
                          fontFamily: 'Manrope',
                          fontSize: 13.sp,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'Custom ranges, summaries & PDF exports',
                        style: TextStyle(
                          fontFamily: 'Manrope',
                          fontSize: 10.5.sp,
                          color: isDark ? Colors.white60 : const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14.sp,
                  color: AppColors.primaryTeal,
                ),
              ],
            ),
          ),
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
