import 'package:spendly/features/investments/domain/entities/return_entry.dart';

class ReturnEntryModel extends ReturnEntry {
  ReturnEntryModel({
    required super.id,
    required super.amountReceived,
    required super.date,
    required super.transactionId,
    required super.medium,
    required super.notes,
  });

  factory ReturnEntryModel.fromJson(Map<String, dynamic> json) {
    return ReturnEntryModel(
      id: json['id'],
      amountReceived: (json['amountReceived'] as num).toDouble(),
      date: DateTime.parse(json['date']),
      transactionId: json['transactionId'],
      medium: json['medium'],
      notes: json['notes'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amountReceived': amountReceived,
      'date': date.toIso8601String(),
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
