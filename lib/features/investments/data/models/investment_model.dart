import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finkeep/core/enums/payment_type.dart';
import 'package:finkeep/core/utils/date_parser.dart';
import 'package:finkeep/features/investments/domain/entities/investment.dart';

import '../../domain/enums/investment_status.dart';
import 'return_entry_model.dart';

class InvestmentModel extends Investment {
  InvestmentModel({
    required super.id,
    required super.title,
    required super.amountInvested,
    required super.startDate,
    required super.expectedEndDate,
    required super.platformName,
    required super.profitRate,
    required super.expectedROI,
    required super.notes,
    required super.docLinks,
    required super.transactionId,
    required super.transactionMedium,
    required super.transactionDate,
    required super.status,
    required super.returns,
  });

  /// Plain Dart deserialization — used by Hive.
  factory InvestmentModel.fromJson(Map<String, dynamic> json) {
    return InvestmentModel(
      id: json['id'] as String,
      title: json['title'] as String,
      amountInvested: (json['amountInvested'] as num).toDouble(),
      startDate: DateParser.parse(json['startDate']),
      expectedEndDate: DateParser.parse(json['expectedEndDate']),
      platformName: json['platformName'] as String,
      profitRate: json['profitRate'],
      expectedROI: (json['expectedROI'] as num).toDouble(),
      notes: json['notes'] as String? ?? '',
      docLinks: json['docLinks'] as String? ?? '',
      transactionId: json['transactionId'] as String,
      transactionMedium: PaymentTypeExtension.fromString(
          json['transactionMedium'] as String? ?? 'CASH'),
      transactionDate: DateParser.parse(json['transactionDate']),
      status: InvestmentStatus.values.firstWhere(
        (e) => e.toString() == 'InvestmentStatus.${json['status']}',
      ),
      returns: (json['returns'] as List<dynamic>?)
              ?.map((e) =>
                  ReturnEntryModel.fromJson(Map<String, dynamic>.from(e as Map)))
              .toList() ??
          [],
    );
  }

  /// Firestore-specific deserialization — reads Firestore Timestamps.
  factory InvestmentModel.fromFirestoreMap(Map<String, dynamic> json) {
    return InvestmentModel(
      id: json['id'] as String,
      title: json['title'] as String,
      amountInvested: (json['amountInvested'] as num).toDouble(),
      startDate: DateParser.parse(json['startDate']),
      expectedEndDate: DateParser.parse(json['expectedEndDate']),
      platformName: json['platformName'] as String,
      profitRate: json['profitRate'],
      expectedROI: (json['expectedROI'] as num).toDouble(),
      notes: json['notes'] as String? ?? '',
      docLinks: json['docLinks'] as String? ?? '',
      transactionId: json['transactionId'] as String,
      transactionMedium: PaymentTypeExtension.fromString(
          json['transactionMedium'] as String? ?? 'CASH'),
      transactionDate: DateParser.parse(json['transactionDate']),
      status: InvestmentStatus.values.firstWhere(
        (e) => e.toString() == 'InvestmentStatus.${json['status']}',
      ),
      returns: (json['returns'] as List<dynamic>?)
              ?.map((e) => ReturnEntryModel.fromFirestoreMap(
                  Map<String, dynamic>.from(e as Map)))
              .toList() ??
          [],
    );
  }

  /// Plain Dart serialization — used by Hive.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'amountInvested': amountInvested,
      'startDate': startDate,
      'expectedEndDate': expectedEndDate,
      'platformName': platformName,
      'profitRate': profitRate,
      'expectedROI': expectedROI,
      'notes': notes,
      'docLinks': docLinks,
      'transactionId': transactionId,
      'transactionMedium': transactionMedium.value,
      'transactionDate': transactionDate,
      'status': status.name,
      'returns': returns.map((r) => (r as ReturnEntryModel).toJson()).toList(),
    };
  }

  /// Firestore-specific serialization — stores dates as Timestamps.
  Map<String, dynamic> toFirestoreMap() {
    return {
      'id': id,
      'title': title,
      'amountInvested': amountInvested,
      'startDate': Timestamp.fromDate(startDate),
      'expectedEndDate': Timestamp.fromDate(expectedEndDate),
      'platformName': platformName,
      'profitRate': profitRate,
      'expectedROI': expectedROI,
      'notes': notes,
      'docLinks': docLinks,
      'transactionId': transactionId,
      'transactionMedium': transactionMedium.value,
      'transactionDate': Timestamp.fromDate(transactionDate),
      'status': status.name,
      'returns':
          returns.map((r) => (r as ReturnEntryModel).toFirestoreMap()).toList(),
    };
  }

  /// Helper to convert domain entity to model.
  factory InvestmentModel.fromEntity(Investment investment) {
    return InvestmentModel(
      id: investment.id,
      title: investment.title,
      amountInvested: investment.amountInvested,
      startDate: investment.startDate,
      expectedEndDate: investment.expectedEndDate,
      platformName: investment.platformName,
      profitRate: investment.profitRate,
      expectedROI: investment.expectedROI,
      notes: investment.notes,
      docLinks: investment.docLinks,
      transactionId: investment.transactionId,
      transactionMedium: investment.transactionMedium,
      transactionDate: investment.transactionDate,
      status: investment.status,
      returns: investment.returns
          .map((r) => ReturnEntryModel.fromEntity(r))
          .toList(),
    );
  }
}
