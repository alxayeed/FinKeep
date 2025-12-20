import 'package:flutter/material.dart';

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
    final totalReturns = investment.returns.fold<double>(
      0,
      (sum, r) => sum + r.amountReceived,
    );

    final profitLoss = totalReturns - investment.amountInvested;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _header(),
              const SizedBox(height: 8),
              _metaInfo(),
              const SizedBox(height: 12),
              _amountRow(totalReturns),
            ],
          ),
        ),
      ),
    );
  }

  // --------------------------------------------------
  // Header
  // --------------------------------------------------

  Widget _header() {
    return Row(
      children: [
        Expanded(
          child: Text(
            investment.title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        _statusChip(),
      ],
    );
  }

  // --------------------------------------------------
  // Platform + Dates
  // --------------------------------------------------

  Widget _metaInfo() {
    return Row(
      children: [
        Icon(Icons.account_balance, size: 16, color: Colors.grey.shade600),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            investment.platformName,
            style: TextStyle(color: Colors.grey.shade700),
          ),
        ),
        Text(
          _formatDateRange(),
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  // --------------------------------------------------
  // Amounts
  // --------------------------------------------------

  Widget _amountRow(double totalReturns) {
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
          label: 'Invested',
          amount: invested,
        ),
        _amountColumn(
          label: 'Returned',
          amount: totalReturns,
        ),
        _amountColumn(
          label: thirdLabel,
          amount: thirdAmount,
          amountColor: thirdColor,
        ),
      ],
    );
  }

  Widget _amountColumn({
    required String label,
    required double amount,
    Color? amountColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '৳${amount.toStringAsFixed(0)}',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: amountColor ?? Colors.black,
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: statusData.color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        statusData.label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
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
