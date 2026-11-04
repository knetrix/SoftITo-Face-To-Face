import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

@pragma('vm:entry-point')
Future<void> fcmBackgroundHandler(RemoteMessage message) async {}

class FcmNotificationService {
  final FirebaseMessaging fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> start({
    required Function(RemoteMessage message) onMessageReceived,
  }) async {
    await fcm.requestPermission(alert: true, badge: true, sound: true);

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iOSSettings = DarwinInitializationSettings();
    const initializationSettings = InitializationSettings(
      android: androidSettings,
      iOS: iOSSettings,
    );

    await localNotificationsPlugin.initialize(initializationSettings);
    FirebaseMessaging.onMessage.listen((message) {
      _localShowNotification(message);
      onMessageReceived(message);
    });
    FirebaseMessaging.onBackgroundMessage(fcmBackgroundHandler);
  }

  Future<void> subscribeToTopic(String topic) async {
    await fcm.subscribeToTopic(topic);
  }

  Future<void> unsubscribeFromTopic(String topic) async {
    await fcm.unsubscribeFromTopic(topic);
  }

  Future<void> _localShowNotification(RemoteMessage message) async {
    const androidDetails = AndroidNotificationDetails(
      'softito_fcm_channel_id',
      'softito_notifications',
      channelDescription: 'FCM Push Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(),
    );

    await localNotificationsPlugin.show(
      message.hashCode,
      message.notification?.title ?? 'New Notification',
      message.notification?.body ?? '',
      details,
    );
  }
}
