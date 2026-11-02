import 'package:flutter/material.dart'; // Flutter'ın Material Widget'larını import Eder.

import 'core/constants/app_colors.dart'; // Uygulamanın Renk Sabitlerini İçeren AppColors'u import Eder.
import 'core/theme/app_theme.dart'; // Uygulamanın Tema Ayarlarını İçeren AppTheme'i import Eder.
import 'features/water_tracker/controllers/water_tracker_controller.dart'; // Su Takibi Controller'ını import Eder.
import 'features/water_tracker/views/water_tracker_view.dart'; // Su Takibi Sayfasının View'ını import Eder.
import 'features/workout/controllers/workout_controller.dart'; // Egzersiz Controller'ını import Eder.
import 'features/workout/views/workout_view.dart'; // Egzersiz Sayfasının View'ını import Eder.

void main() { // Uygulamanın Entry Point'idir.
  runApp(const SusadamApp()); // SusadamApp'i Root Widget Olarak Çalıştırıp Uygulamayı Başlatır.
}

class SusadamApp extends StatelessWidget { // Uygulamanın Root Widget'ıdır, State Tutmayan Bir StatelessWidget'tır.
  const SusadamApp({super.key}); // key Parametresini Superclass'a İleten const Constructor'dır.

  @override // Superclass'taki build Metodunun Override Edildiğini Belirtir.
  Widget build(BuildContext context) { // Uygulamanın Widget Tree'sini Oluşturur.
    return MaterialApp( // Material Tasarımlı Uygulama Çatısını Oluşturur.
      title: 'Susadım v2', // Uygulamanın Başlığını Belirler.
      debugShowCheckedModeBanner: false, // Sağ Üstteki Debug Banner'ını Gizler.
      theme: AppTheme.darkTheme, // Uygulamaya Koyu Temayı Uygular.
      home: const MainDashboardScreen(), // Açılışta Gösterilecek Ana Ekranı Belirler.
    );
  }
}

class MainDashboardScreen extends StatefulWidget { // Alt Navigasyonlu Ana Ekranı Temsil Eden StatefulWidget'tır.
  const MainDashboardScreen({super.key}); // key Parametresini Superclass'a İleten const Constructor'dır.

  @override // Superclass'taki createState Metodunun Override Edildiğini Belirtir.
  State<MainDashboardScreen> createState() => _MainDashboardScreenState(); // Widget'ın State Nesnesini Oluşturur.
}

class _MainDashboardScreenState extends State<MainDashboardScreen> { // MainDashboardScreen'in State'ini Yöneten Class'tır.
  int _currentIndex = 0; // Seçili Sekmenin Index'ini Tutar.
  late final WaterTrackerController _waterController; // Su Takibi Controller'ını Tutan late final Field'dır.
  late final WorkoutController _workoutController; // Egzersiz Controller'ını Tutan late final Field'dır.

  @override // Superclass'taki initState Metodunun Override Edildiğini Belirtir.
  void initState() { // State İlk Oluşturulduğunda Bir Kez Çalışır.
    super.initState(); // Superclass'ın initState Metodunu Çağırır.
    _waterController = WaterTrackerController(); // Su Takibi Controller'ını Oluşturur.
    _workoutController = WorkoutController(); // Egzersiz Controller'ını Oluşturur.
  }

  @override // Superclass'taki dispose Metodunun Override Edildiğini Belirtir.
  void dispose() { // State Kaldırılırken Kaynakları Serbest Bırakır.
    _waterController.dispose(); // Su Takibi Controller'ını dispose Eder.
    _workoutController.dispose(); // Egzersiz Controller'ını dispose Eder.
    super.dispose(); // Superclass'ın dispose Metodunu Çağırır.
  }

  @override // Superclass'taki build Metodunun Override Edildiğini Belirtir.
  Widget build(BuildContext context) { // Ana Ekranın Widget Tree'sini Oluşturur.
    return Scaffold( // Sayfanın Temel Material Layout'unu Oluşturur.
      appBar: AppBar( // Sayfanın Üst Bar'ını Oluşturur.
        leading: Padding( // Logonun Soluna Boşluk Veren Padding Widget'ıdır.
          padding: const EdgeInsets.only(left: 16.0), // Sol Taraftan 16 Birim Boşluk Bırakır.
          child: Image.asset( // Asset Klasöründeki Logo Görselini Gösterir.
            'assets/images/logo.png', // Logo Görselinin Dosya Yoludur.
            width: 32, // Görselin Genişliğini 32 Yapar.
            height: 32, // Görselin Yüksekliğini 32 Yapar.
            errorBuilder: (_, _, _) => // Görsel Yüklenemezse Çalışacak Callback'tir.
                const Icon(Icons.bolt, color: AppColors.neonCyan), // Yedek Olarak Neon Cyan Renkli Bolt Icon'unu Gösterir.
          ),
        ),
        title: const Text('Susadım v2'), // AppBar'da Uygulama Başlığını Gösterir.
      ),
      body: IndexedStack( // Sayfaları Üst Üste Tutup Sadece Seçili Olanı Gösterir.
        index: _currentIndex, // Gösterilecek Sayfanın Index'ini Belirler.
        children: [ // IndexedStack'in Sayfa Listesidir.
          WaterTrackerView(controller: _waterController), // Su Takibi Sayfasını Controller İle Oluşturur.
          WorkoutView(controller: _workoutController), // Egzersiz Sayfasını Controller İle Oluşturur.
        ],
      ),
      bottomNavigationBar: NavigationBar( // Alt Navigasyon Bar'ını Oluşturur.
        selectedIndex: _currentIndex, // Seçili Sekmenin Index'ini Belirtir.
        onDestinationSelected: (index) { // Bir Sekmeye Tıklanınca Çalışan Callback'tir.
          setState(() { // State'i Güncelleyip Widget'ı Yeniden Çizer.
            _currentIndex = index; // Seçilen Sekmenin Index'ini Kaydeder.
          });
        },
        destinations: const [ // Navigasyon Bar'ındaki Sekmelerin Listesidir.
          NavigationDestination( // Su Takibi Sekmesini Oluşturur.
            icon: Icon(Icons.water_drop_outlined), // Seçili Değilken Gösterilen Icon'dur.
            selectedIcon: Icon(Icons.water_drop), // Seçiliyken Gösterilen Icon'dur.
            label: 'Su Takibi', // Sekmenin label'ını Belirler.
          ),
          NavigationDestination( // Egzersiz Sekmesini Oluşturur.
            icon: Icon(Icons.fitness_center_outlined), // Seçili Değilken Gösterilen Icon'dur.
            selectedIcon: Icon(Icons.fitness_center), // Seçiliyken Gösterilen Icon'dur.
            label: 'Egzersiz', // Sekmenin label'ını Belirler.
          ),
        ],
      ),
    );
  }
}
