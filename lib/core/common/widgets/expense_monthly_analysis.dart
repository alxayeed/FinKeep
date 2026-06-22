import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:finkeep/core/extensions/double_ext.dart';
import 'package:finkeep/core/responsive/responsive.dart';
import 'package:finkeep/core/styles/app_colors.dart';
import 'package:finkeep/core/styles/currency_provider.dart';
import 'package:get/get.dart';
import '../../../features/expense/presentation/controllers/expense_report_controller.dart';
import '../../../features/expense/domain/entities/expense_entity.dart';

class ExpenseMonthlyAnalysis extends StatefulWidget {
  final List<ExpenseEntity> expenses;

  const ExpenseMonthlyAnalysis({
    super.key,
    required this.expenses,
  });

  @override
  State<ExpenseMonthlyAnalysis> createState() => _ExpenseMonthlyAnalysisState();
}

class _ExpenseMonthlyAnalysisState extends State<ExpenseMonthlyAnalysis> {
  int _currentPage = 0;
  static const int _pageSize = 12;

  @override
  void didUpdateWidget(covariant ExpenseMonthlyAnalysis oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reset page if widget is updated to ensure no out-of-bounds index mapping
    _currentPage = 0;
  }

  Map<String, double> _getMonthlyAggregates() {
    final Map<String, double> monthlyTotals = {};
    final DateFormat formatter = DateFormat('MMM yyyy');

    DateTime? start;
    DateTime? end;

    if (Get.isRegistered<ExpenseReportController>()) {
      final controller = Get.find<ExpenseReportController>();
      start = controller.startDate.value;
      end = controller.endDate.value;
    }

    final now = DateTime.now();
    start ??= DateTime(now.year, 1, 1);
    end ??= DateTime(now.year, 12, 31);

    DateTime current = DateTime(start.year, start.month, 1);
    DateTime targetEnd = DateTime(end.year, end.month, 1);
    final DateTime currentMonthStart = DateTime(now.year, now.month, 1);
    if (targetEnd.isAfter(currentMonthStart)) {
      targetEnd = currentMonthStart;
    }

    while (!current.isAfter(targetEnd)) {
      final key = formatter.format(current);
      monthlyTotals[key] = 0.0;
      current = DateTime(current.year, current.month + 1, 1);
    }

    for (var expense in widget.expenses) {
      final monthYearKey = formatter.format(expense.date);
      monthlyTotals.update(
        monthYearKey,
        (value) => value + expense.amount,
        ifAbsent: () => expense.amount,
      );
    }
    return monthlyTotals;
  }

  Map<String, dynamic> _getSummary(Map<String, double> monthlyTotals) {
    if (monthlyTotals.isEmpty) {
      return {
        'highestMonth': 'N/A',
        'highestAmount': 0.0,
        'lowestMonth': 'N/A',
        'lowestAmount': 0.0,
        'average': 0.0,
      };
    }

    final currentMonthKey = DateFormat('MMM yyyy').format(DateTime.now());

    double maxAmount = -1;
    String maxMonth = 'N/A';

    double minAmount = double.infinity;
    String minMonth = 'N/A';

    double totalSum = 0;
    int count = monthlyTotals.length;

    monthlyTotals.forEach((month, amount) {
      // Average calculation includes the current month
      totalSum += amount;

      // Omit current month from highest and lowest calculation
      if (month != currentMonthKey) {
        if (amount > maxAmount) {
          maxAmount = amount;
          maxMonth = month;
        }
        if (amount < minAmount) {
          minAmount = amount;
          minMonth = month;
        }
      }
    });

    // Fallbacks if only the current month is present
    if (maxMonth == 'N/A') {
      maxMonth = currentMonthKey;
      maxAmount = monthlyTotals[currentMonthKey] ?? 0.0;
    }
    if (minMonth == 'N/A') {
      minMonth = currentMonthKey;
      minAmount = monthlyTotals[currentMonthKey] ?? 0.0;
    }

    return {
      'highestMonth': maxMonth,
      'highestAmount': maxAmount,
      'lowestMonth': minMonth,
      'lowestAmount': minAmount,
      'average': count > 0 ? totalSum / count : 0.0,
    };
  }

