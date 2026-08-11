import 'package:intl/intl.dart';
import '../providers/privacy_provider.dart';

extension DoubleFormatting on double {
  String toCurrency({bool ignorePrivacy = false}) {
    if (!ignorePrivacy && PrivacyProvider().isMasked) {
      return '*****';
    }

    final hasDecimal = (this - truncate()).abs() > 0.00001;
    final formatter = NumberFormat.currency(
      locale: 'en_IN',
      name: '',
      symbol: '',
      decimalDigits: hasDecimal ? 2 : 0,
    );

    return formatter.format(this);
  }
}
