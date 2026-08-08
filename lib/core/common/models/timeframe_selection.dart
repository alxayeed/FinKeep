import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum TimeframeType {
  monthly,
  yearly,
  fiscalYearly,
  custom,
  allTime,
}

extension TimeframeTypeExtension on TimeframeType {
  String get label {
    switch (this) {
      case TimeframeType.monthly:
        return 'Monthly';
      case TimeframeType.yearly:
        return 'Yearly';
      case TimeframeType.fiscalYearly:
        return 'Fiscal Year';
      case TimeframeType.custom:
        return 'Custom Range';
      case TimeframeType.allTime:
        return 'All Time';
    }
  }
}

class TimeframeSelection {
  final TimeframeType type;
  final DateTime referenceDate; // Used for monthly, yearly, fiscalYearly navigation
  final DateTime? customStartDate;
  final DateTime? customEndDate;
  final int fiscalYearStartMonth; // Default 7 (July)

  TimeframeSelection({
    required this.type,
    required this.referenceDate,
    this.customStartDate,
    this.customEndDate,
    this.fiscalYearStartMonth = 7,
  });

  factory TimeframeSelection.defaultMonthly() {
    return TimeframeSelection(
      type: TimeframeType.monthly,
      referenceDate: DateTime.now(),
    );
  }

  TimeframeSelection copyWith({
    TimeframeType? type,
    DateTime? referenceDate,
    DateTime? customStartDate,
    DateTime? customEndDate,
    int? fiscalYearStartMonth,
  }) {
    return TimeframeSelection(
      type: type ?? this.type,
      referenceDate: referenceDate ?? this.referenceDate,
      customStartDate: customStartDate ?? this.customStartDate,
      customEndDate: customEndDate ?? this.customEndDate,
      fiscalYearStartMonth: fiscalYearStartMonth ?? this.fiscalYearStartMonth,
    );
  }

  /// Switch to a new [TimeframeType] while preserving the logical period being viewed.
  ///
  /// Unlike [copyWith], this method normalises [referenceDate] so that the displayed
  /// period stays consistent after a type change. For example:
  ///   - FY 2026-27 (referenceDate = Jan 2027) → Yearly  → Year 2026 (not 2027)
  ///   - FY 2026-27 (referenceDate = Jan 2027) → Monthly → January 2027
  ///   - Yearly 2025          (referenceDate = Jul 2025) → Monthly → July 2025
  TimeframeSelection withType(TimeframeType newType) {
    if (newType == type) return this;

    DateTime newReferenceDate = referenceDate;

    if (type == TimeframeType.fiscalYearly) {
      // When leaving fiscalYearly, normalise to the FY start year so that yearly/monthly
      // views reflect the same fiscal period the user was on.
      //   FY 2026-27 (referenceDate = Jan 2027) → Yearly  → Year 2026
      //   FY 2026-27 (referenceDate = Jan 2027) → Monthly → January 2027 (keep as-is)
      final fyStartYear = referenceDate.month >= fiscalYearStartMonth
          ? referenceDate.year
          : referenceDate.year - 1;

      switch (newType) {
        case TimeframeType.yearly:
          // Anchor to Jan 1 of the FY start year so displayTitle shows "Year <fyStartYear>"
          newReferenceDate = DateTime(fyStartYear, 1);
          break;
        case TimeframeType.monthly:
          // Keep the exact month the user was browsing within the FY
          newReferenceDate = referenceDate;
          break;
        default:
          newReferenceDate = referenceDate;
      }
    } else if (type == TimeframeType.yearly && newType == TimeframeType.fiscalYearly) {
      // When switching Yearly → FiscalYearly, anchor to the FY that *starts* in the
      // selected year, so "Year 2027" consistently maps to FY 2027-28.
      //
      // We do this by setting referenceDate to the FY start month of that year.
      // That guarantees: referenceDate.month == fiscalYearStartMonth >= fiscalYearStartMonth
      // → fyStartYear = referenceDate.year = the selected year.
      newReferenceDate = DateTime(referenceDate.year, fiscalYearStartMonth);
    }

    return copyWith(type: newType, referenceDate: newReferenceDate);
  }

