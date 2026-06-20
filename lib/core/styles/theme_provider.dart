import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ValueNotifier<ThemeMode> {
  static ThemeProvider? _instance;
  static const _key = 'theme_mode';

  ThemeProvider._internal(super.mode);

  /// Singleton accessor
  factory ThemeProvider() {
    _instance ??= ThemeProvider._internal(ThemeMode.light);
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
      case 'system':
        value = ThemeMode.system;
        break;
      default:
        value = ThemeMode.light;
    }
  }

  /// Save theme to SharedPreferences
  Future<void> _saveTheme(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, mode.name); // 'light', 'dark', 'system'
  }

  /// Set theme specifically
  Future<void> setTheme(ThemeMode mode) async {
    value = mode;
    await _saveTheme(mode);
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
