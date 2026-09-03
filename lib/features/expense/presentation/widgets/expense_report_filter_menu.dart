import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/common/models/date_filter.dart';
import '../../../../core/common/widgets/app_date_filter.dart';
import '../../../../core/responsive/responsive.dart';
import '../../../../core/styles/app_colors.dart';
import '../controllers/expense_category_controller.dart';
import '../controllers/expense_report_controller.dart';
import '../controllers/monthly_expense_controller.dart';

/// Shows the streamlined on-screen Data Filter Modal Sheet (Date Range & Categories).
void showExpenseReportFilterMenu(
  BuildContext context, {
  DateFilter? dateFilter,
  List<String>? initialCategories,
}) {
  final isDark = Theme.of(context).brightness == Brightness.dark;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (modalContext) {
      return Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF0F172A) : Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
          border: Border.all(
            color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
            width: 1,
          ),
        ),
        child: _ExpenseReportFilterMenuContent(
          initialDateFilter: dateFilter,
          initialCategories: initialCategories,
        ),
      );
    },
  );
}

class _ExpenseReportFilterMenuContent extends StatefulWidget {
  final DateFilter? initialDateFilter;
  final List<String>? initialCategories;

  const _ExpenseReportFilterMenuContent({
    this.initialDateFilter,
    this.initialCategories,
  });

  @override
  State<_ExpenseReportFilterMenuContent> createState() =>
      _ExpenseReportFilterMenuContentState();
}

