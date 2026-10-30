// ============================================================================
// main.dart → Uygulamanın Giriş Kapısı
// ----------------------------------------------------------------------------
// Uygulama Çalıştırıldığında İlk Okunan Dosya Budur. Burada İki İş Yapılır:
//   1) main() Fonksiyonu ile Uygulama Başlatılır.
//   2) Uygulamanın Genel Ayarları (Tema, Başlık, İlk Sayfa) Belirlenir.
// ============================================================================

// "import" Başka Bir Dosyadaki Kodu Bu Dosyada Kullanılabilir Hale Getirir.
// "package:flutter/material.dart" Flutter'ın Hazır Görsel Parçalarını
// (Buton, Yazı, Liste, Renkler, İkonlar...) İçeren Ana Kütüphanedir.
// Google'ın "Material Design" Tasarım Diline Göre Hazırlanmıştır.
import 'package:flutter/material.dart';

// Uygulama Açılınca Gösterilecek Ana Ekranı İçeri Aktarır.
// "package:" ile Başlamayan Yollar, Projenin Kendi Dosyalarını Gösterir.
// Buradaki Yol, lib Klasörüne Göre: lib/screens/urun_listesi_ekrani.dart
import 'screens/urun_listesi_ekrani.dart';

// main() Dart'ta Her Programın Başladığı Yerdir. Uygulama Açılınca Önce Bu Çalışır.
// "void": Bu Fonksiyon Geriye Hiçbir Değer Döndürmez Demektir.
void main() {
  // runApp: Verilen Widget'ı Ekranın En Üst Noktasına (Köküne) Yerleştirir
  // ve Uygulamayı Çalıştırır. Ekranda Görünen Her Şey Bu Widget'ın İçinden Çıkar.
  // "const": Bu Nesne Hiç Değişmeyecek Demektir; Flutter Onu Tekrar Tekrar
  // Oluşturmak Zorunda Kalmaz, Bu da Performansı Artırır.
  runApp(const MiniMagazaUygulamasi());
}

// "Widget" Flutter'da Ekranda Görünen Her Şeyin Ortak Adıdır: Yazı, Buton, Sayfa...
// Hatta Uygulamanın Kendisi Bile Bir Widget'tır.
//
// Widget'lar İkiye Ayrılır:
//   - StatelessWidget: Kendi İçinde Değişen Bir Bilgi (Durum) TUTMAZ.
//   - StatefulWidget : Zamanla Değişen Bir Bilgi TUTAR (Örn: Liste, Sayaç).
//
// Bu Sınıf Sadece Ayarları Taşıdığı ve Hiçbir Şey Değişmediği için StatelessWidget.
// "class": Yeni Bir Tip (Kalıp) Tanımlar.
// "extends": Bu Sınıf, StatelessWidget'ın Tüm Özelliklerini Miras Alır.
class MiniMagazaUygulamasi extends StatelessWidget {
  // Kurucu (Constructor): Bu Sınıftan Nesne Oluşturulurken Çalışan Özel Metot.
  // super.key: Flutter'ın Widget'ları Birbirinden Ayırt Etmek için Kullandığı
  // Kimlik Bilgisi. Şimdilik Bilmeniz Gereken: Her Widget Kurucusunda Bulunur.
  const MiniMagazaUygulamasi({super.key});

  // @override: "Üst Sınıftaki (StatelessWidget) Aynı İsimli Metodu Kendi
  // Versiyonumla Değiştiriyorum" Demektir.
  // build: Bu Widget'ın Ekranda Neye Benzeyeceğini Söyleyen Metot.
  // Flutter, Ekranı Çizmesi Gerektiğinde Bu Metodu Çağırır.
  // BuildContext context: Widget'ın Ekran Ağacındaki Yerini Bilen Nesne.
  // Tema Rengine Ulaşmak Gibi İşlerde Kullanılır.
  @override
  Widget build(BuildContext context) {
    // MaterialApp: Tüm Uygulamayı Saran En Dış Kap.
    // Tema, Başlık, İlk Sayfa Gibi Uygulama Genelindeki Ayarları Burada Veririz.
    return MaterialApp(
      // Debug (Geliştirme) Modunda Sağ Üst Köşede Kırmızı Bir "DEBUG" Şeridi Çıkar.
      // false Yapınca Bu Şerit Gizlenir.
      debugShowCheckedModeBanner: false,
      // Uygulamanın Adı. Örneğin Android'de "Son Uygulamalar" Ekranında Görünür.
      title: "Mini Mağaza",
      // ThemeData: Tüm Uygulamanın Renkleri, Yazı Tipleri Gibi Görsel Ayarları.
      // Burada Bir Kez Ayarlanınca Bütün Ekranlar Bu Ayarları Kullanır.
      theme: ThemeData(
        // Material 3: Google'ın En Yeni Tasarım Dili. Daha Yuvarlak Köşeler,
        // Daha Yumuşak Renkler Kullanır.
        useMaterial3: true,
        // ColorScheme.fromSeed: Tek Bir "Tohum" (Seed) Renk Verirsiniz,
        // Flutter O Renkten Uyumlu Bir Renk Paleti (Ana Renk, İkincil Renk,
        // Arka Plan Rengi...) Otomatik Olarak Üretir.
        // Örnek: Ürün Kartındaki Fiyatın Rengi (colorScheme.primary) Buradan Gelir.
        colorScheme: ColorScheme.fromSeed(
          // Tohum Renk: Çivit Mavisi. Bunu Colors.green Yapıp Uygulamayı Yeniden
          // Başlatırsanız Bütün Uygulamanın Renginin Değiştiğini Görürsünüz.
          seedColor: Colors.indigo,
          // Açık (Light) Tema. Koyu Tema için Brightness.dark Kullanılır.
          brightness: Brightness.light,
        ),
      ),
      // home: Uygulama Açıldığında Gösterilecek İlk Sayfa.
      home: const UrunListesiEkrani(),
    );
  }
}