  Widget _buildBreakdownRow(String label, double amount, bool isDark) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 13.sp,
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.white.withValues(alpha: 0.9) : const Color(0xFF334155),
            ),
          ),
          Text(
            "${amount.toCurrency()} ${context.currency.symbol}",
            style: TextStyle(
              fontSize: 13.sp,
              fontFamily: 'Manrope',
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryStatRow(String label, double amount, Color amountColor, bool isDark) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 13.sp,
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.white.withValues(alpha: 0.9) : const Color(0xFF334155),
            ),
          ),
          Text(
            "${amount.toCurrency()} ${context.currency.symbol}",
            style: TextStyle(
              fontSize: 13.sp,
              fontFamily: 'Manrope',
              fontWeight: FontWeight.bold,
              color: amountColor,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final monthlyData = _getMonthlyAggregates();
    final summary = _getSummary(monthlyData);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final List<MapEntry<String, double>> sortedMonthlyData;
    if (monthlyData.isEmpty) {
      final currentMonthKey = DateFormat('MMM yyyy').format(DateTime.now());
      sortedMonthlyData = [MapEntry(currentMonthKey, 0.0)];
    } else {
      sortedMonthlyData = monthlyData.entries.toList();
      final DateFormat keyParser = DateFormat('MMM yyyy');
      sortedMonthlyData.sort((a, b) {
        final DateTime dateA = keyParser.parse(a.key);
        final DateTime dateB = keyParser.parse(b.key);
        return dateA.compareTo(dateB);
      });
    }

    // Pagination bounds calculation
    final int startIdx = _currentPage * _pageSize;
    final int endIdx = (startIdx + _pageSize).clamp(0, sortedMonthlyData.length);
    final displayedData = sortedMonthlyData.sublist(startIdx, endIdx);

    final bool hasPrev = _currentPage > 0;
    final bool hasNext = (startIdx + _pageSize) < sortedMonthlyData.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 1. Summary by Month Card
        Container(
          padding: EdgeInsets.all(18.r),
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardDark : AppColors.cardLight,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 10.r,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'SUMMARY BY MONTH',
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white38 : const Color(0xFF94A3B8),
                      letterSpacing: 1.2,
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: hasPrev
                            ? () {
                                setState(() {
                                  _currentPage--;
                                });
                              }
                            : null,
                        behavior: HitTestBehavior.opaque,
                        child: Container(
                          padding: EdgeInsets.all(2.r),
                          child: Icon(
                            Icons.chevron_left,
                            size: 18.sp,
                            color: hasPrev
                                ? (isDark ? Colors.white70 : const Color(0xFF475569))
                                : (isDark ? Colors.white10 : const Color(0xFFCBD5E1)),
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      GestureDetector(
                        onTap: hasNext
                            ? () {
                                setState(() {
                                  _currentPage++;
                                });
                              }
                            : null,
                        behavior: HitTestBehavior.opaque,
                        child: Container(
                          padding: EdgeInsets.all(2.r),
                          child: Icon(
                            Icons.chevron_right,
                            size: 18.sp,
                            color: hasNext
                                ? (isDark ? Colors.white70 : const Color(0xFF475569))
                                : (isDark ? Colors.white10 : const Color(0xFFCBD5E1)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: displayedData.length,
                separatorBuilder: (context, index) => SizedBox(height: 6.h),
                itemBuilder: (context, index) {
                  final entry = displayedData[index];
                  return _buildBreakdownRow(
                    entry.key,
                    entry.value,
                    isDark,
                  );
                },
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        // 2. High/Low/Avg Card
        Container(
          padding: EdgeInsets.all(18.r),
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardDark : AppColors.cardLight,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 10.r,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'HIGH/LOW/AVG (MONTH)',
                style: TextStyle(
                  fontSize: 10.sp,
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white38 : const Color(0xFF94A3B8),
                  letterSpacing: 1.2,
                ),
              ),
              SizedBox(height: 12.h),
              _buildSummaryStatRow(
                'Highest (${summary['highestMonth']})',
                summary['highestAmount'],
                isDark ? Colors.red.shade400 : Colors.red.shade600,
                isDark,
              ),
              SizedBox(height: 6.h),
              _buildSummaryStatRow(
                'Lowest (${summary['lowestMonth']})',
                summary['lowestAmount'],
                isDark ? Colors.green.shade400 : Colors.green.shade600,
                isDark,
              ),
              SizedBox(height: 6.h),
              _buildSummaryStatRow(
                'Average',
                summary['average'],
                isDark ? Colors.white70 : const Color(0xFF475569),
                isDark,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
