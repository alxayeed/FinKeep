import 'dart:developer';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../../../core/permissions/app_permission_handler.dart';
import 'expense_reminder_service.dart';

class IosExpenseReminderService implements ExpenseReminderService {
  static const _notificationId = 1001;
  static const _testNotificationId = 9999; // Separate ID for immediate test

  final FlutterLocalNotificationsPlugin _plugin;
  bool _initialized = false;
  Future<void>? _initFuture;

  IosExpenseReminderService({FlutterLocalNotificationsPlugin? plugin})
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

    const DarwinInitializationSettings iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    await _plugin.initialize(
      settings: const InitializationSettings(iOS: iosSettings),
      onDidReceiveNotificationResponse: (response) {
        onTap(response.payload);
      },
    );

    _initialized = true;
    log("Flutter Local Notifications initialized successfully on iOS");
  }

  Future<void> _ensureInitialized() async {
    if (!_initialized && _initFuture != null) {
      await _initFuture;
    }
  }

  @override
  Future<void> scheduleDailyReminder({
    required int hour,
    required int minute,
  }) async {
    await _ensureInitialized();

    final granted = await AppPermissionHandler.request(Permission.notification);
    if (!granted) {
      log("Notification permission denied");
      return;
    }

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

    log('📅 Scheduling daily expense reminder at: $scheduledDate (local time) on iOS');

    await _plugin.zonedSchedule(
      id: _notificationId,
      title: 'Add today’s expense',
      body: 'Don’t forget to log today’s expenses 💸',
      scheduledDate: scheduledDate,
      notificationDetails: const NotificationDetails(
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: 'add_expense',
    );

    log("Daily reminder scheduled successfully on iOS");
  }

  @override
  Future<void> cancelReminder() async {
    await _ensureInitialized();
    await _plugin.cancel(id: _notificationId);
    log('📌 Expense reminder canceled on iOS');
  }

  @override
  Future<void> showTestNotificationNow() async {
    await _ensureInitialized();
    log("🔥 Showing immediate test notification on iOS");

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
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: 'add_expense',
    );

    log("Immediate test notification triggered on iOS");
  }
}
