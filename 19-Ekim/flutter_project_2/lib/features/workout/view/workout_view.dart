import 'package:flutter/material.dart'; // Flutter'ın Material Widget'larını import Eder.

import '../../../core/constants/app_colors.dart'; // Uygulama Renk Sabitlerini import Eder.
import '../controller/workout_controller.dart'; // Antrenman Controller'ını import Eder.
import '../models/workout_item.dart'; // WorkoutItem Model'ini import Eder.
import '../widget/workout_list_item.dart'; // Antrenman Liste Elemanı Widget'ını import Eder.
import '../widget/workout_summary_card.dart'; // Antrenman Özet Kartı Widget'ını import Eder.

class WorkoutView extends StatelessWidget { // Antrenman Sayfasıdır, State Tutmayan Bir StatelessWidget'tır.
  const WorkoutView({required this.controller, super.key}); // controller'ı required Alıp key'i Superclass'a İleten const Constructor'dır.

  final WorkoutController controller; // Sayfanın Kullandığı Antrenman Controller'ıdır.

  @override // Superclass'taki build Metodunun Override Edildiğini Belirtir.
  Widget build(BuildContext context) { // Antrenman Sayfasının Widget Tree'sini Oluşturur.
    return ListenableBuilder( // Controller Değiştikçe Arayüzü Yeniden Çizen Builder'dır.
      listenable: controller, // Dinlenecek Listenable Olarak controller'ı Verir.
      builder: (context, _) { // Her Değişiklikte Çağrılan builder Callback'idir.
        return SingleChildScrollView( // İçeriği Kaydırılabilir Hale Getirir.
          padding: const EdgeInsets.all(16), // Her Yönden 16 Birim Boşluk Verir.
          child: Column( // Child Widget'larını Dikey Olarak Dizer.
            crossAxisAlignment: CrossAxisAlignment.stretch, // Child Widget'ları Yatayda Tam Genişliğe Yayar.
            children: [ // Column'un Child Widget Listesini Başlatır.
              WorkoutSummaryCard( // Toplam Süre ve Kaloriyi Gösteren Özet Kartını Oluşturur.
                totalMinutes: controller.totalMinutes, // Toplam Dakikayı Karta Verir.
                totalCalories: controller.totalCalories, // Toplam Kaloriyi Karta Verir.
              ),
              const SizedBox(height: 16), // Dikey 16 Birim Boşluk Bırakır.
              _AddWorkoutQuickButton(onAdded: controller.addWorkout), // Hızlı Antrenman Ekleme Butonunu addWorkout Callback'iyle Gösterir.
              const SizedBox(height: 20), // Dikey 20 Birim Boşluk Bırakır.
              _WorkoutListSection( // Antrenman Listesi Bölümünü Oluşturur.
                workouts: controller.workouts, // Gösterilecek Antrenmanları Verir.
                onDelete: controller.removeWorkout, // Silme İşlemi İçin removeWorkout Callback'ini Verir.
              ),
            ],
          ),
        );
      },
    );
  }
}

class _AddWorkoutQuickButton extends StatelessWidget { // Hızlı Antrenman Ekleme Butonunu Gösteren Private StatelessWidget'tır.
  const _AddWorkoutQuickButton({required this.onAdded}); // onAdded Callback'ini required Alan const Constructor'dır.

  final void Function(WorkoutItem) onAdded; // Yeni Antrenman Eklenince Çağrılan Callback'tir.