  /// Get formatted display title for header pill
  String get displayTitle {
    final now = DateTime.now();
    switch (type) {
      case TimeframeType.monthly:
        if (referenceDate.year == now.year && referenceDate.month == now.month) {
          return DateFormat('d MMMM, yyyy').format(now);
        }
        return DateFormat('MMMM yyyy').format(referenceDate);
      case TimeframeType.yearly:
        return 'Year ${referenceDate.year}';
      case TimeframeType.fiscalYearly:
        final fyStartYear = referenceDate.month >= fiscalYearStartMonth
            ? referenceDate.year
            : referenceDate.year - 1;
        final fyEndYear = fyStartYear + 1;
        final startMonthName = DateFormat('MMM').format(DateTime(2026, fiscalYearStartMonth));
        final endMonthNum = fiscalYearStartMonth == 1 ? 12 : fiscalYearStartMonth - 1;
        final endMonthName = DateFormat('MMM').format(DateTime(2026, endMonthNum));
        return 'FY $fyStartYear-${fyEndYear.toString().substring(2)} ($startMonthName-$endMonthName)';
      case TimeframeType.custom:
        if (customStartDate != null && customEndDate != null) {
          final startStr = DateFormat('MMM d').format(customStartDate!);
          final endStr = DateFormat('MMM d, yyyy').format(customEndDate!);
          return '$startStr - $endStr';
        }
        return 'Custom Range';
      case TimeframeType.allTime:
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
      case TimeframeType.monthly:
        final start = DateTime(referenceDate.year, referenceDate.month, 1);
        final end = DateTime(referenceDate.year, referenceDate.month + 1, 0, 23, 59, 59);
        return DateTimeRange(start: start, end: end);

      case TimeframeType.yearly:
        final start = DateTime(referenceDate.year, 1, 1);
        final end = DateTime(referenceDate.year, 12, 31, 23, 59, 59);
        return DateTimeRange(start: start, end: end);

      case TimeframeType.fiscalYearly:
        final fyStartYear = referenceDate.month >= fiscalYearStartMonth
            ? referenceDate.year
            : referenceDate.year - 1;
        final start = DateTime(fyStartYear, fiscalYearStartMonth, 1);
        final end = DateTime(fyStartYear + 1, fiscalYearStartMonth, 0, 23, 59, 59);
        return DateTimeRange(start: start, end: end);

      case TimeframeType.custom:
        if (customStartDate != null && customEndDate != null) {
          final start = DateTime(customStartDate!.year, customStartDate!.month, customStartDate!.day);
          final end = DateTime(customEndDate!.year, customEndDate!.month, customEndDate!.day, 23, 59, 59);
          return DateTimeRange(start: start, end: end);
        }
        return null;

      case TimeframeType.allTime:
        return null;
    }
  }

  /// Determines if a date falls within the selected timeframe
  bool contains(DateTime date) {
    final range = dateRange;
    if (range == null) return true; // All time
    return (date.isAfter(range.start) || date.isAtSameMomentAs(range.start)) &&
        (date.isBefore(range.end) || date.isAtSameMomentAs(range.end));
  }

  /// Step backward in time (for prev chevron)
  TimeframeSelection previous() {
    switch (type) {
      case TimeframeType.monthly:
        final prevMonth = DateTime(
          referenceDate.month == 1 ? referenceDate.year - 1 : referenceDate.year,
          referenceDate.month == 1 ? 12 : referenceDate.month - 1,
        );
        return copyWith(referenceDate: prevMonth);

      case TimeframeType.yearly:
        return copyWith(referenceDate: DateTime(referenceDate.year - 1, referenceDate.month));

      case TimeframeType.fiscalYearly:
        return copyWith(referenceDate: DateTime(referenceDate.year - 1, referenceDate.month));

      case TimeframeType.custom:
      case TimeframeType.allTime:
        return this;
    }
  }

  /// Step forward in time (for next chevron)
  TimeframeSelection next() {
    switch (type) {
      case TimeframeType.monthly:
        final nextMonth = DateTime(
          referenceDate.month == 12 ? referenceDate.year + 1 : referenceDate.year,
          referenceDate.month == 12 ? 1 : referenceDate.month + 1,
        );
        return copyWith(referenceDate: nextMonth);

      case TimeframeType.yearly:
        return copyWith(referenceDate: DateTime(referenceDate.year + 1, referenceDate.month));

      case TimeframeType.fiscalYearly:
        return copyWith(referenceDate: DateTime(referenceDate.year + 1, referenceDate.month));

      case TimeframeType.custom:
      case TimeframeType.allTime:
        return this;
    }
  }
}
