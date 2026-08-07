import 'package:flutter/material.dart';
import '../providers/user_preferences_provider.dart';

class ThemeProvider extends ValueNotifier<ThemeMode> {
  static ThemeProvider? _instance;

  ThemeProvider._internal(super.mode);

  factory ThemeProvider() {
    _instance ??= ThemeProvider._internal(UserPreferencesProvider().themeMode);
    UserPreferencesProvider().addListener(() {
      if (_instance != null) {
        _instance!.value = UserPreferencesProvider().themeMode;
      }
    });
    return _instance!;
  }

  Future<void> loadTheme() async {
    value = UserPreferencesProvider().themeMode;
  }

  Future<void> setTheme(ThemeMode mode) async {
    await UserPreferencesProvider().setTheme(mode);
    value = mode;
  }

  Future<void> toggleTheme() async {
    final newMode = value == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    await setTheme(newMode);
  }
}
