import 'dart:developer';

import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../../../core/permissions/app_permission_handler.dart';
import 'expense_reminder_service.dart';

class AndroidExpenseReminderService implements ExpenseReminderService {
  static const _notificationId = 1001;
  static const _testNotificationId = 9999; // Separate ID for immediate test

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  Future<void> _requestExactAlarmsPermission() async {
    try {
      final intent = AndroidIntent(
        action: 'android.settings.SCHEDULE_EXACT_ALARM',
      );
      log("Opening SCHEDULE_EXACT_ALARM settings...");
      await intent.launch();
    } on PlatformException {
      log("Failed to open exact alarm settings");
    }
  }

  @override
  Future<void> init(
      {required void Function(String?) onTap,
      void Function(NotificationResponse)? onDidReceiveBackgroundNotificationResponse}) async {
    tz.initializeTimeZones();

    try {
      final TimezoneInfo timezoneInfo =
          await FlutterTimezone.getLocalTimezone();
      final String currentTimeZone = timezoneInfo.identifier;
      tz.setLocalLocation(tz.getLocation(currentTimeZone));
      log("Local timezone set to: $currentTimeZone");
    } catch (e) {
      log("Failed to get local timezone, falling back to UTC: $e");
      tz.setLocalLocation(tz.UTC);
    }

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'expense_reminder_channel',
      'Expense Reminder',
      description: 'Daily reminder to log expenses',
      importance: Importance.max,
      playSound: true,
      enableVibration: true,
    );

    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    await _plugin.initialize(
      const InitializationSettings(android: androidSettings),
      onDidReceiveNotificationResponse: (response) {
        onTap(response.payload);
      },
      onDidReceiveBackgroundNotificationResponse: onDidReceiveBackgroundNotificationResponse,
    );

    log("Flutter Local Notifications initialized successfully");
  }

  @override
  Future<void> scheduleDailyReminder({
    required int hour,
    required int minute,
  }) async {
    final granted = await AppPermissionHandler.request(Permission.notification);
    if (!granted) {
      log("Notification permission denied");
      return;
    }

    await _requestExactAlarmsPermission();

    final now = tz.TZDateTime.now(tz.local);

    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    log('📅 Scheduling daily expense reminder at: $scheduledDate (local time)');

    await _plugin.zonedSchedule(
      _notificationId,
      'Add today’s expense',
      'Don’t forget to log today’s expenses 💸',
      scheduledDate,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'expense_reminder_channel',
          'Expense Reminder',
          channelDescription: 'Daily reminder to log expenses',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
          enableVibration: true,
          icon: '@mipmap/ic_launcher',
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: 'add_expense',
    );

    log("Daily reminder scheduled successfully");
  }

  @override
  Future<void> cancelReminder() async {
    await _plugin.cancel(_notificationId);
    log('📌 Expense reminder canceled');
  }

  // ================================================
  // NEW: Test method to show notification IMMEDIATELY
  // ================================================
  @override
  Future<void> showTestNotificationNow() async {
    log("🔥 Showing immediate test notification");

    await _plugin.show(
      _testNotificationId,
      'TEST NOTIFICATION',
      'If you see this, your notification setup is working perfectly! 🎉',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'expense_reminder_channel',
          'Expense Reminder',
          channelDescription: 'Test immediate notification',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
          enableVibration: true,
          icon: '@mipmap/ic_launcher',
        ),
      ),
      payload: 'add_expense',
    );

    log("Immediate test notification triggered");
  }
}
