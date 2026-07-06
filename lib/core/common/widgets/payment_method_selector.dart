import 'package:flutter/material.dart';
import 'package:finkeep/core/enums/payment_type.dart';
import 'package:finkeep/core/responsive/responsive.dart';

class PaymentMethodSelector extends StatelessWidget {
  final PaymentType selectedMethod;
  final ValueChanged<PaymentType> onChanged;
  final Color? labelColor;

  const PaymentMethodSelector({
    super.key,
    required this.selectedMethod,
    required this.onChanged,
    this.labelColor,
  });

  Widget _buildLabel(BuildContext context, String text, Color color) {
    return Padding(
      padding: EdgeInsets.only(left: 4.w, bottom: 6.h, top: 10.h),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 11.sp,
            fontFamily: 'Manrope',
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentBtn(
    BuildContext context,
    String text,
    IconData icon,
    PaymentType method,
    Color primaryColor,
  ) {
    final isSelected = selectedMethod == method;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Expanded(
      child: GestureDetector(
        onTap: () => onChanged(method),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          decoration: BoxDecoration(
            color: isSelected
                ? primaryColor.withValues(alpha: 0.05)
                : (isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9)),
            border: Border.all(
              color: isSelected ? primaryColor : Colors.transparent,
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                size: 20.sp,
                color: isSelected
                    ? primaryColor
                    : (isDark ? Colors.white38 : const Color(0xFF94A3B8)),
              ),
              SizedBox(height: 4.h),
              Text(
                text.toUpperCase(),
                style: TextStyle(
                  fontSize: 9.sp,
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.bold,
                  color: isSelected
                      ? primaryColor
                      : (isDark ? Colors.white38 : const Color(0xFF64748B)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color actualLabelColor = labelColor ?? (isDark ? Colors.white60 : const Color(0xFF64748B));
    final Color primaryColor = Theme.of(context).colorScheme.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(context, 'Payment Method', actualLabelColor),
        Row(
          children: [
            _buildPaymentBtn(context, 'Cash', Icons.payments_rounded, PaymentType.cash, primaryColor),
            SizedBox(width: 8.w),
            _buildPaymentBtn(context, 'MFS', Icons.phone_android_rounded, PaymentType.mfs, primaryColor),
            SizedBox(width: 8.w),
            _buildPaymentBtn(context, 'Card', Icons.credit_card_rounded, PaymentType.card, primaryColor),
            SizedBox(width: 8.w),
            _buildPaymentBtn(context, 'Transfer', Icons.account_balance_rounded, PaymentType.transfer, primaryColor),
          ],
        ),
      ],
    );
  }
}
