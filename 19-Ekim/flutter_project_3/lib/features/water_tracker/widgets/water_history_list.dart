import 'package:flutter/material.dart'; // Flutter'ın Material Widget'larını import Eder.

import '../models/water_log.dart'; // WaterLog Model'ini import Eder.

class WaterHistoryList extends StatelessWidget { // Günlük Su Kayıtlarını Listeleyen StatelessWidget'tır.
  final List<WaterLog> logs; // Gösterilecek Su Kayıtlarının Listesidir.

  const WaterHistoryList({super.key, required this.logs}); // key'i Superclass'a İleten ve logs'u required Alan const Constructor'dır.

  @override // Superclass'taki build Metodunun Override Edildiğini Belirtir.
  Widget build(BuildContext context) { // Listenin Widget Tree'sini Oluşturur.
    final theme = Theme.of(context); // Aktif ThemeData'yı Alır.
    final isDark = theme.brightness == Brightness.dark; // Dark Mode Aktif mi Diye Hesaplar.
    final primaryColor = theme.colorScheme.primary; // Theme'in primary Rengini Alır.

    final mutedColor = isDark // Moda Göre Soluk Text Rengini Seçer.
        ? const Color(0xFF6E7681) // Dark Mode İçin Soluk Renktir.
        : const Color(0xFF8C959F); // Light Mode İçin Soluk Renktir.
    final secondaryTextColor = isDark // Moda Göre İkincil Text Rengini Seçer.
        ? const Color(0xFF8B949E) // Dark Mode İçin İkincil Renktir.
        : const Color(0xFF656D76); // Light Mode İçin İkincil Renktir.
    final titleColor = isDark // Moda Göre Başlık Rengini Seçer.
        ? const Color(0xFFF0F6FC) // Dark Mode İçin Başlık Rengidir.
        : const Color(0xFF1F2328); // Light Mode İçin Başlık Rengidir.
    final cardBg = isDark ? const Color(0xFF161B22) : Colors.white; // Moda Göre Kart Arka Plan Rengini Seçer.
    final borderColor = isDark // Moda Göre Border Rengini Seçer.
        ? const Color(0xFF30363D) // Dark Mode İçin Border Rengidir.
        : const Color(0xFFD0D7DE); // Light Mode İçin Border Rengidir.

    if (logs.isEmpty) { // Kayıt Yoksa Boş Durum Mesajı Gösterir.
      return Container( // Boş Durum Mesajı İçin Kutu Oluşturur.
        padding: const EdgeInsets.all(24), // Her Yönden 24 Piksel Boşluk Verir.
        alignment: Alignment.center, // İçeriği Ortalar.
        child: Text( // Boş Durum Mesajını Gösteren Text'tir.
          'Bugün henüz su kaydı eklenmedi.', // Kayıt Olmadığını Belirten Mesajdır.
          style: TextStyle(color: mutedColor, fontSize: 13), // Soluk Renk ve 13 Font Boyutu Uygular.
        ),
      );
    }

    return Column( // Başlık ve Listeyi Dikey Olarak Sıralar.
      crossAxisAlignment: CrossAxisAlignment.start, // Alt Widget'ları Sola Hizalar.
      children: [ // Column'un Alt Widget'larını Tanımlar.
        Padding( // Başlığa İç Boşluk Verir.
          padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0), // Yatay 4, Dikey 8 Piksel Boşluk Verir.
          child: Text( // Bölüm Başlığını Gösteren Text'tir.
            'BUGÜNKÜ KAYITLAR', // Başlık Metnidir.
            style: TextStyle( // Başlık Stilini Tanımlar.
              color: secondaryTextColor, // İkincil Text Rengini Uygular.
              fontSize: 12, // Font Boyutunu 12 Yapar.
              fontWeight: FontWeight.bold, // Yazıyı Kalın Yapar.
              letterSpacing: 1.2, // Harf Aralığını Belirler.
            ),
          ),
        ),
        ListView.separated( // Aralarında Ayraç Olan Bir ListView Oluşturur.
          shrinkWrap: true, // ListView'ı İçeriği Kadar Yükseklikte Tutar.
          physics: const NeverScrollableScrollPhysics(), // ListView'ın Kendi Kaydırmasını Kapatır.
          itemCount: logs.length, // Öğe Sayısını Kayıt Sayısı Kadar Yapar.
          separatorBuilder: (context, index) => const SizedBox(height: 8), // Öğeler Arasına 8 Piksel Boşluk Koyar.
          itemBuilder: (context, index) { // Her Index İçin Liste Öğesi Üreten Callback'tir.
            final log = logs[index]; // Index'teki Kaydı Alır.
            final hour = log.timestamp.hour.toString().padLeft(2, '0'); // Saati İki Haneli String'e Çevirir.
            final minute = log.timestamp.minute.toString().padLeft(2, '0'); // Dakikayı İki Haneli String'e Çevirir.

            return Container( // Kayıt Satırının Kutusunu Oluşturur.
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), // Kutunun İç Boşluğunu Belirler.
              decoration: BoxDecoration( // Kutunun Dekorasyonunu Tanımlar.
                color: cardBg, // Kart Arka Plan Rengini Uygular.
                borderRadius: BorderRadius.circular(12), // Köşeleri 12 Piksel Yuvarlar.
                border: Border.all(color: borderColor), // Kutuya Border Ekler.
              ),
              child: Row( // Satır İçeriğini Yatay Olarak Sıralar.
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // İçeriği İki Uca Yaslar.
                children: [ // Row'un Alt Widget'larını Tanımlar.
                  Row( // Icon ve Miktar Metnini Yan Yana Dizer.
                    children: [ // İç Row'un Alt Widget'larını Tanımlar.
                      Icon(Icons.water_drop, color: primaryColor, size: 20), // Su Damlası Icon'unu Gösterir.
                      const SizedBox(width: 10), // 10 Piksel Yatay Boşluk Bırakır.
                      Text( // Eklenen Miktarı Gösteren Text'tir.
                        '+${log.amountMl} ml Su Eklendi', // Eklenen Su Miktarını Yazar.
                        style: TextStyle( // Miktar Metninin Stilini Tanımlar.
                          color: titleColor, // Başlık Rengini Uygular.
                          fontWeight: FontWeight.w600, // Yazıyı Yarı Kalın Yapar.
                          fontSize: 14, // Font Boyutunu 14 Yapar.
                        ),
                      ),
                    ],
                  ),
                  Text( // Kayıt Saatini Gösteren Text'tir.
                    '$hour:$minute', // Saati SS:DD Formatında Yazar.
                    style: TextStyle(color: secondaryTextColor, fontSize: 12), // İkincil Renk ve 12 Font Boyutu Uygular.
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
