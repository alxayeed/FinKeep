import 'package:spendly/core/enums/payment_type.dart';
import 'package:spendly/features/investments/domain/entities/return_entry.dart';

import '../enums/investment_status.dart';

class Investment {
  final String id;
  final String title;
  final double amountInvested;
  final DateTime startDate;
  final DateTime expectedEndDate;
  final String platformName;
  final String profitRate;
  final double expectedROI;
  final String notes;
  final String docLinks;
  final String transactionId;
  final PaymentType transactionMedium;
  final DateTime transactionDate;
  InvestmentStatus status;
  final List<ReturnEntry> returns;

  Investment({
    required this.id,
    required this.title,
    required this.amountInvested,
    required this.startDate,
    required this.expectedEndDate,
    required this.platformName,
    required this.profitRate,
    required this.expectedROI,
    required this.notes,
    required this.docLinks,
    required this.transactionId,
    required this.transactionMedium,
    required this.transactionDate,
    required this.status,
    required this.returns,
  }) {
    if (returns.isNotEmpty && status == InvestmentStatus.active) {
      status = InvestmentStatus.returnsStarted;
    }
  }

  Investment copyWith({
    String? id,
    String? title,
    double? amountInvested,
    DateTime? startDate,
    DateTime? expectedEndDate,
    String? platformName,
    String? profitRate,
    double? expectedROI,
    String? notes,
    String? docLinks,
    String? transactionId,
    PaymentType? transactionMedium,
    DateTime? transactionDate,
    InvestmentStatus? status,
    List<ReturnEntry>? returns,
  }) {
    return Investment(
      id: id ?? this.id,
      title: title ?? this.title,
      amountInvested: amountInvested ?? this.amountInvested,
      startDate: startDate ?? this.startDate,
      expectedEndDate: expectedEndDate ?? this.expectedEndDate,
      platformName: platformName ?? this.platformName,
      profitRate: profitRate ?? this.profitRate,
      expectedROI: expectedROI ?? this.expectedROI,
      notes: notes ?? this.notes,
      docLinks: docLinks ?? this.docLinks,
      transactionId: transactionId ?? this.transactionId,
      transactionMedium: transactionMedium ?? this.transactionMedium,
      transactionDate: transactionDate ?? this.transactionDate,
      status: status ?? this.status,
      returns: returns ?? this.returns,
    );
  }
}