  @override // Superclass'taki build Metodunun Override Edildiğini Belirtir.
  Widget build(BuildContext context) { // Butonun Widget Tree'sini Oluşturur.
    return ElevatedButton.icon( // İkonlu Yükseltilmiş Buton Oluşturur.
      style: ElevatedButton.styleFrom( // Butonun Stilini Tanımlar.
        backgroundColor: AppColors.neonGreen, // Buton Arka Plan Rengini Neon Yeşil Yapar.
        foregroundColor: AppColors.background, // Buton Yazı ve İkon Rengini Belirler.
        padding: const EdgeInsets.symmetric(vertical: 14), // Dikey 14 Birim İç Boşluk Verir.
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), // Butonun Köşelerini 12 Birim Yuvarlatır.
      ),
      onPressed: () { // Butona Basılınca Çalışan Callback'tir.
        final now = DateTime.now().millisecondsSinceEpoch; // Benzersiz id İçin Şu Anki Zaman Damgasını Alır.
        onAdded( // onAdded Callback'ini Yeni Antrenmanla Çağırır.
          WorkoutItem( // Yeni Bir WorkoutItem Nesnesi Oluşturur.
            id: now.toString(), // Zaman Damgasını id Olarak Atar.
            title: 'Hızlı Antrenman', // Antrenmanın Başlığını Belirler.
            durationMinutes: 20, // Süreyi 20 Dakika Olarak Belirler.
            caloriesBurned: 150, // Yakılan Kaloriyi 150 Olarak Belirler.
            category: WorkoutCategory.strength, // Kategoriyi Kuvvet Olarak Belirler.
          ),
        );
      },
      icon: const Icon(Icons.add, size: 20), // 20 Boyutunda Artı İkonunu Gösterir.
      label: const Text( // Buton Etiketini Oluşturur.
        'HIZLI ANTRENMAN EKLE', // Gösterilecek Etiket Metnidir.
        style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.5), // Kalın ve Hafif Aralıklı Yazı Stili Uygular.
      ),
    );
  }
}

class _WorkoutListSection extends StatelessWidget { // Antrenman Listesini Gösteren Private StatelessWidget'tır.
  const _WorkoutListSection({required this.workouts, required this.onDelete}); // workouts ve onDelete'i required Alan const Constructor'dır.

  final List<WorkoutItem> workouts; // Gösterilecek Antrenmanların Listesidir.
  final void Function(String id) onDelete; // Silme İçin id İle Çağrılan Callback'tir.

  @override // Superclass'taki build Metodunun Override Edildiğini Belirtir.
  Widget build(BuildContext context) { // Liste Bölümünün Widget Tree'sini Oluşturur.
    if (workouts.isEmpty) { // Antrenman Yoksa Boş Durum Mesajı Gösterir.
      return const Center( // Mesajı Ortalar.
        child: Padding( // Mesaja Boşluk Ekler.
          padding: EdgeInsets.symmetric(vertical: 24), // Dikey 24 Birim Boşluk Verir.
          child: Text( // Boş Durum Metnini Oluşturur.
            'Henüz antrenman kaydı yok.', // Gösterilecek Boş Durum Metnidir.
            style: TextStyle(color: AppColors.textMuted), // Soluk Metin Rengi Uygular.
          ),
        ),
      );
    }

    return ListView.separated( // Aralarında Ayırıcı Olan Bir ListView Oluşturur.
      shrinkWrap: true, // ListView'ın Sadece İçeriği Kadar Yer Kaplamasını Sağlar.
      physics: const NeverScrollableScrollPhysics(), // ListView'ın Kendi Kaydırmasını Kapatır.
      itemCount: workouts.length, // Eleman Sayısını Antrenman Sayısı Kadar Yapar.
      separatorBuilder: (context, index) => const SizedBox(height: 8), // Elemanlar Arasına 8 Birim Boşluk Koyar.
      itemBuilder: (context, index) { // Her Eleman İçin Widget Oluşturan Callback'tir.
        final item = workouts[index]; // İlgili Index'teki Antrenmanı Alır.
        return WorkoutListItem( // Antrenman Satırı Widget'ını Oluşturur.
          workout: item, // Gösterilecek Antrenmanı Verir.
          onDelete: () => onDelete(item.id), // Silme Butonunda Antrenmanın id'siyle onDelete'i Çağırır.
        );
      },
    );
  }
}
