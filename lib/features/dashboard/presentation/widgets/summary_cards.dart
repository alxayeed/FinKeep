import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:finkeep/core/routes/app_router.dart';
import 'package:finkeep/core/extensions/double_ext.dart';
import 'package:finkeep/core/styles/currency_provider.dart';
import 'package:finkeep/core/config/app_config.dart';
import '../../../../core/styles/app_colors.dart';
import '../../domain/entities/dashboard_aggregate_stats_entity.dart';

class SummaryCards extends StatelessWidget {
  final DashboardAggregateStatsEntity data;
  final bool showOnlyLendingAndInvesting;

  const SummaryCards({
    super.key,
    required this.data,
    this.showOnlyLendingAndInvesting = false,
  });

  @override
  Widget build(BuildContext context) {
    final symbol = context.currency.symbol;

    if (showOnlyLendingAndInvesting) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          children: [
            Expanded(
              child: _buildMiniCard(
                context,
                title: 'Net Lendings',
                value: '${(data.totalGivenDue - data.totalReceivedDue).toCurrency()} $symbol',
                icon: FontAwesomeIcons.handshake,
                color: Colors.orange,
                onTap: () => context.goNamed(AppRoutes.lendings),
              ),
            ),
            if (AppConfig.isPersonal) ...[
              const SizedBox(width: 12),
              Expanded(
                child: _buildMiniCard(
                  context,
                  title: 'Investments',
                  value: '${(data.totalInvested + data.totalInvestmentProfit).toCurrency()} $symbol',
                  icon: FontAwesomeIcons.chartLine,
                  color: Colors.teal,
                  onTap: () => context.goNamed(AppRoutes.investments),
                ),
              ),
            ],
          ],
        ),
      );
    }

    // Full Original Implementation
    final double netWorth = data.totalIncome -
        data.totalExpense +
        data.totalInvested +
        data.totalInvestmentProfit +
        (data.totalGivenDue - data.totalReceivedDue);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          // Net Worth Card (Gradient Hero Card)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF047857), // emerald-700
                  Color(0xFF059669), // emerald-600
                  Color(0xFF10B981), // emerald-500
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryTeal.withValues(alpha: 0.3),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'ESTIMATED NET WORTH',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.info_outline,
                        color: Colors.white70,
                        size: 18,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () => _showNetWorthInfo(context),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '${netWorth.toCurrency()} $symbol',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'TOTAL INCOME',
                          style: TextStyle(color: Colors.white60, fontSize: 10),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '+${data.totalIncome.toCurrency()} $symbol',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'TOTAL EXPENSE',
                          style: TextStyle(color: Colors.white60, fontSize: 10),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '-${data.totalExpense.toCurrency()} $symbol',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Mini statistics Grid
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.6,
            children: [
              _buildMiniCard(
                context,
                title: 'Savings Rate',
                value: '${data.savingsRate.toStringAsFixed(1)}%',
                icon: FontAwesomeIcons.percent,
                color: Colors.blue,
              ),
              _buildMiniCard(
                context,
                title: 'Monthly Savings',
                value: '${data.netSavings.toCurrency()} $symbol',
                icon: FontAwesomeIcons.solidBookmark,
                color: Colors.purple,
              ),
              _buildMiniCard(
                context,
                title: 'Net Lendings',
                value: '${(data.totalGivenDue - data.totalReceivedDue).toCurrency()} $symbol',
                icon: FontAwesomeIcons.handshake,
                color: Colors.orange,
                onTap: () => context.goNamed(AppRoutes.lendings),
              ),
              if (AppConfig.isPersonal)
                _buildMiniCard(
                  context,
                  title: 'Investments',
                  value: '${(data.totalInvested + data.totalInvestmentProfit).toCurrency()} $symbol',
                  icon: FontAwesomeIcons.chartLine,
                  color: Colors.teal,
                  onTap: () => context.goNamed(AppRoutes.investments),
                ),
            ],
          ),
        ],
      ),
    );
  }

  void _showNetWorthInfo(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppColors.cardDark : AppColors.cardLight,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Financial Summary Info',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildInfoItem(
                  'Estimated Net Worth',
                  'Calculated as: Income - Expense + Active Investments + Net Lendings. It represents a unified estimate of your current financial value.',
                  isDark,
                ),
                const SizedBox(height: 12),
                _buildInfoItem(
                  'Savings Rate',
                  'Percentage of income saved: (Income - Expense) / Income. A rate above 20% is generally a great healthy target.',
                  isDark,
                ),
                const SizedBox(height: 12),
                _buildInfoItem(
                  'Net Lendings',
                  'Outstanding loans: Given (Due to you) - Taken (Due from you). Represents net cash owed to you.',
                  isDark,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoItem(String title, String description, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryTeal,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          description,
          style: TextStyle(
            fontSize: 13,
            color: isDark ? Colors.white70 : Colors.black54,
          ),
        ),
      ],
    );
  }

  Widget _buildMiniCard(
    BuildContext context, {
    required String title,
    required String value,
    required FaIconData icon,
    required Color color,
    VoidCallback? onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    Widget card = Ink(
      padding: const EdgeInsets.all(12),
      height: 98,
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: isDark ? Colors.white70 : Colors.black54,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              FaIcon(icon, color: color.withValues(alpha: 0.8), size: 14),
            ],
          ),
          Text(
            value,
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black.withValues(alpha: 0.8),
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );

    if (onTap != null) {
      card = InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: card,
      );
    }

    return Material(
      color: Colors.transparent,
      child: card,
    );
  }
}

class SummaryCardsShimmer extends StatelessWidget {
  final bool showOnlyLendingAndInvesting;

  const SummaryCardsShimmer({
    super.key,
    this.showOnlyLendingAndInvesting = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0);
    final highlightColor = isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9);
    final itemBg = isDark ? AppColors.cardDark : AppColors.cardLight;

    if (showOnlyLendingAndInvesting) {
      return Shimmer.fromColors(
        baseColor: baseColor,
        highlightColor: highlightColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 98,
                  decoration: BoxDecoration(
                    color: itemBg,
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  height: 98,
                  decoration: BoxDecoration(
                    color: itemBg,
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            // Large Hero Card Skeleton
            Container(
              width: double.infinity,
              height: 170,
              decoration: BoxDecoration(
                color: itemBg,
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            const SizedBox(height: 16),
            // Grid of 4 Mini Cards Skeletons
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.6,
              children: List.generate(4, (index) {
                return Container(
                  decoration: BoxDecoration(
                    color: itemBg,
                    borderRadius: BorderRadius.circular(16),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
