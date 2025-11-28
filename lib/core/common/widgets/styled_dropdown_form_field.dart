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
  });

  @override
  Widget build(BuildContext context) {
    debugPrint("Current selected value: $value");
    return DropdownButtonFormField<T>(
      value: value,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(color: AppColors.primaryTealDark),
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, color: AppColors.iconColor)
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: AppColors.borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: AppColors.enabledBorderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide:
              const BorderSide(color: AppColors.focusedBorderColor, width: 2.0),
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
        fillColor: AppColors.subtleBackground,
      ),
      items: items,
      onChanged: onChanged,
      validator: validator,
      iconEnabledColor: AppColors.primaryTealDark,
      focusColor: Colors.transparent,
      itemHeight: itemHeight,
      dropdownColor: dropdownColor ?? AppColors.white,
      menuMaxHeight: 300,
      borderRadius: BorderRadius.circular(10.0),
    );
  }
}
