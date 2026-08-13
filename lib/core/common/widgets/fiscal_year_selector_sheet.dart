import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../responsive/responsive.dart';
import '../../styles/app_colors.dart';
import '../../providers/fiscal_year_provider.dart';

void showFiscalYearSelectorBottomSheet(BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final textColor = isDark ? Colors.white : const Color(0xFF0F172A);

  final months = [
    {'month': 1, 'label': 'January (Standard Calendar / US Corporate)'},
    {'month': 4, 'label': 'April (UK / India / Japan / Canada)'},
    {'month': 7, 'label': 'July (Bangladesh / Australia / Pakistan)'},
    {'month': 10, 'label': 'October (US Federal Govt)'},
  ];

  showModalBottomSheet(
    context: context,
    backgroundColor: isDark ? AppColors.cardDark : Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
    ),
    builder: (sheetContext) {
      return StatefulBuilder(
        builder: (context, setModalState) {
          final selectedMonth = FiscalYearProvider().startMonth;
          return Material(
            color: isDark ? AppColors.cardDark : Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Fiscal Year Start Month',
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                    color: textColor,
                  ),
                ),
                SizedBox(height: 14.h),
                ...months.map((item) {
                  final monthVal = item['month'] as int;
                  final label = item['label'] as String;
                  final isSelected = selectedMonth == monthVal;

                  return Container(
                    margin: EdgeInsets.only(bottom: 6.h),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primaryTeal.withValues(alpha: 0.12)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(12.r),
                      border: isSelected
                          ? Border.all(
                              color: AppColors.primaryTeal.withValues(alpha: 0.3),
                            )
                          : null,
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 12.w),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      title: Text(
                        label,
                        style: TextStyle(
                          fontFamily: 'Manrope',
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.w500,
                          fontSize: 13.sp,
                          color: isSelected
                              ? AppColors.primaryTeal
                              : (isDark ? Colors.white : const Color(0xFF0F172A)),
                        ),
                      ),
                      trailing: isSelected
                          ? Icon(
                              Icons.check_circle_rounded,
                              color: AppColors.primaryTeal,
                              size: 20.sp,
                            )
                          : null,
                      onTap: () async {
                        await FiscalYearProvider().setStartMonth(monthVal);
                        if (sheetContext.mounted) Navigator.pop(sheetContext);
                      },
                    ),
                  );
                }),
                SizedBox(height: 6.h),
                // Option for custom month
                (() {
                  final isPreset = months.any(
                    (item) => item['month'] == selectedMonth,
                  );
                  final isCustomSelected = !isPreset;
                  final customMonthName = DateFormat(
                    'MMMM',
                  ).format(DateTime(2026, selectedMonth));
                  final labelText = isCustomSelected
                      ? 'Custom Month ($customMonthName)'
                      : 'Custom Month...';

                  return Container(
                    decoration: BoxDecoration(
                      color: isCustomSelected
                          ? AppColors.primaryTeal.withValues(alpha: 0.12)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(12.r),
                      border: isCustomSelected
                          ? Border.all(
                              color: AppColors.primaryTeal.withValues(alpha: 0.3),
                            )
                          : null,
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 12.w),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      leading: const Icon(
                        Icons.edit_calendar_rounded,
                        color: AppColors.primaryTeal,
                      ),
                      title: Text(
                        labelText,
                        style: TextStyle(
                          fontFamily: 'Manrope',
                          fontWeight: FontWeight.bold,
                          fontSize: 13.sp,
                          color: AppColors.primaryTeal,
                        ),
                      ),
                      trailing: isCustomSelected
                          ? Icon(
                              Icons.check_circle_rounded,
                              color: AppColors.primaryTeal,
                              size: 20.sp,
                            )
                          : null,
                      onTap: () async {
                        Navigator.pop(sheetContext);
                        _showCustomMonthPickerDialog(context);
                      },
                    ),
                  );
                })(),
              ],
            ),
          ),
        );
        },
      );
    },
  );
}

void _showCustomMonthPickerDialog(BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final presetMonths = {1, 4, 7, 10};
  final customMonths = List.generate(
    12,
    (i) => i + 1,
  ).where((m) => !presetMonths.contains(m)).toList();

  showDialog(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        backgroundColor: isDark ? AppColors.cardDark : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        title: Text(
          'Select Fiscal Start Month',
          style: TextStyle(
            fontSize: 16.sp,
            fontFamily: 'Manrope',
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : const Color(0xFF0F172A),
          ),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: customMonths.length,
            itemBuilder: (context, index) {
              final monthNum = customMonths[index];
              final monthName = DateFormat('MMMM').format(DateTime(2026, monthNum));
              final isSelected = FiscalYearProvider().startMonth == monthNum;

              return ListTile(
                title: Text(
                  monthName,
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    color: isSelected ? AppColors.primaryTeal : (isDark ? Colors.white : const Color(0xFF0F172A)),
                  ),
                ),
                trailing: isSelected ? const Icon(Icons.check_circle_rounded, color: AppColors.primaryTeal) : null,
                onTap: () async {
                  await FiscalYearProvider().setStartMonth(monthNum);
                  if (dialogContext.mounted) Navigator.pop(dialogContext);
                },
              );
            },
          ),
        ),
      );
    },
  );
}
