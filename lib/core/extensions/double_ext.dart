import 'package:intl/intl.dart';

extension DoubleFormatting on double {
  String toCurrency() {
    final formatter = NumberFormat.currency(
      locale: 'en_IN',
      name: '',
      symbol: '',
      decimalDigits: 0,
    );

    return formatter.format(this);
  }
}
