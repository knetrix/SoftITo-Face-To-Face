import 'package:flutter/material.dart'; // Flutter'ın Material Widget'larını import Eder.

class AppColors { // Uygulamanın Renk Sabitlerini Barındıran Class'tır.
  AppColors._(); // Class'ın Örneklenmesini Engelleyen Private Constructor'dır.

  // Dark Obsidian Backgrounds
  static const Color background = Color(0xFF0D1117); // Uygulamanın Ana Arka Plan Rengidir.
  static const Color surface = Color(0xFF161B22); // Kart ve Yüzeylerin Arka Plan Rengidir.
  static const Color surfaceElevated = Color(0xFF21262D); // Yükseltilmiş Yüzeylerin Rengidir.
  static const Color border = Color(0xFF30363D); // Kenarlık Rengidir.

  // Neon & Brand Accents
  static const Color neonCyan = Color(0xFF00F0FF); // Neon Cyan Vurgu Rengidir.
  static const Color neonLime = Color(0xFFCCFF00); // Neon Lime Vurgu Rengidir.
  static const Color neonPink = Color(0xFFFF007A); // Neon Pembe Vurgu Rengidir.
  static const Color neonPurple = Color(0xFF9D00FF); // Neon Mor Vurgu Rengidir.

  // Status & Utility Colors
  static const Color success = Color(0xFF3FB950); // Başarı Durumunu Gösteren Renktir.
  static const Color warning = Color(0xFFD29922); // Uyarı Durumunu Gösteren Renktir.
  static const Color error = Color(0xFFF85149); // Hata Durumunu Gösteren Renktir.

  // Typography
  static const Color textPrimary = Color(0xFFF0F6FC); // Birincil Metin Rengidir.
  static const Color textSecondary = Color(0xFF8B949E); // İkincil Metin Rengidir.
  static const Color textMuted = Color(0xFF484F58); // Soluk Metin Rengidir.
}
