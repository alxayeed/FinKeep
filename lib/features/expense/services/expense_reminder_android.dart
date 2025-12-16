import 'dart:developer';

import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../../../core/permissions/app_permission_handler.dart';
import 'expense_reminder_service.dart';

class AndroidExpenseReminderService implements ExpenseReminderService {
  static const _notificationId = 1001;

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  // ------------------------------------------------
  // PRIVATE HELPER: Request user to allow exact alarms
  // ------------------------------------------------
  Future<void> _requestExactAlarmsPermission() async {
    try {
      final intent = AndroidIntent(
        action: 'android.settings.SCHEDULE_EXACT_ALARM',
      );
      log("-----------------------------------------------------");
      await intent.launch();
    } on PlatformException {
      // ignore errors if user cannot open settings
    }
  }

  @override
  Future<void> init({required void Function(String?) onTap}) async {
    tz.initializeTimeZones();

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'expense_reminder_channel',
      'Expense Reminder',
      description: 'Daily reminder to log expenses',
      importance: Importance.high,
    );

    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    await _plugin.initialize(
      const InitializationSettings(android: androidSettings),
      onDidReceiveNotificationResponse: (response) {
        onTap(response.payload);
      },
    );
  }

  @override
  Future<void> scheduleDailyReminder(
      {required int hour, required int minute}) async {
    final granted = await AppPermissionHandler.request(
      Permission.notification,
    );
    if (!granted) return;

    // Prompt user to allow exact alarms (Android 12+)
    await _requestExactAlarmsPermission();

    final now = tz.TZDateTime.now(tz.local);
    final scheduledTime = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    ).isBefore(now)
        ? tz.TZDateTime(
            tz.local,
            now.year,
            now.month,
            now.day,
            hour,
            minute,
          ).add(const Duration(days: 1))
        : tz.TZDateTime(
            tz.local,
            now.year,
            now.month,
            now.day,
            hour,
            minute,
          );

    log('📅 Scheduling expense reminder at: $scheduledTime');

    await _plugin.zonedSchedule(
      _notificationId,
      'Add today’s expense',
      'Don’t forget to log today’s expenses 💸',
      scheduledTime,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'expense_reminder_channel',
          'Expense Reminder',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      payload: 'add_expense',
      matchDateTimeComponents: DateTimeComponents.time,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }

  @override
  Future<void> cancelReminder() async {
    await _plugin.cancel(_notificationId);
    log('📌 Expense reminder canceled');
  }
}
