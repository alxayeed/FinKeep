import 'package:flutter/material.dart';
import '../enums/currency.dart';
import '../providers/user_preferences_provider.dart';

class CurrencyProvider extends ValueNotifier<Currency> {
  static CurrencyProvider? _instance;

  CurrencyProvider._internal(super.value);

  factory CurrencyProvider() {
    _instance ??= CurrencyProvider._internal(UserPreferencesProvider().currency);
    UserPreferencesProvider().addListener(() {
      if (_instance != null) {
        _instance!.value = UserPreferencesProvider().currency;
      }
    });
    return _instance!;
  }

  Future<void> loadCurrency() async {
    value = UserPreferencesProvider().currency;
  }

  Future<void> setCurrency(Currency currency) async {
    await UserPreferencesProvider().setCurrency(currency);
    value = currency;
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
