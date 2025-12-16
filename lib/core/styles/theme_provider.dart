import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ValueNotifier<ThemeMode> {
  static ThemeProvider? _instance;
  static const _key = 'theme_mode';

  ThemeProvider._internal(super.mode);

  /// Singleton accessor
  factory ThemeProvider() {
    _instance ??= ThemeProvider._internal(ThemeMode.system);
    return _instance!;
  }

  /// Load theme from SharedPreferences
  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeStr = prefs.getString(_key) ?? 'light';
    switch (themeStr) {
      case 'light':
        value = ThemeMode.light;
        break;
      case 'dark':
        value = ThemeMode.dark;
        break;
      default:
        value = ThemeMode.system;
    }
  }

  /// Save theme to SharedPreferences
  Future<void> _saveTheme(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, mode.name); // 'light', 'dark', 'system'
  }

  /// Toggle between light and dark
  Future<void> toggleTheme() async {
    if (value == ThemeMode.light) {
      value = ThemeMode.dark;
    } else {
      value = ThemeMode.light;
    }
    await _saveTheme(value);
  }
}
