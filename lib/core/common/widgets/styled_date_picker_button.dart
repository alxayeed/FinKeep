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
  final bool readOnly;
  final String? Function(DateTime?)? validator;

  const StyledDatePickerButton({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
    this.firstDate,
    this.lastDate,
    required this.labelText,
    this.hintText = 'Select Date',
    this.isOptional = false,
    this.readOnly = false,
    this.validator,
  });

  Future<void> _pickDate(
    BuildContext context,
    FormFieldState<DateTime> state,
  ) async {
    if (readOnly) return;

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
      state.didChange(pickedDate);
      onDateSelected(pickedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FormField<DateTime>(
      initialValue: selectedDate,
      validator: validator,
      builder: (FormFieldState<DateTime> state) {
        final bool hasValue = state.value != null;
        final String displayText = hasValue
            ? DateFormat('d MMM, yyyy').format(state.value!)
            : hintText;

        return InkWell(
          onTap: readOnly ? null : () => _pickDate(context, state),
          borderRadius: BorderRadius.circular(10.0),
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: labelText,
              labelStyle: TextStyle(
                color: readOnly
                    ? AppColors.darkGrey
                    : AppColors.primaryTealDark,
              ),
              prefixIcon: Icon(
                Icons.calendar_today_outlined,
                color: readOnly
                    ? AppColors.darkGrey.withValues(alpha: 0.6)
                    : AppColors.iconColor,
              ),
              suffixIcon: (isOptional && hasValue && !readOnly)
                  ? IconButton(
                      icon: const Icon(Icons.clear, size: 20),
                      color: AppColors.darkGrey,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () {
                        state.didChange(null);
                        onDateSelected(null);
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: const BorderSide(color: AppColors.borderColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: const BorderSide(
                  color: AppColors.enabledBorderColor,
                ),
              ),
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
                borderSide: const BorderSide(
                  color: AppColors.error,
                  width: 1.5,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: const BorderSide(
                  color: AppColors.error,
                  width: 2.0,
                ),
              ),
              filled: true,
              fillColor: readOnly
                  ? AppColors.subtleBackground.withValues(alpha: 0.7)
                  : AppColors.subtleBackground,
              errorText: state.errorText,
              contentPadding: const EdgeInsets.fromLTRB(0, 15, 10, 15),
            ),
            child: Padding(
              padding: const EdgeInsetsDirectional.only(start: 12.0),
              child: Text(
                displayText,
                style: TextStyle(
                  fontSize: 16,
                  color: readOnly
                      ? AppColors.darkGrey
                      : (hasValue
                            ? AppColors.primaryTealDark
                            : AppColors.hintText),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
