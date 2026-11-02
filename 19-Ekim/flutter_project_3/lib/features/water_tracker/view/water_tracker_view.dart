import 'package:flutter/material.dart'; // Flutter'ın Material Widget'larını import Eder.

import '../../../core/theme/theme_controller.dart'; // Theme Değişimini Yöneten ThemeController'ı import Eder.
import '../controller/water_tracker_controller.dart'; // Su Takibi Controller'ını import Eder.
import '../models/water_log.dart'; // WaterLog Model'ini import Eder.
import '../widgets/quick_add_water_grid.dart'; // Hızlı Su Ekleme Widget'ını import Eder.
import '../widgets/water_history_list.dart'; // Su Geçmişi Listesi Widget'ını import Eder.
import '../widgets/water_progress_card.dart'; // Su İlerleme Kartı Widget'ını import Eder.

class WaterTrackerView extends StatefulWidget { // Su Takibi Ana Ekranıdır, State Tutan Bir StatefulWidget'tır.
  const WaterTrackerView({super.key}); // key Parametresini Superclass'a İleten const Constructor'dır.

  @override // Superclass'taki createState Metodunun Override Edildiğini Belirtir.
  State<WaterTrackerView> createState() => _WaterTrackerViewState(); // Bu Widget'ın State Nesnesini Oluşturur.
}

class _WaterTrackerViewState extends State<WaterTrackerView> { // WaterTrackerView'ın State Class'ıdır.
  late final WaterTrackerController _controller; // Sonradan Atanacak Su Takibi Controller'ıdır.

  @override // Superclass'taki initState Metodunun Override Edildiğini Belirtir.
  void initState() { // State İlk Oluşturulduğunda Çalışır.
    super.initState(); // Superclass'ın initState Metodunu Çağırır.
    _controller = WaterTrackerController(); // Controller Instance'ını Oluşturur.
  }

  @override // Superclass'taki dispose Metodunun Override Edildiğini Belirtir.
  void dispose() { // State Kaldırılırken Kaynakları Temizler.
    _controller.dispose(); // Controller'daki ValueNotifier'ları Dispose Eder.
    super.dispose(); // Superclass'ın dispose Metodunu Çağırır.
  }

  @override // Superclass'taki build Metodunun Override Edildiğini Belirtir.
  Widget build(BuildContext context) { // Ekranın Widget Tree'sini Oluşturur.
    return Scaffold( // Sayfanın Temel Material Layout'unu Oluşturur.
      appBar: AppBar( // Üst Uygulama Çubuğunu Oluşturur.
        title: const Text('SUSADIM v1'), // AppBar Başlığını Gösterir.
        actions: [ // AppBar'ın Sağ Tarafındaki Aksiyon Butonlarını Tanımlar.
          ValueListenableBuilder<ThemeMode>( // ThemeMode Değiştikçe Theme Butonunu Yeniden Çizer.
            valueListenable: ThemeController.instance.themeModeNotifier, // Dinlenecek ThemeMode ValueNotifier'ını Belirtir.
            builder: (context, themeMode, _) { // Güncel ThemeMode İle Buton Üreten builder Callback'idir.
              final isDark = themeMode == ThemeMode.dark; // Dark Mode Aktif mi Diye Hesaplar.
              return IconButton( // Theme Değiştirme Butonunu Oluşturur.
                tooltip: isDark ? 'Aydınlık Moda Geç' : 'Karanlık Moda Geç', // Moda Göre Tooltip Metnini Belirler.
                icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode), // Moda Göre Icon Seçer.
                onPressed: ThemeController.instance.toggleTheme, // Basılınca Theme'i Değiştirir.
              );
            },
          ),
          IconButton( // Sıfırlama Butonunu Oluşturur.
            tooltip: 'Sıfırla', // Tooltip Metnini Belirler.
            icon: const Icon(Icons.refresh), // Yenile Icon'unu Gösterir.
            onPressed: _controller.resetWater, // Basılınca Su Verilerini Sıfırlar.
          ),
        ],
      ),
      body: SafeArea( // İçeriği Sistem Alanlarından Korur.
        child: SingleChildScrollView( // İçeriği Kaydırılabilir Yapar.
          padding: const EdgeInsets.all(16.0), // Her Yönden 16 Piksel Boşluk Verir.
          child: Column( // Alt Widget'ları Dikey Olarak Sıralar.
            crossAxisAlignment: CrossAxisAlignment.stretch, // Alt Widget'ları Yatayda Genişletir.
            children: [ // Column'un Alt Widget'larını Tanımlar.
              ValueListenableBuilder<int>( // Su Miktarı Değiştikçe İlerleme Kartını Yeniden Çizer.
                valueListenable: _controller.currentWater, // Dinlenecek currentWater ValueNotifier'ını Belirtir.
                builder: (context, currentWater, _) { // Güncel Su Miktarıyla Kart Üreten builder Callback'idir.
                  return WaterProgressCard( // Su İlerleme Kartını Oluşturur.
                    currentWater: currentWater, // Güncel Su Miktarını Karta İletir.
                    dailyGoal: _controller.dailyGoalWater, // Günlük Hedefi Karta İletir.
                  );
                },
              ),
              const SizedBox(height: 16), // 16 Piksel Dikey Boşluk Bırakır.
              QuickAddWaterGrid(onAddWater: _controller.addWater), // Hızlı Su Ekleme Butonlarını Gösterir.
              const SizedBox(height: 20), // 20 Piksel Dikey Boşluk Bırakır.
              ValueListenableBuilder<List<WaterLog>>( // Kayıtlar Değiştikçe Geçmiş Listesini Yeniden Çizer.
                valueListenable: _controller.logs, // Dinlenecek logs ValueNotifier'ını Belirtir.
                builder: (context, logs, _) { // Güncel Kayıtlarla Liste Üreten builder Callback'idir.
                  return WaterHistoryList(logs: logs); // Su Geçmişi Listesini Gösterir.
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
