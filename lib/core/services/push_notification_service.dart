import 'dart:developer';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import '../common/widgets/custom_permission_dialog.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  log("Handling a background message: ${message.messageId}");
  log("Message data: ${message.data}");
  if (message.notification != null) {
    log("Message notification title: ${message.notification?.title}");
    log("Message notification body: ${message.notification?.body}");
  }
}

class PushNotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    // 1. Set background messaging handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // 2. Setup Foreground Notifications presentation options
    await _fcm.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // Request permissions for push notifications
    await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // 3. Handle messages when app is in foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log("Foreground Message received: ${message.notification?.title}");
      _showLocalNotification(message);
    });

    // 4. Handle notification tap when app is in background but not terminated
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      log("Notification tapped and opened app: ${message.messageId}");
    });

    // 5. Handle notification when app is opened from terminated state
    RemoteMessage? initialMessage = await _fcm.getInitialMessage();
    if (initialMessage != null) {
      log("App opened from terminated state by notification: ${initialMessage.messageId}");
    }

    // 6. Get and log the FCM token in the console
    await logFcmToken();
  }

  Future<void> logFcmToken() async {
    try {
      String? token = await _fcm.getToken();
      log("====================================================");
      log("FCM TOKEN: $token");
      log("====================================================");
      print("FCM TOKEN: $token"); // Log to console
    } catch (e) {
      log("Error getting FCM Token: $e");
    }
  }

  Future<bool> requestPermissions(BuildContext context) async {
    final status = await Permission.notification.status;
    
    if (status.isGranted) {
      return true;
    }

    if (status.isDenied || status.isPermanentlyDenied) {
      if (!context.mounted) return false;

      final bool? goToSettings = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (context) => CustomPermissionDialog(
          title: 'Enable Notifications',
          description: 'To receive important updates and notifications, please grant notification permissions.',
          actionText: 'Go to Settings',
          cancelText: 'Not Now',
          icon: Icons.notifications_active_rounded,
          onActionPressed: () => Navigator.pop(context, true),
          onCancelPressed: () => Navigator.pop(context, false),
        ),
      );

      if (goToSettings == true) {
        await openAppSettings();
        final newStatus = await Permission.notification.status;
        return newStatus.isGranted;
      }
      return false;
    }

    final newStatus = await Permission.notification.request();
    return newStatus.isGranted;
  }

  void _showLocalNotification(RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    if (notification != null) {
      _localNotificationsPlugin.show(
        id: notification.hashCode,
        title: notification.title,
        body: notification.body,
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails(
            'finkeep_push_channel',
            'Push Notifications',
            channelDescription: 'FCM push notification channel',
            importance: Importance.max,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
      );
    }
  }
}
