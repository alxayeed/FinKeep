import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spendly/core/responsive/responsive.dart';
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color inputBg = isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9);
    final Color labelColor = isDark ? Colors.white60 : const Color(0xFF64748B);
    final Color textColor = isDark ? Colors.white : const Color(0xFF334155);
    final Color iconColor = isDark ? Colors.white38 : const Color(0xFF94A3B8);

    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(16.r),
      borderSide: BorderSide.none,
    );

    return FormField<DateTime>(
      initialValue: selectedDate,
      validator: validator,
      builder: (FormFieldState<DateTime> state) {
        final bool hasValue = state.value != null;
        final String displayText = hasValue
            ? DateFormat('d MMM, yyyy').format(state.value!)
            : hintText;

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
            InkWell(
              onTap: readOnly ? null : () => _pickDate(context, state),
              borderRadius: BorderRadius.circular(16.r),
              child: InputDecorator(
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.calendar_today_outlined,
                    color: iconColor,
                    size: 18.sp,
                  ),
                  suffixIcon: (isOptional && hasValue && !readOnly)
                      ? IconButton(
                          icon: Icon(Icons.clear, size: 18.sp),
                          color: labelColor,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: () {
                            state.didChange(null);
                            onDateSelected(null);
                          },
                        )
                      : null,
                  border: border,
                  enabledBorder: border,
                  focusedBorder: readOnly
                      ? border
                      : OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.r),
                          borderSide: const BorderSide(
                            color: AppColors.primaryTeal,
                            width: 1.5,
                          ),
                        ),
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
                  errorText: state.errorText,
                  contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
                ),
                child: Padding(
                  padding: EdgeInsets.only(left: 4.w),
                  child: Text(
                    displayText,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.w600,
                      color: hasValue
                          ? textColor
                          : (isDark ? Colors.white24 : const Color(0xFFCBD5E1)),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

