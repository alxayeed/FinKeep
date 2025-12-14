import 'package:intl/intl.dart';

extension DateTimeFormatter on DateTime {
  String formatToReadableShort() {
    final formattedDay = DateFormat('EEE, d MMMM').format(this);
    return formattedDay;
  }

  String formatToReadable() {
    final formattedDay = DateFormat('EEE, d MMMM • hh:mm a').format(this);
    return formattedDay;
  }

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
