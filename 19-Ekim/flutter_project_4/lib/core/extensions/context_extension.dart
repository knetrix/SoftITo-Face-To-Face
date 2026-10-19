import 'package:flutter/material.dart';

extension NumberFormatting on num {
  String toVolumeString() => '$this ml';
  String toCalorieString() => '$this kcal';
}

extension ContextExtension on BuildContext {
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
}
