import 'package:flutter/material.dart'; // Flutter'ın Material Widget'larını import Eder.
import '../../../core/constants/app_colors.dart'; // Uygulama Renk Sabitlerini import Eder.
import '../controllers/workout_controller.dart'; // WorkoutController Class'ını import Eder.
import '../models/workout_model.dart'; // WorkoutModel Class'ını import Eder.
import '../widgets/workout_add_dialog_widget.dart'; // Egzersiz Ekleme Dialog Widget'ını import Eder.
import '../widgets/workout_item_card_widget.dart'; // Antrenman Kartı Widget'ını import Eder.
import '../widgets/workout_stats_card_widget.dart'; // İstatistik Kartı Widget'ını import Eder.

class WorkoutView extends StatelessWidget { // Antrenman Sayfasını Gösteren, State Tutmayan Bir StatelessWidget'tır.
  final WorkoutController controller; // Sayfanın Kullandığı WorkoutController'ı Tutar.

  const WorkoutView({ // key ve controller Alan const Constructor'dır.
    super.key, // key Parametresini Superclass'a İletir.
    required this.controller, // controller Field'ını required Yapar.
  });

  void _showAddDialog(BuildContext context) { // Yeni Egzersiz Ekleme Dialog'unu Açan Metottur.
    showDialog( // Ekranda Bir Dialog Gösterir.
      context: context, // Dialog'un Açılacağı context'i Belirtir.
      builder: (ctx) => WorkoutAddDialogWidget( // Dialog İçeriği Olarak WorkoutAddDialogWidget'ı Oluşturur.
        onAdd: controller.addCustomWorkout, // Ekleme Callback'i Olarak Controller'ın addCustomWorkout Metodunu Verir.
      ),
    );
  }

  @override // Superclass'taki build Metodunun Override Edildiğini Belirtir.
  Widget build(BuildContext context) { // Antrenman Sayfasının Widget Tree'sini Oluşturur.
    return ValueListenableBuilder<WorkoutModel>( // State Değiştikçe Arayüzü Yeniden Oluşturan Builder'dır.
      valueListenable: controller.state, // Dinlenecek ValueNotifier Olarak Controller State'ini Verir.
      builder: (context, data, _) { // Güncel WorkoutModel Verisiyle Arayüzü Oluşturur.
        return SingleChildScrollView( // İçeriği Kaydırılabilir Yapar.
          padding: const EdgeInsets.all(16.0), // Tüm Kenarlara 16 Piksel Boşluk Verir.
          child: Column( // Elemanları Dikey Olarak Sıralar.
            crossAxisAlignment: CrossAxisAlignment.stretch, // Elemanları Yatayda Tam Genişliğe Yayar.
            children: [ // Column'un Alt Widget'larını Tanımlar.
              WorkoutStatsCardWidget( // Günlük İstatistik Kartını Gösterir.
                totalCalories: data.totalCaloriesBurned, // Toplam Yakılan Kaloriyi Karta Verir.
                calorieGoal: data.dailyCalorieGoal, // Günlük Kalori Hedefini Karta Verir.
                activeMinutes: data.totalActiveMinutes, // Toplam Aktif Süreyi Karta Verir.
                progress: data.calorieProgress, // Kalori İlerleme Oranını Karta Verir.
              ),
              const SizedBox(height: 20), // 20 Piksel Dikey Boşluk Bırakır.
              Row( // Başlık ve Ekle Butonunu Yatayda Sıralar.
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // Elemanları İki Uca Yaslar.
                children: [ // Row'un Alt Widget'larını Tanımlar.
                  const Text( // Liste Başlığını Gösteren const Text Widget'ıdır.
                    'Günlük Antrenman Listesi', // Gösterilecek Başlık Metnidir.
                    style: TextStyle( // Başlığın Yazı Stilini Belirler.
                      fontSize: 16, // Yazı Boyutunu 16 Yapar.
                      fontWeight: FontWeight.bold, // Yazıyı Kalın Yapar.
                      color: AppColors.textPrimary, // Yazı Rengini Birincil Metin Rengi Yapar.
                    ),
                  ),
                  IconButton( // Egzersiz Ekleme İkon Butonunu Oluşturur.
                    onPressed: () => _showAddDialog(context), // Butona Basılınca Ekleme Dialog'unu Açar.
                    icon: const Icon(Icons.add_circle, color: AppColors.neonLime), // Neon Lime Renkli Ekle İkonunu Gösterir.
                    tooltip: 'Egzersiz Ekle', // Uzun Basışta Gösterilecek İpucu Metnidir.
                  ),
                ],
              ),
              const SizedBox(height: 8), // 8 Piksel Dikey Boşluk Bırakır.
              ListView.separated( // Aralarında Ayırıcı Olan Bir ListView Oluşturur.
                shrinkWrap: true, // ListView'in Yüksekliğini İçeriğe Göre Ayarlar.
                physics: const NeverScrollableScrollPhysics(), // ListView'in Kendi Kaydırmasını Devre Dışı Bırakır.
                itemCount: data.workouts.length, // Liste Eleman Sayısını Antrenman Sayısı Kadar Belirler.
                separatorBuilder: (_, _) => const SizedBox(height: 8), // Elemanlar Arasına 8 Piksel Boşluk Koyar.
                itemBuilder: (context, index) { // Her Index İçin Bir Liste Elemanı Oluşturur.
                  final workout = data.workouts[index]; // İlgili Index'teki Antrenmanı Alır.
                  return WorkoutItemCardWidget( // Antrenmanı Gösteren Kart Widget'ını Döndürür.
                    workout: workout, // Gösterilecek Antrenmanı Karta Verir.
                    onToggle: () => controller.toggleWorkoutCompletion(workout.id), // Karta Dokunulunca Tamamlanma Durumunu Değiştirir.
                  );
                },
              ),
              const SizedBox(height: 16), // 16 Piksel Dikey Boşluk Bırakır.
              OutlinedButton.icon( // İkonlu Kenarlıklı Bir Buton Oluşturur.
                onPressed: controller.resetAll, // Butona Basılınca Tüm Antrenmanları Sıfırlar.
                icon: const Icon(Icons.refresh, size: 18), // Yenileme İkonunu Gösterir.
                label: const Text('Antrenmanları Sıfırla'), // Butonun label Metnini Gösterir.
              ),
            ],
          ),
        );
      },
    );
  }
}
