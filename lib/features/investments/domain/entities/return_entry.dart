class ReturnEntry {
  final String id;
  final double amountReceived;
  final DateTime date;
  final String transactionId;
  final String medium;
  final String notes;

  ReturnEntry({
    required this.id,
    required this.amountReceived,
    required this.date,
    required this.transactionId,
    required this.medium,
    required this.notes,
  });
}
