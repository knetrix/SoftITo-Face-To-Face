import 'package:flutter/material.dart'; // Flutter'ın Material Widget'larını import Eder.
import 'core/constants/app_colors.dart'; // Uygulama Renk Sabitlerini import Eder.
import 'core/theme/app_theme.dart'; // Uygulama Theme Tanımını import Eder.
import 'features/water_tracker/controller/water_tracker_controller.dart'; // Su Takibi Controller'ını import Eder.
import 'features/water_tracker/view/water_tracker_view.dart'; // Su Takibi View'ını import Eder.
import 'features/workout/controller/workout_controller.dart'; // Antrenman Controller'ını import Eder.
import 'features/workout/view/workout_view.dart'; // Antrenman View'ını import Eder.

void main() { // Uygulamanın Entry Point'idir.
  runApp(const SusadimApp()); // SusadimApp'i Root Widget Olarak Çalıştırıp Uygulamayı Başlatır.
}

class SusadimApp extends StatelessWidget { // Uygulamanın Root Widget'ıdır, State Tutmayan Bir StatelessWidget'tır.
  const SusadimApp({super.key}); // key Parametresini Superclass'a İleten const Constructor'dır.

  @override // Superclass'taki build Metodunun Override Edildiğini Belirtir.
  Widget build(BuildContext context) { // Uygulamanın Widget Tree'sini Oluşturur.
    return MaterialApp( // Material Tasarımlı Uygulama Çatısını Oluşturur.
      title: 'Susadım', // Uygulamanın Başlığını Belirler.
      debugShowCheckedModeBanner: false, // Sağ Üstteki Debug Banner'ını Gizler.
      theme: AppTheme.darkTheme, // Uygulamaya Koyu Theme'i Uygular.
      home: const MainNavigationScreen(), // Açılış Sayfası Olarak MainNavigationScreen'i Gösterir.
    );
  }
}

class MainNavigationScreen extends StatefulWidget { // Alt Navigasyonlu Ana Ekrandır, State Tutan Bir StatefulWidget'tır.
  const MainNavigationScreen({super.key}); // key Parametresini Superclass'a İleten const Constructor'dır.

  @override // Superclass'taki createState Metodunun Override Edildiğini Belirtir.
  State<MainNavigationScreen> createState() => _MainNavigationScreenState(); // Bu Widget'ın State Nesnesini Oluşturur.
}

class _MainNavigationScreenState extends State<MainNavigationScreen> { // MainNavigationScreen'in State'ini Yöneten Class'tır.
  int _currentIndex = 0; // Seçili Sekmenin Index'ini Tutar.
  late final WaterTrackerController _waterController; // Sonradan Atanacak Su Takibi Controller'ıdır.
  late final WorkoutController _workoutController; // Sonradan Atanacak Antrenman Controller'ıdır.

  @override // Superclass'taki initState Metodunun Override Edildiğini Belirtir.
  void initState() { // State İlk Oluşturulduğunda Bir Kez Çalışır.
    super.initState(); // Superclass'ın initState Metodunu Çağırır.
    _waterController = WaterTrackerController(); // Su Takibi Controller'ını Oluşturur.
    _workoutController = WorkoutController(); // Antrenman Controller'ını Oluşturur.
  }

  @override // Superclass'taki dispose Metodunun Override Edildiğini Belirtir.
  void dispose() { // Widget Ağaçtan Kaldırılırken Kaynakları Serbest Bırakır.
    _waterController.dispose(); // Su Takibi Controller'ını dispose Eder.
    _workoutController.dispose(); // Antrenman Controller'ını dispose Eder.
    super.dispose(); // Superclass'ın dispose Metodunu Çağırır.
  }

  @override // Superclass'taki build Metodunun Override Edildiğini Belirtir.
  Widget build(BuildContext context) { // Ana Ekranın Widget Tree'sini Oluşturur.
    return Scaffold( // Sayfanın Temel Material Layout'unu Oluşturur.
      appBar: AppBar( // Sayfanın Üst Bar'ını Oluşturur.
        title: const Text('SUSADIM • FITNESS & SU'), // AppBar Başlık Metnini Gösterir.
      ),
      body: IndexedStack( // Sayfaları State'lerini Koruyarak Üst Üste Tutar ve Sadece Seçileni Gösterir.
        index: _currentIndex, // Gösterilecek Sayfanın Index'ini Belirler.
        children: [ // IndexedStack'in Sayfa Listesini Başlatır.
          WaterTrackerView(controller: _waterController), // Su Takibi Sayfasını Controller'ıyla Oluşturur.
          WorkoutView(controller: _workoutController), // Antrenman Sayfasını Controller'ıyla Oluşturur.
        ],
      ),
      bottomNavigationBar: NavigationBar( // Alt Navigasyon Bar'ını Oluşturur.
        selectedIndex: _currentIndex, // Seçili Sekmenin Index'ini Belirler.
        backgroundColor: AppColors.surface, // Bar'ın Arka Plan Rengini Belirler.
        indicatorColor: AppColors.surfaceVariant, // Seçili Sekme Göstergesinin Rengini Belirler.
        onDestinationSelected: (index) { // Bir Sekme Seçildiğinde Çalışan Callback'tir.
          setState(() { // State Değişikliğini Bildirip Arayüzü Yeniden Çizdirir.
            _currentIndex = index; // Seçili Index'i Günceller.
          });
        },
        destinations: const [ // Navigasyon Sekmelerinin Listesini Başlatır.
          NavigationDestination( // Su Takibi Sekmesini Tanımlar.
            icon: Icon(Icons.water_drop_outlined), // Seçili Değilken Gösterilen İkondur.
            selectedIcon: Icon(Icons.water_drop, color: AppColors.neonCyan), // Seçiliyken Gösterilen Neon Cyan İkondur.
            label: 'Su Takibi', // Sekme Etiketini Gösterir.
          ),
          NavigationDestination( // Antrenman Sekmesini Tanımlar.
            icon: Icon(Icons.fitness_center_outlined), // Seçili Değilken Gösterilen İkondur.
            selectedIcon: Icon(Icons.fitness_center, color: AppColors.neonGreen), // Seçiliyken Gösterilen Neon Yeşil İkondur.
            label: 'Antrenman', // Sekme Etiketini Gösterir.
          ),
        ],
      ),
    );
  }
}
