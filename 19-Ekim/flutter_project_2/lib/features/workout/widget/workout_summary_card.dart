import 'package:flutter/material.dart'; // Flutter'ın Material Widget'larını import Eder.
import '../../../core/constants/app_colors.dart'; // Uygulama Renk Sabitlerini import Eder.

class WorkoutSummaryCard extends StatelessWidget { // Toplam Süre ve Kaloriyi Gösteren Özet Kartı StatelessWidget'ıdır.
  const WorkoutSummaryCard({ // Named Parametreli const Constructor'dır.
    required this.totalMinutes, // totalMinutes Field'ını required Yapar.
    required this.totalCalories, // totalCalories Field'ını required Yapar.
    super.key, // key Parametresini Superclass'a İletir.
  });

  final int totalMinutes; // Toplam Antrenman Süresini Tutar.
  final int totalCalories; // Toplam Yakılan Kaloriyi Tutar.

  @override // Superclass'taki build Metodunun Override Edildiğini Belirtir.
  Widget build(BuildContext context) { // Özet Kartının Widget Tree'sini Oluşturur.
    return Card( // Özet Bilgilerini İçeren Kartı Oluşturur.
      child: Padding( // Kart İçeriğine Boşluk Ekler.
        padding: const EdgeInsets.all(20), // Her Yönden 20 Birim Boşluk Verir.
        child: Row( // Metrikleri Yatay Dizer.
          mainAxisAlignment: MainAxisAlignment.spaceAround, // Elemanları Eşit Aralıklarla Dağıtır.
          children: [ // Row'un Child Widget Listesini Başlatır.
            _MetricItem( // Toplam Süre Metriğini Oluşturur.
              title: 'TOPLAM SÜRE', // Metrik Başlığını Belirler.
              value: '$totalMinutes dk', // Toplam Süreyi Değer Olarak Verir.
              accentColor: AppColors.neonGreen, // Vurgu Rengini Neon Yeşil Yapar.
            ),
            Container(height: 40, width: 1, color: AppColors.border), // Metrikler Arasına İnce Dikey Ayırıcı Çizgi Koyar.
            _MetricItem( // Yakılan Kalori Metriğini Oluşturur.
              title: 'YAKILAN KALORİ', // Metrik Başlığını Belirler.
              value: '$totalCalories kcal', // Toplam Kaloriyi Değer Olarak Verir.
              accentColor: AppColors.neonOrange, // Vurgu Rengini Neon Turuncu Yapar.
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricItem extends StatelessWidget { // Tek Bir Metriği Gösteren Private StatelessWidget'tır.
  const _MetricItem({ // Named Parametreli const Constructor'dır.
    required this.title, // title Field'ını required Yapar.
    required this.value, // value Field'ını required Yapar.
    required this.accentColor, // accentColor Field'ını required Yapar.
  });

  final String title; // Metriğin Başlığıdır.
  final String value; // Metriğin Gösterilen Değeridir.
  final Color accentColor; // Değer Metninin Vurgu Rengidir.

  @override // Superclass'taki build Metodunun Override Edildiğini Belirtir.
  Widget build(BuildContext context) { // Metrik Elemanının Widget Tree'sini Oluşturur.
    return Column( // Başlık ve Değeri Dikey Dizer.
      children: [ // Column'un Child Widget Listesini Başlatır.
        Text( // Metrik Başlığını Gösteren Metni Oluşturur.
          title, // Başlık Metnini Yazdırır.
          style: const TextStyle( // Başlık Stilini Tanımlar.
            color: AppColors.textSecondary, // Metin Rengini İkincil Renk Yapar.
            fontSize: 11, // Yazı Boyutunu 11 Yapar.
            letterSpacing: 1.0, // Harf Aralığını 1.0 Yapar.
            fontWeight: FontWeight.w600, // Yazı Kalınlığını w600 Yapar.
          ),
        ),
        const SizedBox(height: 6), // Dikey 6 Birim Boşluk Bırakır.
        Text( // Metrik Değerini Gösteren Metni Oluşturur.
          value, // Değer Metnini Yazdırır.
          style: TextStyle( // Değer Stilini Tanımlar.
            color: accentColor, // Metin Rengini Vurgu Rengi Yapar.
            fontSize: 22, // Yazı Boyutunu 22 Yapar.
            fontWeight: FontWeight.bold, // Yazıyı Kalın Yapar.
          ),
        ),
      ],
    );
  }
}
