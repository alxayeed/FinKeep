import 'package:flutter/material.dart';
import '../../extensions/double_ext.dart';
import '../../providers/privacy_provider.dart';

/// A lightweight, privacy-aware text widget that automatically listens to [PrivacyProvider].
///
/// It updates ONLY its own text string (rendering `*****` when masked, or formatted digits when revealed)
/// without rebuilding parent cards, containers, charts, or screens!
class PrivacyText extends StatelessWidget {
  final double amount;
  final TextStyle? style;
  final String? prefix;
  final String? suffix;
  final bool ignorePrivacy;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final int? maxLines;

  const PrivacyText(
    this.amount, {
    super.key,
    this.style,
    this.prefix,
    this.suffix,
    this.ignorePrivacy = false,
    this.textAlign,
    this.overflow,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: PrivacyProvider(),
      builder: (context, isMasked, _) {
        final formattedAmount = amount.toCurrency(ignorePrivacy: ignorePrivacy);
        final displayText = '${prefix ?? ''}$formattedAmount${suffix ?? ''}';

        return Text(
          displayText,
          style: style,
          textAlign: textAlign,
          overflow: overflow,
          maxLines: maxLines,
        );
      },
    );
  }
}
