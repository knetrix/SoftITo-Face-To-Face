import 'package:flutter/material.dart'; // Flutter'ın Material Widget'larını import Eder.

class HataliveDogruRow extends StatelessWidget { // Row'un Hatalı ve Doğru Kullanımını Gösteren StatelessWidget'tır.
  const HataliveDogruRow({super.key}); // key Parametresini Superclass'a İleten const Constructor'dır.

  @override // Superclass'taki build Metodunun Override Edildiğini Belirtir.
  Widget build(BuildContext context) { // Sayfanın Widget Tree'sini Oluşturur.
    return Scaffold( // Sayfanın Temel Material Layout'unu Oluşturur.
      appBar: AppBar(title: const Text("Row ve Layout.")), // Üstte 'Row ve Layout.' title'lı Bir AppBar Gösterir.
      body: Padding( // body İçeriğinin Etrafına Padding Ekler.
        padding: const EdgeInsets.all(16.0), // Dört Kenardan 16 Logical Pixel Padding Verir.
        child: Column( // Örnekleri Column İçinde Alt Alta Dizer.
          crossAxisAlignment: CrossAxisAlignment.start, // children'ı Yatayda Sola Hizalar.
          children: [ // Column'un children Listesidir.
            const Text( // Hatalı Örneğin Başlığını Gösterir.
              'Hatalı Yapı: A Overflowed By ***Pixels (Sarı Siyah Şerit)', // Overflow Hatasını Anlatan Başlık Metnidir.
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green), // Metni Kalın ve Yeşil Yapar.
            ),
            const SizedBox(height: 8), // Başlık ile Örnek Arasına 8 Logical Pixel Boşluk Koyar.
            Container( // Hatalı Örneği Saran Container'dır.
              color: Colors.amber.shade100, // Arka Planı Açık Amber Rengi Yapar.
              child: const Row( // İkon ve Metni Yan Yana Dizen Row'dur.
                children: [ // Row'un children Listesidir.
                  Icon(Icons.warning, color: Colors.red), // Kırmızı Bir warning İkonu Gösterir.
                  SizedBox(width: 8), // İkon ile Metin Arasına 8 Logical Pixel Boşluk Koyar.
                  Text( // Expanded İle Sarılmadığı İçin Genişliği Sınırlanmayan Text'tir.
                    'Kısa Metin (Hata Vermez, Fakat Uzarsa Render Patlar.)', // Uzadığında Overflow'a Yol Açacak Metindir.
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24), // İki Örnek Arasına 24 Logical Pixel Boşluk Koyar.
            const Text( // Doğru Örneğin Başlığını Gösterir.
              'Doğru Yapı: Flexible - Expanded ile Sınırlandırılmıştır.', // Çözümü Anlatan Başlık Metnidir.
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green), // Metni Kalın ve Yeşil Yapar.
            ),
            const SizedBox(height: 8), // Başlık ile Örnek Arasına 8 Logical Pixel Boşluk Koyar.
            Container( // Doğru Örneği Saran Container'dır.
              padding: const EdgeInsets.all(12), // İçeriğe Dört Kenardan 12 Logical Pixel Padding Verir.
              decoration: BoxDecoration( // Container'ın Görünümünü BoxDecoration İle Belirler.
                color: Colors.green.shade50, // Arka Planı Çok Açık Yeşil Yapar.
                borderRadius: BorderRadius.circular(8), // Köşeleri 8 Radius İle Yuvarlar.
                border: Border.all(color: Colors.green), // Dört Kenara Yeşil Bir Border Çizer.
              ),
              child: const Row( // Avatar ve Metinleri Yan Yana Dizen Row'dur.
                children: [ // Row'un children Listesidir.
                  CircleAvatar( // Yuvarlak Bir Avatar Oluşturur.
                    backgroundColor: Colors.green, // Avatar'ın Arka Planını Yeşil Yapar.
                    child: Icon(Icons.check, color: Colors.white), // Avatar İçinde Beyaz Bir check İkonu Gösterir.
                  ),
                  SizedBox(width: 12), // Avatar ile Metinler Arasına 12 Logical Pixel Boşluk Koyar.
                  Expanded( // Row'da Kalan Genişliği Doldurarak child'ın Genişliğini Sınırlar.
                    child: Column( // Başlık ve Açıklamayı Alt Alta Dizer.
                      crossAxisAlignment: CrossAxisAlignment.start, // children'ı Yatayda Sola Hizalar.
                      children: [ // Column'un children Listesidir.
                        Text( // Kartın Başlık Metnidir.
                          'Softito 4. Dönem Mobil Standartı.', // Başlıkta Gösterilen Yazıdır.
                          style: TextStyle(fontWeight: FontWeight.bold), // Başlığı Kalın Yapar.
                        ),
                        SizedBox(height: 4), // Başlık ile Açıklama Arasına 4 Logical Pixel Boşluk Koyar.
                        Text( // Genişliği Expanded İle Sınırlandığı İçin Alt Satıra Geçebilen Text'tir.
                          'Bu Metin Ne Kadar Uzun Olursa Olsun Telefonun Ekranının Genişliğinde Alt Satıra Geçer ve Asla Sarı Siyah Taşma Hatası Üretmez.', // Uzun Açıklama Metnidir.
                          style: TextStyle(color: Colors.black87), // Metni Koyu Gri (black87) Yapar.
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
