import 'package:flutter/material.dart';
import '../../../../core/responsive/responsive.dart';
import '../../../../core/styles/app_colors.dart';
import '../../../../core/styles/app_text_styles.dart';

import '../../domain/entities/investment.dart';
import '../../domain/enums/investment_status.dart';

class InvestmentItem extends StatelessWidget {
  final Investment investment;
  final VoidCallback? onTap;

  const InvestmentItem({
    super.key,
    required this.investment,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final totalReturns = investment.returns.fold<double>(
      0,
      (sum, r) => sum + r.amountReceived,
    );

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8.r,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.all(16.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _header(context),
                SizedBox(height: 8.h),
                _metaInfo(context),
                SizedBox(height: 12.h),
                _amountRow(context, totalReturns),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --------------------------------------------------
  // Header
  // --------------------------------------------------

  Widget _header(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            investment.title,
            style: AppTextStyles.cardTitle(context),
          ),
        ),
        _statusChip(),
      ],
    );
  }

  // --------------------------------------------------
  // Platform + Dates
  // --------------------------------------------------

  Widget _metaInfo(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      children: [
        Icon(
          Icons.account_balance,
          size: 14.sp,
          color: isDark ? Colors.white38 : const Color(0xFF94A3B8),
        ),
        SizedBox(width: 4.w),
        Expanded(
          child: Text(
            investment.platformName,
            style: AppTextStyles.cardSubtitle(context),
          ),
        ),
        Text(
          _formatDateRange(),
          style: AppTextStyles.cardSubtitle(context),
        ),
      ],
    );
  }

  // --------------------------------------------------
  // Amounts
  // --------------------------------------------------

  Widget _amountRow(BuildContext context, double totalReturns) {
    final invested = investment.amountInvested;

    late String thirdLabel;
    late double thirdAmount;
    late Color thirdColor;

    switch (investment.status) {
      case InvestmentStatus.active:
      case InvestmentStatus.returnsStarted:
        thirdLabel = 'Remaining';
        thirdAmount = (invested - totalReturns).clamp(0, double.infinity);
        thirdColor = Colors.orange;
        break;

      case InvestmentStatus.completed:
        final profit = totalReturns - invested;
        thirdLabel = profit >= 0 ? 'Profit' : 'Loss';
        thirdAmount = profit.abs();
        thirdColor = profit >= 0 ? Colors.green : Colors.red;
        break;

      case InvestmentStatus.loss:
        thirdLabel = 'Loss';
        thirdAmount = (invested - totalReturns).clamp(0, double.infinity);
        thirdColor = Colors.red;
        break;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _amountColumn(
          context: context,
          label: 'Invested',
          amount: invested,
        ),
        _amountColumn(
          context: context,
          label: 'Returned',
          amount: totalReturns,
        ),
        _amountColumn(
          context: context,
          label: thirdLabel,
          amount: thirdAmount,
          amountColor: thirdColor,
        ),
      ],
    );
  }

  Widget _amountColumn({
    required BuildContext context,
    required String label,
    required double amount,
    Color? amountColor,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.cardSubtitle(context),
        ),
        SizedBox(height: 4.h),
        Text(
          '৳${amount.toStringAsFixed(0)}',
          style: AppTextStyles.cardTitle(context).copyWith(
            color: amountColor ?? (isDark ? Colors.white : const Color(0xFF0F172A)),
          ),
        ),
      ],
    );
  }

  // --------------------------------------------------
  // Status
  // --------------------------------------------------

  Widget _statusChip() {
    final statusData = _statusConfig(investment.status);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: statusData.color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        statusData.label,
        style: TextStyle(
          fontSize: 10.sp,
          fontFamily: 'Manrope',
          fontWeight: FontWeight.bold,
          color: statusData.color,
        ),
      ),
    );
  }

  _StatusConfig _statusConfig(InvestmentStatus status) {
    switch (status) {
      case InvestmentStatus.active:
        return _StatusConfig('Active', Colors.blue);
      case InvestmentStatus.returnsStarted:
        return _StatusConfig('Returns Started', Colors.orange);
      case InvestmentStatus.completed:
        return _StatusConfig('Completed', Colors.green);
      case InvestmentStatus.loss:
        return _StatusConfig('Loss', Colors.red);
    }
  }

  // --------------------------------------------------
  // Helpers
  // --------------------------------------------------

  String _formatDateRange() {
    return '${_fmt(investment.startDate)} - ${_fmt(investment.expectedEndDate)}';
  }

  String _fmt(DateTime d) {
    return '${d.day}/${d.month}/${d.year}';
  }
}

// --------------------------------------------------
// Internal helper class
// --------------------------------------------------

class _StatusConfig {
  final String label;
  final Color color;

  const _StatusConfig(this.label, this.color);
}
