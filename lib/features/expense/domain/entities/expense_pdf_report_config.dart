import 'package:equatable/equatable.dart';
import 'expense_entity.dart';

enum ExpenseReportPdfMode {
  compact,
  details;

  String get displayName {
    switch (this) {
      case ExpenseReportPdfMode.compact:
        return 'Compact';
      case ExpenseReportPdfMode.details:
        return 'Details';
    }
  }
}

class CompactExpenseRow extends Equatable {
  final DateTime date;
  final String category;
  final double totalAmount;

  const CompactExpenseRow({
    required this.date,
    required this.category,
    required this.totalAmount,
  });

  @override
  List<Object?> get props => [date, category, totalAmount];
}

class ExpensePdfReportConfig extends Equatable {
  final DateTime startDate;
  final DateTime endDate;
  final String selectedCategory;
  final List<String> selectedCategories;
  final ExpenseReportPdfMode mode;
  final String currencySymbol;
  final String currencyCode;
  final bool includeCategorySummary;
  final bool includeMonthlyBreakdown;
  final bool includePaymentMethodBreakdown;
  final bool includeHighLowAvgMetrics;

  const ExpensePdfReportConfig({
    required this.startDate,
    required this.endDate,
    this.selectedCategory = 'All',
    this.selectedCategories = const ['All'],
    this.mode = ExpenseReportPdfMode.compact,
    this.currencySymbol = '৳',
    this.currencyCode = 'BDT',
    this.includeCategorySummary = false,
    this.includeMonthlyBreakdown = false,
    this.includePaymentMethodBreakdown = false,
    this.includeHighLowAvgMetrics = false,
  });

  /// Returns effective selected categories list
  List<String> get effectiveCategories {
    if (selectedCategories.isNotEmpty && !selectedCategories.contains('All')) {
      return selectedCategories;
    }
    if (selectedCategory.isNotEmpty && selectedCategory.toLowerCase() != 'all') {
      return [selectedCategory];
    }
    return const [];
  }

  @override
  List<Object?> get props => [
        startDate,
        endDate,
        selectedCategory,
        selectedCategories,
        mode,
        currencySymbol,
        currencyCode,
        includeCategorySummary,
        includeMonthlyBreakdown,
        includePaymentMethodBreakdown,
        includeHighLowAvgMetrics,
      ];
}

/// Pure domain helper to group multiple expenses of the same date and category into single summed rows.
List<CompactExpenseRow> groupExpensesForCompactMode(List<ExpenseEntity> expenses) {
  final Map<String, CompactExpenseRow> grouped = {};

  for (final expense in expenses) {
    final dateKey =
        '${expense.date.year}-${expense.date.month.toString().padLeft(2, '0')}-${expense.date.day.toString().padLeft(2, '0')}';
    final groupKey = '${dateKey}_${expense.category.trim().toLowerCase()}';

    if (grouped.containsKey(groupKey)) {
      final existing = grouped[groupKey]!;
      grouped[groupKey] = CompactExpenseRow(
        date: existing.date,
        category: existing.category,
        totalAmount: existing.totalAmount + expense.amount,
      );
    } else {
      grouped[groupKey] = CompactExpenseRow(
        date: DateTime(expense.date.year, expense.date.month, expense.date.day),
        category: expense.category,
        totalAmount: expense.amount,
      );
    }
  }

  final result = grouped.values.toList()
    ..sort((a, b) {
      final dateCompare = a.date.compareTo(b.date);
      if (dateCompare != 0) return dateCompare;
      return a.category.compareTo(b.category);
    });

  return result;
}
