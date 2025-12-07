import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spendly/core/styles/app_colors.dart';

import '../../domain/entity/repayment/repayment_entity.dart';

class RepaymentItemWidget extends StatelessWidget {
  final RepaymentEntity repayment;
  final VoidCallback onEdit;
  final NumberFormat currencyFormat;
  final DateFormat dateFormat;

  const RepaymentItemWidget({
    super.key,
    required this.repayment,
    required this.onEdit,
    required this.currencyFormat,
    required this.dateFormat,
  });

  @override
  Widget build(BuildContext context) {
    final amountText = currencyFormat.format(repayment.amount);
    final dateText = dateFormat.format(repayment.paidDate);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: AppColors.subtleBackground,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(
                      text: 'Paid ',
                      style: TextStyle(
                        fontSize: 13,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    TextSpan(
                      text: amountText,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                    const TextSpan(
                      text: ' on ',
                      style: TextStyle(
                        fontSize: 13,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    TextSpan(
                      text: dateText,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.edit, color: AppColors.primaryTealDark),
              onPressed: onEdit,
            ),
          ],
        ),
      ),
    );
  }
}
