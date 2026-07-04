enum DashboardTimeframe {
  currentMonth,
  last3Months,
  last6Months,
  last12Months,
  custom,
}

extension DashboardTimeframeExtension on DashboardTimeframe {
  String get displayName {
    switch (this) {
      case DashboardTimeframe.currentMonth:
        return 'Current Month';
      case DashboardTimeframe.last3Months:
        return 'Last 3 Months';
      case DashboardTimeframe.last6Months:
        return 'Last 6 Months';
      case DashboardTimeframe.last12Months:
        return 'Last 12 Months';
      case DashboardTimeframe.custom:
        return 'Custom Range';
    }
  }
}