class _ExpenseReportFilterMenuContentState
    extends State<_ExpenseReportFilterMenuContent> {
  late final ExpenseCategoryController categoryController;

  late DateFilter _dateFilter;
  Set<String> _selectedCategories = <String>{};

  @override
  void initState() {
    super.initState();
    categoryController = Get.isRegistered<ExpenseCategoryController>()
        ? Get.find<ExpenseCategoryController>()
        : Get.put(
            ExpenseCategoryController(
              addCategoryUseCase: Get.find(),
              getCategoriesUseCase: Get.find(),
              updateCategoryUseCase: Get.find(),
              deleteCategoryUseCase: Get.find(),
            ),
          );

    if (widget.initialDateFilter != null) {
      _dateFilter = widget.initialDateFilter!.copyWith();
    } else if (Get.isRegistered<ExpenseReportController>()) {
      _dateFilter =
          Get.find<ExpenseReportController>().dateFilter.value.copyWith();
    } else if (Get.isRegistered<MonthlyExpenseController>()) {
      _dateFilter =
          Get.find<MonthlyExpenseController>().dateFilter.value.copyWith();
    } else {
      _dateFilter = DateFilter.defaultMonthly();
    }

    if (widget.initialCategories != null) {
      _selectedCategories = widget.initialCategories!.toSet();
    } else if (Get.isRegistered<ExpenseReportController>()) {
      _selectedCategories =
          Get.find<ExpenseReportController>().selectedCategories.toSet();
    }
  }

  void _handleResetDefaults() {
    Navigator.of(context).pop();

    if (Get.isRegistered<ExpenseReportController>()) {
      final ctrl = Get.find<ExpenseReportController>();
      final defaultFilter = DateFilter(
        type: DateFilterType.yearly,
        referenceDate: DateTime.now(),
      );

      final isAlreadyDefault = ctrl.dateFilter.value == defaultFilter &&
          ctrl.selectedCategories.isEmpty;

      if (!isAlreadyDefault) {
        ctrl.resetReportFilters();
      }
    }
  }

  void _handleApplyFilters() {
    Navigator.of(context).pop();

    if (Get.isRegistered<ExpenseReportController>()) {
      final ctrl = Get.find<ExpenseReportController>();

      final isDateSame = ctrl.dateFilter.value == _dateFilter;
      final isCategorySame =
          setEquals(ctrl.selectedCategories.toSet(), _selectedCategories);

      final hasNoChange = isDateSame && isCategorySame;

      if (hasNoChange) return;

      ctrl.applyReportFilters(
        newDateFilter: _dateFilter,
        categories: _selectedCategories.toList(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final mutedColor =
        isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final cardBorder =
        isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);

    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Drag Handle
            Center(
              child: Container(
                width: 36.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: isDark ? Colors.white24 : Colors.black12,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
            SizedBox(height: 12.h),

            // 2. Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(7.r),
                        decoration: BoxDecoration(
                          color: AppColors.primaryTeal.withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.tune_rounded,
                          size: 16.sp,
                          color: AppColors.primaryTeal,
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Filter Menu',
                              style: TextStyle(
                                fontFamily: 'Manrope',
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                color: textColor,
                              ),
                            ),
                            Text(
                              'Filter report analytics & transactions list',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: 'Manrope',
                                fontSize: 11.sp,
                                color: mutedColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8.w),
                IconButton(
                  icon: Icon(Icons.close_rounded,
                      size: 20.sp, color: mutedColor),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            SizedBox(height: 16.h),

            // 3. Inline Date Filter
            Text(
              'Date Period Range',
              style: TextStyle(
                fontFamily: 'Manrope',
                fontWeight: FontWeight.w600,
                fontSize: 12.sp,
                color: mutedColor,
              ),
            ),
            SizedBox(height: 8.h),
            AppDateFilter.inline(
              dateFilter: _dateFilter,
              onDateFilterChanged: (newFilter) {
                setState(() {
                  _dateFilter = newFilter;
                });
              },
            ),
            SizedBox(height: 16.h),

            // 4. Multi-Select Category Chips (Ultra-Compact)
            Text(
              'Category Filter (Multi-Select)',
              style: TextStyle(
                fontFamily: 'Manrope',
                fontWeight: FontWeight.w600,
                fontSize: 12.sp,
                color: mutedColor,
              ),
            ),
            SizedBox(height: 8.h),
            Obx(() {
              final categories = categoryController.categories;

              return Wrap(
                spacing: 6.w,
                runSpacing: 6.h,
                children: [
                  FilterChip(
                    label: const Text('✨ All Categories'),
                    selected: _selectedCategories.isEmpty,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategories.clear();
                      });
                    },
                    selectedColor: AppColors.primaryTeal,
                    backgroundColor: isDark
                        ? const Color(0xFF1E293B)
                        : const Color(0xFFF1F5F9),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                    padding:
                        EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                    labelStyle: TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 10.5.sp,
                      fontWeight: _selectedCategories.isEmpty
                          ? FontWeight.bold
                          : FontWeight.w600,
                      color: _selectedCategories.isEmpty
                          ? Colors.white
                          : textColor,
                    ),
                    side: BorderSide(
                      color: _selectedCategories.isEmpty
                          ? AppColors.primaryTeal
                          : cardBorder,
                      width: 1,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    showCheckmark: false,
                  ),
                  ...categories.map((cat) {
                    final isSelected =
                        _selectedCategories.contains(cat.displayLabel);
                    final emoji =
                        cat.emoji.isNotEmpty ? '${cat.emoji} ' : '';

                    return FilterChip(
                      label: Text('$emoji${cat.displayLabel}'),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            _selectedCategories.add(cat.displayLabel);
                          } else {
                            _selectedCategories.remove(cat.displayLabel);
                          }
                        });
                      },
                      selectedColor: AppColors.primaryTeal,
                      backgroundColor: isDark
                          ? const Color(0xFF1E293B)
                          : const Color(0xFFF1F5F9),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: VisualDensity.compact,
                      padding:
                          EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                      labelStyle: TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 10.5.sp,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected ? Colors.white : textColor,
                      ),
                      side: BorderSide(
                        color: isSelected
                            ? AppColors.primaryTeal
                            : cardBorder,
                        width: 1,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      showCheckmark: false,
                    );
                  }),
                ],
              );
            }),
            SizedBox(height: 24.h),

            // 5. Action Buttons Bar (Clear & Apply)
            Row(
              children: [
                // Clear / Reset Button
                OutlinedButton.icon(
                  icon: Icon(Icons.restart_alt_rounded, size: 18.sp),
                  label: const Text('Clear'),
                  onPressed: _handleResetDefaults,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: mutedColor,
                    side: BorderSide(color: cardBorder),
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    textStyle: TextStyle(
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.bold,
                      fontSize: 13.sp,
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                // Apply Filters Button
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.tune_rounded, size: 18),
                    label: const Text('Apply Filters'),
                    onPressed: _handleApplyFilters,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryTeal,
                      foregroundColor: Colors.white,
                      elevation: 1,
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                      textStyle: TextStyle(
                        fontFamily: 'Manrope',
                        fontWeight: FontWeight.bold,
                        fontSize: 13.sp,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
