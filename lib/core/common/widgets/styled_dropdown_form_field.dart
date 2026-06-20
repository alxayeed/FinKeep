import 'package:flutter/material.dart';
import 'package:finkeep/core/responsive/responsive.dart';
import 'package:finkeep/core/styles/app_colors.dart';

class StyledDropdownFormField<T> extends StatelessWidget {
  final T? value;
  final String labelText;
  final List<DropdownMenuItem<T>> items;
  final void Function(T?)? onChanged;
  final String? Function(T?)? validator;
  final IconData? prefixIcon;
  final double? itemHeight;
  final Color? dropdownColor;
  final bool readOnly;

  const StyledDropdownFormField({
    super.key,
    required this.value,
    required this.labelText,
    required this.items,
    required this.onChanged,
    this.validator,
    this.prefixIcon,
    this.itemHeight,
    this.dropdownColor,
    this.readOnly = false,
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
        DropdownButtonFormField<T>(
          initialValue: value,
          decoration: InputDecoration(
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
              vertical: 14.h,
            ),
          ),
          items: items,
          onChanged: readOnly ? null : onChanged,
          validator: validator,
          iconEnabledColor: iconColor,
          iconDisabledColor: iconColor.withValues(alpha: 0.5),
          dropdownColor: dropdownColor ?? (isDark ? const Color(0xFF1E293B) : Colors.white),
          menuMaxHeight: 300,
          borderRadius: BorderRadius.circular(16.r),
          style: TextStyle(
            fontSize: 13.sp,
            fontFamily: 'Manrope',
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
      ],
    );
  }
}

