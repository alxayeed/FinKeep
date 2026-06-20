import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:finkeep/features/expense/services/expense_reminder_android.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class MockFlutterLocalNotificationsPlugin extends Mock
    implements FlutterLocalNotificationsPlugin {}

void main() {
  setUpAll(() {
    tz.initializeTimeZones();
    registerFallbackValue(NotificationDetails());
    registerFallbackValue(tz.TZDateTime.now(tz.UTC));
    registerFallbackValue(DateTimeComponents.time);
    registerFallbackValue(AndroidScheduleMode.inexactAllowWhileIdle);
    registerFallbackValue(InitializationSettings(
      android: const AndroidInitializationSettings('@mipmap/ic_launcher'),
    ));
  });

  group('AndroidExpenseReminderService Tests', () {
    late AndroidExpenseReminderService reminderService;
    late MockFlutterLocalNotificationsPlugin mockPlugin;

    setUp(() {
      mockPlugin = MockFlutterLocalNotificationsPlugin();
      reminderService = AndroidExpenseReminderService(plugin: mockPlugin);
    });

    test('init() initializes notifications correctly', () async {
      // Arrange
      when(() => mockPlugin.initialize(
            settings: any(named: 'settings'),
            onDidReceiveNotificationResponse: any(named: 'onDidReceiveNotificationResponse'),
          )).thenAnswer((_) async => true);

      when(() => mockPlugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>())
          .thenReturn(null); // safe fallback

      // Act
      await reminderService.init(onTap: (payload) {});

      // Assert
      verify(() => mockPlugin.initialize(
            settings: any(named: 'settings'),
            onDidReceiveNotificationResponse: any(named: 'onDidReceiveNotificationResponse'),
          )).called(1);
    });

    test('scheduleDailyReminder() calls zonedSchedule with correct parameters', () async {
      // Arrange
      when(() => mockPlugin.zonedSchedule(
            id: any(named: 'id'),
            title: any(named: 'title'),
            body: any(named: 'body'),
            scheduledDate: any(named: 'scheduledDate'),
            notificationDetails: any(named: 'notificationDetails'),
            androidScheduleMode: any(named: 'androidScheduleMode'),
            matchDateTimeComponents: any(named: 'matchDateTimeComponents'),
            payload: any(named: 'payload'),
          )).thenAnswer((_) async => {});

      // Act
      await reminderService.scheduleDailyReminder(hour: 20, minute: 30);

      // Assert
      verify(() => mockPlugin.zonedSchedule(
            id: 1001,
            title: 'Add today’s expense',
            body: 'Don’t forget to log today’s expenses 💸',
            scheduledDate: any(named: 'scheduledDate'),
            notificationDetails: any(named: 'notificationDetails'),
            androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
            matchDateTimeComponents: DateTimeComponents.time,
            payload: 'add_expense',
          )).called(1);
    });

    test('cancelReminder() calls cancel with correct notification ID', () async {
      // Arrange
      when(() => mockPlugin.cancel(id: any(named: 'id'))).thenAnswer((_) async => {});

      // Act
      await reminderService.cancelReminder();

      // Assert
      verify(() => mockPlugin.cancel(id: 1001)).called(1);
    });

    test('showTestNotificationNow() calls show with correct immediate test parameters', () async {
      // Arrange
      when(() => mockPlugin.show(
            id: any(named: 'id'),
            title: any(named: 'title'),
            body: any(named: 'body'),
            notificationDetails: any(named: 'notificationDetails'),
            payload: any(named: 'payload'),
          )).thenAnswer((_) async => {});

      // Act
      await reminderService.showTestNotificationNow();

      // Assert
      verify(() => mockPlugin.show(
            id: 9999,
            title: 'TEST NOTIFICATION',
            body: 'If you see this, your notification setup is working perfectly! 🎉',
            notificationDetails: any(named: 'notificationDetails'),
            payload: 'add_expense',
          )).called(1);
    });
  });
}
