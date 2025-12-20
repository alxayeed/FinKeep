import 'package:flutter/material.dart';

import '../../domain/entities/investment.dart';
import '../../domain/enums/investment_status.dart';

class InvestmentFinancialsCard extends StatelessWidget {
  final Investment investment;

  const InvestmentFinancialsCard({super.key, required this.investment});

  @override
  Widget build(BuildContext context) {
    final totalReturns = investment.returns.fold<double>(
      0,
      (sum, r) => sum + r.amountReceived,
    );

    final profitLoss = totalReturns - investment.amountInvested;
    final isLoss = investment.status == InvestmentStatus.loss;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Amounts Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _amountColumn(
                    label: 'Invested', amount: investment.amountInvested),
                _amountColumn(label: 'Returned', amount: totalReturns),
                _amountColumn(
                  label: isLoss ? 'Loss' : 'Remaining',
                  amount: profitLoss >= 0 ? profitLoss : profitLoss.abs(),
                  amountColor: profitLoss >= 0 ? Colors.green : Colors.red,
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Profit Rate & Expected ROI Row
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
    );
  }

  // --------------------------
  // Column for numeric amounts
  // --------------------------
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

  // --------------------------
  // Column for string values
  // --------------------------
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
