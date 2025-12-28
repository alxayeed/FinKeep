import 'package:spendly/features/investments/domain/entities/return_entry.dart';

import '../enums/investment_status.dart';

class Investment {
  final String id;
  final String userId;
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
  final String transactionMedium;
  final DateTime transactionDate;
  InvestmentStatus status;
  final List<ReturnEntry> returns;

  Investment({
    required this.id,
    required this.userId,
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
  });
}
