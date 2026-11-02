import 'package:flutter/material.dart'; // Flutter'ın Material Widget'larını import Eder.

class WaterProgressCard extends StatelessWidget { // Günlük Su İlerlemesini Gösteren StatelessWidget'tır.
  final int currentWater; // İçilen Güncel Su Miktarını Tutar.
  final int dailyGoal; // Günlük Su Hedefini Tutar.

  const WaterProgressCard({ // Field'ları Alan const Constructor'dır.
    super.key, // key Parametresini Superclass'a İletir.
    required this.currentWater, // currentWater Field'ını required Yapar.
    required this.dailyGoal, // dailyGoal Field'ını required Yapar.
  });

  @override // Superclass'taki build Metodunun Override Edildiğini Belirtir.
  Widget build(BuildContext context) { // Kartın Widget Tree'sini Oluşturur.
    final theme = Theme.of(context); // Aktif ThemeData'yı Alır.
    final isDark = theme.brightness == Brightness.dark; // Dark Mode Aktif mi Diye Hesaplar.
    final progress = (currentWater / dailyGoal).clamp(0.0, 1.0); // İlerleme Oranını 0 İle 1 Arasında Hesaplar.
    final percentage = (progress * 100).toInt(); // İlerlemeyi Tam Sayı Yüzdeye Çevirir.

    final secondaryTextColor = isDark ? Colors.white70 : Colors.black54; // Moda Göre İkincil Text Rengini Seçer.
    final primaryTextColor = isDark ? Colors.white : Colors.black87; // Moda Göre Birincil Text Rengini Seçer.
    final trackColor = isDark // Moda Göre İlerleme Çubuğu Arka Plan Rengini Seçer.
        ? const Color(0xFF21262D) // Dark Mode İçin Track Rengidir.
        : const Color(0xFFE1E4E8); // Light Mode İçin Track Rengidir.
    final primaryColor = theme.colorScheme.primary; // Theme'in primary Rengini Alır.

    return Card( // İçeriği Bir Card İçinde Gösterir.
      child: Padding( // Card İçeriğine Boşluk Verir.
        padding: const EdgeInsets.all(24.0), // Her Yönden 24 Piksel Boşluk Verir.
        child: Column( // İçeriği Dikey Olarak Sıralar.
          children: [ // Column'un Alt Widget'larını Tanımlar.
            Text( // Kart Başlığını Gösteren Text'tir.
              'GÜNLÜK SU HEDEFİ', // Başlık Metnidir.
              style: TextStyle( // Başlık Stilini Tanımlar.
                color: secondaryTextColor, // İkincil Text Rengini Uygular.
                fontSize: 13, // Font Boyutunu 13 Yapar.
                fontWeight: FontWeight.bold, // Yazıyı Kalın Yapar.
                letterSpacing: 1.5, // Harf Aralığını Belirler.
              ),
            ),
            const SizedBox(height: 16), // 16 Piksel Dikey Boşluk Bırakır.
            Stack( // Dairesel Göstergeyi ve Metinleri Üst Üste Yerleştirir.
              alignment: Alignment.center, // Stack İçeriğini Ortalar.
              children: [ // Stack'in Alt Widget'larını Tanımlar.
                SizedBox( // Dairesel Göstergeye Sabit Boyut Verir.
                  width: 170, // Genişliği 170 Piksel Yapar.
                  height: 170, // Yüksekliği 170 Piksel Yapar.
                  child: CircularProgressIndicator( // Dairesel İlerleme Göstergesini Oluşturur.
                    value: progress, // İlerleme Oranını Atar.
                    strokeWidth: 14, // Çizgi Kalınlığını 14 Yapar.
                    backgroundColor: trackColor, // Track Rengini Uygular.
                    valueColor: AlwaysStoppedAnimation<Color>(primaryColor), // İlerleme Rengini primary Renk Yapar.
                  ),
                ),
                Column( // Gösterge Ortasındaki Metinleri Dikey Sıralar.
                  mainAxisSize: MainAxisSize.min, // Column'u İçeriği Kadar Yükseklikte Tutar.
                  children: [ // Column'un Alt Widget'larını Tanımlar.
                    Text( // Güncel Su Miktarını Gösteren Text'tir.
                      '$currentWater', // currentWater Değerini Yazar.
                      style: TextStyle( // Miktar Yazısının Stilini Tanımlar.
                        fontSize: 36, // Font Boyutunu 36 Yapar.
                        fontWeight: FontWeight.bold, // Yazıyı Kalın Yapar.
                        color: primaryTextColor, // Birincil Text Rengini Uygular.
                      ),
                    ),
                    Text( // Hedef Miktarı Gösteren Text'tir.
                      '/ $dailyGoal ml', // Günlük Hedefi ml Cinsinden Yazar.
                      style: TextStyle(fontSize: 14, color: secondaryTextColor), // 14 Font Boyutu ve İkincil Renk Uygular.
                    ),
                    const SizedBox(height: 4), // 4 Piksel Dikey Boşluk Bırakır.
                    Text( // Tamamlanma Yüzdesini Gösteren Text'tir.
                      '%$percentage Tamamlandı', // Yüzde Değerini Yazar.
                      style: TextStyle( // Yüzde Yazısının Stilini Tanımlar.
                        fontSize: 12, // Font Boyutunu 12 Yapar.
                        fontWeight: FontWeight.w600, // Yazıyı Yarı Kalın Yapar.
                        color: primaryColor, // primary Rengi Uygular.
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
