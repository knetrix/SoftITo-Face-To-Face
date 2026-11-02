import 'package:flutter/material.dart'; // Flutter'ın Material Widget'larını import Eder.
import '../controllers/water_tracker_controller.dart'; // Su Takibi Controller'ını import Eder.
import '../models/water_tracker_model.dart'; // Su Takibi Model'ini import Eder.
import '../widgets/water_history_list_widget.dart'; // Su Geçmişi Listesi Widget'ını import Eder.
import '../widgets/water_progress_widget.dart'; // Su İlerleme Widget'ını import Eder.
import '../widgets/water_quick_add_widget.dart'; // Hızlı Su Ekleme Widget'ını import Eder.

class WaterTrackerView extends StatelessWidget { // Su Takibi Sayfasını Oluşturan StatelessWidget'tır.
  final WaterTrackerController controller; // Sayfanın Kullandığı Su Takibi Controller'ıdır.

  const WaterTrackerView({ // View'ın const Constructor'ıdır.
    super.key, // key Parametresini Superclass'a İletir.
    required this.controller, // controller Field'ını required Yapar.
  });

  @override // Superclass'taki build Metodunun Override Edildiğini Belirtir.
  Widget build(BuildContext context) { // Su Takibi Sayfasının Widget Tree'sini Oluşturur.
    return ValueListenableBuilder<WaterTrackerModel>( // State Değiştikçe Arayüzü Yeniden Çizer.
      valueListenable: controller.state, // Dinlenecek ValueNotifier'ı Belirtir.
      builder: (context, data, _) { // Güncel Veriyle Arayüzü Oluşturan Callback'tir.
        return SingleChildScrollView( // İçeriği Kaydırılabilir Yapar.
          padding: const EdgeInsets.all(16.0), // Her Yönden 16 Birim Boşluk Bırakır.
          child: Column( // Widget'ları Dikey Olarak Sıralar.
            crossAxisAlignment: CrossAxisAlignment.stretch, // Çocukları Yatayda Tam Genişliğe Yayar.
            children: [ // Column'un Alt Widget Listesidir.
              WaterProgressWidget( // Su İlerleme Göstergesini Oluşturur.
                currentWaterMl: data.currentWaterMl, // Mevcut Su Miktarını Aktarır.
                dailyGoalMl: data.dailyGoalMl, // Günlük Hedefi Aktarır.
                progress: data.progress, // İlerleme Oranını Aktarır.
                isGoalReached: data.isGoalReached, // Hedefe Ulaşılma Durumunu Aktarır.
              ),
              const SizedBox(height: 20), // Dikeyde 20 Birim Boşluk Bırakır.
              WaterQuickAddWidget( // Hızlı Su Ekleme Butonlarını Oluşturur.
                onAddWater: controller.addWater, // Su Ekleme Callback'ini Controller'a Bağlar.
                onReset: controller.resetWater, // Sıfırlama Callback'ini Controller'a Bağlar.
              ),
              const SizedBox(height: 24), // Dikeyde 24 Birim Boşluk Bırakır.
              WaterHistoryListWidget( // Su Tüketim Geçmişi Listesini Oluşturur.
                history: data.intakeHistory, // Geçmiş Listesini Aktarır.
              ),
            ],
          ),
        );
      },
    );
  }
}
