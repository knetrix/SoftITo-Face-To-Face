import 'package:firebase_messaging/firebase_messaging.dart'; // FCM İşlemleri için firebase_messaging Package'ını import Eder.
import 'package:flutter/foundation.dart'; // debugPrint Function'ını Kullanmak için flutter/foundation Library'sini import Eder.
import 'package:flutter_local_notifications/flutter_local_notifications.dart'; // Cihazda Local Notification Göstermek için flutter_local_notifications Package'ını import Eder.

@pragma('vm:entry-point') // Release Modda Tree Shaking ile Silinmemesi için Function'ı Native Entry Point Olarak İşaretler.
Future<void> fcmBackgroundHandler(RemoteMessage message) async {} // Uygulama Background'dayken Gelen FCM Mesajlarını Karşılayan Top-Level Handler'dır.

class FcmNotificationService { // FCM ve Local Notification İşlemlerini Yöneten Service Class'tır.
  final FirebaseMessaging fcm = FirebaseMessaging.instance; // FirebaseMessaging Singleton Instance'ını Tutan Field'dır.
  final FlutterLocalNotificationsPlugin localNotificationsPlugin = // Local Notification Plugin'ini Tutan Field'dır.
      FlutterLocalNotificationsPlugin(); // Yeni Bir FlutterLocalNotificationsPlugin Oluşturur.

  Future<void> start({ // İzinleri Alıp Plugin'i Başlatan ve Mesajları Dinleyen async Metottur.
    required Function(RemoteMessage message) onMessageReceived, // Mesaj Geldiğinde Çağrılacak Zorunlu Callback Parametresidir.
  }) async {
    await fcm.requestPermission(alert: true, badge: true, sound: true); // Kullanıcıdan alert, badge ve sound Bildirim İzinlerini İster.

    const androidSettings = AndroidInitializationSettings( // Android için Initialization Ayarlarını Oluşturur.
      '@mipmap/ic_launcher', // Bildirim İkonu Olarak Uygulamanın Launcher İkonunu Kullanır.
    );
    const iOSSettings = DarwinInitializationSettings(); // iOS/macOS için Varsayılan Initialization Ayarlarını Oluşturur.
    const initializationSettings = InitializationSettings( // Platform Ayarlarını Tek Bir InitializationSettings'te Birleştirir.
      android: androidSettings, // Android Ayarlarını Atar.
      iOS: iOSSettings, // iOS Ayarlarını Atar.
    );

    await localNotificationsPlugin.initialize(initializationSettings); // Local Notification Plugin'ini Verilen Ayarlarla Başlatır.
    FirebaseMessaging.onMessage.listen((message) { // Uygulama Foreground'dayken Gelen Mesajları Dinler.
      _localShowNotification(message); // Gelen Mesajı Local Notification Olarak Gösterir.
      onMessageReceived(message); // Mesajı Callback ile Çağıran Tarafa İletir.
    });
    FirebaseMessaging.onBackgroundMessage(fcmBackgroundHandler); // Background Mesajları için Handler'ı Kaydeder.
  }

  Future<String?> getToken() async { // Cihazın FCM Token'ını Döndüren async Metottur.
    try { // Hata Oluşabilecek Token Alma İşlemini try Bloğuna Alır.
      return await fcm.getToken(); // FCM Üzerinden Token'ı Alıp Döndürür.
    } catch (e) { // Oluşan Hatayı Yakalar.
      debugPrint('Failed To Get FCM Token: $e'); // Hatayı Debug Konsoluna Yazdırır.
      return null; // Token Alınamadığı için null Döndürür.
    }
  }

  Future<void> subscribeToTopic(String topic) async { // Cihazı Verilen Topic'e Abone Eden async Metottur.
    await fcm.subscribeToTopic(topic); // FCM Üzerinden Topic'e Abone Olur.
  }

  Future<void> unsubscribeFromTopic(String topic) async { // Cihazın Verilen Topic Aboneliğini İptal Eden async Metottur.
    await fcm.unsubscribeFromTopic(topic); // FCM Üzerinden Topic Aboneliğinden Çıkar.
  }

  Future<void> _localShowNotification(RemoteMessage message) async { // RemoteMessage'ı Local Notification Olarak Gösteren Private async Metottur.
    const androidDetails = AndroidNotificationDetails( // Android Bildirim Detaylarını Oluşturur.
      'softito_fcm_channel_id', // Notification Channel id'sini Belirler.
      'softito_notifications', // Notification Channel Adını Belirler.
      channelDescription: 'FCM Push Notifications', // Channel Açıklamasını Belirler.
      importance: Importance.max, // Bildirimin Önem Düzeyini En Yükseğe Ayarlar.
      priority: Priority.high, // Bildirimin Önceliğini Yüksek Yapar.
    );

    const details = NotificationDetails( // Platform Bildirim Detaylarını Tek Bir NotificationDetails'te Birleştirir.
      android: androidDetails, // Android Detaylarını Atar.
      iOS: DarwinNotificationDetails(), // iOS için Varsayılan Detayları Atar.
    );

    await localNotificationsPlugin.show( // Bildirimi Cihazda Gösterir.
      message.hashCode, // Bildirim id'si Olarak Mesajın hashCode'unu Kullanır.
      message.notification?.title ?? 'New Notification', // Başlık Yoksa Varsayılan Başlığı Kullanır.
      message.notification?.body ?? '', // body Yoksa Boş String Kullanır.
      details, // Hazırlanan Bildirim Detaylarını Verir.
    );
  }
}
