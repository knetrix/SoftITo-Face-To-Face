import 'package:flutter/material.dart'; // Flutter'ın Material Widget'larını import Eder.
import '../../../core/constants/app_colors.dart'; // Uygulama Renk Sabitlerini import Eder.
import '../models/workout_model.dart'; // WorkoutItem Modelini import Eder.

class WorkoutItemCardWidget extends StatelessWidget { // Tek Bir Antrenmanı Kart Olarak Gösteren StatelessWidget'tır.
  final WorkoutItem workout; // Kartta Gösterilecek Antrenmanı Tutar.
  final VoidCallback onToggle; // Tamamlanma Durumu Değiştirildiğinde Çağrılacak Callback'tir.

  const WorkoutItemCardWidget({ // key, workout ve onToggle Alan const Constructor'dır.
    super.key, // key Parametresini Superclass'a İletir.
    required this.workout, // workout Field'ını required Yapar.
    required this.onToggle, // onToggle Field'ını required Yapar.
  });

  @override // Superclass'taki build Metodunun Override Edildiğini Belirtir.
  Widget build(BuildContext context) { // Antrenman Kartının Widget Tree'sini Oluşturur.
    final isDone = workout.isCompleted; // Antrenmanın Tamamlanma Durumunu Yerel Değişkene Alır.

    return InkWell( // Karta Dokunma Efekti ve Tıklama Özelliği Kazandırır.
      onTap: onToggle, // Karta Dokunulunca onToggle Callback'ini Çağırır.
      borderRadius: BorderRadius.circular(16), // Dokunma Efektinin Köşelerini 16 Piksel Yuvarlar.
      child: Container( // Kartın Gövdesini Oluşturan Container'dır.
        padding: const EdgeInsets.all(16), // Tüm Kenarlara 16 Piksel İç Boşluk Verir.
        decoration: BoxDecoration( // Kartın Görünümünü Belirler.
          color: AppColors.surface, // Kart Arka Plan Rengini Yüzey Rengi Yapar.
          borderRadius: BorderRadius.circular(16), // Kart Köşelerini 16 Piksel Yuvarlar.
          border: Border.all( // Kartın Etrafına Kenarlık Çizer.
            color: isDone ? AppColors.neonLime.withAlpha(100) : AppColors.border, // Tamamlandıysa Neon Lime, Değilse Standart Kenarlık Rengi Kullanır.
            width: isDone ? 1.5 : 1, // Tamamlandıysa Kenarlığı Daha Kalın Yapar.
          ),
        ),
        child: Row( // Kart İçeriğini Yatay Olarak Sıralar.
          children: [ // Row'un Alt Widget'larını Tanımlar.
            Container( // İkonu Çevreleyen Yuvarlak Container'dır.
              width: 44, // Container Genişliğini 44 Piksel Yapar.
              height: 44, // Container Yüksekliğini 44 Piksel Yapar.
              decoration: BoxDecoration( // Yuvarlak Arka Planın Görünümünü Belirler.
                color: isDone // Tamamlanma Durumuna Göre Arka Plan Rengini Seçer.
                    ? AppColors.neonLime.withAlpha(30) // Tamamlandıysa Şeffaf Neon Lime Rengi Kullanır.
                    : AppColors.surfaceElevated, // Tamamlanmadıysa Yükseltilmiş Yüzey Rengini Kullanır.
                shape: BoxShape.circle, // Arka Planı Daire Şeklinde Yapar.
              ),
              child: Icon( // Antrenman Durumunu Gösteren İkonu Oluşturur.
                isDone ? Icons.check : Icons.fitness_center, // Tamamlandıysa Onay, Değilse Fitness İkonu Gösterir.
                color: isDone ? AppColors.neonLime : AppColors.neonCyan, // Duruma Göre İkon Rengini Belirler.
                size: 22, // İkon Boyutunu 22 Yapar.
              ),
            ),
            const SizedBox(width: 14), // 14 Piksel Yatay Boşluk Bırakır.
            Expanded( // Metin Alanının Kalan Genişliği Doldurmasını Sağlar.
              child: Column( // Başlık ve Detayları Dikey Olarak Sıralar.
                crossAxisAlignment: CrossAxisAlignment.start, // Elemanları Sola Hizalar.
                children: [ // Column'un Alt Widget'larını Tanımlar.
                  Text( // Antrenman Başlığını Gösteren Text Widget'ıdır.
                    workout.title, // Antrenmanın Başlığını Gösterir.
                    style: TextStyle( // Başlığın Yazı Stilini Belirler.
                      fontSize: 15, // Yazı Boyutunu 15 Yapar.
                      fontWeight: FontWeight.w600, // Yazıyı Yarı Kalın Yapar.
                      color: isDone ? AppColors.textSecondary : AppColors.textPrimary, // Tamamlandıysa Soluk, Değilse Birincil Metin Rengi Kullanır.
                      decoration: isDone ? TextDecoration.lineThrough : null, // Tamamlandıysa Metnin Üstünü Çizer.
                    ),
                  ),
                  const SizedBox(height: 4), // 4 Piksel Dikey Boşluk Bırakır.
                  Row( // Kategori ve Detay Bilgilerini Yatayda Sıralar.
                    children: [ // Row'un Alt Widget'larını Tanımlar.
                      Container( // Kategori Etiketini Çevreleyen Container'dır.
                        padding: const EdgeInsets.symmetric( // Etikete Simetrik İç Boşluk Verir.
                            horizontal: 6, vertical: 2), // Yatayda 6, Dikeyde 2 Piksel Boşluk Belirler.
                        decoration: BoxDecoration( // Etiketin Görünümünü Belirler.
                          color: AppColors.surfaceElevated, // Etiket Arka Plan Rengini Yükseltilmiş Yüzey Rengi Yapar.
                          borderRadius: BorderRadius.circular(4), // Etiket Köşelerini 4 Piksel Yuvarlar.
                        ),
                        child: Text( // Kategori Adını Gösteren Text Widget'ıdır.
                          workout.category, // Antrenmanın Kategorisini Gösterir.
                          style: const TextStyle( // Kategori Yazı Stilini Belirler.
                            fontSize: 10, // Yazı Boyutunu 10 Yapar.
                            color: AppColors.neonCyan, // Yazı Rengini Neon Cyan Yapar.
                          ),
                        ),
                      ),
                      const SizedBox(width: 8), // 8 Piksel Yatay Boşluk Bırakır.
                      Text( // Süre ve Kalori Bilgisini Gösteren Text Widget'ıdır.
                        '${workout.durationMinutes} dk • ${workout.caloriesBurned} kcal', // Süreyi ve Kaloriyi Tek Metinde Birleştirir.
                        style: const TextStyle( // Detay Yazı Stilini Belirler.
                          fontSize: 12, // Yazı Boyutunu 12 Yapar.
                          color: AppColors.textSecondary, // Yazı Rengini İkincil Metin Rengi Yapar.
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Checkbox( // Tamamlanma Durumunu Gösteren Checkbox'tır.
              value: isDone, // Checkbox'ın value'sunu Tamamlanma Durumuna Bağlar.
              activeColor: AppColors.neonLime, // İşaretliyken Arka Plan Rengini Neon Lime Yapar.
              checkColor: Colors.black, // Onay İşaretinin Rengini Siyah Yapar.
              side: const BorderSide(color: AppColors.textSecondary, width: 1.5), // Checkbox Kenarlığının Rengini ve Kalınlığını Belirler.
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)), // Checkbox Köşelerini 4 Piksel Yuvarlar.
              onChanged: (_) => onToggle(), // Checkbox Değişince onToggle Callback'ini Çağırır.
            ),
          ],
        ),
      ),
    );
  }
}
