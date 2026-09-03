import 'package:flutter/material.dart';
import '../../../../core/common/models/date_filter.dart';
import '../../../../core/common/widgets/app_toast.dart';
import '../../../../core/responsive/responsive.dart';
import '../../../../core/styles/app_colors.dart';
import '../../../../core/styles/currency_provider.dart';
import '../../data/services/expense_pdf_service.dart';
import '../../domain/entities/expense_pdf_report_config.dart';
import '../controllers/expense_report_controller.dart';
import '../screens/expense_report_pdf_viewer_screen.dart';

/// Shows the dedicated PDF Export Configuration modal bottom sheet.
void showExpensePdfExportSheet(
  BuildContext context, {
  required ExpenseReportController controller,
}) {
  final isDark = Theme.of(context).brightness == Brightness.dark;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (modalContext) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(modalContext).viewInsets.bottom,
        ),
        child: _ExpensePdfExportSheetContent(
          controller: controller,
          isDark: isDark,
        ),
      );
    },
  );
}

class _ExpensePdfExportSheetContent extends StatefulWidget {
  final ExpenseReportController controller;
  final bool isDark;

  const _ExpensePdfExportSheetContent({
    required this.controller,
    required this.isDark,
  });

  @override
  State<_ExpensePdfExportSheetContent> createState() =>
      _ExpensePdfExportSheetContentState();
}

