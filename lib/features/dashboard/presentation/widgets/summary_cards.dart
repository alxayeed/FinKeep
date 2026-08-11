import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:finkeep/core/routes/app_router.dart';
import 'package:finkeep/core/styles/currency_provider.dart';
import 'package:finkeep/core/config/app_config.dart';
import '../../../../core/common/widgets/privacy_text.dart';
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
        child: Column(
          children: [
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.6,
              children: [
                _buildLendingCard(
                  context,
                  title: 'Lendings',
                  given: data.totalGivenDue,
                  taken: data.totalReceivedDue,
                  symbol: symbol,
                  icon: FontAwesomeIcons.handshake,
                  color: Colors.orange,
                  onTap: () => context.go(AppRoutes.lendings),
                ),
                if (AppConfig.isPersonal)
                  _buildMiniCard(
                    context,
                    title: 'Investments',
                    amount: data.totalInvested + data.totalInvestmentProfit,
                    suffix: ' $symbol',
                    icon: FontAwesomeIcons.chartLine,
                    color: Colors.teal,
                    onTap: () => context.go(AppRoutes.investments),
                  ),
                _buildMiniCard(
                  context,
                  title: 'Savings',
                  value: 'Goal Tracker',
                  badgeText: 'SOON',
                  icon: FontAwesomeIcons.piggyBank,
                  color: Colors.purple,
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Savings & Goal Tracker feature coming soon!'),
                        backgroundColor: Colors.purple,
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                ),
              ],
            ),
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
                  ],
                ),
                const SizedBox(height: 8),
                PrivacyText(
                  netWorth,
                  suffix: ' $symbol',
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
                        PrivacyText(
                          data.totalIncome,
                          prefix: '+',
                          suffix: ' $symbol',
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
                        PrivacyText(
                          data.totalExpense,
                          prefix: '-',
                          suffix: ' $symbol',
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
                amount: data.netSavings,
                suffix: ' $symbol',
                icon: FontAwesomeIcons.solidBookmark,
                color: Colors.purple,
              ),
              _buildLendingCard(
                context,
                title: 'Lendings',
                given: data.totalGivenDue,
                taken: data.totalReceivedDue,
                symbol: symbol,
                icon: FontAwesomeIcons.handshake,
                color: Colors.orange,
                onTap: () => context.goNamed(AppRoutes.lendings),
              ),
              if (AppConfig.isPersonal)
                _buildMiniCard(
                  context,
                  title: 'Investments',
                  amount: data.totalInvested + data.totalInvestmentProfit,
                  suffix: ' $symbol',
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



Widget _buildMiniCard(
    BuildContext context, {
    required String title,
    String? value,
    double? amount,
    String? suffix,
    FaIconData? icon,
    String? symbolIcon,
    required Color color,
    String? badgeText,
    VoidCallback? onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Widget card = Ink(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
                  fontWeight: FontWeight.w600,
                ),
              ),
              Row(
                children: [
                  if (symbolIcon != null)
                    Text(
                      symbolIcon,
                      style: TextStyle(
                        color: color,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  else if (icon != null)
                    FaIcon(icon, color: color.withValues(alpha: 0.9), size: 14),
                  if (onTap != null) ...[
                    const SizedBox(width: 4),
                    Icon(
                      Icons.chevron_right,
                      size: 14,
                      color: isDark ? Colors.white38 : Colors.black38,
                    ),
                  ],
                ],
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: amount != null
                    ? PrivacyText(
                        amount,
                        suffix: suffix,
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black.withValues(alpha: 0.85),
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : Text(
                        value ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black.withValues(alpha: 0.85),
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
              if (badgeText != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    badgeText,
                    style: TextStyle(
                      color: color,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
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

  Widget _buildLendingCard(
    BuildContext context, {
    required String title,
    required double given,
    required double taken,
    required String symbol,
    required FaIconData icon,
    required Color color,
    VoidCallback? onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Widget card = Ink(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
                  fontWeight: FontWeight.w600,
                ),
              ),
              Row(
                children: [
                  FaIcon(icon, color: color.withValues(alpha: 0.9), size: 14),
                  if (onTap != null) ...[
                    const SizedBox(width: 4),
                    Icon(
                      Icons.chevron_right,
                      size: 14,
                      color: isDark ? Colors.white38 : Colors.black38,
                    ),
                  ],
                ],
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                child: PrivacyText(
                  given,
                  prefix: 'Given: ',
                  suffix: ' $symbol',
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black.withValues(alpha: 0.85),
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 2),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: PrivacyText(
                  taken,
                  prefix: 'Taken: ',
                  suffix: ' $symbol',
                  style: TextStyle(
                    color: isDark ? Colors.white70 : Colors.black54,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
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
      final cardCount = AppConfig.isPersonal ? 3 : 2;
      return Shimmer.fromColors(
        baseColor: baseColor,
        highlightColor: highlightColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.6,
            children: List.generate(
              cardCount,
              (index) => Container(
                decoration: BoxDecoration(
                  color: itemBg,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
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
