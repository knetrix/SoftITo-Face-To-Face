import 'package:flutter/material.dart'; // Flutter'ın Material Widget'larını ve ThemeMode'u import Eder.

class ThemeController { // Uygulamanın ThemeMode'unu Yöneten Singleton Class'tır.
  ThemeController._(); // Dışarıdan Instance Oluşturulmasını Engelleyen Private Constructor'dır.
  static final ThemeController instance = ThemeController._(); // Tek Paylaşılan Singleton Instance'ıdır.

  final ValueNotifier<ThemeMode> themeModeNotifier = ValueNotifier<ThemeMode>(ThemeMode.dark); // Aktif ThemeMode'u Tutan ValueNotifier'dır, Varsayılan Dark'tır.

  ThemeMode get themeMode => themeModeNotifier.value; // Güncel ThemeMode Değerini Döndürür.

  bool get isDarkMode => themeModeNotifier.value == ThemeMode.dark; // Dark Mode Aktifse true Döndürür.

  void toggleTheme() { // Theme'i Dark ve Light Arasında Değiştirir.
    if (themeModeNotifier.value == ThemeMode.dark) { // Mevcut Mod Dark mı Diye Kontrol Eder.
      themeModeNotifier.value = ThemeMode.light; // Modu Light Yapar.
    } else { // Mevcut Mod Dark Değilse Çalışır.
      themeModeNotifier.value = ThemeMode.dark; // Modu Dark Yapar.
    }
  }

  void setThemeMode(ThemeMode mode) { // Verilen ThemeMode'u Doğrudan Ayarlar.
    themeModeNotifier.value = mode; // themeModeNotifier'ın value'sunu Verilen Moda Eşitler.
  }
}
