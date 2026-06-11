import 'package:spendly/core/enums/payment_type.dart';
import 'package:spendly/features/investments/domain/entities/investment.dart';

import '../../domain/enums/investment_status.dart';
import 'return_entry_model.dart';

class InvestmentModel extends Investment {
  InvestmentModel({
    required super.id,
    required super.userId,
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

  factory InvestmentModel.fromJson(Map<String, dynamic> json) {
    return InvestmentModel(
      id: json['id'],
      userId: json['userId'],
      title: json['title'],
      amountInvested: (json['amountInvested'] as num).toDouble(),
      startDate: DateTime.parse(json['startDate']),
      expectedEndDate: DateTime.parse(json['expectedEndDate']),
      platformName: json['platformName'],
      profitRate: json['profitRate'],
      expectedROI: (json['expectedROI'] as num).toDouble(),
      notes: json['notes'] ?? '',
      docLinks: json['docLinks'] ?? '',
      transactionId: json['transactionId'],
      transactionMedium: PaymentTypeExtension.fromString(json['transactionMedium'] as String? ?? 'CASH'),
      transactionDate: DateTime.parse(json['transactionDate']),
      status: InvestmentStatus.values.firstWhere(
        (e) => e.toString() == 'InvestmentStatus.${json['status']}',
      ),
      returns:
          (json['returns'] as List<dynamic>?)
              ?.map((e) => ReturnEntryModel.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'amountInvested': amountInvested,
      'startDate': startDate.toIso8601String(),
      'expectedEndDate': expectedEndDate.toIso8601String(),
      'platformName': platformName,
      'profitRate': profitRate,
      'expectedROI': expectedROI,
      'notes': notes,
      'docLinks': docLinks,
      'transactionId': transactionId,
      'transactionMedium': transactionMedium.value,
      'transactionDate': transactionDate.toIso8601String(),
      'status': status.name,
      'returns': returns.map((r) => (r as ReturnEntryModel).toJson()).toList(),
    };
  }

  /// Helper to convert domain entity to model
  factory InvestmentModel.fromEntity(Investment investment) {
    return InvestmentModel(
      id: investment.id,
      userId: investment.userId,
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
