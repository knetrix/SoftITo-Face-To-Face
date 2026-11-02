import 'package:flutter/material.dart'; // Flutter'ın Material Widget'larını import Eder.
import '../constants/app_colors.dart'; // Renk Sabitlerini İçeren AppColors'ı import Eder.

class AppTheme { // Uygulamanın Light ve Dark ThemeData Tanımlarını Tutan Class'tır.
  const AppTheme._(); // Class'ın Instance'ının Oluşturulmasını Engelleyen Private Constructor'dır.

  static ThemeData get darkTheme { // Dark Theme'i Döndüren Static Getter'dır.
    return ThemeData( // Dark Theme İçin ThemeData Oluşturur.
      useMaterial3: true, // Material 3 Tasarımını Aktif Eder.
      brightness: Brightness.dark, // Theme Parlaklığını Dark Olarak Ayarlar.
      scaffoldBackgroundColor: AppColors.darkBackground, // Scaffold Arka Plan Rengini Belirler.
      colorScheme: const ColorScheme.dark( // Dark ColorScheme Tanımlar.
        primary: AppColors.neonCyan, // primary Rengini Neon Camgöbeği Yapar.
        secondary: AppColors.electricBlue, // secondary Rengini Elektrik Mavisi Yapar.
        surface: AppColors.darkSurface, // surface Rengini Belirler.
        onSurface: AppColors.darkTextPrimary, // Surface Üzerindeki İçerik Rengini Belirler.
        error: Colors.redAccent, // error Rengini Kırmızı Accent Yapar.
      ),
      appBarTheme: const AppBarTheme( // AppBar Görünümünü Tanımlar.
        backgroundColor: AppColors.darkSurface, // AppBar Arka Plan Rengini Belirler.
        elevation: 0, // AppBar Gölgesini Kaldırır.
        centerTitle: true, // AppBar Başlığını Ortalar.
        titleTextStyle: TextStyle( // AppBar Başlık TextStyle'ını Tanımlar.
          color: AppColors.darkTextPrimary, // Başlık Rengini Belirler.
          fontSize: 20, // Başlık Font Boyutunu Belirler.
          fontWeight: FontWeight.bold, // Başlığı Kalın Yapar.
          letterSpacing: 0.5, // Harf Aralığını Belirler.
        ),
        iconTheme: IconThemeData(color: AppColors.neonCyan), // AppBar Icon Rengini Belirler.
      ),
      cardTheme: CardThemeData( // Card Görünümünü Tanımlar.
        color: AppColors.darkCardBg, // Card Arka Plan Rengini Belirler.
        elevation: 0, // Card Gölgesini Kaldırır.
        shape: RoundedRectangleBorder( // Card'a Yuvarlatılmış Köşeli Shape Verir.
          borderRadius: BorderRadius.circular(16), // Köşe Yarıçapını 16 Yapar.
          side: const BorderSide(color: AppColors.darkBorder, width: 1), // Card'a 1 Piksellik Border Ekler.
        ),
      ),
      dividerColor: AppColors.darkBorder, // Divider Rengini Belirler.
      elevatedButtonTheme: ElevatedButtonThemeData( // ElevatedButton Görünümünü Tanımlar.
        style: ElevatedButton.styleFrom( // ElevatedButton Style'ını Oluşturur.
          backgroundColor: AppColors.neonCyan, // Buton Arka Plan Rengini Belirler.
          foregroundColor: Colors.black, // Buton İçerik Rengini Siyah Yapar.
          elevation: 0, // Buton Gölgesini Kaldırır.
          textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16), // Buton Yazısını Kalın ve 16 Boyutunda Yapar.
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14), // Buton İç Boşluğunu Belirler.
          shape: RoundedRectangleBorder( // Butona Yuvarlatılmış Köşeli Shape Verir.
            borderRadius: BorderRadius.circular(12), // Köşe Yarıçapını 12 Yapar.
          ),
        ),
      ),
    );
  }

  static ThemeData get lightTheme { // Light Theme'i Döndüren Static Getter'dır.
    return ThemeData( // Light Theme İçin ThemeData Oluşturur.
      useMaterial3: true, // Material 3 Tasarımını Aktif Eder.
      brightness: Brightness.light, // Theme Parlaklığını Light Olarak Ayarlar.
      scaffoldBackgroundColor: AppColors.lightBackground, // Scaffold Arka Plan Rengini Belirler.
      colorScheme: const ColorScheme.light( // Light ColorScheme Tanımlar.
        primary: AppColors.electricBlue, // primary Rengini Elektrik Mavisi Yapar.
        secondary: AppColors.neonCyan, // secondary Rengini Neon Camgöbeği Yapar.
        surface: AppColors.lightSurface, // surface Rengini Belirler.
        onSurface: AppColors.lightTextPrimary, // Surface Üzerindeki İçerik Rengini Belirler.
        error: Colors.redAccent, // error Rengini Kırmızı Accent Yapar.
      ),
      appBarTheme: const AppBarTheme( // AppBar Görünümünü Tanımlar.
        backgroundColor: AppColors.lightSurface, // AppBar Arka Plan Rengini Belirler.
        elevation: 0, // AppBar Gölgesini Kaldırır.
        centerTitle: true, // AppBar Başlığını Ortalar.
        titleTextStyle: TextStyle( // AppBar Başlık TextStyle'ını Tanımlar.
          color: AppColors.lightTextPrimary, // Başlık Rengini Belirler.
          fontSize: 20, // Başlık Font Boyutunu Belirler.
          fontWeight: FontWeight.bold, // Başlığı Kalın Yapar.
          letterSpacing: 0.5, // Harf Aralığını Belirler.
        ),
        iconTheme: IconThemeData(color: AppColors.electricBlue), // AppBar Icon Rengini Belirler.
      ),
      cardTheme: CardThemeData( // Card Görünümünü Tanımlar.
        color: AppColors.lightCardBg, // Card Arka Plan Rengini Belirler.
        elevation: 0, // Card Gölgesini Kaldırır.
        shape: RoundedRectangleBorder( // Card'a Yuvarlatılmış Köşeli Shape Verir.
          borderRadius: BorderRadius.circular(16), // Köşe Yarıçapını 16 Yapar.
          side: const BorderSide(color: AppColors.lightBorder, width: 1), // Card'a 1 Piksellik Border Ekler.
        ),
      ),
      dividerColor: AppColors.lightBorder, // Divider Rengini Belirler.
      elevatedButtonTheme: ElevatedButtonThemeData( // ElevatedButton Görünümünü Tanımlar.
        style: ElevatedButton.styleFrom( // ElevatedButton Style'ını Oluşturur.
          backgroundColor: AppColors.electricBlue, // Buton Arka Plan Rengini Belirler.
          foregroundColor: Colors.white, // Buton İçerik Rengini Beyaz Yapar.
          elevation: 0, // Buton Gölgesini Kaldırır.
          textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16), // Buton Yazısını Kalın ve 16 Boyutunda Yapar.
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14), // Buton İç Boşluğunu Belirler.
          shape: RoundedRectangleBorder( // Butona Yuvarlatılmış Köşeli Shape Verir.
            borderRadius: BorderRadius.circular(12), // Köşe Yarıçapını 12 Yapar.
          ),
        ),
      ),
    );
  }
}
