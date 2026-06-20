import 'package:flutter/material.dart';
import 'package:finkeep/core/responsive/responsive.dart';

class StyledAmountField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final bool autofocus;
  final String? Function(String?)? validator;

  const StyledAmountField({
    super.key,
    required this.controller,
    required this.labelText,
    this.autofocus = false,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color labelColor = isDark ? Colors.white60 : const Color(0xFF64748B);
    final Color textColor = isDark ? Colors.white : const Color(0xFF0F172A);

    return Column(
      children: [
        Text(
          labelText.toUpperCase(),
          style: TextStyle(
            fontSize: 10.sp,
            fontFamily: 'Manrope',
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
            color: labelColor,
          ),
        ),
        SizedBox(height: 8.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              '৳',
              style: TextStyle(
                fontSize: 32.sp,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white30 : const Color(0xFFCBD5E1),
              ),
            ),
            SizedBox(width: 4.w),
            IntrinsicWidth(
              child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: 150.w),
                child: TextFormField(
                  controller: controller,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  autofocus: autofocus,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 42.sp,
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                  validator: validator,
                  decoration: InputDecoration(
                    hintText: '0.00',
                    hintStyle: TextStyle(
                      color: isDark ? Colors.white12 : const Color(0xFFE2E8F0),
                      fontSize: 42.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    errorStyle: TextStyle(
                      fontSize: 11.sp,
                      fontFamily: 'Manrope',
                      color: Theme.of(context).colorScheme.error,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
