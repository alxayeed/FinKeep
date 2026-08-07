import 'package:flutter/foundation.dart';
import 'user_preferences_provider.dart';

class FiscalYearProvider {
  static final FiscalYearProvider _instance = FiscalYearProvider._internal();
  factory FiscalYearProvider() => _instance;
  FiscalYearProvider._internal() {
    UserPreferencesProvider().addListener(() {
      startMonthNotifier.value = UserPreferencesProvider().fiscalYearStartMonth;
    });
  }

  final ValueNotifier<int> startMonthNotifier = ValueNotifier<int>(UserPreferencesProvider().fiscalYearStartMonth);

  int get startMonth => UserPreferencesProvider().fiscalYearStartMonth;

  Future<void> init() async {
    startMonthNotifier.value = UserPreferencesProvider().fiscalYearStartMonth;
  }

  Future<void> setStartMonth(int month) async {
    await UserPreferencesProvider().setFiscalYearStartMonth(month);
    startMonthNotifier.value = month;
  }
}
