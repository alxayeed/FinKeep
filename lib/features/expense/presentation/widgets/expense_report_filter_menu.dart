import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:finkeep/core/common/models/date_filter.dart';
import 'package:finkeep/core/common/widgets/styled_multi_category_selector_field.dart';
import 'package:finkeep/core/providers/privacy_provider.dart';
import 'package:finkeep/core/responsive/responsive.dart';
import 'package:finkeep/core/styles/app_colors.dart';
import 'package:finkeep/core/styles/currency_provider.dart';
import '../../data/services/expense_pdf_service.dart';
import '../../domain/entities/expense_pdf_report_config.dart';
import '../../domain/usecases/usecases.dart';
import '../controllers/expense_category_controller.dart';
import '../controllers/expense_report_controller.dart';
import '../controllers/monthly_expense_controller.dart';
import '../screens/expense_report_pdf_viewer_screen.dart';

void showExpenseReportFilterMenu(
  BuildContext context, {
  DateFilter? dateFilter,
}) {
  final isDark = Theme.of(context).brightness == Brightness.dark;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: isDark ? AppColors.cardDark : AppColors.cardLight,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
    ),
    builder: (modalContext) => _ExpenseReportFilterMenuContent(
      initialDateFilter: dateFilter,
    ),
  );
}

class _ExpenseReportFilterMenuContent extends StatefulWidget {
  final DateFilter? initialDateFilter;

  const _ExpenseReportFilterMenuContent({this.initialDateFilter});

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
  bool _isGenerating = false;

  // Optional Summary Section Toggles - Pre-selected by default to match report screen
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

    // Initialize with passed filter or controller's active date filter
    if (widget.initialDateFilter != null) {
      _dateFilter = widget.initialDateFilter!.copyWith();
    } else if (Get.isRegistered<ExpenseReportController>()) {
      _dateFilter = Get.find<ExpenseReportController>().dateFilter.value.copyWith();
    } else if (Get.isRegistered<MonthlyExpenseController>()) {
      _dateFilter = Get.find<MonthlyExpenseController>().dateFilter.value.copyWith();
    } else {
      _dateFilter = DateFilter.defaultMonthly();
    }

