import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../enums/currency.dart';

class CurrencyProvider extends ValueNotifier<Currency> {
  static CurrencyProvider? _instance;
  static const _key = 'user_currency';

  CurrencyProvider._internal(super.value);

  /// Singleton accessor
  factory CurrencyProvider() {
    _instance ??= CurrencyProvider._internal(Currency.bdt);
    return _instance!;
  }

  /// Load currency from SharedPreferences
  Future<void> loadCurrency() async {
    final prefs = await SharedPreferences.getInstance();
    final currencyStr = prefs.getString(_key) ?? 'BDT';
    value = Currency.values.firstWhere(
      (c) => c.code == currencyStr,
      orElse: () => Currency.bdt,
    );
  }

  /// Save and set currency
  Future<void> setCurrency(Currency currency) async {
    value = currency;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, currency.code);
  }
}

class CurrencyTheme extends InheritedNotifier<CurrencyProvider> {
  const CurrencyTheme({
    super.key,
    required super.notifier,
    required super.child,
  });

  static Currency of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<CurrencyTheme>()!.notifier!.value;
  }
}

extension CurrencyExtension on BuildContext {
  Currency get currency => CurrencyTheme.of(this);
}
