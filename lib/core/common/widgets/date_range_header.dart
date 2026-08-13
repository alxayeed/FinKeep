import 'package:flutter/material.dart';
import '../../responsive/responsive.dart';
import '../../styles/app_colors.dart';
import '../../providers/fiscal_year_provider.dart';
import '../../providers/privacy_provider.dart';
import '../models/date_filter.dart';
import 'fiscal_year_selector_sheet.dart';

class DateRangeHeader extends StatelessWidget {
  final DateFilter dateFilter;
  final ValueChanged<DateFilter> onDateFilterChanged;
  final VoidCallback? onSettingsPressed;
  final bool showSearchButton;

  const DateRangeHeader({
    super.key,
    required this.dateFilter,
    required this.onDateFilterChanged,
    this.onSettingsPressed,
    this.showSearchButton = false,
  });

  bool get _hasChevronNavigation {
    return dateFilter.type == DateFilterType.monthly ||
        dateFilter.type == DateFilterType.yearly ||
        dateFilter.type == DateFilterType.fiscalYearly;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: FiscalYearProvider().startMonthNotifier,
      builder: (context, fiscalStartMonth, _) {
        final currentSelection = dateFilter.fiscalYearStartMonth == fiscalStartMonth
            ? dateFilter
            : dateFilter.copyWith(fiscalYearStartMonth: fiscalStartMonth);
        final isDark = Theme.of(context).brightness == Brightness.dark;

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Left switching cluster
              Row(
                children: [
                  // Left Chevron
                  if (_hasChevronNavigation) ...[
                    GestureDetector(
                      onTap: () => onDateFilterChanged(currentSelection.previous()),
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        width: 36.r,
                        height: 36.r,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isDark ? const Color(0xFF1E293B) : Colors.transparent,
                        ),
                        child: Icon(
                          Icons.chevron_left,
                          size: 24.sp,
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                        ),
                      ),
                    ),
                    SizedBox(width: 4.w),
                  ],

                  // Dropdown Button Pill
                  GestureDetector(
                    onTap: () => _showDateFilterPickerModal(context, currentSelection),
                    child: Container(
                      height: 36.h,
                      padding: EdgeInsets.symmetric(horizontal: 14.w),
                      decoration: BoxDecoration(
                        color: AppColors.primaryTeal,
                        borderRadius: BorderRadius.circular(9999.r),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryTeal.withValues(alpha: 0.25),
                            blurRadius: 6.r,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            currentSelection.displayTitle,
                            style: TextStyle(
                              fontSize: 13.5.sp,
                              fontFamily: 'Manrope',
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 6.w),
                          Icon(
                            Icons.keyboard_arrow_down,
                            size: 18.sp,
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Right Chevron
                  if (_hasChevronNavigation) ...[
                    SizedBox(width: 4.w),
                    GestureDetector(
                      onTap: () => onDateFilterChanged(currentSelection.next()),
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        width: 36.r,
                        height: 36.r,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isDark ? const Color(0xFF1E293B) : Colors.transparent,
                        ),
                        child: Icon(
                          Icons.chevron_right,
                          size: 24.sp,
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                        ),
                      ),
                    ),
                  ],
                ],
              ),

              // Right Cluster: Privacy Eye Toggle & Settings Action Icon
              Row(
                children: [
                  ValueListenableBuilder<bool>(
                    valueListenable: PrivacyProvider(),
                    builder: (context, isMasked, _) {
                      return GestureDetector(
                        onTap: () => PrivacyProvider().toggleWithBiometrics(context),
                        child: Container(
                          width: 36.r,
                          height: 36.r,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isDark ? const Color(0xFF1E293B) : Colors.transparent,
                          ),
                          child: Icon(
                            isMasked
                                ? Icons.visibility_off_rounded
                                : Icons.visibility_rounded,
                            size: 22.sp,
                            color: isMasked
                                ? (isDark ? Colors.white60 : const Color(0xFF64748B))
                                : AppColors.primaryTeal,
                          ),
                        ),
                      );
                    },
                  ),
                  if (onSettingsPressed != null) ...[
                    SizedBox(width: 4.w),
                    GestureDetector(
                      onTap: onSettingsPressed,
                      child: Container(
                        width: 36.r,
                        height: 36.r,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isDark ? const Color(0xFF1E293B) : Colors.transparent,
                        ),
                        child: Icon(
                          Icons.settings_rounded,
                          size: 22.sp,
                          color: isDark ? Colors.white70 : const Color(0xFF64748B),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  /// Show date filter selection bottom sheet modal
  void _showDateFilterPickerModal(BuildContext context, DateFilter currentSelection) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (modalContext) {
        return Material(
          color: isDark ? AppColors.cardDark : AppColors.cardLight,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white24 : Colors.black12,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                'Select Date Range',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
              SizedBox(height: 14.h),
              ...DateFilterType.values.map((type) {
                final isSelected = currentSelection.type == type;
                final isFiscal = type == DateFilterType.fiscalYearly;

                return Container(
                  margin: EdgeInsets.only(bottom: 6.h),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primaryTeal.withValues(alpha: 0.12)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(14.r),
                    border: isSelected
                        ? Border.all(
                            color: AppColors.primaryTeal.withValues(alpha: 0.3),
                            width: 1,
                          )
                        : null,
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: isFiscal ? 2.h : 0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    leading: Icon(
                      _getIconForType(type),
                      color: isSelected
                          ? AppColors.primaryTeal
                          : (isDark ? Colors.white60 : const Color(0xFF64748B)),
                    ),
                    title: Text(
                      type.label,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontFamily: 'Manrope',
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        color: isSelected
                            ? AppColors.primaryTeal
                            : (isDark ? Colors.white : const Color(0xFF0F172A)),
                      ),
                    ),
                    subtitle: isFiscal
                        ? Text(
                            currentSelection.fiscalYearPeriodSubtitle,
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontFamily: 'Manrope',
                              color: isSelected
                                  ? AppColors.primaryTeal.withValues(alpha: 0.8)
                                  : (isDark ? Colors.white54 : const Color(0xFF64748B)),
                            ),
                          )
                        : null,
                    trailing: isSelected
                        ? Icon(
                            Icons.check_circle_rounded,
                            color: AppColors.primaryTeal,
                            size: 20.sp,
                          )
                        : (isFiscal
                            ? TextButton(
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                                  minimumSize: Size.zero,
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                                onPressed: () {
                                  Navigator.pop(modalContext);
                                  showFiscalYearSelectorBottomSheet(context);
                                },
                                child: Text(
                                  'Change',
                                  style: TextStyle(
                                    fontSize: 12.5.sp,
                                    fontFamily: 'Manrope',
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primaryTeal,
                                  ),
                                ),
                              )
                            : null),
                    onTap: () {
                      Navigator.pop(modalContext);
                      if (type == DateFilterType.custom) {
                        _showCustomRangePicker(context);
                      } else {
                        onDateFilterChanged(currentSelection.withType(type));
                      }
                    },
                  ),
                );
              }),
            ],
          ),
        ),
      );
      },
    );
  }

  IconData _getIconForType(DateFilterType type) {
    switch (type) {
      case DateFilterType.monthly:
        return Icons.calendar_view_month_rounded;
      case DateFilterType.yearly:
        return Icons.calendar_today_rounded;
      case DateFilterType.fiscalYearly:
        return Icons.account_balance_rounded;
      case DateFilterType.custom:
        return Icons.date_range_rounded;
      case DateFilterType.allTime:
        return Icons.all_inclusive_rounded;
    }
  }

  /// Custom Date Range picker modal sheet
  Future<void> _showCustomRangePicker(BuildContext context) async {
    final now = DateTime.now();
    DateTime startDate = dateFilter.customStartDate ?? now.subtract(const Duration(days: 30));
    DateTime endDate = dateFilter.customEndDate ?? now;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final isDark = Theme.of(context).brightness == Brightness.dark;
            final bg = isDark ? AppColors.cardDark : Colors.white;

            return Container(
              padding: EdgeInsets.only(
                left: 20.w,
                right: 20.w,
                top: 20.h,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24.h,
              ),
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40.w,
                      height: 4.h,
                      decoration: BoxDecoration(
                        color: isDark ? Colors.white24 : Colors.black12,
                        borderRadius: BorderRadius.circular(2.r),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Row(
                    children: [
                      const Icon(Icons.date_range_rounded, color: AppColors.primaryTeal),
                      SizedBox(width: 8.w),
                      Text(
                        'Select Custom Range',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontFamily: 'Manrope',
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Start Date',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: isDark ? Colors.white60 : const Color(0xFF64748B),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 6.h),
                            InkWell(
                              onTap: () async {
                                final picked = await showDatePicker(
                                  context: context,
                                  initialDate: startDate,
                                  firstDate: DateTime(now.year - 10),
                                  lastDate: endDate,
                                );
                                if (picked != null) {
                                  setModalState(() {
                                    startDate = picked;
                                  });
                                }
                              },
                              borderRadius: BorderRadius.circular(12.r),
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                                decoration: BoxDecoration(
                                  color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
                                  borderRadius: BorderRadius.circular(12.r),
                                  border: Border.all(
                                    color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.calendar_today_rounded, size: 16, color: AppColors.primaryTeal),
                                    SizedBox(width: 8.w),
                                    Expanded(
                                      child: Text(
                                        '${startDate.day}/${startDate.month}/${startDate.year}',
                                        style: TextStyle(
                                          fontSize: 13.sp,
                                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'End Date',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: isDark ? Colors.white60 : const Color(0xFF64748B),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 6.h),
                            InkWell(
                              onTap: () async {
                                final picked = await showDatePicker(
                                  context: context,
                                  initialDate: endDate,
                                  firstDate: startDate,
                                  lastDate: DateTime(now.year + 5),
                                );
                                if (picked != null) {
                                  setModalState(() {
                                    endDate = picked;
                                  });
                                }
                              },
                              borderRadius: BorderRadius.circular(12.r),
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                                decoration: BoxDecoration(
                                  color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
                                  borderRadius: BorderRadius.circular(12.r),
                                  border: Border.all(
                                    color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.calendar_today_rounded, size: 16, color: AppColors.primaryTeal),
                                    SizedBox(width: 8.w),
                                    Expanded(
                                      child: Text(
                                        '${endDate.day}/${endDate.month}/${endDate.year}',
                                        style: TextStyle(
                                          fontSize: 13.sp,
                                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24.h),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 14.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          child: const Text('Cancel'),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            onDateFilterChanged(
                              dateFilter.copyWith(
                                type: DateFilterType.custom,
                                customStartDate: startDate,
                                customEndDate: endDate,
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryTeal,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 14.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          child: const Text(
                            'Apply Filter',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

