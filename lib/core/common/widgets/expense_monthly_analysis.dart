import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spendly/core/common/widgets/custom_divider.dart';
import 'package:spendly/core/extensions/double_ext.dart';
import 'package:spendly/core/responsive/responsive.dart';
import '../../../features/expense/domain/entities/expense_entity.dart';

class ExpenseMonthlyAnalysis extends StatelessWidget {
  final List<ExpenseEntity> expenses;

  const ExpenseMonthlyAnalysis({
    super.key,
    required this.expenses,
  });

  Map<String, double> _getMonthlyAggregates() {
    final Map<String, double> monthlyTotals = {};
    final DateFormat formatter = DateFormat('MMM yyyy');

    for (var expense in expenses) {
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
            "${amount.toCurrency()} ৳",
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
            "${amount.toCurrency()} ৳",
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

    if (monthlyData.isEmpty) {
      return const SizedBox.shrink();
    }

    final List<MapEntry<String, double>> sortedMonthlyData =
        monthlyData.entries.toList();

    final DateFormat keyParser = DateFormat('MMM yyyy');
    sortedMonthlyData.sort((a, b) {
      final DateTime dateA = keyParser.parse(a.key);
      final DateTime dateB = keyParser.parse(b.key);
      return dateA.compareTo(dateB);
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 4.w, bottom: 8.h),
                child: Text(
                  'Summary by Month',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
              ),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: sortedMonthlyData.length,
                separatorBuilder: (context, index) => SizedBox(height: 8.h),
                itemBuilder: (context, index) {
                  final entry = sortedMonthlyData[index];
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
        const CustomDivider(),
        SizedBox(height: 12.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 4.w, bottom: 8.h),
                child: Text(
                  'High/Low/Avg (Month)',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
              ),
              _buildSummaryStatRow(
                'Highest (${summary['highestMonth']})',
                summary['highestAmount'],
                isDark ? Colors.red.shade400 : Colors.red.shade600,
                isDark,
              ),
              _buildSummaryStatRow(
                'Lowest (${summary['lowestMonth']})',
                summary['lowestAmount'],
                isDark ? Colors.green.shade400 : Colors.green.shade600,
                isDark,
              ),
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
