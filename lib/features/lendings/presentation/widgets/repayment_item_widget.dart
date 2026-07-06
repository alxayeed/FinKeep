import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:finkeep/core/extensions/double_ext.dart';
import 'package:finkeep/core/responsive/responsive.dart';
import 'package:finkeep/core/styles/app_colors.dart';

import 'package:finkeep/core/styles/currency_provider.dart';
import '../../domain/entity/repayment/repayment_entity.dart';
import 'package:finkeep/core/enums/payment_type.dart';

/// Standalone repayment card — used when embedding repayment tiles outside
/// of [RepaymentListWidget] (e.g. in a future summary view).
class RepaymentItemWidget extends StatelessWidget {
  final RepaymentEntity repayment;
  final VoidCallback onEdit;

  // These are kept for backwards compat but ignored — we format internally.
  final NumberFormat? currencyFormat;
  final DateFormat? dateFormat;

  const RepaymentItemWidget({
    super.key,
    required this.repayment,
    required this.onEdit,
    this.currencyFormat,
    this.dateFormat,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dateText =
        DateFormat('MMM dd, yyyy').format(repayment.paidDate);

    return GestureDetector(
      onTap: onEdit,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5.h),
        padding: EdgeInsets.all(14.r),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : AppColors.cardLight,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isDark
                ? const Color(0xFF334155)
                : const Color(0xFFF1F5F9),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 6.r,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon badge
            Container(
              width: 40.r,
              height: 40.r,
              decoration: BoxDecoration(
                color: const Color(0xFFECFDF5),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(Icons.payments_rounded,
                  size: 18.sp, color: AppColors.primaryTeal),
            ),
            SizedBox(width: 12.w),

            // Notes + date
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    repayment.notes?.isNotEmpty == true
                        ? repayment.notes!
                        : 'Repayment',
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.bold,
                      color:
                          isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 3.h),
                  Row(
                    children: [
                      Text(
                        dateText,
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontFamily: 'Manrope',
                          fontWeight: FontWeight.w500,
                          color: isDark
                              ? Colors.white38
                              : const Color(0xFF94A3B8),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Container(
                        width: 4.r,
                        height: 4.r,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isDark ? Colors.white24 : const Color(0xFFCBD5E1),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        repayment.paymentMethod.displayName,
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontFamily: 'Manrope',
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryTeal,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Amount
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '+',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryTeal,
                  ),
                ),
                Text(
                  '${repayment.amount.toCurrency()} ${context.currency.symbol}',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryTeal,
                  ),
                ),
              ],
            ),

            SizedBox(width: 4.w),
            Icon(Icons.edit_rounded,
                size: 14.sp,
                color:
                    isDark ? Colors.white24 : const Color(0xFFCBD5E1)),
          ],
        ),
      ),
    );
  }
}
