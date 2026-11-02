import 'package:flutter/material.dart'; // Flutter'ın Material Widget'larını import Eder.

abstract final class AppColors { // Uygulama Renk Sabitlerini Toplayan, Örneklenemeyen Class'tır.
  // Dark Obsidian Palette
  static const Color background = Color(0xFF0B0F19); // Ana Arka Plan Rengidir.
  static const Color surface = Color(0xFF161F30); // Kart ve Bar Gibi Yüzeylerin Rengidir.
  static const Color surfaceVariant = Color(0xFF1E293B); // Alternatif Yüzey Rengidir.
  static const Color border = Color(0xFF2E3D52); // Kenarlık Rengidir.

  // Neon Accent Palette
  static const Color neonCyan = Color(0xFF00F0FF); // Neon Cyan Vurgu Rengidir.
  static const Color neonGreen = Color(0xFF39FF14); // Neon Yeşil Vurgu Rengidir.
  static const Color neonOrange = Color(0xFFFF5E00); // Neon Turuncu Vurgu Rengidir.
  static const Color neonPink = Color(0xFFFF007F); // Neon Pembe Vurgu Rengidir.

  // Text
  static const Color textPrimary = Color(0xFFF8FAFC); // Birincil Metin Rengidir.
  static const Color textSecondary = Color(0xFF94A3B8); // İkincil Metin Rengidir.
  static const Color textMuted = Color(0xFF64748B); // Soluk Metin Rengidir.
}