class _ExpensePdfExportSheetContentState
    extends State<_ExpensePdfExportSheetContent> {
  late ExpenseReportPdfMode _selectedMode;
  late bool _includeCategorySummary;
  late bool _includeMonthlyBreakdown;
  late bool _includePaymentMethods;
  bool _isGenerating = false;

  bool get _isMultiMonth {
    final range = widget.controller.dateFilter.value.dateRange;
    if (range == null) return true;
    final start = range.start;
    final end = range.end;
    return start.year != end.year || start.month != end.month;
  }

  @override
  void initState() {
    super.initState();
    final ctrl = widget.controller;
    _selectedMode = ctrl.listMode.value;
    _includeCategorySummary = ctrl.includeCategorySummary.value;
    _includeMonthlyBreakdown = ctrl.includeMonthlyBreakdown.value;
    _includePaymentMethods = ctrl.includePaymentMethodBreakdown.value;
  }

  Future<void> _handleGeneratePdf() async {
    if (_isGenerating) return;

    setState(() {
      _isGenerating = true;
    });

    final ctrl = widget.controller;
    // Sync preferences back to controller
    ctrl.listMode.value = _selectedMode;
    ctrl.includeCategorySummary.value = _includeCategorySummary;
    ctrl.includeMonthlyBreakdown.value = _includeMonthlyBreakdown;
    ctrl.includePaymentMethodBreakdown.value = _includePaymentMethods;

    final filter = ctrl.dateFilter.value;
    final currency = context.currency;

    DateTime start = ctrl.startDate.value ?? DateTime(DateTime.now().year, 1, 1);
    DateTime end = ctrl.endDate.value ??
        DateTime(DateTime.now().year, 12, 31, 23, 59, 59);
    final range = filter.dateRange;
    if (range != null) {
      start = range.start;
      end = range.end;
    }

    final isMultiMonth = filter.type != DateFilterType.monthly &&
        (start.year != end.year || start.month != end.month);

    final config = ExpensePdfReportConfig(
      startDate: start,
      endDate: end,
      currencySymbol: currency.symbol,
      selectedCategory: ctrl.selectedCategories.length == 1
          ? ctrl.selectedCategories.first
          : 'All',
      selectedCategories: ctrl.selectedCategories.toList(),
      mode: _selectedMode,
      includeCategorySummary: _includeCategorySummary,
      includeMonthlyBreakdown: isMultiMonth && _includeMonthlyBreakdown,
      includePaymentMethodBreakdown: _includePaymentMethods,
      includeHighLowAvgMetrics:
          isMultiMonth && ctrl.includeHighLowAvgMetrics.value,
    );

    try {
      final pdfBytes = await ExpensePdfService().generateExpensePdf(
        expenses: ctrl.reportFilteredExpenses.toList(),
        config: config,
      );

      if (!mounted) return;
      setState(() {
        _isGenerating = false;
      });
      Navigator.of(context).pop(); // Dismiss bottom sheet

      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ExpenseReportPdfViewerScreen(
            pdfBytes: pdfBytes,
            config: config,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isGenerating = false;
      });
      AppToast.showError(
        context,
        message: 'Failed to generate PDF: $e',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    final textColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final mutedColor =
        isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final cardBorder =
        isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);

    return Material(
      color: isDark ? AppColors.cardDark : AppColors.cardLight,
      borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      child: SafeArea(
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
                            color:
                                AppColors.primaryTeal.withValues(alpha: 0.12),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.picture_as_pdf_rounded,
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
                                'Export PDF Report',
                                style: TextStyle(
                                  fontFamily: 'Manrope',
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                ),
                              ),
                              Text(
                                'Choose statement layout and breakdown sections',
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

              // 3. Transaction Layout Section
              Text(
                'Transaction Layout',
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
                    child: _buildLayoutOption(
                      mode: ExpenseReportPdfMode.compact,
                      title: 'Category Summary',
                      subtitle: 'Aggregated subtotals',
                      icon: Icons.pie_chart_outline_rounded,
                      isSelected: _selectedMode == ExpenseReportPdfMode.compact,
                      isDark: isDark,
                      textColor: textColor,
                      mutedColor: mutedColor,
                      cardBorder: cardBorder,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: _buildLayoutOption(
                      mode: ExpenseReportPdfMode.details,
                      title: 'Detailed Statement',
                      subtitle: 'Line-by-line transactions',
                      icon: Icons.list_alt_rounded,
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

              // 4. PDF Export Sections (Optional Breakdowns)
              Text(
                'Include in PDF Report',
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
                    label: const Text('📊 Category Breakdown'),
                    selected: _includeCategorySummary,
                    onSelected: (val) =>
                        setState(() => _includeCategorySummary = val),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                    padding:
                        EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
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
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                      side: BorderSide(
                        color: _includeCategorySummary
                            ? AppColors.primaryTeal
                            : cardBorder,
                        width: 1,
                      ),
                    ),
                    showCheckmark: false,
                  ),
                  FilterChip(
                    label: Text(_isMultiMonth
                        ? '📈 Monthly Trend'
                        : '📈 Monthly Trend (Multi-month)'),
                    selected: _isMultiMonth && _includeMonthlyBreakdown,
                    onSelected: _isMultiMonth
                        ? (val) => setState(() => _includeMonthlyBreakdown = val)
                        : null,
                    disabledColor:
                        isDark ? Colors.white10 : const Color(0xFFF1F5F9),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                    padding:
                        EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
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
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                      side: BorderSide(
                        color: (_isMultiMonth && _includeMonthlyBreakdown)
                            ? AppColors.primaryTeal
                            : cardBorder,
                        width: 1,
                      ),
                    ),
                    showCheckmark: false,
                  ),
                  FilterChip(
                    label: const Text('💳 Payment Methods'),
                    selected: _includePaymentMethods,
                    onSelected: (val) =>
                        setState(() => _includePaymentMethods = val),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                    padding:
                        EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                    labelStyle: TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 10.5.sp,
                      fontWeight: _includePaymentMethods
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: _includePaymentMethods ? Colors.white : textColor,
                    ),
                    selectedColor: AppColors.primaryTeal,
                    backgroundColor: isDark
                        ? const Color(0xFF1E293B)
                        : const Color(0xFFF1F5F9),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                      side: BorderSide(
                        color: _includePaymentMethods
                            ? AppColors.primaryTeal
                            : cardBorder,
                        width: 1,
                      ),
                    ),
                    showCheckmark: false,
                  ),
                ],
              ),
              SizedBox(height: 20.h),

              // 5. Generate PDF Action Button
              SizedBox(
                width: double.infinity,
                height: 44.h,
                child: ElevatedButton.icon(
                  onPressed: _isGenerating ? null : _handleGeneratePdf,
                  icon: _isGenerating
                      ? SizedBox(
                          width: 16.sp,
                          height: 16.sp,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Icon(
                          Icons.picture_as_pdf_rounded,
                          size: 18.sp,
                          color: Colors.white,
                        ),
                  label: Text(
                    _isGenerating ? 'Generating PDF...' : 'Preview & Generate PDF',
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 13.5.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryTeal,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLayoutOption({
    required ExpenseReportPdfMode mode,
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isSelected,
    required bool isDark,
    required Color textColor,
    required Color mutedColor,
    required Color cardBorder,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedMode = mode;
          });
        },
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primaryTeal.withValues(alpha: isDark ? 0.18 : 0.08)
                : (isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC)),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: isSelected ? AppColors.primaryTeal : cardBorder,
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 18.sp,
                color: isSelected ? AppColors.primaryTeal : mutedColor,
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 12.sp,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.w600,
                        color: isSelected ? AppColors.primaryTeal : textColor,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 10.sp,
                        color: mutedColor,
                      ),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check_circle_rounded,
                  size: 16.sp,
                  color: AppColors.primaryTeal,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
