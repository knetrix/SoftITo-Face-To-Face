import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:susadim_v1/core/theme/theme_controller.dart';
import 'package:susadim_v1/features/water_tracker/controller/water_tracker_controller.dart';
import 'package:susadim_v1/main.dart';

void main() {
  group('WaterTrackerController Tests', () {
    test('initial water is 0 and logs empty', () {
      final controller = WaterTrackerController();
      expect(controller.currentWater.value, 0);
      expect(controller.logs.value.isEmpty, true);
      controller.dispose();
    });

    test('addWater increments water count and adds log', () {
      final controller = WaterTrackerController();
      controller.addWater(250);
      expect(controller.currentWater.value, 250);
      expect(controller.logs.value.length, 1);
      expect(controller.logs.value.first.amountMl, 250);

      controller.addWater(500);
      expect(controller.currentWater.value, 750);
      expect(controller.logs.value.length, 2);

      controller.resetWater();
      expect(controller.currentWater.value, 0);
      expect(controller.logs.value.isEmpty, true);
      controller.dispose();
    });
  });

  group('ThemeController Tests', () {
    test('theme toggles between dark and light mode', () {
      ThemeController.instance.setThemeMode(ThemeMode.dark);
      expect(ThemeController.instance.isDarkMode, true);

      ThemeController.instance.toggleTheme();
      expect(ThemeController.instance.isDarkMode, false);
      expect(ThemeController.instance.themeMode, ThemeMode.light);

      ThemeController.instance.toggleTheme();
      expect(ThemeController.instance.isDarkMode, true);
    });
  });

  group('Widget Smoke Tests', () {
    testWidgets('SusadimApp smoke test renders UI and toggles theme', (
      tester,
    ) async {
      await tester.pumpWidget(const SusadimApp());
      expect(find.text('SUSADIM v1'), findsOneWidget);
      expect(find.text('GÜNLÜK SU HEDEFİ'), findsOneWidget);
      expect(find.text('+200 ml'), findsOneWidget);

      // Tap theme toggle button
      await tester.tap(find.byTooltip('Aydınlık Moda Geç'));
      await tester.pumpAndSettle();
      expect(find.byTooltip('Karanlık Moda Geç'), findsOneWidget);
    });
  });
}