    final multiMonth = _isMultiMonth;
    _includeMonthlyBreakdown = multiMonth;
    _includeHighLowAvgMetrics = multiMonth;
  }

  Future<void> _handleGeneratePdf() async {
    if (_isGenerating) return;

    final currency = context.currency;

    // Biometric / PIN Verification Check (like revealing expense amounts)
    final authenticated = await PrivacyProvider().authenticate(context);
    if (!authenticated || !mounted) {
      return;
    }

    setState(() => _isGenerating = true);

    try {
      final range = _dateFilter.dateRange;
      final DateTime startDate = range?.start ?? DateTime(2000, 1, 1);
      final DateTime endDate = range?.end ?? DateTime(2100, 12, 31, 23, 59, 59);

      final config = ExpensePdfReportConfig(
        startDate: startDate,
        endDate: endDate,
        selectedCategories: _selectedCategories.isEmpty ? const ['All'] : _selectedCategories.toList(),
        mode: _selectedMode,
        currencySymbol: currency.symbol,
        currencyCode: currency.code,
        includeCategorySummary: _includeCategorySummary,
        includeMonthlyBreakdown: _isMultiMonth && _includeMonthlyBreakdown,
        includePaymentMethodBreakdown: _includePaymentMethodBreakdown,
        includeHighLowAvgMetrics: _isMultiMonth && _includeHighLowAvgMetrics,
      );

      final getExpensesUseCase = Get.find<GetExpensesInRangeUseCase>();
      final expenses = await getExpensesUseCase(startDate, endDate);

      final pdfService = ExpensePdfService();
      final pdfBytes = await pdfService.generateExpensePdf(
        config: config,
        expenses: expenses,
      );

      if (!mounted) return;
      Navigator.of(context).pop(); // Close bottom sheet

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ExpenseReportPdfViewerScreen(
            pdfBytes: pdfBytes,
            config: config,
          ),
        ),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error generating PDF: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isGenerating = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final mutedColor = isDark ? Colors.white60 : const Color(0xFF64748B);
    final cardBorder = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 20.h),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Drag Handle
              Center(
                child: Container(
                  width: 40.w,
                  height: 4.h,
                  margin: EdgeInsets.only(bottom: 16.h),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white24 : Colors.black12,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),

              // 2. Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Filter Menu',
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                        color: textColor,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close_rounded, size: 20.sp, color: mutedColor),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              SizedBox(height: 12.h),

              // 3. Active Date Period (Inherited from Screen Filter)
              Text(
                'Date Period',
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w600,
                  fontSize: 12.sp,
                  color: mutedColor,
                ),
              ),
              SizedBox(height: 6.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: cardBorder),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_month_rounded,
                      size: 18.sp,
                      color: AppColors.primaryTeal,
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        _dateFilter.displayTitle,
                        style: TextStyle(
                          fontFamily: 'Manrope',
                          fontWeight: FontWeight.bold,
                          fontSize: 13.sp,
                          color: textColor,
                        ),
                      ),
                    ),
                    Text(
                      'From screen filter',
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 11.sp,
                        color: mutedColor,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),

              // 4. Multi-Select Category Dropdown Filter
              Obx(() {
                final categoryNames = categoryController.categories
                    .map((c) => c.displayLabel)
                    .toList();

                return StyledMultiCategorySelectorField<String>(
                  selectedItems: _selectedCategories,
                  labelText: 'Category Filter (Multi-Select)',
                  items: categoryNames,
                  titleExtractor: (item) => item,
                  allSelectedText: 'All Categories',
                  placeholder: 'Select Categories',
                  onSelectionChanged: (updated) {
                    setState(() => _selectedCategories = updated);
                  },
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

              // 6. Optional Summary Breakdown Toggles
              Text(
                'Include Summary Sections (Optional)',
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w600,
                  fontSize: 12.sp,
                  color: mutedColor,
                ),
              ),
              SizedBox(height: 8.h),
              Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: [
                  FilterChip(
                    label: const Text('📊 Category Summary'),
                    selected: _includeCategorySummary,
                    onSelected: (val) => setState(() => _includeCategorySummary = val),
                    labelStyle: TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 11.sp,
                      fontWeight: _includeCategorySummary ? FontWeight.bold : FontWeight.normal,
                      color: _includeCategorySummary ? Colors.white : textColor,
                    ),
                    selectedColor: AppColors.primaryTeal,
                    backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                    side: BorderSide(
                      color: _includeCategorySummary ? AppColors.primaryTeal : cardBorder,
                      width: 1,
                    ),
                  ),
                  FilterChip(
                    label: Text(_isMultiMonth ? '📅 By Month' : '📅 By Month (Multi-month)'),
                    selected: _isMultiMonth && _includeMonthlyBreakdown,
                    onSelected: _isMultiMonth
                        ? (val) => setState(() => _includeMonthlyBreakdown = val)
                        : null,
                    disabledColor: isDark ? Colors.white10 : const Color(0xFFF1F5F9),
                    labelStyle: TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 11.sp,
                      fontWeight: (_isMultiMonth && _includeMonthlyBreakdown) ? FontWeight.bold : FontWeight.normal,
                      color: !_isMultiMonth
                          ? mutedColor.withValues(alpha: 0.5)
                          : (_includeMonthlyBreakdown ? Colors.white : textColor),
                    ),
                    selectedColor: AppColors.primaryTeal,
                    backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                    side: BorderSide(
                      color: (_isMultiMonth && _includeMonthlyBreakdown) ? AppColors.primaryTeal : cardBorder,
                      width: 1,
                    ),
                  ),
                  FilterChip(
                    label: const Text('💳 By Payment Method'),
                    selected: _includePaymentMethodBreakdown,
                    onSelected: (val) => setState(() => _includePaymentMethodBreakdown = val),
                    labelStyle: TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 11.sp,
                      fontWeight: _includePaymentMethodBreakdown ? FontWeight.bold : FontWeight.normal,
                      color: _includePaymentMethodBreakdown ? Colors.white : textColor,
                    ),
                    selectedColor: AppColors.primaryTeal,
                    backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                    side: BorderSide(
                      color: _includePaymentMethodBreakdown ? AppColors.primaryTeal : cardBorder,
                      width: 1,
                    ),
                  ),
                  FilterChip(
                    label: Text(_isMultiMonth ? '📈 High / Low / Avg (Month)' : '📈 High / Low / Avg (Multi-month)'),
                    selected: _isMultiMonth && _includeHighLowAvgMetrics,
                    onSelected: _isMultiMonth
                        ? (val) => setState(() => _includeHighLowAvgMetrics = val)
                        : null,
                    disabledColor: isDark ? Colors.white10 : const Color(0xFFF1F5F9),
                    labelStyle: TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 11.sp,
                      fontWeight: (_isMultiMonth && _includeHighLowAvgMetrics) ? FontWeight.bold : FontWeight.normal,
                      color: !_isMultiMonth
                          ? mutedColor.withValues(alpha: 0.5)
                          : (_includeHighLowAvgMetrics ? Colors.white : textColor),
                    ),
                    selectedColor: AppColors.primaryTeal,
                    backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                    side: BorderSide(
                      color: (_isMultiMonth && _includeHighLowAvgMetrics) ? AppColors.primaryTeal : cardBorder,
                      width: 1,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.h),

              // 7. Generate Button
              ElevatedButton(
                onPressed: _isGenerating ? null : _handleGeneratePdf,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryTeal,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  elevation: 0,
                ),
                child: _isGenerating
                    ? SizedBox(
                        height: 20.h,
                        width: 20.h,
                        child: const CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.picture_as_pdf_rounded, size: 18.sp),
                          SizedBox(width: 8.w),
                          Flexible(
                            child: Text(
                              'Generate & Preview PDF',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: 'Manrope',
                                fontWeight: FontWeight.bold,
                                fontSize: 13.5.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
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
                      fontSize: 13.sp,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? AppColors.primaryTeal : textColor,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 4.h),
            Text(
              subtitle,
              style: TextStyle(
                fontFamily: 'Manrope',
                fontSize: 9.5.sp,
                color: mutedColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
