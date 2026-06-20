import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finkeep/features/investments/domain/entities/return_entry.dart';

class ReturnEntryModel extends ReturnEntry {
  ReturnEntryModel({
    required super.id,
    required super.amountReceived,
    required super.date,
    required super.transactionId,
    required super.medium,
    required super.notes,
  });

  /// Plain Dart deserialization — used by Hive.
  factory ReturnEntryModel.fromJson(Map<String, dynamic> json) {
    return ReturnEntryModel(
      id: json['id'] as String,
      amountReceived: (json['amountReceived'] as num).toDouble(),
      date: json['date'] as DateTime,
      transactionId: json['transactionId'] as String,
      medium: json['medium'] as String,
      notes: json['notes'] as String? ?? '',
    );
  }

  /// Firestore-specific deserialization — reads Firestore Timestamps.
  factory ReturnEntryModel.fromFirestoreMap(Map<String, dynamic> json) {
    return ReturnEntryModel(
      id: json['id'] as String,
      amountReceived: (json['amountReceived'] as num).toDouble(),
      date: (json['date'] as Timestamp).toDate(),
      transactionId: json['transactionId'] as String,
      medium: json['medium'] as String,
      notes: json['notes'] as String? ?? '',
    );
  }

  /// Plain Dart serialization — used by Hive.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amountReceived': amountReceived,
      'date': date,
      'transactionId': transactionId,
      'medium': medium,
      'notes': notes,
    };
  }

  /// Firestore-specific serialization — stores dates as Timestamps.
  Map<String, dynamic> toFirestoreMap() {
    return {
      'id': id,
      'amountReceived': amountReceived,
      'date': Timestamp.fromDate(date),
      'transactionId': transactionId,
      'medium': medium,
      'notes': notes,
    };
  }

  factory ReturnEntryModel.fromEntity(ReturnEntry entry) {
    return ReturnEntryModel(
      id: entry.id,
      amountReceived: entry.amountReceived,
      date: entry.date,
      transactionId: entry.transactionId,
      medium: entry.medium,
      notes: entry.notes,
    );
  }
}
