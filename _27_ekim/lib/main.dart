import 'package:flutter/material.dart'; // Flutter'ın Material Widget'larını import Eder.

import 'screens/product_list_screen.dart'; // Açılışta Gösterilecek ProductListScreen Class'ını import Eder.

void main() { // Uygulamanın Entry Point'idir.
  runApp(const MiniStoreApp()); // MiniStoreApp'i Root Widget Olarak Çalıştırıp Uygulamayı Başlatır.
}

class MiniStoreApp extends StatelessWidget { // Uygulamanın Root Widget'ıdır, State Tutmayan Bir StatelessWidget'tır.
  const MiniStoreApp({super.key}); // key Parametresini Superclass'a İleten const Constructor'dır.

  @override // Superclass'taki build Metodunun Override Edildiğini Belirtir.
  Widget build(BuildContext context) { // Uygulamanın Widget Tree'sini Oluşturur.
    return MaterialApp( // Tema, Başlık ve İlk Sayfayı Tanımlayan MaterialApp Döndürür.
      debugShowCheckedModeBanner: false, // Sağ Üstteki Debug Banner'ını Gizler.
      title: "Mini Mağaza", // İşletim Sisteminin Görev Yöneticisinde Görünen Uygulama title'ıdır.
      theme: ThemeData( // Tüm Uygulamanın Görsel Temasını Tanımlar.
        useMaterial3: true, // Material 3 Tasarım Dilini Açar.
        colorScheme: ColorScheme.fromSeed( // Tek Bir Seed Renkten Tüm Renk Paletini Üretir.
          seedColor: Colors.indigo, // Paletin Üretileceği Seed Renk Indigo'dur.
          brightness: Brightness.light, // Açık (Light) Tema Kullanır.
        ),
      ),
      home: const ProductListScreen(), // Uygulama Açılınca ProductListScreen'i Gösterir.
    );
  }
}
