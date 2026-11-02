import 'package:flutter/material.dart'; // Flutter'ın Material Widget'larını import Eder.
import '../../../core/constants/app_colors.dart'; // Uygulama Renk Sabitlerini import Eder.
import '../models/workout_item.dart'; // WorkoutItem Model'ini import Eder.

class WorkoutListItem extends StatelessWidget { // Tek Bir Antrenman Satırını Gösteren StatelessWidget'tır.
  const WorkoutListItem({ // Named Parametreli const Constructor'dır.
    required this.workout, // workout Field'ını required Yapar.
    required this.onDelete, // onDelete Field'ını required Yapar.
    super.key, // key Parametresini Superclass'a İletir.
  });

  final WorkoutItem workout; // Gösterilecek Antrenman Verisidir.
  final VoidCallback onDelete; // Silme Butonuna Basılınca Çağrılan Callback'tir.

  @override // Superclass'taki build Metodunun Override Edildiğini Belirtir.
  Widget build(BuildContext context) { // Antrenman Satırının Widget Tree'sini Oluşturur.
    return Container( // Satırın Kutusunu Oluşturur.
      padding: const EdgeInsets.all(14), // Her Yönden 14 Birim İç Boşluk Verir.
      decoration: BoxDecoration( // Kutunun Görünümünü Tanımlar.
        color: AppColors.surface, // Kutu Arka Plan Rengini Belirler.
        borderRadius: BorderRadius.circular(12), // Köşe Yarıçapını 12 Olarak Belirler.
        border: Border.all(color: AppColors.border), // Kutuya Kenarlık Ekler.
      ),
      child: Row( // Satır İçeriğini Yatay Dizer.
        children: [ // Row'un Child Widget Listesini Başlatır.
          _CategoryBadge(category: workout.category), // Kategori İkon Rozetini Gösterir.
          const SizedBox(width: 12), // Yatay 12 Birim Boşluk Bırakır.
          Expanded( // Metin Alanının Kalan Genişliği Kaplamasını Sağlar.
            child: Column( // Başlık ve Detayı Dikey Dizer.
              crossAxisAlignment: CrossAxisAlignment.start, // Child Widget'ları Sola Hizalar.
              children: [ // Column'un Child Widget Listesini Başlatır.
                Text( // Antrenman Başlığını Gösteren Metni Oluşturur.
                  workout.title, // Antrenmanın Başlığını Yazdırır.
                  style: const TextStyle( // Başlık Stilini Tanımlar.
                    color: AppColors.textPrimary, // Metin Rengini Birincil Renk Yapar.
                    fontWeight: FontWeight.w600, // Yazı Kalınlığını w600 Yapar.
                  ),
                ),
                const SizedBox(height: 4), // Dikey 4 Birim Boşluk Bırakır.
                Text( // Süre ve Kalori Detayını Gösteren Metni Oluşturur.
                  '${workout.durationMinutes} dk • ${workout.caloriesBurned} kcal', // Süreyi ve Kaloriyi Yazdırır.
                  style: const TextStyle( // Detay Metninin Stilini Tanımlar.
                    color: AppColors.textMuted, // Metin Rengini Soluk Renk Yapar.
                    fontSize: 12, // Yazı Boyutunu 12 Yapar.
                  ),
                ),
              ],
            ),
          ),
          IconButton( // Silme İkon Butonunu Oluşturur.
            icon: const Icon(Icons.delete_outline, size: 20), // Çöp Kutusu İkonunu Gösterir.
            color: AppColors.neonPink, // İkon Rengini Neon Pembe Yapar.
            onPressed: onDelete, // Basılınca onDelete Callback'ini Çağırır.
          ),
        ],
      ),
    );
  }
}

class _CategoryBadge extends StatelessWidget { // Kategoriye Göre İkon Rozeti Gösteren Private StatelessWidget'tır.
  const _CategoryBadge({required this.category}); // category'yi required Alan const Constructor'dır.

  final WorkoutCategory category; // Rozetin Temsil Ettiği Antrenman Kategorisidir.

  @override // Superclass'taki build Metodunun Override Edildiğini Belirtir.
  Widget build(BuildContext context) { // Rozetin Widget Tree'sini Oluşturur.
    final iconData = switch (category) { // Kategoriye Göre İkonu switch Expression İle Seçer.
      WorkoutCategory.cardio => Icons.directions_run, // Kardiyo İçin Koşu İkonunu Seçer.
      WorkoutCategory.strength => Icons.fitness_center, // Kuvvet İçin Dambıl İkonunu Seçer.
      WorkoutCategory.flexibility => Icons.self_improvement, // Esneme İçin Meditasyon İkonunu Seçer.
    };

    return Container( // Rozet Kutusunu Oluşturur.
      padding: const EdgeInsets.all(8), // Her Yönden 8 Birim İç Boşluk Verir.
      decoration: BoxDecoration( // Kutunun Görünümünü Tanımlar.
        color: AppColors.surfaceVariant, // Kutu Arka Plan Rengini Belirler.
        borderRadius: BorderRadius.circular(8), // Köşe Yarıçapını 8 Olarak Belirler.
      ),
      child: Icon(iconData, color: AppColors.neonGreen, size: 20), // Seçilen İkonu Neon Yeşil Renkte Gösterir.
    );
  }
}
