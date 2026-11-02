import 'package:flutter/material.dart'; // Flutter'ın Material Widget'larını import Eder.

import '../constants/app_colors.dart'; // Uygulama Renk Sabitlerini import Eder.

abstract final class AppTheme { // Uygulama Theme Tanımlarını Toplayan, Örneklenemeyen Class'tır.
  static ThemeData get darkTheme { // Koyu Theme'i Döndüren Static Getter'dır.
    return ThemeData( // Koyu Theme Ayarlarını İçeren ThemeData'yı Oluşturur.
      useMaterial3: true, // Material 3 Tasarım Sistemini Aktif Eder.
      brightness: Brightness.dark, // Koyu Parlaklık Modunu Seçer.
      scaffoldBackgroundColor: AppColors.background, // Scaffold Arka Plan Rengini Belirler.
      colorScheme: const ColorScheme.dark( // Koyu Bir ColorScheme Tanımlar.
        surface: AppColors.surface, // Yüzey Rengini Belirler.
        primary: AppColors.neonCyan, // Primary Rengi Neon Cyan Yapar.
        secondary: AppColors.neonGreen, // Secondary Rengi Neon Yeşil Yapar.
        tertiary: AppColors.neonOrange, // Tertiary Rengi Neon Turuncu Yapar.
      ),
      appBarTheme: const AppBarTheme( // AppBar'ların Varsayılan Theme'ini Tanımlar.
        backgroundColor: AppColors.surface, // AppBar Arka Plan Rengini Belirler.
        elevation: 0, // AppBar Gölgesini Kaldırır.
        centerTitle: true, // Başlığı Ortalar.
        titleTextStyle: TextStyle( // AppBar Başlık Stilini Tanımlar.
          color: AppColors.textPrimary, // Başlık Rengini Belirler.
          fontSize: 18, // Yazı Boyutunu 18 Yapar.
          fontWeight: FontWeight.w700, // Yazı Kalınlığını w700 Yapar.
          letterSpacing: 0.5, // Harf Aralığını 0.5 Yapar.
        ),
      ),
      cardTheme: CardThemeData( // Card'ların Varsayılan Theme'ini Tanımlar.
        color: AppColors.surface, // Kart Arka Plan Rengini Belirler.
        elevation: 0, // Kart Gölgesini Kaldırır.
        shape: RoundedRectangleBorder( // Kartın Köşe ve Kenarlık Şeklini Tanımlar.
          side: const BorderSide(color: AppColors.border), // Kart Kenarlığının Rengini Belirler.
          borderRadius: BorderRadius.circular(16), // Köşe Yarıçapını 16 Olarak Belirler.
        ),
      ),
    );
  }
}
