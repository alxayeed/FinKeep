import 'package:flutter/material.dart';
import 'package:spendly/core/styles/app_colors.dart';

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
    debugPrint("Current selected value: $value");

    return DropdownButtonFormField<T>(
      initialValue: value,

      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(color: AppColors.primaryTealDark),

        prefixIcon: prefixIcon != null
            ? Icon(
                prefixIcon,
                color: readOnly
                    ? AppColors.darkGrey.withValues(alpha: .6)
                    : AppColors.iconColor,
              )
            : (readOnly
                ? const Icon(
                    Icons.lock_outline,
                    size: 18,
                    color: AppColors.darkGrey,
                  )
                : null),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: AppColors.borderColor),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: AppColors.enabledBorderColor),
        ),

        // Prevent focus-looking effect when readOnly
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: readOnly
                ? AppColors.enabledBorderColor
                : AppColors.focusedBorderColor,
            width: readOnly ? 1.0 : 2.0,
          ),
        ),

        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),

        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: AppColors.error, width: 2.0),
        ),

        filled: true,
        fillColor: readOnly
            ? AppColors.subtleBackground.withValues(alpha: .7)
            : AppColors.subtleBackground,
      ),

      items: items,

      // Disable interaction
      onChanged: readOnly ? null : onChanged,

      validator: validator,

      iconEnabledColor: readOnly
          ? AppColors.darkGrey.withValues(alpha: .6)
          : AppColors.primaryTealDark,

      focusColor: Colors.transparent,
      itemHeight: itemHeight,
      dropdownColor: dropdownColor ?? AppColors.white,
      menuMaxHeight: 300,
      borderRadius: BorderRadius.circular(10.0),
    );
  }
}
