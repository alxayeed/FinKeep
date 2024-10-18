import 'package:intl/intl.dart';

extension DateTimeFormatter on DateTime {
  String formatToReadable() {
    final dayWithSuffix = '$day${_getDaySuffix(day)}';
    final formattedTime =
        DateFormat('hh:mm a').format(this); // 12-hour time format with AM/PM
    final formattedMonth = DateFormat('MMMM').format(this); // Month part
    return '$formattedTime, $dayWithSuffix $formattedMonth'; // Final format: Time, DayWithSuffix Month
  }

  String _getDaySuffix(int day) {
    if (day >= 11 && day <= 13) {
      return 'th';
    }
    switch (day % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }

  // String formatTime() {
  //   final String hour = this.hour.toString().padLeft(2, '0');
  //   final String minute = this.minute.toString().padLeft(2, '0');
  //   final String period = this.hour >= 12 ? 'PM' : 'AM';
  //   return '$hour:$minute $period';
  // }

  String formatDate() {
    final day = this.day;
    final month = this.month;
    final year = this.year;

    // Determine the suffix for the day (st, nd, rd, th)
    String suffix;
    if (day >= 11 && day <= 13) {
      suffix = 'th';
    } else {
      switch (day % 10) {
        case 1:
          suffix = 'st';
          break;
        case 2:
          suffix = 'nd';
          break;
        case 3:
          suffix = 'rd';
          break;
        default:
          suffix = 'th';
      }
    }

    // Format the month name
    final monthName = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ][month - 1];

    // Return formatted date
    return '$day$suffix $monthName, $year';
  }
}
