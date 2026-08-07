import 'package:flutter/material.dart';
import '../enums/currency.dart';
import '../models/user_preferences_model.dart';
import '../services/preferences_sync_service.dart';

class UserPreferencesProvider extends ValueNotifier<UserPreferencesModel> {
  static UserPreferencesProvider? _instance;

  UserPreferencesProvider._internal(super.value);

  factory UserPreferencesProvider() {
    _instance ??= UserPreferencesProvider._internal(UserPreferencesModel.defaultValues());
    return _instance!;
  }

  ThemeMode get themeMode {
    switch (value.themeMode) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  Currency get currency {
    return Currency.values.firstWhere(
      (c) => c.code == value.currencyCode,
      orElse: () => Currency.bdt,
    );
  }

  int get fiscalYearStartMonth => value.fiscalYearStartMonth;

  Future<void> update(UserPreferencesModel newModel) async {
    value = newModel;
    await PreferencesSyncService().updatePreferences(newModel);
  }

  Future<void> setTheme(ThemeMode mode) async {
    final updated = value.copyWith(themeMode: mode.name, updatedAt: DateTime.now());
    await update(updated);
  }

  Future<void> setCurrency(Currency newCurrency) async {
    final updated = value.copyWith(currencyCode: newCurrency.code, updatedAt: DateTime.now());
    await update(updated);
  }

  Future<void> setFiscalYearStartMonth(int month) async {
    final updated = value.copyWith(fiscalYearStartMonth: month, updatedAt: DateTime.now());
    await update(updated);
  }
}

class CurrencyTheme extends InheritedNotifier<UserPreferencesProvider> {
  const CurrencyTheme({
    super.key,
    required super.notifier,
    required super.child,
  });

  static Currency of(BuildContext context) {
    final provider = context.dependOnInheritedWidgetOfExactType<CurrencyTheme>()?.notifier;
    return provider?.currency ?? Currency.bdt;
  }
}
