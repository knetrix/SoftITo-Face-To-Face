// Flutter'ın Material Design Bileşenlerini (Widget'larını) Projeye Dahil Eder.
import 'package:flutter/material.dart';

// Uygulama Açılınca Gösterilecek Ana Ekranı İçeri Aktarır.
import 'screens/urun_listesi_ekrani.dart';

// Dart'ta Her Program main() Fonksiyonundan Başlar.
void main() {
  // Verilen Widget'ı Ekranın En Köküne Yerleştirip Uygulamayı Çalıştırır.
  runApp(const MiniMagazaUygulamasi());
}

// Uygulamanın En Dış Widget'ı. Kendi Değişen Durumu Olmadığı İçin StatelessWidget.
class MiniMagazaUygulamasi extends StatelessWidget {
  // super.key: Flutter'ın Widget'ları Birbirinden Ayırt Etmek İçin Kullandığı Kimlik.
  const MiniMagazaUygulamasi({super.key});

  // build: Bu Widget'ın Ekrana Ne Çizeceğini Döndüren Metot.
  @override
  Widget build(BuildContext context) {
    // MaterialApp: Tema, Başlık, İlk Sayfa Gibi Uygulama Çapındaki Ayarları Tutar.
    return MaterialApp(
      // Sağ Üst Köşedeki Kırmızı "DEBUG" Şeridini Gizler.
      debugShowCheckedModeBanner: false,
      // İşletim Sisteminin Gördüğü Uygulama Adı.
      title: "Mini Mağaza",
      // Tüm Uygulamanın Görsel Teması.
      theme: ThemeData(
        // Google'ın En Yeni Tasarım Dili Olan Material 3'ü Kullan.
        useMaterial3: true,
        // Tek Bir "Tohum" Renkten Tüm Renk Paletini Otomatik Üretir.
        // Ürün Kartındaki Fiyatın Rengi (colorScheme.primary) Buradan Gelir.
        colorScheme: ColorScheme.fromSeed(
          // Tohum Renk: Çivit Mavisi.
          seedColor: Colors.indigo,
          // Açık (Light) Tema.
          brightness: Brightness.light,
        ),
      ),
      // Uygulama Açılınca Gösterilecek İlk Sayfa.
      home: const UrunListesiEkrani(),
    );
  }
}
