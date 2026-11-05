import 'package:firebase_core/firebase_core.dart'; // Firebase'i Başlatmak için firebase_core Package'ını import Eder.
import 'package:flutter/material.dart'; // Material Widget'larını Kullanmak için flutter/material Library'sini import Eder.

import 'screens/storage_and_fcm_screen.dart'; // Storage ve FCM Ekranını import Eder.

void main() async { // Uygulamanın async Entry Point'idir.
  WidgetsFlutterBinding.ensureInitialized(); // runApp'ten Önce Native Plugin'lerin Kullanılabilmesini Sağlar.
  try { // Firebase Henüz Bağlanmadığı için Hata Verebilecek Başlatma İşlemini try Bloğuna Alır.
    await Firebase.initializeApp(); // Firebase'i Başlatır ve Bitmesini Bekler.
  } catch (_) {} // Firebase Başlatılamazsa Hatayı Yutar ve Uygulamayı Çalıştırmaya Devam Eder.
  runApp(const SoftitoFcmDemoApp()); // SoftitoFcmDemoApp Widget'ını Root Olarak Çalıştırır.
}

class SoftitoFcmDemoApp extends StatelessWidget { // Uygulamanın Root Widget'ı Olan StatelessWidget'tır.
  const SoftitoFcmDemoApp({super.key}); // key'i Üst Class'a İleten const Constructor'dır.

  @override // Üst Class'taki build Metodunu Override Eder.
  Widget build(BuildContext context) { // Widget Ağacını Oluşturan build Metodudur.
    return MaterialApp( // Material Design Ayarlarını Taşıyan MaterialApp Döndürür.
      debugShowCheckedModeBanner: false, // Sağ Üstteki Debug Etiketini Gizler.
      title: 'Softito FCM Demo Application', // Uygulamanın Başlığını Belirler.
      theme: ThemeData( // Uygulamanın Temasını Tanımlar.
        colorScheme: ColorScheme.fromSeed( // Seed Color'dan ColorScheme Üretir.
          seedColor: const Color.fromARGB(0, 0, 0, 0), // Seed Color Olarak Siyahı Kullanır.
          brightness: Brightness.light, // Açık Tema Kullanır.
        ), // ColorScheme.fromSeed
        useMaterial3: true, // Material 3 Tasarımını Etkinleştirir.
      ), // ThemeData
      home: const StorageAndFcmScreen(), // Açılışta StorageAndFcmScreen'i Gösterir.
    ); // MaterialApp
  }
}
