import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../../../core/permissions/app_permission_handler.dart';
import '../../../core/common/widgets/custom_permission_dialog.dart';
import 'expense_reminder_service.dart';

class AndroidExpenseReminderService implements ExpenseReminderService {
  static const _notificationId = 1001;
  static const _testNotificationId = 9999; // Separate ID for immediate test

  final FlutterLocalNotificationsPlugin _plugin;
  bool _initialized = false;
  Future<void>? _initFuture;

  AndroidExpenseReminderService({FlutterLocalNotificationsPlugin? plugin})
      : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  @override
  Future<void> init({required void Function(String?) onTap}) async {
    if (_initFuture != null) return _initFuture!;
    _initFuture = _doInit(onTap);
    return _initFuture!;
  }

  Future<void> _doInit(void Function(String?) onTap) async {
    tz.initializeTimeZones();

    try {
      final TimezoneInfo timezoneInfo = await FlutterTimezone.getLocalTimezone();
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
      settings: const InitializationSettings(android: androidSettings),
      onDidReceiveNotificationResponse: (response) {
        onTap(response.payload);
      },
    );

    _initialized = true;
    log("Flutter Local Notifications initialized successfully");
  }

  Future<void> _ensureInitialized() async {
    if (!_initialized && _initFuture != null) {
      await _initFuture;
    }
  }

  @override
  Future<bool> requestPermissions(BuildContext context) async {
    // 1. Request standard notification permission
    final notificationGranted = await AppPermissionHandler.request(Permission.notification);
    if (!notificationGranted) {
      log("Notification permission denied");
      return false;
    }

    // 2. Request exact alarm permission if needed
    final status = await Permission.scheduleExactAlarm.status;
    if (status.isDenied || status.isPermanentlyDenied) {
      if (!context.mounted) return true;
      final bool? requestExact = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (context) => CustomPermissionDialog(
          title: 'Enable Exact Reminders',
          description: 'To ensure your daily reminder arrives exactly at the scheduled time (even when the app is in the background), FinKeep needs the "Alarms & Reminders" permission.',
          actionText: 'Go to Settings',
          cancelText: 'Not Now',
          icon: Icons.alarm_rounded,
          onActionPressed: () => Navigator.pop(context, true),
          onCancelPressed: () => Navigator.pop(context, false),
        ),
      );

      if (requestExact == true) {
        await Permission.scheduleExactAlarm.request();
      }
    }

    return true;
  }

  @override
  Future<void> scheduleDailyReminder({
    required int hour,
    required int minute,
  }) async {
    await _ensureInitialized();

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

    // Use exact timing if permission is granted, otherwise inexact fallback
    AndroidScheduleMode scheduleMode = AndroidScheduleMode.inexactAllowWhileIdle;
    if (await Permission.scheduleExactAlarm.isGranted) {
      scheduleMode = AndroidScheduleMode.exactAllowWhileIdle;
      log('using exact alarm mode for scheduled reminder');
    } else {
      log('exact alarm permission not granted, using inexact fallback');
    }

    await _plugin.zonedSchedule(
      id: _notificationId,
      title: 'Add today’s expense',
      body: 'Don’t forget to log today’s expenses 💸',
      scheduledDate: scheduledDate,
      notificationDetails: const NotificationDetails(
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
      androidScheduleMode: scheduleMode,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: 'add_expense',
    );

    log("Daily reminder scheduled successfully");
  }

  @override
  Future<void> cancelReminder() async {
    await _ensureInitialized();
    await _plugin.cancel(id: _notificationId);
    log('📌 Expense reminder canceled');
  }

  @override
  Future<void> showTestNotificationNow() async {
    await _ensureInitialized();
    log("🔥 Showing immediate test notification");
    
    final granted = await AppPermissionHandler.request(Permission.notification);
    if (!granted) {
      log("Notification permission denied");
      return;
    }

    await _plugin.show(
      id: _testNotificationId,
      title: 'TEST NOTIFICATION',
      body: 'If you see this, your notification setup is working perfectly! 🎉',
      notificationDetails: const NotificationDetails(
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
