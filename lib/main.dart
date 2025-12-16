import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:spendly/core/routes/app_router.dart';

import 'core/config/app_config.dart';
import 'core/styles/app_themes.dart';
import 'core/styles/theme_provider.dart';
import 'dependency_injection.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  DependencyInjection.initDependencies();
  AppConfig.init(env: kReleaseMode ? AppEnvironment.prod : AppEnvironment.dev);

  // Get the singleton ThemeProvider instance
  final themeProvider = ThemeProvider();

  runApp(MainApp(themeProvider: themeProvider));
}

class MainApp extends StatelessWidget {
  final ThemeProvider themeProvider;

  const MainApp({required this.themeProvider, super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeProvider,
      builder: (context, themeMode, _) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          routerConfig: AppRouter.router,
          title: 'Spendly',
          theme: AppThemes.lightTheme,
          darkTheme: AppThemes.darkTheme,
          themeMode: themeMode,
        );
      },
    );
  }
}
