import 'package:flutter/material.dart'; // Flutter'ın Material Widget'larını import Eder.

extension NumberFormatting on num { // num Tipine Biçimlendirme Metotları Ekleyen Extension'dır.
  String toVolumeString() => '$this ml'; // Sayıyı ml Birimli String'e Çevirir.
  String toCalorieString() => '$this kcal'; // Sayıyı kcal Birimli String'e Çevirir.
}

extension ContextExtension on BuildContext { // BuildContext'e Tema Kısayolları Ekleyen Extension'dır.
  ThemeData get theme => Theme.of(this); // Mevcut ThemeData'yı Döndüren Getter'dır.
  TextTheme get textTheme => Theme.of(this).textTheme; // Mevcut TextTheme'i Döndüren Getter'dır.
  ColorScheme get colorScheme => Theme.of(this).colorScheme; // Mevcut ColorScheme'i Döndüren Getter'dır.
}
