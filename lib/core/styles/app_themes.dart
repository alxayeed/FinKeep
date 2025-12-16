import 'package:flutter/material.dart';

class AppThemes {
  static ThemeData lightTheme = ThemeData(
    primarySwatch: Colors.teal,
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: Colors.teal,
      selectionColor: Colors.tealAccent,
      selectionHandleColor: Colors.teal,
    ),
    colorScheme: ColorScheme.light(
      primary: Colors.teal,
      onPrimary: Colors.white,
      onSurface: Colors.black87,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: Colors.teal,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.teal,
      ),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.all(Colors.teal),
      trackColor: WidgetStateProperty.all(Colors.teal.withValues(alpha: 0.5)),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.all(Colors.teal),
    ),
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.all(Colors.teal),
    ),
    dividerColor: Colors.grey.shade300,
    listTileTheme: const ListTileThemeData(
      iconColor: Colors.teal,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    primarySwatch: Colors.teal,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Colors.black,
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: Colors.teal,
      selectionColor: Colors.tealAccent,
      selectionHandleColor: Colors.teal,
    ),
    colorScheme: ColorScheme.dark(
      primary: Colors.teal,
      onPrimary: Colors.white,
      onSurface: Colors.white70,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: Colors.teal,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.teal,
      ),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.all(Colors.teal),
      trackColor: WidgetStateProperty.all(Colors.teal.withValues(alpha: 0.5)),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.all(Colors.teal),
    ),
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.all(Colors.teal),
    ),
    dividerColor: Colors.grey.shade700,
    listTileTheme: const ListTileThemeData(
      iconColor: Colors.teal,
    ),
  );
}
