import 'package:cloud_firestore/cloud_firestore.dart';

class DateParser {
  /// Safely parses dynamic values (Timestamp, String, int, DateTime) to a [DateTime].
  static DateTime parse(dynamic val) {
    if (val == null) {
      throw const FormatException('Date value cannot be null');
    }
    if (val is Timestamp) {
      return val.toDate();
    } else if (val is String) {
      return DateTime.parse(val);
    } else if (val is int) {
      return DateTime.fromMillisecondsSinceEpoch(val);
    } else if (val is DateTime) {
      return val;
    }
    throw FormatException('Invalid date format: $val (${val.runtimeType})');
  }
}
