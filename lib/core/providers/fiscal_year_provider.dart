import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FiscalYearProvider {
  static final FiscalYearProvider _instance = FiscalYearProvider._internal();
  factory FiscalYearProvider() => _instance;
  FiscalYearProvider._internal();

  final ValueNotifier<int> startMonthNotifier = ValueNotifier<int>(7); // Default July

  int get startMonth => startMonthNotifier.value;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    startMonthNotifier.value = prefs.getInt('fiscal_year_start_month') ?? 7;
  }

  Future<void> setStartMonth(int month) async {
    if (month < 1 || month > 12) return;
    startMonthNotifier.value = month;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('fiscal_year_start_month', month);
  }
}
