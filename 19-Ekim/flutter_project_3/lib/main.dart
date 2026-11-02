import 'package:flutter/material.dart'; // Flutter'ın Material Widget'larını import Eder.

import 'core/theme/app_theme.dart'; // Uygulamanın Light ve Dark Theme Tanımlarını import Eder.
import 'core/theme/theme_controller.dart'; // Theme Modunu Yöneten ThemeController'ı import Eder.
import 'features/water_tracker/view/water_tracker_view.dart'; // Su Takip Ana Ekranını import Eder.

void main() { // Uygulamanın Entry Point'idir.
  runApp(const SusadimApp()); // SusadimApp'i Root Widget Olarak Çalıştırıp Uygulamayı Başlatır.
}

class SusadimApp extends StatelessWidget { // Uygulamanın Root Widget'ıdır, State Tutmayan Bir StatelessWidget'tır.
  const SusadimApp({super.key}); // key Parametresini Superclass'a İleten const Constructor'dır.

  @override // Superclass'taki build Metodunun Override Edildiğini Belirtir.
  Widget build(BuildContext context) { // Uygulamanın Widget Tree'sini Oluşturur.
    return ValueListenableBuilder<ThemeMode>( // ThemeMode Değiştikçe Alt Widget'ları Yeniden Çizer.
      valueListenable: ThemeController.instance.themeModeNotifier, // Dinlenecek ThemeMode ValueNotifier'ını Belirtir.
      builder: (context, themeMode, _) { // Güncel ThemeMode İle Widget Üreten builder Callback'idir.
        return MaterialApp( // Material Tasarımlı Uygulama Kökünü Oluşturur.
          title: 'Susadım v1', // Uygulamanın Başlığını Belirler.
          debugShowCheckedModeBanner: false, // Debug Banner'ını Gizler.
          theme: AppTheme.lightTheme, // Light Theme'i Atar.
          darkTheme: AppTheme.darkTheme, // Dark Theme'i Atar.
          themeMode: themeMode, // Aktif ThemeMode'u Uygular.
          home: const WaterTrackerView(), // Açılış Sayfası Olarak WaterTrackerView'ı Gösterir.
        );
      },
    );
  }
}
