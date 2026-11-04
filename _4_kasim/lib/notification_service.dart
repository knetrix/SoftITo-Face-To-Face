import 'package:firebase_messaging/firebase_messaging.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print(
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
      print('User Granted Notification Permission');
    } else {
      print('User Denied Notification Permission');
    }
    final token = await _firebaseMessaging.getToken();
    print('Device FCM Token: $token');
  }
}
