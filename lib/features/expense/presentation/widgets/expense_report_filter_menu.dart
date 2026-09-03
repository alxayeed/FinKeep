import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:finkeep/core/common/models/date_filter.dart';
import 'package:finkeep/core/common/widgets/app_date_filter.dart';
import 'package:finkeep/core/responsive/responsive.dart';
import 'package:finkeep/core/styles/app_colors.dart';
import '../../domain/entities/expense_pdf_report_config.dart';
import '../controllers/expense_category_controller.dart';
import '../controllers/expense_report_controller.dart';
import '../controllers/monthly_expense_controller.dart';

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
  ExpenseReportPdfMode _selectedMode = ExpenseReportPdfMode.compact;

  bool _includeCategorySummary = true;
  bool _includeMonthlyBreakdown = true;
  bool _includePaymentMethodBreakdown = true;
  bool _includeHighLowAvgMetrics = true;

  bool get _isMultiMonth {
    final range = _dateFilter.dateRange;
    if (range == null) return true;
    final start = range.start;
    final end = range.end;
    return start.year != end.year || start.month != end.month;
  }

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
      _dateFilter = Get.find<ExpenseReportController>().dateFilter.value.copyWith();
    } else if (Get.isRegistered<MonthlyExpenseController>()) {
      _dateFilter = Get.find<MonthlyExpenseController>().dateFilter.value.copyWith();
    } else {
      _dateFilter = DateFilter.defaultMonthly();
    }

    if (widget.initialCategories != null) {
      _selectedCategories = widget.initialCategories!.toSet();
    } else if (Get.isRegistered<ExpenseReportController>()) {
      _selectedCategories = Get.find<ExpenseReportController>().selectedCategories.toSet();
    }

    if (Get.isRegistered<ExpenseReportController>()) {
      final ctrl = Get.find<ExpenseReportController>();
      _selectedMode = ctrl.listMode.value;
      _includeCategorySummary = ctrl.includeCategorySummary.value;
      _includeMonthlyBreakdown = ctrl.includeMonthlyBreakdown.value;
      _includePaymentMethodBreakdown = ctrl.includePaymentMethodBreakdown.value;
      _includeHighLowAvgMetrics = ctrl.includeHighLowAvgMetrics.value;
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
          ctrl.selectedCategories.isEmpty &&
          ctrl.listMode.value == ExpenseReportPdfMode.compact &&
          ctrl.includeCategorySummary.value == true &&
          ctrl.includeMonthlyBreakdown.value == true &&
          ctrl.includePaymentMethodBreakdown.value == true &&
          ctrl.includeHighLowAvgMetrics.value == true;

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
      final isCategorySame = setEquals(ctrl.selectedCategories.toSet(), _selectedCategories);
      final isModeSame = ctrl.listMode.value == _selectedMode;
      final isSummarySame = ctrl.includeCategorySummary.value == _includeCategorySummary;
      final isMonthlySame = ctrl.includeMonthlyBreakdown.value == _includeMonthlyBreakdown;
      final isPaymentSame = ctrl.includePaymentMethodBreakdown.value == _includePaymentMethodBreakdown;
      final isMetricsSame = ctrl.includeHighLowAvgMetrics.value == _includeHighLowAvgMetrics;

      final hasNoChange = isDateSame &&
          isCategorySame &&
          isModeSame &&
          isSummarySame &&
          isMonthlySame &&
          isPaymentSame &&
          isMetricsSame;

      if (!hasNoChange) {
        ctrl.applyReportFilters(
          newDateFilter: _dateFilter,
          categories: _selectedCategories.toList(),
          mode: _selectedMode,
          categorySummary: _includeCategorySummary,
          monthlyBreakdown: _includeMonthlyBreakdown,
          paymentMethodBreakdown: _includePaymentMethodBreakdown,
          highLowAvgMetrics: _includeHighLowAvgMetrics,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final mutedColor = isDark ? Colors.white60 : const Color(0xFF64748B);
    final cardBorder = isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0);

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 20.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Drag Handle
              Center(
                child: Container(
                  width: 36.w,
                  height: 4.h,
                  margin: EdgeInsets.only(bottom: 12.h),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white24 : const Color(0xFFCBD5E1),
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),

              // 2. Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.tune_rounded,
                        size: 20.sp,
                        color: AppColors.primaryTeal,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        'Filter Menu',
                        style: TextStyle(
                          fontFamily: 'Manrope',
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                          color: textColor,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: Icon(Icons.close_rounded, size: 20.sp, color: mutedColor),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              SizedBox(height: 16.h),

              // 3. Inline Date Filter
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
                      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
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
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    ...categories.map((cat) {
                      final isSelected =
                          _selectedCategories.contains(cat.displayLabel);
                      return FilterChip(
                        label: Text(
                          cat.emoji.isNotEmpty
                              ? '${cat.emoji} ${cat.displayLabel}'
                              : cat.displayLabel,
                        ),
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
                        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                        labelStyle: TextStyle(
                          fontFamily: 'Manrope',
                          fontSize: 10.5.sp,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.w600,
                          color: isSelected ? Colors.white : textColor,
                        ),
                        side: BorderSide(
                          color: isSelected
                              ? AppColors.primaryTeal
                              : cardBorder,
                          width: 1,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      );
                    }),
                  ],
                );
              }),
              SizedBox(height: 16.h),

              // 5. Layout Mode (Compact vs Details)
              Text(
                'Transaction List Style',
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w600,
                  fontSize: 12.sp,
                  color: mutedColor,
                ),
              ),
              SizedBox(height: 8.h),
              Row(
                children: [
                  Expanded(
                    child: _buildModeOption(
                      mode: ExpenseReportPdfMode.compact,
                      title: 'Compact',
                      subtitle: 'Date • Category • Sum',
                      isSelected: _selectedMode == ExpenseReportPdfMode.compact,
                      isDark: isDark,
                      textColor: textColor,
                      mutedColor: mutedColor,
                      cardBorder: cardBorder,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: _buildModeOption(
                      mode: ExpenseReportPdfMode.details,
                      title: 'Details',
                      subtitle: 'Itemized with Notes',
                      isSelected: _selectedMode == ExpenseReportPdfMode.details,
                      isDark: isDark,
                      textColor: textColor,
                      mutedColor: mutedColor,
                      cardBorder: cardBorder,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),

              // 6. Summary Sections (Optional)
              Text(
                'Summary Sections (On-Screen & PDF)',
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w600,
                  fontSize: 12.sp,
                  color: mutedColor,
                ),
              ),
              SizedBox(height: 8.h),
              Wrap(
                spacing: 6.w,
                runSpacing: 6.h,
                children: [
                  FilterChip(
                    label: const Text('📊 By Category'),
                    selected: _includeCategorySummary,
                    onSelected: (val) =>
                        setState(() => _includeCategorySummary = val),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                    labelStyle: TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 10.5.sp,
                      fontWeight: _includeCategorySummary
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: _includeCategorySummary ? Colors.white : textColor,
                    ),
                    selectedColor: AppColors.primaryTeal,
                    backgroundColor: isDark
                        ? const Color(0xFF1E293B)
                        : const Color(0xFFF1F5F9),
                    side: BorderSide(
                      color: _includeCategorySummary
                          ? AppColors.primaryTeal
                          : cardBorder,
                      width: 1,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  FilterChip(
                    label: Text(_isMultiMonth
                        ? '📅 By Month'
                        : '📅 By Month (Multi-month)'),
                    selected: _isMultiMonth && _includeMonthlyBreakdown,
                    onSelected: _isMultiMonth
                        ? (val) => setState(() => _includeMonthlyBreakdown = val)
                        : null,
                    disabledColor:
                        isDark ? Colors.white10 : const Color(0xFFF1F5F9),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                    labelStyle: TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 10.5.sp,
                      fontWeight: (_isMultiMonth && _includeMonthlyBreakdown)
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: !_isMultiMonth
                          ? mutedColor.withValues(alpha: 0.5)
                          : (_includeMonthlyBreakdown
                              ? Colors.white
                              : textColor),
                    ),
                    selectedColor: AppColors.primaryTeal,
                    backgroundColor: isDark
                        ? const Color(0xFF1E293B)
                        : const Color(0xFFF1F5F9),
                    side: BorderSide(
                      color: (_isMultiMonth && _includeMonthlyBreakdown)
                          ? AppColors.primaryTeal
                          : cardBorder,
                      width: 1,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  FilterChip(
                    label: const Text('💳 By Payment Method'),
                    selected: _includePaymentMethodBreakdown,
                    onSelected: (val) =>
                        setState(() => _includePaymentMethodBreakdown = val),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                    labelStyle: TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 10.5.sp,
                      fontWeight: _includePaymentMethodBreakdown
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: _includePaymentMethodBreakdown
                          ? Colors.white
                          : textColor,
                    ),
                    selectedColor: AppColors.primaryTeal,
                    backgroundColor: isDark
                        ? const Color(0xFF1E293B)
                        : const Color(0xFFF1F5F9),
                    side: BorderSide(
                      color: _includePaymentMethodBreakdown
                          ? AppColors.primaryTeal
                          : cardBorder,
                      width: 1,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  FilterChip(
                    label: Text(_isMultiMonth
                        ? '📈 Min / Max / Avg'
                        : '📈 Min / Max / Avg (Multi-month)'),
                    selected: _isMultiMonth && _includeHighLowAvgMetrics,
                    onSelected: _isMultiMonth
                        ? (val) => setState(() => _includeHighLowAvgMetrics = val)
                        : null,
                    disabledColor:
                        isDark ? Colors.white10 : const Color(0xFFF1F5F9),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                    labelStyle: TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 10.5.sp,
                      fontWeight: (_isMultiMonth && _includeHighLowAvgMetrics)
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: !_isMultiMonth
                          ? mutedColor.withValues(alpha: 0.5)
                          : (_includeHighLowAvgMetrics
                              ? Colors.white
                              : textColor),
                    ),
                    selectedColor: AppColors.primaryTeal,
                    backgroundColor: isDark
                        ? const Color(0xFF1E293B)
                        : const Color(0xFFF1F5F9),
                    side: BorderSide(
                      color: (_isMultiMonth && _includeHighLowAvgMetrics)
                          ? AppColors.primaryTeal
                          : cardBorder,
                      width: 1,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.h),

              // 7. Action Buttons Bar (Clear & Apply)
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
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
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
      ),
    );
  }

  Widget _buildModeOption({
    required ExpenseReportPdfMode mode,
    required String title,
    required String subtitle,
    required bool isSelected,
    required bool isDark,
    required Color textColor,
    required Color mutedColor,
    required Color cardBorder,
  }) {
    return InkWell(
      onTap: () => setState(() => _selectedMode = mode),
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryTeal.withValues(alpha: 0.1)
              : (isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC)),
          border: Border.all(
            color: isSelected ? AppColors.primaryTeal : cardBorder,
            width: isSelected ? 1.5 : 1,
          ),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isSelected
                      ? Icons.radio_button_checked
                      : Icons.radio_button_off,
                  size: 16.sp,
                  color: isSelected ? AppColors.primaryTeal : mutedColor,
                ),
                SizedBox(width: 6.w),
                Flexible(
                  child: Text(
                    title,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.bold,
                      fontSize: 12.5.sp,
                      color: isSelected ? AppColors.primaryTeal : textColor,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 3.h),
            Text(
              subtitle,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: 'Manrope',
                fontSize: 10.5.sp,
                color: mutedColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
