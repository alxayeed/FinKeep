import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:spendly/core/routes/app_router.dart';
import 'package:spendly/features/expense/services/expense_reminder_android.dart';

import 'core/config/app_config.dart';
import 'core/responsive/responsive.dart';
import 'core/styles/app_themes.dart';
import 'core/styles/theme_provider.dart';
import 'dependency_injection.dart';
import 'firebase_options.dart';

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  if (notificationResponse.payload == 'add_expense') {
    // Using a separate router instance for background navigation
    final router = AppRouter.router;
    router.go(AppRoutes.addExpense);
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  DependencyInjection.initDependencies();
  // AppConfig.init(env: AppEnvironment.prod);

  AppConfig.init(env: kReleaseMode ? AppEnvironment.prod : AppEnvironment.dev);

  // Get the singleton ThemeProvider instance
  final themeProvider = ThemeProvider();
  await themeProvider.loadTheme();

  final notificationService = AndroidExpenseReminderService();
  await notificationService.init(
    onTap: (payload) {
      if (payload == 'add_expense') {
        // Use the main app's router for foreground navigation
        AppRouter.router.go(AppRoutes.addExpense);
      }
    },
    onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
  );

  runApp(MainApp(themeProvider: themeProvider));
}

class MainApp extends StatelessWidget {
  final ThemeProvider themeProvider;

  const MainApp({required this.themeProvider, super.key});

  @override
  Widget build(BuildContext context) {
    Responsive.init(
      context,
      refHeight: 924, // Pixel 9 height in dp
      refWidth: 412, // Pixel 9 width in dp
    );

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
