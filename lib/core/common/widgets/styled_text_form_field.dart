import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:finkeep/core/responsive/responsive.dart';

import '../../styles/app_colors.dart';

class StyledTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final TextInputType keyboardType;
  final int maxLines;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final bool obscureText;
  final IconData? prefixIcon;
  final bool readOnly;
  final String? hintText;

  final FocusNode? focusNode;

  const StyledTextFormField({
    super.key,
    required this.controller,
    required this.labelText,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.validator,
    this.inputFormatters,
    this.obscureText = false,
    this.prefixIcon,
    this.readOnly = false,
    this.hintText,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color inputBg = isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9);
    final Color labelColor = isDark ? Colors.white60 : const Color(0xFF64748B);
    final Color textColor = isDark ? Colors.white : const Color(0xFF334155);
    final Color iconColor = isDark ? Colors.white38 : const Color(0xFF94A3B8);

    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(16.r),
      borderSide: BorderSide.none,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 4.w, bottom: 6.h),
          child: Text(
            labelText,
            style: TextStyle(
              fontSize: 11.sp,
              fontFamily: 'Manrope',
              fontWeight: FontWeight.bold,
              color: labelColor,
            ),
          ),
        ),
        TextFormField(
          focusNode: focusNode,
          controller: controller,
          readOnly: readOnly,
          enableInteractiveSelection: !readOnly,
          showCursor: !readOnly,
          style: TextStyle(
            fontSize: 13.sp,
            fontFamily: 'Manrope',
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              color: isDark ? Colors.white24 : const Color(0xFFCBD5E1),
              fontSize: 13.sp,
              fontFamily: 'Manrope',
            ),
            prefixIcon: prefixIcon != null
                ? Icon(
                    prefixIcon,
                    color: iconColor,
                    size: 18.sp,
                  )
                : null,
            border: border,
            enabledBorder: border,
            focusedBorder: border,
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: const BorderSide(color: AppColors.error, width: 1.0),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: const BorderSide(color: AppColors.error, width: 1.5),
            ),
            filled: true,
            fillColor: readOnly ? inputBg.withValues(alpha: 0.6) : inputBg,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 14.w,
              vertical: maxLines > 1 ? 12.h : 14.h,
            ),
          ),
          keyboardType: keyboardType,
          maxLines: maxLines,
          validator: validator,
          inputFormatters: inputFormatters,
          obscureText: obscureText,
          cursorColor: readOnly ? Colors.transparent : AppColors.primaryTeal,
        ),
      ],
    );
  }
}

