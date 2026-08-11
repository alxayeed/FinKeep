import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum DateFilterType {
  monthly,
  yearly,
  fiscalYearly,
  custom,
  allTime,
}

extension DateFilterTypeExtension on DateFilterType {
  String get label {
    switch (this) {
      case DateFilterType.monthly:
        return 'Monthly';
      case DateFilterType.yearly:
        return 'Yearly';
      case DateFilterType.fiscalYearly:
        return 'Fiscal Year';
      case DateFilterType.custom:
        return 'Custom Range';
      case DateFilterType.allTime:
        return 'All Time';
    }
  }
}

class DateFilter {
  final DateFilterType type;
  final DateTime referenceDate; // Used for monthly, yearly, fiscalYearly navigation
  final DateTime? customStartDate;
  final DateTime? customEndDate;
  final int fiscalYearStartMonth; // Default 7 (July)

  DateFilter({
    required this.type,
    required this.referenceDate,
    this.customStartDate,
    this.customEndDate,
    this.fiscalYearStartMonth = 7,
  });

  factory DateFilter.defaultMonthly() {
    return DateFilter(
      type: DateFilterType.monthly,
      referenceDate: DateTime.now(),
    );
  }

  DateFilter copyWith({
    DateFilterType? type,
    DateTime? referenceDate,
    DateTime? customStartDate,
    DateTime? customEndDate,
    int? fiscalYearStartMonth,
  }) {
    return DateFilter(
      type: type ?? this.type,
      referenceDate: referenceDate ?? this.referenceDate,
      customStartDate: customStartDate ?? this.customStartDate,
      customEndDate: customEndDate ?? this.customEndDate,
      fiscalYearStartMonth: fiscalYearStartMonth ?? this.fiscalYearStartMonth,
    );
  }

  /// Switch to a new [DateFilterType] while preserving the logical period being viewed.
  DateFilter withType(DateFilterType newType) {
    if (newType == type) return this;

    DateTime newReferenceDate = referenceDate;

    if (type == DateFilterType.fiscalYearly) {
      final fyStartYear = referenceDate.month >= fiscalYearStartMonth
          ? referenceDate.year
          : referenceDate.year - 1;

      switch (newType) {
        case DateFilterType.yearly:
          newReferenceDate = DateTime(fyStartYear, 1);
          break;
        case DateFilterType.monthly:
          newReferenceDate = referenceDate;
          break;
        default:
          newReferenceDate = referenceDate;
      }
    } else if (type == DateFilterType.yearly && newType == DateFilterType.fiscalYearly) {
      newReferenceDate = DateTime(referenceDate.year, fiscalYearStartMonth);
    }

    return copyWith(type: newType, referenceDate: newReferenceDate);
  }

  /// Get formatted display title for header pill
  String get displayTitle {
    final now = DateTime.now();
    switch (type) {
      case DateFilterType.monthly:
        if (referenceDate.year == now.year && referenceDate.month == now.month) {
          return DateFormat('d MMMM, yyyy').format(now);
        }
        return DateFormat('MMMM yyyy').format(referenceDate);
      case DateFilterType.yearly:
        return 'Year ${referenceDate.year}';
      case DateFilterType.fiscalYearly:
        final fyStartYear = referenceDate.month >= fiscalYearStartMonth
            ? referenceDate.year
            : referenceDate.year - 1;
        final fyEndYear = fyStartYear + 1;
        final startMonthName = DateFormat('MMM').format(DateTime(2026, fiscalYearStartMonth));
        final endMonthNum = fiscalYearStartMonth == 1 ? 12 : fiscalYearStartMonth - 1;
        final endMonthName = DateFormat('MMM').format(DateTime(2026, endMonthNum));
        return 'FY $fyStartYear-${fyEndYear.toString().substring(2)} ($startMonthName-$endMonthName)';
      case DateFilterType.custom:
        if (customStartDate != null && customEndDate != null) {
          final startStr = DateFormat('MMM d').format(customStartDate!);
          final endStr = DateFormat('MMM d, yyyy').format(customEndDate!);
          return '$startStr - $endStr';
        }
        return 'Custom Range';
      case DateFilterType.allTime:
        return 'All Time';
    }
  }

