import 'package:flutter/material.dart'; // Flutter'ın Material Widget'larını import Eder.
import '../../../core/constants/app_colors.dart'; // Uygulama Renk Sabitlerini import Eder.

class WorkoutStatsCardWidget extends StatelessWidget { // Günlük Antrenman İstatistiklerini Gösteren StatelessWidget'tır.
  final int totalCalories; // Toplam Yakılan Kaloriyi Tutar.
  final int calorieGoal; // Günlük Kalori Hedefini Tutar.
  final int activeMinutes; // Toplam Aktif Süreyi Dakika Olarak Tutar.
  final double progress; // Kalori Hedefine Ulaşma Oranını Tutar.

  const WorkoutStatsCardWidget({ // İstatistik Değerlerini Alan const Constructor'dır.
    super.key, // key Parametresini Superclass'a İletir.
    required this.totalCalories, // totalCalories Field'ını required Yapar.
    required this.calorieGoal, // calorieGoal Field'ını required Yapar.
    required this.activeMinutes, // activeMinutes Field'ını required Yapar.
    required this.progress, // progress Field'ını required Yapar.
  });

  @override // Superclass'taki build Metodunun Override Edildiğini Belirtir.
  Widget build(BuildContext context) { // İstatistik Kartının Widget Tree'sini Oluşturur.
    return Card( // İçeriği Material Card İçinde Gösterir.
      child: Padding( // Kart İçeriğine İç Boşluk Ekler.
        padding: const EdgeInsets.all(20.0), // Tüm Kenarlara 20 Piksel Boşluk Verir.
        child: Column( // Kart İçeriğini Dikey Olarak Sıralar.
          children: [ // Column'un Alt Widget'larını Tanımlar.
            Row( // İstatistik Öğelerini Yatayda Sıralar.
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // Öğeleri Eşit Aralıklarla İki Uca Yayar.
              children: [ // Row'un Alt Widget'larını Tanımlar.
                _StatItem( // Yakılan Kalori İstatistiğini Gösterir.
                  icon: Icons.local_fire_department, // Ateş İkonunu Kullanır.
                  iconColor: AppColors.neonPink, // İkon Rengini Neon Pink Yapar.
                  value: '$totalCalories', // Toplam Kaloriyi String Olarak Verir.
                  unit: 'kcal', // Birim Olarak kcal Gösterir.
                  label: 'Yakılan Kalori', // Öğenin label Metnini Belirler.
                ),
                Container( // Öğeler Arasında Dikey Ayırıcı Çizgi Oluşturur.
                  width: 1, // Ayırıcı Genişliğini 1 Piksel Yapar.
                  height: 40, // Ayırıcı Yüksekliğini 40 Piksel Yapar.
                  color: AppColors.border, // Ayırıcı Rengini Kenarlık Rengi Yapar.
                ),
                _StatItem( // Aktif Süre İstatistiğini Gösterir.
                  icon: Icons.timer, // Zamanlayıcı İkonunu Kullanır.
                  iconColor: AppColors.neonCyan, // İkon Rengini Neon Cyan Yapar.
                  value: '$activeMinutes', // Aktif Süreyi String Olarak Verir.
                  unit: 'dk', // Birim Olarak dk Gösterir.
                  label: 'Aktif Süre', // Öğenin label Metnini Belirler.
                ),
                Container( // Öğeler Arasında Dikey Ayırıcı Çizgi Oluşturur.
                  width: 1, // Ayırıcı Genişliğini 1 Piksel Yapar.
                  height: 40, // Ayırıcı Yüksekliğini 40 Piksel Yapar.
                  color: AppColors.border, // Ayırıcı Rengini Kenarlık Rengi Yapar.
                ),
                _StatItem( // Günlük Hedef İstatistiğini Gösterir.
                  icon: Icons.flag, // Bayrak İkonunu Kullanır.
                  iconColor: AppColors.neonLime, // İkon Rengini Neon Lime Yapar.
                  value: '$calorieGoal', // Kalori Hedefini String Olarak Verir.
                  unit: 'kcal', // Birim Olarak kcal Gösterir.
                  label: 'Günlük Hedef', // Öğenin label Metnini Belirler.
                ),
              ],
            ),
            const SizedBox(height: 20), // 20 Piksel Dikey Boşluk Bırakır.
            Column( // İlerleme Bölümünü Dikey Olarak Sıralar.
              crossAxisAlignment: CrossAxisAlignment.start, // Elemanları Sola Hizalar.
              children: [ // Column'un Alt Widget'larını Tanımlar.
                Row( // İlerleme Başlığını ve Yüzdesini Yatayda Sıralar.
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, // Elemanları İki Uca Yaslar.
                  children: [ // Row'un Alt Widget'larını Tanımlar.
                    const Text( // İlerleme Başlığını Gösteren const Text Widget'ıdır.
                      'Kalori Hedef İlerlemesi', // Gösterilecek Başlık Metnidir.
                      style: TextStyle(fontSize: 12, color: AppColors.textSecondary), // Küçük Boyutlu İkincil Renkli Yazı Stili Uygular.
                    ),
                    Text( // İlerleme Yüzdesini Gösteren Text Widget'ıdır.
                      '%${(progress * 100).toInt()}', // İlerleme Oranını Yüzdeye Çevirip Gösterir.
                      style: const TextStyle( // Yüzde Yazısının Stilini Belirler.
                        fontSize: 12, // Yazı Boyutunu 12 Yapar.
                        fontWeight: FontWeight.bold, // Yazıyı Kalın Yapar.
                        color: AppColors.neonPink, // Yazı Rengini Neon Pink Yapar.
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8), // 8 Piksel Dikey Boşluk Bırakır.
                LinearProgressIndicator( // Kalori İlerlemesini Yatay Çubukla Gösterir.
                  value: progress, // Çubuğun Doluluk value'sunu progress'e Bağlar.
                  minHeight: 8, // Çubuğun Minimum Yüksekliğini 8 Piksel Yapar.
                  backgroundColor: AppColors.surfaceElevated, // Çubuğun Arka Plan Rengini Belirler.
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.neonPink), // Dolu Kısmın Rengini Sabit Neon Pink Yapar.
                  borderRadius: BorderRadius.circular(4), // Çubuğun Köşelerini 4 Piksel Yuvarlar.
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget { // Tek Bir İstatistik Öğesini Gösteren Private StatelessWidget'tır.
  final IconData icon; // Gösterilecek İkonu Tutar.
  final Color iconColor; // İkonun Rengini Tutar.
  final String value; // Gösterilecek Sayısal Değeri Tutar.
  final String unit; // Değerin Birimini Tutar.
  final String label; // Öğenin Açıklama Metnini Tutar.

  const _StatItem({ // Öğe Bilgilerini Alan const Constructor'dır.
    required this.icon, // icon Field'ını required Yapar.
    required this.iconColor, // iconColor Field'ını required Yapar.
    required this.value, // value Field'ını required Yapar.
    required this.unit, // unit Field'ını required Yapar.
    required this.label, // label Field'ını required Yapar.
  });

  @override // Superclass'taki build Metodunun Override Edildiğini Belirtir.
  Widget build(BuildContext context) { // İstatistik Öğesinin Widget Tree'sini Oluşturur.
    return Column( // Değer Satırını ve label'ı Dikey Olarak Sıralar.
      children: [ // Column'un Alt Widget'larını Tanımlar.
        Row( // İkon, Değer ve Birimi Yatayda Sıralar.
          mainAxisSize: MainAxisSize.min, // Row'un Genişliğini İçeriğe Göre Minimumda Tutar.
          children: [ // Row'un Alt Widget'larını Tanımlar.
            Icon(icon, color: iconColor, size: 18), // Belirtilen Renk ve Boyutta İkonu Gösterir.
            const SizedBox(width: 4), // 4 Piksel Yatay Boşluk Bırakır.
            Text( // Sayısal Değeri Gösteren Text Widget'ıdır.
              value, // Gösterilecek value Metnidir.
              style: const TextStyle( // Değer Yazısının Stilini Belirler.
                fontSize: 20, // Yazı Boyutunu 20 Yapar.
                fontWeight: FontWeight.bold, // Yazıyı Kalın Yapar.
                color: AppColors.textPrimary, // Yazı Rengini Birincil Metin Rengi Yapar.
              ),
            ),
            const SizedBox(width: 2), // 2 Piksel Yatay Boşluk Bırakır.
            Text( // Birimi Gösteren Text Widget'ıdır.
              unit, // Gösterilecek unit Metnidir.
              style: const TextStyle( // Birim Yazısının Stilini Belirler.
                fontSize: 12, // Yazı Boyutunu 12 Yapar.
                color: AppColors.textSecondary, // Yazı Rengini İkincil Metin Rengi Yapar.
              ),
            ),
          ],
        ),
        const SizedBox(height: 4), // 4 Piksel Dikey Boşluk Bırakır.
        Text( // Açıklama Metnini Gösteren Text Widget'ıdır.
          label, // Gösterilecek label Metnidir.
          style: const TextStyle( // Açıklama Yazısının Stilini Belirler.
            fontSize: 11, // Yazı Boyutunu 11 Yapar.
            color: AppColors.textSecondary, // Yazı Rengini İkincil Metin Rengi Yapar.
          ),
        ),
      ],
    );
  }
}
