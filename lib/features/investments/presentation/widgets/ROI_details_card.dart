import 'package:flutter/material.dart';

import '../../domain/entities/investment.dart';
import '../../domain/enums/investment_status.dart';

class ROIDetailsCard extends StatelessWidget {
  final Investment investment;

  const ROIDetailsCard({super.key, required this.investment});

  @override
  Widget build(BuildContext context) {
    final totalReturns = investment.returns.fold<double>(
      0,
      (sum, r) => sum + r.amountReceived,
    );

    final profitLoss = totalReturns - investment.amountInvested;

    // Determine label and color based on status
    String label;
    Color labelColor;
    if (investment.status == InvestmentStatus.loss) {
      label = 'Loss';
      labelColor = Colors.red;
    } else if (profitLoss > 0) {
      label = 'Profit';
      labelColor = Colors.green;
    } else {
      label = 'Remaining';
      labelColor = Colors.orange;
    }

    // Progress as fraction of invested amount
    final progress = (totalReturns / investment.amountInvested).clamp(0.0, 1.0);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Stack(
        children: [
          // Background progress
          Positioned.fill(
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: progress,
              child: Container(
                decoration: BoxDecoration(
                  color: labelColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          // Foreground content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Amounts row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _amountColumn(
                        label: 'Invested', amount: investment.amountInvested),
                    _amountColumn(label: 'Returned', amount: totalReturns),
                    _amountColumn(
                      label: label,
                      amount: profitLoss.abs(),
                      amountColor: labelColor,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Profit rate & expected ROI
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _stringColumn(
                        label: 'Profit Rate',
                        value: investment.profitRate.toString()),
                    _amountColumn(
                        label: 'Expected ROI',
                        amount: investment.expectedROI,
                        isPercentage: true),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _amountColumn({
    required String label,
    required double amount,
    Color? amountColor,
    bool isPercentage = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
        const SizedBox(height: 4),
        Text(
          isPercentage
              ? '${amount.toStringAsFixed(2)}%'
              : '৳${amount.toStringAsFixed(0)}',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: amountColor ?? Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _stringColumn({
    required String label,
    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
