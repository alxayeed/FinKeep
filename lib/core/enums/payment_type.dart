enum PaymentType {
  cash,
  mfs,
  card,
  transfer,
}

extension PaymentTypeExtension on PaymentType {
  String get displayName {
    switch (this) {
      case PaymentType.cash:
        return 'Cash';
      case PaymentType.mfs:
        return 'MFS';
      case PaymentType.card:
        return 'Card';
      case PaymentType.transfer:
        return 'Transfer';
    }
  }

  String get value {
    switch (this) {
      case PaymentType.cash:
        return 'CASH';
      case PaymentType.mfs:
        return 'MFS';
      case PaymentType.card:
        return 'CARD';
      case PaymentType.transfer:
        return 'TRANSFER';
    }
  }

  static PaymentType fromString(String val) {
    final normalized = val.trim().toUpperCase();
    switch (normalized) {
      case 'CASH':
        return PaymentType.cash;
      case 'MFS':
        return PaymentType.mfs;
      case 'CARD':
        return PaymentType.card;
      case 'TRANSFER':
        return PaymentType.transfer;
      default:
        return PaymentType.cash;
    }
  }
}
