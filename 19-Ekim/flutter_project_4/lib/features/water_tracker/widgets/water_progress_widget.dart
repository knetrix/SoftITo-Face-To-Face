import 'package:flutter/material.dart'; // Flutter'ın Material Widget'larını import Eder.
import '../../../core/constants/app_colors.dart'; // Renk Sabitlerini İçeren AppColors'u import Eder.

class WaterProgressWidget extends StatelessWidget { // Su İlerlemesini Dairesel Gösterge İle Gösteren StatelessWidget'tır.
  final int currentWaterMl; // Mevcut Su Miktarını Tutar.
  final int dailyGoalMl; // Günlük Su Hedefini Tutar.
  final double progress; // İlerleme Oranını Tutar.
  final bool isGoalReached; // Hedefe Ulaşılıp Ulaşılmadığını Tutar.

  const WaterProgressWidget({ // Widget'ın const Constructor'ıdır.
    super.key, // key Parametresini Superclass'a İletir.
    required this.currentWaterMl, // currentWaterMl Field'ını required Yapar.
    required this.dailyGoalMl, // dailyGoalMl Field'ını required Yapar.
    required this.progress, // progress Field'ını required Yapar.
    required this.isGoalReached, // isGoalReached Field'ını required Yapar.
  });

  @override // Superclass'taki build Metodunun Override Edildiğini Belirtir.
  Widget build(BuildContext context) { // İlerleme Kartının Widget Tree'sini Oluşturur.
    return Card( // İçeriği Bir Card İçinde Gösterir.
      child: Padding( // Card İçine Boşluk Veren Padding Widget'ıdır.
        padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20), // Dikey 28, Yatay 20 Birim Boşluk Bırakır.
        child: Column( // Gösterge ve Durum Metnini Dikey Olarak Sıralar.
          children: [ // Column'un Alt Widget Listesidir.
            Stack( // Göstergeyi ve Ortadaki İçeriği Üst Üste Bindirir.
              alignment: Alignment.center, // Çocukları Ortaya Hizalar.
              children: [ // Stack'in Alt Widget Listesidir.
                SizedBox( // Göstergeye Sabit Boyut Verir.
                  width: 170, // Genişliği 170 Yapar.
                  height: 170, // Yüksekliği 170 Yapar.
                  child: CircularProgressIndicator( // Dairesel İlerleme Göstergesini Oluşturur.
                    value: progress, // Göstergenin Doluluk Oranını Belirler.
                    strokeWidth: 14, // Çizgi Kalınlığını 14 Yapar.
                    backgroundColor: AppColors.surfaceElevated, // Göstergenin Arka Plan Rengini Belirler.
                    valueColor: AlwaysStoppedAnimation<Color>( // Göstergenin Dolu Kısım Rengini Sabit Olarak Belirler.
                      isGoalReached ? AppColors.neonLime : AppColors.neonCyan, // Hedefe Ulaşıldıysa Lime, Değilse Cyan Kullanır.
                    ),
                  ),
                ),
                Column( // Ortadaki Icon ve Metinleri Dikey Olarak Sıralar.
                  mainAxisSize: MainAxisSize.min, // Column'u İçeriği Kadar Küçültür.
                  children: [ // Column'un Alt Widget Listesidir.
                    Icon( // Duruma Göre Icon Gösterir.
                      isGoalReached ? Icons.check_circle : Icons.water_drop, // Hedefe Ulaşıldıysa Onay, Değilse Damla Icon'u Seçer.
                      color: isGoalReached ? AppColors.neonLime : AppColors.neonCyan, // Duruma Göre Icon Rengini Seçer.
                      size: 36, // Icon Boyutunu 36 Yapar.
                    ),
                    const SizedBox(height: 6), // Dikeyde 6 Birim Boşluk Bırakır.
                    Text( // Mevcut Su Miktarını Gösterir.
                      '$currentWaterMl', // Su Miktarını String'e Çevirir.
                      style: const TextStyle( // Miktarın Yazı Stilini Tanımlar.
                        fontSize: 32, // Yazı Boyutunu 32 Yapar.
                        fontWeight: FontWeight.bold, // Yazıyı Kalın Yapar.
                        color: AppColors.textPrimary, // Yazı Rengini Birincil Metin Rengi Yapar.
                      ),
                    ),
                    Text( // Günlük Hedefi Gösterir.
                      '/ $dailyGoalMl ml', // Hedefi İçeren Metindir.
                      style: const TextStyle( // Hedef Metninin Yazı Stilini Tanımlar.
                        fontSize: 14, // Yazı Boyutunu 14 Yapar.
                        color: AppColors.textSecondary, // Yazı Rengini İkincil Metin Rengi Yapar.
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20), // Dikeyde 20 Birim Boşluk Bırakır.
            Text( // İlerleme Durum Metnini Gösterir.
              isGoalReached // Hedefe Ulaşılıp Ulaşılmadığını Kontrol Eder.
                  ? 'Tebrikler! Günlük su hedefine ulaştın.' // Hedefe Ulaşıldıysa Tebrik Mesajını Gösterir.
                  : '%${(progress * 100).toInt()} tamamlandı', // Değilse Tamamlanma Yüzdesini Gösterir.
              style: TextStyle( // Durum Metninin Yazı Stilini Tanımlar.
                color: isGoalReached ? AppColors.neonLime : AppColors.neonCyan, // Duruma Göre Yazı Rengini Seçer.
                fontWeight: FontWeight.w600, // Yazıyı Yarı Kalın Yapar.
                fontSize: 14, // Yazı Boyutunu 14 Yapar.
              ),
            ),
          ],
        ),
      ),
    );
  }
}
