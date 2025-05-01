import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spendly/core/styles/app_colors.dart';

class StyledDatePickerButton extends StatelessWidget {
  final DateTime? selectedDate;
  final Function(DateTime?) onDateSelected;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final String labelText;
  final String hintText;
  final bool isOptional;

  const StyledDatePickerButton({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
    this.firstDate,
    this.lastDate,
    required this.labelText,
    this.hintText = 'Select Date',
    this.isOptional = false,
  });

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: firstDate ?? DateTime(2000),
      lastDate: lastDate ?? DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryTeal,
              onPrimary: AppColors.white,
              onSurface: AppColors.primaryTealDark,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primaryTealDark,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (pickedDate != null) {
      onDateSelected(pickedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    final String displayFormat = 'MMM d, yyyy';
    final String displayText = selectedDate != null
        ? DateFormat(displayFormat).format(selectedDate!)
        : hintText;
    final bool hasValue = selectedDate != null;

    return InkWell(
      onTap: () => _pickDate(context),
      borderRadius: BorderRadius.circular(10.0),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: const TextStyle(color: AppColors.primaryTealDark),
          prefixIcon: const Icon(Icons.calendar_today_outlined,
              color: AppColors.iconColor),
          suffixIcon: (isOptional && hasValue)
              ? IconButton(
                  icon: const Icon(Icons.clear, size: 20),
                  color: AppColors.darkGrey,
                  tooltip: 'Clear Date',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () => onDateSelected(null), // Clear the date
                )
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
            borderSide: const BorderSide(
                color: AppColors.focusedBorderColor, width: 2.0),
          ),
          filled: true,
          fillColor: AppColors.subtleBackground,
          contentPadding:
              const EdgeInsets.fromLTRB(0, 15, 10, 15), // Adjust padding
        ),
        child: Padding(
          padding: const EdgeInsetsDirectional.only(start: 12.0),
          // Align with icon
          child: Text(
            displayText,
            style: TextStyle(
              fontSize: 16,
              color: hasValue ? AppColors.primaryTealDark : AppColors.hintText,
            ),
          ),
        ),
      ),
    );
  }
}