  /// Format detailed fiscal year date period (e.g., July 1 - June 30)
  String get fiscalYearPeriodSubtitle {
    final startMonthName = DateFormat('MMMM').format(DateTime(2026, fiscalYearStartMonth));
    final endMonthNum = fiscalYearStartMonth == 1 ? 12 : fiscalYearStartMonth - 1;
    final endMonthName = DateFormat('MMMM').format(DateTime(2026, endMonthNum));
    final endMonthLastDay = DateTime(2026, endMonthNum + 1, 0).day;
    return '$startMonthName 1 - $endMonthName $endMonthLastDay';
  }

  /// Calculates start and end dates for data filtering
  DateTimeRange? get dateRange {
    switch (type) {
      case DateFilterType.monthly:
        final start = DateTime(referenceDate.year, referenceDate.month, 1);
        final end = DateTime(referenceDate.year, referenceDate.month + 1, 0, 23, 59, 59);
        return DateTimeRange(start: start, end: end);

      case DateFilterType.yearly:
        final start = DateTime(referenceDate.year, 1, 1);
        final end = DateTime(referenceDate.year, 12, 31, 23, 59, 59);
        return DateTimeRange(start: start, end: end);

      case DateFilterType.fiscalYearly:
        final fyStartYear = referenceDate.month >= fiscalYearStartMonth
            ? referenceDate.year
            : referenceDate.year - 1;
        final start = DateTime(fyStartYear, fiscalYearStartMonth, 1);
        final end = DateTime(fyStartYear + 1, fiscalYearStartMonth, 0, 23, 59, 59);
        return DateTimeRange(start: start, end: end);

      case DateFilterType.custom:
        if (customStartDate != null && customEndDate != null) {
          final start = DateTime(customStartDate!.year, customStartDate!.month, customStartDate!.day);
          final end = DateTime(customEndDate!.year, customEndDate!.month, customEndDate!.day, 23, 59, 59);
          return DateTimeRange(start: start, end: end);
        }
        return null;

      case DateFilterType.allTime:
        return null;
    }
  }

  /// Determines if a date falls within the selected date filter
  bool contains(DateTime date) {
    final range = dateRange;
    if (range == null) return true; // All time
    return (date.isAfter(range.start) || date.isAtSameMomentAs(range.start)) &&
        (date.isBefore(range.end) || date.isAtSameMomentAs(range.end));
  }

  /// Step backward in time (for prev chevron)
  DateFilter previous() {
    switch (type) {
      case DateFilterType.monthly:
        final prevMonth = DateTime(
          referenceDate.month == 1 ? referenceDate.year - 1 : referenceDate.year,
          referenceDate.month == 1 ? 12 : referenceDate.month - 1,
        );
        return copyWith(referenceDate: prevMonth);

      case DateFilterType.yearly:
        return copyWith(referenceDate: DateTime(referenceDate.year - 1, referenceDate.month));

      case DateFilterType.fiscalYearly:
        return copyWith(referenceDate: DateTime(referenceDate.year - 1, referenceDate.month));

      case DateFilterType.custom:
      case DateFilterType.allTime:
        return this;
    }
  }

  /// Step forward in time (for next chevron)
  DateFilter next() {
    switch (type) {
      case DateFilterType.monthly:
        final nextMonth = DateTime(
          referenceDate.month == 12 ? referenceDate.year + 1 : referenceDate.year,
          referenceDate.month == 12 ? 1 : referenceDate.month + 1,
        );
        return copyWith(referenceDate: nextMonth);

      case DateFilterType.yearly:
        return copyWith(referenceDate: DateTime(referenceDate.year + 1, referenceDate.month));

      case DateFilterType.fiscalYearly:
        return copyWith(referenceDate: DateTime(referenceDate.year + 1, referenceDate.month));

      case DateFilterType.custom:
      case DateFilterType.allTime:
        return this;
    }
  }
}
