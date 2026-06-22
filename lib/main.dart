import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:finkeep/core/routes/app_router.dart';
import 'core/common/biometric_lock_screen.dart';
import 'core/services/biometric_service.dart';

import 'core/responsive/responsive.dart';
import 'core/services/local_db_service.dart';
import 'core/styles/app_themes.dart';
import 'core/styles/theme_provider.dart';
import 'dependency_injection.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Enable edge-to-edge mode so Flutter can render behind the system bars
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize offline local database (Hive)
  final localDb = LocalDbService();
  await localDb.init();

  DependencyInjection.initDependencies();

  // Get the singleton ThemeProvider instance
  final themeProvider = ThemeProvider();
  await themeProvider.loadTheme();

  // Read onboarding preference and initialize router
  final prefs = await SharedPreferences.getInstance();
  final seenOnboarding = prefs.getBool('seen_onboarding') ?? false;
  bool requiresUnlock = prefs.getBool('biometric_enabled') ?? false;

  if (requiresUnlock) {
    final biometricService = BiometricService();
    final isAvailable = await biometricService.isBiometricsAvailable();
    if (!isAvailable) {
      requiresUnlock = false;
      await prefs.setBool('biometric_enabled', false);
    }
  }

  AppRouter.init(seenOnboarding);

  runApp(MainApp(themeProvider: themeProvider, requiresUnlock: requiresUnlock));
}

class MainApp extends StatefulWidget {
  final ThemeProvider themeProvider;
  final bool requiresUnlock;

  const MainApp({required this.themeProvider, required this.requiresUnlock, super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  late bool _isLocked;

  @override
  void initState() {
    super.initState();
    _isLocked = widget.requiresUnlock;
  }

  @override
  Widget build(BuildContext context) {
    Responsive.init(
      context,
      refHeight: 924, // Pixel 9 height in dp
      refWidth: 412, // Pixel 9 width in dp
    );

    return ValueListenableBuilder<ThemeMode>(
      valueListenable: widget.themeProvider,
      builder: (context, themeMode, _) {
        final isDark = themeMode == ThemeMode.dark ||
            (themeMode == ThemeMode.system &&
                WidgetsBinding.instance.platformDispatcher.platformBrightness == Brightness.dark);

        SystemChrome.setSystemUIOverlayStyle(
          SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
            statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
            systemNavigationBarColor: Colors.transparent,
            systemNavigationBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
          ),
        );

        if (_isLocked) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'FinKeep',
            theme: AppThemes.lightTheme,
            darkTheme: AppThemes.darkTheme,
            themeMode: themeMode,
            home: BiometricLockScreen(
              onUnlocked: () {
                setState(() {
                  _isLocked = false;
                });
              },
            ),
          );
        }

        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          routerConfig: AppRouter.router,
          title: 'FinKeep',
          theme: AppThemes.lightTheme,
          darkTheme: AppThemes.darkTheme,
          themeMode: themeMode,
        );
      },
    );
  }
}
