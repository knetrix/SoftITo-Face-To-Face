import 'package:flutter/material.dart'; // Flutter'ın Material Widget'larını ve Color Class'ını import Eder.

class AppColors { // Uygulamada Kullanılan Renk Sabitlerini Tutan Class'tır.
  const AppColors._(); // Class'ın Instance'ının Oluşturulmasını Engelleyen Private Constructor'dır.

  // Dark Obsidian Palette (Dark Theme)
  static const Color darkBackground = Color(0xFF0D1117); // Dark Theme'in Arka Plan Rengidir.
  static const Color darkSurface = Color(0xFF161B22); // Dark Theme'in Surface Rengidir.
  static const Color darkSurfaceVariant = Color(0xFF21262D); // Dark Theme'in Alternatif Surface Rengidir.
  static const Color darkCardBg = Color(0xFF1F242C); // Dark Theme'deki Card Arka Plan Rengidir.
  static const Color darkBorder = Color(0xFF30363D); // Dark Theme'deki Border Rengidir.

  // Light Glacier Palette (Light Theme)
  static const Color lightBackground = Color(0xFFF6F8FA); // Light Theme'in Arka Plan Rengidir.
  static const Color lightSurface = Color(0xFFFFFFFF); // Light Theme'in Surface Rengidir.
  static const Color lightSurfaceVariant = Color(0xFFEAEEF2); // Light Theme'in Alternatif Surface Rengidir.
  static const Color lightCardBg = Color(0xFFFFFFFF); // Light Theme'deki Card Arka Plan Rengidir.
  static const Color lightBorder = Color(0xFFD0D7DE); // Light Theme'deki Border Rengidir.

  // Accent & Brand Colors
  static const Color neonCyan = Color(0xFF00C4D6); // Neon Camgöbeği Accent Rengidir.
  static const Color electricBlue = Color(0xFF0070F3); // Elektrik Mavisi Accent Rengidir.
  static const Color neonGreen = Color(0xFF00C853); // Neon Yeşil Accent Rengidir.
  static const Color neonOrange = Color(0xFFFF9100); // Neon Turuncu Accent Rengidir.

  // Text Colors (Dark)
  static const Color darkTextPrimary = Color(0xFFF0F6FC); // Dark Theme'deki Birincil Text Rengidir.
  static const Color darkTextSecondary = Color(0xFF8B949E); // Dark Theme'deki İkincil Text Rengidir.
  static const Color darkTextMuted = Color(0xFF6E7681); // Dark Theme'deki Soluk Text Rengidir.

  // Text Colors (Light)
  static const Color lightTextPrimary = Color(0xFF1F2328); // Light Theme'deki Birincil Text Rengidir.
  static const Color lightTextSecondary = Color(0xFF656D76); // Light Theme'deki İkincil Text Rengidir.
  static const Color lightTextMuted = Color(0xFF8C959F); // Light Theme'deki Soluk Text Rengidir.
}
