import 'package:flutter/material.dart'; // Flutter'ın Material Widget'larını import Eder.
import '../constants/app_colors.dart'; // Renk Sabitlerini İçeren AppColors'u import Eder.

class AppTheme { // Uygulamanın Tema Ayarlarını Barındıran Class'tır.
  AppTheme._(); // Class'ın Örneklenmesini Engelleyen Private Constructor'dır.

  static ThemeData get darkTheme { // Uygulamanın Koyu Temasını Döndüren Getter'dır.
    return ThemeData( // Tema Ayarlarını İçeren ThemeData Nesnesini Oluşturur.
      useMaterial3: true, // Material 3 Tasarımını Aktif Eder.
      brightness: Brightness.dark, // Temanın Parlaklığını Koyu Olarak Belirler.
      scaffoldBackgroundColor: AppColors.background, // Scaffold'ların Arka Plan Rengini Belirler.
      colorScheme: const ColorScheme.dark( // Koyu Renk Şemasını Tanımlar.
        primary: AppColors.neonCyan, // Birincil Rengi Neon Cyan Yapar.
        secondary: AppColors.neonLime, // İkincil Rengi Neon Lime Yapar.
        surface: AppColors.surface, // Yüzey Rengini Belirler.
        error: AppColors.error, // Hata Rengini Belirler.
        onPrimary: Colors.black, // Birincil Renk Üzerindeki İçerik Rengini Siyah Yapar.
        onSecondary: Colors.black, // İkincil Renk Üzerindeki İçerik Rengini Siyah Yapar.
        onSurface: AppColors.textPrimary, // Yüzey Üzerindeki İçerik Rengini Belirler.
        onError: Colors.white, // Hata Rengi Üzerindeki İçerik Rengini Beyaz Yapar.
      ),
      appBarTheme: const AppBarTheme( // AppBar'ların Görünümünü Tanımlar.
        backgroundColor: AppColors.background, // AppBar'ın Arka Plan Rengini Belirler.
        elevation: 0, // AppBar'ın Gölgesini Kaldırır.
        centerTitle: false, // Başlığı Sola Hizalar.
        scrolledUnderElevation: 0, // Kaydırma Sırasında Oluşan Gölgeyi Kaldırır.
        titleTextStyle: TextStyle( // AppBar Başlığının Yazı Stilini Tanımlar.
          color: AppColors.textPrimary, // Başlık Rengini Belirler.
          fontSize: 20, // Başlık Yazı Boyutunu 20 Yapar.
          fontWeight: FontWeight.bold, // Başlığı Kalın Yapar.
          letterSpacing: 0.5, // Harfler Arası Boşluğu 0.5 Yapar.
        ),
        iconTheme: IconThemeData(color: AppColors.neonCyan), // AppBar Icon'larının Rengini Neon Cyan Yapar.
      ),
      cardTheme: CardThemeData( // Card Widget'larının Görünümünü Tanımlar.
        color: AppColors.surface, // Card'ın Arka Plan Rengini Belirler.
        elevation: 0, // Card'ın Gölgesini Kaldırır.
        shape: RoundedRectangleBorder( // Card'a Yuvarlak Köşeli Şekil Verir.
          borderRadius: BorderRadius.circular(16), // Köşe Yarıçapını 16 Yapar.
          side: const BorderSide(color: AppColors.border, width: 1), // Card'a 1 Birimlik Kenarlık Ekler.
        ),
      ),
      navigationBarTheme: NavigationBarThemeData( // NavigationBar'ın Görünümünü Tanımlar.
        backgroundColor: AppColors.surface, // NavigationBar'ın Arka Plan Rengini Belirler.
        indicatorColor: AppColors.neonCyan.withAlpha(50), // Seçili Sekme Göstergesinin Rengini Yarı Saydam Neon Cyan Yapar.
        labelTextStyle: WidgetStateProperty.resolveWith((states) { // Sekme label'larının Stilini Duruma Göre Belirler.
          if (states.contains(WidgetState.selected)) { // Sekme Seçiliyse Bu Bloğu Çalıştırır.
            return const TextStyle( // Seçili Sekme label Stilini Döndürür.
              color: AppColors.neonCyan, // label Rengini Neon Cyan Yapar.
              fontWeight: FontWeight.w600, // label'ı Yarı Kalın Yapar.
              fontSize: 12, // label Yazı Boyutunu 12 Yapar.
            );
          }
          return const TextStyle( // Seçili Olmayan Sekme label Stilini Döndürür.
            color: AppColors.textSecondary, // label Rengini İkincil Metin Rengi Yapar.
            fontWeight: FontWeight.normal, // label'ı Normal Kalınlıkta Yapar.
            fontSize: 12, // label Yazı Boyutunu 12 Yapar.
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) { // Sekme Icon'larının Stilini Duruma Göre Belirler.
          if (states.contains(WidgetState.selected)) { // Sekme Seçiliyse Bu Bloğu Çalıştırır.
            return const IconThemeData(color: AppColors.neonCyan); // Seçili Icon Rengini Neon Cyan Yapar.
          }
          return const IconThemeData(color: AppColors.textSecondary); // Seçili Olmayan Icon Rengini İkincil Metin Rengi Yapar.
        }),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData( // ElevatedButton'ların Görünümünü Tanımlar.
        style: ElevatedButton.styleFrom( // ElevatedButton Stilini Oluşturur.
          backgroundColor: AppColors.neonCyan, // Buton Arka Plan Rengini Neon Cyan Yapar.
          foregroundColor: Colors.black, // Buton İçerik Rengini Siyah Yapar.
          elevation: 0, // Butonun Gölgesini Kaldırır.
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12), // Buton İç Boşluklarını Belirler.
          shape: RoundedRectangleBorder( // Butona Yuvarlak Köşeli Şekil Verir.
            borderRadius: BorderRadius.circular(12), // Köşe Yarıçapını 12 Yapar.
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14), // Buton Yazısını Kalın ve 14 Boyutunda Yapar.
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData( // OutlinedButton'ların Görünümünü Tanımlar.
        style: OutlinedButton.styleFrom( // OutlinedButton Stilini Oluşturur.
          foregroundColor: AppColors.neonCyan, // Buton İçerik Rengini Neon Cyan Yapar.
          side: const BorderSide(color: AppColors.neonCyan, width: 1.5), // Butona Neon Cyan Renkli Kenarlık Ekler.
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), // Buton İç Boşluklarını Belirler.
          shape: RoundedRectangleBorder( // Butona Yuvarlak Köşeli Şekil Verir.
            borderRadius: BorderRadius.circular(12), // Köşe Yarıçapını 12 Yapar.
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14), // Buton Yazısını Yarı Kalın ve 14 Boyutunda Yapar.
        ),
      ),
      textTheme: const TextTheme( // Uygulamanın Yazı Stillerini Tanımlar.
        headlineLarge: TextStyle( // Büyük Başlık Stilini Tanımlar.
          color: AppColors.textPrimary, // Yazı Rengini Birincil Metin Rengi Yapar.
          fontSize: 28, // Yazı Boyutunu 28 Yapar.
          fontWeight: FontWeight.bold, // Yazıyı Kalın Yapar.
        ),
        headlineMedium: TextStyle( // Orta Başlık Stilini Tanımlar.
          color: AppColors.textPrimary, // Yazı Rengini Birincil Metin Rengi Yapar.
          fontSize: 22, // Yazı Boyutunu 22 Yapar.
          fontWeight: FontWeight.bold, // Yazıyı Kalın Yapar.
        ),
        titleLarge: TextStyle( // Büyük Title Stilini Tanımlar.
          color: AppColors.textPrimary, // Yazı Rengini Birincil Metin Rengi Yapar.
          fontSize: 18, // Yazı Boyutunu 18 Yapar.
          fontWeight: FontWeight.w600, // Yazıyı Yarı Kalın Yapar.
        ),
        titleMedium: TextStyle( // Orta Title Stilini Tanımlar.
          color: AppColors.textPrimary, // Yazı Rengini Birincil Metin Rengi Yapar.
          fontSize: 16, // Yazı Boyutunu 16 Yapar.
          fontWeight: FontWeight.w500, // Yazıyı Orta Kalınlıkta Yapar.
        ),
        bodyLarge: TextStyle(color: AppColors.textPrimary, fontSize: 16), // Büyük Gövde Metni Stilini Tanımlar.
        bodyMedium: TextStyle(color: AppColors.textSecondary, fontSize: 14), // Orta Gövde Metni Stilini Tanımlar.
        bodySmall: TextStyle(color: AppColors.textMuted, fontSize: 12), // Küçük Gövde Metni Stilini Tanımlar.
      ),
    );
  }
}
