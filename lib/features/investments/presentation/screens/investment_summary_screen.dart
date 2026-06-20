import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:finkeep/core/extensions/double_ext.dart';
import 'package:finkeep/core/responsive/responsive.dart';
import 'package:finkeep/core/styles/app_colors.dart';
import 'package:finkeep/features/investments/domain/enums/investment_status.dart';

import '../controller/investment_controller.dart';

class InvestmentSummaryScreen extends StatelessWidget {
  final InvestmentController controller;

  const InvestmentSummaryScreen({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Obx(() {
      if (controller.investments.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.pie_chart_outline_rounded,
                size: 64.sp,
                color: isDark ? Colors.white10 : Colors.black12,
              ),
              SizedBox(height: 16.h),
              Text(
                'No investments to summarize',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white38 : const Color(0xFF64748B),
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                'Add an investment to view the dashboard summary.',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontFamily: 'Manrope',
                  color: isDark ? Colors.white24 : const Color(0xFF94A3B8),
                ),
              ),
            ],
          ),
        );
      }

      final totalInvested = controller.totalMoneyInvested;
      final totalReceived = controller.totalMoneyReceived;
      final totalCount = controller.totalInvestmentsCount;

      return SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Status Chart at the Top with Total Count in center
            _buildChartSection(context, isDark, totalCount),
            SizedBox(height: 20.h),

            // Section 1: Overall Summary (All-Time)
            _buildSectionHeader(isDark, 'OVERALL SUMMARY (ALL-TIME)'),
            SizedBox(height: 8.h),
            _buildOverallSummaryCard(
              isDark: isDark,
              totalInvested: totalInvested,
              totalReceived: totalReceived,
              totalProfit: controller.totalCompletedProfit,
              totalLoss: controller.totalCompletedLoss,
            ),
            SizedBox(height: 20.h),

            // Section 2: Active Investments Summary (Ongoing)
            _buildSectionHeader(isDark, 'ACTIVE INVESTMENTS SUMMARY'),
            SizedBox(height: 8.h),
            _buildActiveSummaryCard(
              isDark: isDark,
              activeInvested: controller.activeMoneyInvested,
              expectedROI: controller.totalExpectedROI,
              activeReceived: controller.activeMoneyReceived,
              capitalAtRisk: controller.capitalAtRisk,
            ),
            SizedBox(height: 100.h),
          ],
        ),
      );
    });
  }

  // --------------------------------------------------
  // Helper: Section Header Text
  // --------------------------------------------------
  Widget _buildSectionHeader(bool isDark, String title) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 10.sp,
          fontFamily: 'Manrope',
          fontWeight: FontWeight.bold,
          color: isDark ? Colors.white38 : const Color(0xFF94A3B8),
          letterSpacing: 1.1,
        ),
      ),
    );
  }

  // --------------------------------------------------
  // Helper: Overall Summary Card (All-Time)
  // --------------------------------------------------
  Widget _buildOverallSummaryCard({
    required bool isDark,
    required double totalInvested,
    required double totalReceived,
    required double totalProfit,
    required double totalLoss,
  }) {
    final titleColor = isDark ? Colors.white70 : const Color(0xFF0F172A);

    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10.r,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildFinancialItem(
                  label: "TOTAL INVESTED",
                  value: totalInvested,
                  isDark: isDark,
                  valueColor: titleColor,
                  isBig: true,
                ),
              ),
              Expanded(
                child: _buildFinancialItem(
                  label: "TOTAL RECEIVED",
                  value: totalReceived,
                  isDark: isDark,
                  valueColor: isDark ? Colors.green.shade300 : Colors.green.shade700,
                  isBig: true,
                ),
              ),
            ],
          ),
          Divider(height: 32.h, color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
          Row(
            children: [
              Expanded(
                child: _buildFinancialItem(
                  label: "TOTAL PROFIT",
                  value: totalProfit,
                  isDark: isDark,
                  valueColor: Colors.green.shade600,
                ),
              ),
              Expanded(
                child: _buildFinancialItem(
                  label: "TOTAL LOSS",
                  value: totalLoss,
                  isDark: isDark,
                  valueColor: Colors.red.shade600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------
  // Helper: Active Summary Card (Ongoing)
  // --------------------------------------------------
  Widget _buildActiveSummaryCard({
    required bool isDark,
    required double activeInvested,
    required double expectedROI,
    required double activeReceived,
    required double capitalAtRisk,
  }) {
    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10.r,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildFinancialItem(
                  label: "ACTIVE INVESTED",
                  value: activeInvested,
                  isDark: isDark,
                  valueColor: isDark ? Colors.blue.shade300 : Colors.blue.shade700,
                ),
              ),
              Expanded(
                child: _buildFinancialItem(
                  label: "EXPECTED ROI",
                  value: expectedROI,
                  isDark: isDark,
                  valueColor: isDark ? Colors.purple.shade300 : Colors.purple.shade700,
                ),
              ),
            ],
          ),
          Divider(height: 32.h, color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
          Row(
            children: [
              Expanded(
                child: _buildFinancialItem(
                  label: "RECEIVED (ACTIVE)",
                  value: activeReceived,
                  isDark: isDark,
                  valueColor: isDark ? Colors.green.shade300 : Colors.green.shade700,
                ),
              ),
              Expanded(
                child: _buildFinancialItem(
                  label: "OUTSTANDING CAPITAL",
                  value: capitalAtRisk,
                  isDark: isDark,
                  valueColor: isDark ? Colors.orange.shade300 : Colors.orange.shade700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------
  // Helper: Financial Item Unit
  // --------------------------------------------------
  Widget _buildFinancialItem({
    required String label,
    required double value,
    required bool isDark,
    Color? valueColor,
    String prefix = "",
    bool isBig = false,
  }) {
    final labelColor = isDark ? Colors.white38 : const Color(0xFF64748B);
    final valColor = valueColor ?? (isDark ? Colors.white : const Color(0xFF1E293B));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 9.sp,
            fontFamily: 'Manrope',
            fontWeight: FontWeight.bold,
            color: labelColor,
            letterSpacing: 0.8,
          ),
        ),
        SizedBox(height: 6.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '$prefix${value.toCurrency()}',
              style: TextStyle(
                fontSize: isBig ? 18.sp : 14.sp,
                fontFamily: 'Manrope',
                fontWeight: FontWeight.bold,
                color: valColor,
              ),
            ),
            SizedBox(width: 3.w),
            Padding(
              padding: EdgeInsets.only(bottom: isBig ? 3.h : 2.h),
              child: FaIcon(
                FontAwesomeIcons.bangladeshiTakaSign,
                size: isBig ? 12.sp : 10.sp,
                color: valColor,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // --------------------------------------------------
  // Helper: Chart Section (Pie Chart) at top
  // --------------------------------------------------
  Widget _buildChartSection(BuildContext context, bool isDark, int totalCount) {
    // Count status distribution
    final Map<InvestmentStatus, int> counts = {};
    for (final status in InvestmentStatus.values) {
      counts[status] = 0;
    }
    for (final investment in controller.investments) {
      counts[investment.status] = (counts[investment.status] ?? 0) + 1;
    }

    final total = controller.investments.length;

    return Container(
      padding: EdgeInsets.all(18.r),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'STATUS DISTRIBUTION',
            style: TextStyle(
              fontSize: 10.sp,
              fontFamily: 'Manrope',
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white38 : const Color(0xFF94A3B8),
              letterSpacing: 1.2,
            ),
          ),
          SizedBox(height: 20.h),
          Row(
            children: [
              // Pie Chart with Total Count in center
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 130.w,
                    height: 130.w,
                    child: PieChart(
                      PieChartData(
                        sectionsSpace: 2,
                        centerSpaceRadius: 45.r,
                        sections: InvestmentStatus.values.map((status) {
                          final count = counts[status] ?? 0;
                          final percentage = total == 0 ? 0.0 : (count / total) * 100;
                          return PieChartSectionData(
                            color: status.color,
                            value: count.toDouble(),
                            title: count > 0 ? '${percentage.toStringAsFixed(0)}%' : '',
                            radius: 18.r,
                            titleStyle: TextStyle(
                              fontSize: 9.sp,
                              fontFamily: 'Manrope',
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '$totalCount',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontFamily: 'Manrope',
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                        ),
                      ),
                      Text(
                        'Total',
                        style: TextStyle(
                          fontSize: 9.sp,
                          fontFamily: 'Manrope',
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white30 : const Color(0xFF94A3B8),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(width: 24.w),

              // Legend
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 4.h,
                  children: InvestmentStatus.values.map((status) {
                    final count = counts[status] ?? 0;
                    return Row(
                      children: [
                        Container(
                          width: 8.r,
                          height: 8.r,
                          decoration: BoxDecoration(
                            color: status.color,
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            status.label,
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontFamily: 'Manrope',
                              color: isDark ? Colors.white70 : const Color(0xFF334155),
                            ),
                          ),
                        ),
                        Text(
                          '$count',
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontFamily: 'Manrope',
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white54 : const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
