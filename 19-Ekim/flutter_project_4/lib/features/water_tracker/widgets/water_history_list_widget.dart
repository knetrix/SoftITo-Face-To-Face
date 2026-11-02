import 'package:flutter/material.dart'; // Flutter'ın Material Widget'larını import Eder.
import '../../../core/constants/app_colors.dart'; // Renk Sabitlerini İçeren AppColors'u import Eder.

class WaterHistoryListWidget extends StatelessWidget { // Su Tüketim Geçmişini Listeleyen StatelessWidget'tır.
  final List<int> history; // Gösterilecek Su Miktarları Listesidir.

  const WaterHistoryListWidget({ // Widget'ın const Constructor'ıdır.
    super.key, // key Parametresini Superclass'a İletir.
    required this.history, // history Field'ını required Yapar.
  });

  @override // Superclass'taki build Metodunun Override Edildiğini Belirtir.
  Widget build(BuildContext context) { // Geçmiş Listesinin Widget Tree'sini Oluşturur.
    if (history.isEmpty) { // Geçmiş Boşsa Bu Bloğu Çalıştırır.
      return Card( // Boş Durum Mesajı İçin Card Döndürür.
        child: Padding( // Card İçine Boşluk Veren Padding Widget'ıdır.
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16), // Dikey 24, Yatay 16 Birim Boşluk Bırakır.
          child: Center( // Mesajı Ortalar.
            child: Text( // Boş Durum Mesajını Gösterir.
              'Bugün henüz su kaydı eklenmedi.', // Gösterilecek Boş Durum Metnidir.
              style: Theme.of(context).textTheme.bodyMedium, // Temadaki bodyMedium Stilini Uygular.
            ),
          ),
        ),
      );
    }

    final reversedHistory = history.reversed.toList(); // Geçmişi En Yeniden Eskiye Sıralar.

    return Column( // Başlık ve Listeyi Dikey Olarak Sıralar.
      crossAxisAlignment: CrossAxisAlignment.start, // Çocukları Sola Hizalar.
      children: [ // Column'un Alt Widget Listesidir.
        Row( // Başlık ve Kayıt Sayısını Yatay Olarak Sıralar.
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Çocukları İki Uca Yaslar.
          children: [ // Row'un Alt Widget Listesidir.
            const Text( // Liste Başlığını Gösterir.
              'Bugünkü Tüketimler', // Başlık Metnidir.
              style: TextStyle( // Başlığın Yazı Stilini Tanımlar.
                fontSize: 16, // Yazı Boyutunu 16 Yapar.
                fontWeight: FontWeight.bold, // Yazıyı Kalın Yapar.
                color: AppColors.textPrimary, // Yazı Rengini Birincil Metin Rengi Yapar.
              ),
            ),
            Text( // Toplam Kayıt Sayısını Gösterir.
              '${history.length} kayıt', // Kayıt Sayısını İçeren Metindir.
              style: const TextStyle( // Kayıt Sayısının Yazı Stilini Tanımlar.
                fontSize: 12, // Yazı Boyutunu 12 Yapar.
                color: AppColors.textSecondary, // Yazı Rengini İkincil Metin Rengi Yapar.
              ),
            ),
          ],
        ),
        const SizedBox(height: 8), // Dikeyde 8 Birim Boşluk Bırakır.
        ListView.separated( // Aralarında Ayırıcı Olan Bir ListView Oluşturur.
          shrinkWrap: true, // ListView'ın Yüksekliğini İçeriğe Göre Ayarlar.
          physics: const NeverScrollableScrollPhysics(), // ListView'ın Kendi Kaydırmasını Kapatır.
          itemCount: reversedHistory.length > 5 ? 5 : reversedHistory.length, // En Fazla 5 Kayıt Gösterir.
          separatorBuilder: (_, _) => const SizedBox(height: 8), // Elemanlar Arasına 8 Birim Boşluk Koyar.
          itemBuilder: (context, index) { // Her Liste Elemanını Oluşturan Callback'tir.
            final amount = reversedHistory[index]; // Index'teki Su Miktarını Alır.
            return Container( // Liste Elemanının Kutusunu Oluşturur.
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), // Kutu İç Boşluklarını Belirler.
              decoration: BoxDecoration( // Kutunun Görünümünü Tanımlar.
                color: AppColors.surface, // Kutunun Arka Plan Rengini Belirler.
                borderRadius: BorderRadius.circular(12), // Köşe Yarıçapını 12 Yapar.
                border: Border.all(color: AppColors.border), // Kutuya Kenarlık Ekler.
              ),
              child: Row( // Icon, Metin ve Miktarı Yatay Olarak Sıralar.
                children: [ // Row'un Alt Widget Listesidir.
                  Container( // Icon'un Yuvarlak Arka Planını Oluşturur.
                    padding: const EdgeInsets.all(8), // Her Yönden 8 Birim Boşluk Bırakır.
                    decoration: BoxDecoration( // Arka Planın Görünümünü Tanımlar.
                      color: AppColors.neonCyan.withAlpha(30), // Arka Planı Yarı Saydam Neon Cyan Yapar.
                      shape: BoxShape.circle, // Arka Planı Daire Şeklinde Yapar.
                    ),
                    child: const Icon( // Su Damlası Icon'unu Gösterir.
                      Icons.water_drop, // Kullanılacak Icon'dur.
                      color: AppColors.neonCyan, // Icon Rengini Neon Cyan Yapar.
                      size: 16, // Icon Boyutunu 16 Yapar.
                    ),
                  ),
                  const SizedBox(width: 12), // Yatayda 12 Birim Boşluk Bırakır.
                  Text( // Eleman Açıklamasını Gösterir.
                    'İçilen Su', // Açıklama Metnidir.
                    style: Theme.of(context).textTheme.bodyLarge, // Temadaki bodyLarge Stilini Uygular.
                  ),
                  const Spacer(), // Kalan Boşluğu Doldurarak Miktarı Sağa İter.
                  Text( // Eklenen Su Miktarını Gösterir.
                    '+$amount ml', // Miktarı İçeren Metindir.
                    style: const TextStyle( // Miktarın Yazı Stilini Tanımlar.
                      color: AppColors.neonCyan, // Yazı Rengini Neon Cyan Yapar.
                      fontWeight: FontWeight.bold, // Yazıyı Kalın Yapar.
                      fontSize: 15, // Yazı Boyutunu 15 Yapar.
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
