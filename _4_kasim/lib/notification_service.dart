import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint(
    'Received Notification Message Background: ${message.notification?.title} ${message.notification?.body}',
  );
}

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> init() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('User Granted Notification Permission');
    } else {
      debugPrint('User Denied Notification Permission');
    }
    _firebaseMessaging.onRegistered.listen((id) {
      debugPrint('Device FCM Registration ID: $id');
    });
    await _firebaseMessaging.register();
  }
}
