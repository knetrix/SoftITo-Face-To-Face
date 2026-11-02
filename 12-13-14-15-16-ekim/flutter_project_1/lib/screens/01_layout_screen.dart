import 'package:flutter/material.dart'; // Flutter'ın Material Widget'larını import Eder.

class LayoutStylingScreen extends StatefulWidget { // Ana Sayfa Layout'unu Gösteren StatefulWidget'tır.
  const LayoutStylingScreen({super.key}); // key Parametresini Superclass'a İleten const Constructor'dır.

  @override // Superclass'taki createState Metodunun Override Edildiğini Belirtir.
  State<LayoutStylingScreen> createState() => _LayoutStylingScreenState(); // Bu Widget'a Ait State Nesnesini Oluşturur.
}

class _LayoutStylingScreenState extends State<LayoutStylingScreen> { // LayoutStylingScreen'in State'ini Yöneten Private Class'tır.
  bool isBalanceVisible = true; // Bakiyenin Görünür Olup Olmadığını Tutar.
  String lastAction = 'Hazır - Butonlara Tıklayabilirsiniz.'; // Kullanıcının Yaptığı Son İşlemin Metnini Tutar.

  @override // Superclass'taki build Metodunun Override Edildiğini Belirtir.
  Widget build(BuildContext context) { // Ana Sayfanın Widget Tree'sini Oluşturur.
    return SingleChildScrollView( // İçeriği Dikey Olarak Scroll Edilebilir Yapar.
      physics: const BouncingScrollPhysics(), // Scroll Sonunda iOS Tarzı Esneme Efekti Verir.
      padding: const EdgeInsets.only(bottom: 32), // Sadece Alt Tarafa 32 Padding Verir.
      child: Column( // child'ları Dikey Olarak Alt Alta Dizer.
        crossAxisAlignment: CrossAxisAlignment.start, // child'ları Yatayda Sola Hizalar.
        children: [ // Column İçindeki Widget Listesidir.
          // Profil Online Rozeti.
          buildProfileHeader(), // Profil Başlığı Widget'ını Ekler.
          // Cüzdan Kartı.
          buildWalletCard(), // Cüzdan Kartı Widget'ını Ekler.
          // Aksiyon Butonları.
          buildQuickActions(), // Hızlı Aksiyon Butonlarını Ekler.
          // İstatistiklik Bölümü.
          buildFlexStatistics(), // Gelir/Gider İstatistik Kartlarını Ekler.
          // Notification Bildirim Banner.
          buildNotificationBanner(), // Bildirim Banner'ını Ekler.
          // Canlı Durum Bildirimi.
          Center( // child'ı Yatayda Ortalar.
            child: Padding( // child'ın Etrafına Boşluk Ekler.
              padding: const EdgeInsets.all(16.0), // Her Yönden 16 Padding Verir.
              child: Text( // Son İşlemi Gösteren Text Widget'ıdır.
                'Son İşlem: $lastAction', // String Interpolation İle lastAction Değerini Yazar.
                style: const TextStyle( // Text'in Stilini Tanımlar.
                  fontSize: 13, // Font Size'ı 13 Yapar.
                  color: Color(0xFF64748B), // Text Rengini Gri Tonuna Ayarlar.
                  fontStyle: FontStyle.italic, // Text'i Italic Yapar.
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildWalletCard() { // Toplam Bakiyeyi Gösteren Cüzdan Kartını Oluşturur.
    return Container( // Dekorasyon ve Boşluk Verilebilen Bir Kutu Oluşturur.
      margin: const EdgeInsets.all(20), // Container'ın Dışına Her Yönden 20 Margin Verir.
      padding: const EdgeInsets.all(24), // Container'ın İçine Her Yönden 24 Padding Verir.
      decoration: BoxDecoration( // Container'ın Görsel Dekorasyonunu Tanımlar.
        color: const Color(0xFF16366F), // Arka Plan Rengini Lacivert Yapar.
        borderRadius: BorderRadius.circular(24), // Köşeleri 24 Radius İle Yuvarlar.
      ),
      child: Column( // Kart İçeriğini Dikey Olarak Dizer.
        crossAxisAlignment: CrossAxisAlignment.start, // child'ları Sola Hizalar.
        children: [ // Column İçindeki Widget Listesidir.
          Row( // Başlık ve Göz İkonunu Yatay Olarak Dizer.
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // child'ları İki Uca Yaslar.
            children: [ // Row İçindeki Widget Listesidir.
              const Text('Toplam Bakiye', // 'Toplam Bakiye' Başlığını Gösterir.
                  style: TextStyle(color: Colors.white70)), // Text Rengini Yarı Saydam Beyaz Yapar.
              IconButton( // Bakiyeyi Gizleyip Gösteren İkon Butonudur.
                tooltip: // Uzun Basınca Görünen Açıklama Metnidir.
                    isBalanceVisible ? 'Bakiyeyi gizle' : 'Bakiyeyi göster', // Duruma Göre tooltip Metnini Seçer.
                color: Colors.white, // İkon Rengini Beyaz Yapar.
                icon: Icon(isBalanceVisible // Duruma Göre Gösterilecek İkonu Seçer.
                    ? Icons.visibility_outlined // Bakiye Görünürse Açık Göz İkonudur.
                    : Icons.visibility_off_outlined), // Bakiye Gizliyse Kapalı Göz İkonudur.
                onPressed: () { // Butona Tıklanınca Çalışan Callback'tir.
                  setState(() { // State'i Güncelleyip build() Metodunu Tetikler.
                    isBalanceVisible = !isBalanceVisible; // Görünürlük Değerini Tersine Çevirir.
                    lastAction = isBalanceVisible // Yeni Duruma Göre lastAction Metnini Belirler.
                        ? 'Bakiye gösterildi.' // Bakiye Görünürse Bu Metni Atar.
                        : 'Bakiye gizlendi.'; // Bakiye Gizliyse Bu Metni Atar.
                  });
                },
              ),
            ],
          ),
          Text( // Bakiye Tutarını Gösteren Text'tir.
            isBalanceVisible ? '₺24.580,00' : '••••••', // Görünürse Tutarı, Değilse Maskeyi Gösterir.
            style: const TextStyle( // Text'in Stilini Tanımlar.
              color: Colors.white, // Text Rengini Beyaz Yapar.
              fontSize: 32, // Font Size'ı 32 Yapar.
              fontWeight: FontWeight.bold, // Text'i Bold Yapar.
            ),
          ),
          const SizedBox(height: 12), // Dikeyde 12 Birim Boşluk Bırakır.
          const Text('Örnek cüzdan verisi', // Verinin Örnek Olduğunu Belirten Text'tir.
              style: TextStyle(color: Colors.white70)), // Text Rengini Yarı Saydam Beyaz Yapar.
        ],
      ),
    );
  }

  Widget buildQuickActions() { // Gönder, Al ve Yatır Butonlarını Oluşturur.
    return Padding( // child'ın Etrafına Boşluk Ekler.
      padding: const EdgeInsets.symmetric(horizontal: 20), // Yatayda 20 Padding Verir.
      child: Wrap( // Sığmayan child'ları Otomatik Olarak Alt Satıra Geçirir.
        spacing: 12, // child'lar Arasında Yatayda 12 Boşluk Bırakır.
        runSpacing: 12, // Satırlar Arasında Dikeyde 12 Boşluk Bırakır.
        children: [ // Wrap İçindeki Butonların Listesidir.
          FilledButton.icon( // İkonlu ve Dolgulu Bir Buton Oluşturur.
            onPressed: () { // Butona Tıklanınca Çalışan Callback'tir.
              setState(() => lastAction = 'Para gönder seçildi.'); // lastAction'ı Güncelleyip build() Metodunu Tetikler.
            },
            icon: const Icon(Icons.send_outlined), // Gönder İkonunu Gösterir.
            label: const Text('Gönder'), // Butonun label'ıdır.
          ),
          OutlinedButton.icon( // İkonlu ve Kenarlıklı Bir Buton Oluşturur.
            onPressed: () { // Butona Tıklanınca Çalışan Callback'tir.
              setState(() => lastAction = 'Para al seçildi.'); // lastAction'ı Güncelleyip build() Metodunu Tetikler.
            },
            icon: const Icon(Icons.call_received), // Al İkonunu Gösterir.
            label: const Text('Al'), // Butonun label'ıdır.
          ),
          OutlinedButton.icon( // İkonlu ve Kenarlıklı Bir Buton Oluşturur.
            onPressed: () { // Butona Tıklanınca Çalışan Callback'tir.
              setState(() => lastAction = 'Para yatır seçildi.'); // lastAction'ı Güncelleyip build() Metodunu Tetikler.
            },
            icon: const Icon(Icons.add), // Ekle İkonunu Gösterir.
            label: const Text('Yatır'), // Butonun label'ıdır.
          ),
        ],
      ),
    );
  }

  Widget buildFlexStatistics() { // Gelir ve Gider Kartlarını Yan Yana Oluşturur.
    return const Padding( // Tamamı const Olan Bir Padding Döndürür.
      padding: EdgeInsets.all(20), // Her Yönden 20 Padding Verir.
      child: Row( // Kartları Yatay Olarak Dizer.
        children: [ // Row İçindeki Widget Listesidir.
          Expanded( // Row'daki Boş Alanı Eşit Olarak Paylaşır.
            child: Card( // Gölgeli ve Yuvarlak Köşeli Bir Card Oluşturur.
              child: Padding( // Card İçeriğine Boşluk Ekler.
                padding: EdgeInsets.all(16), // Her Yönden 16 Padding Verir.
                child: Column( // Card İçeriğini Dikey Olarak Dizer.
                  crossAxisAlignment: CrossAxisAlignment.start, // child'ları Sola Hizalar.
                  children: [ // Column İçindeki Widget Listesidir.
                    Icon(Icons.arrow_downward, color: Colors.green), // Gelir İçin Yeşil Aşağı Ok İkonudur.
                    SizedBox(height: 8), // Dikeyde 8 Birim Boşluk Bırakır.
                    Text('Örnek Gelir'), // Kartın Başlığını Gösterir.
                    Text('₺8.500,00', // Gelir Tutarını Gösterir.
                        style: TextStyle(fontWeight: FontWeight.bold)), // Tutarı Bold Yapar.
                  ],
                ),
              ),
            ),
          ),
          SizedBox(width: 12), // Kartlar Arasında Yatayda 12 Boşluk Bırakır.
          Expanded( // Row'daki Boş Alanı Eşit Olarak Paylaşır.
            child: Card( // Gölgeli ve Yuvarlak Köşeli Bir Card Oluşturur.
              child: Padding( // Card İçeriğine Boşluk Ekler.
                padding: EdgeInsets.all(16), // Her Yönden 16 Padding Verir.
                child: Column( // Card İçeriğini Dikey Olarak Dizer.
                  crossAxisAlignment: CrossAxisAlignment.start, // child'ları Sola Hizalar.
                  children: [ // Column İçindeki Widget Listesidir.
                    Icon(Icons.arrow_upward, color: Colors.red), // Gider İçin Kırmızı Yukarı Ok İkonudur.
                    SizedBox(height: 8), // Dikeyde 8 Birim Boşluk Bırakır.
                    Text('Örnek Gider'), // Kartın Başlığını Gösterir.
                    Text('₺3.200,00', // Gider Tutarını Gösterir.
                        style: TextStyle(fontWeight: FontWeight.bold)), // Tutarı Bold Yapar.
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildNotificationBanner() { // Tıklanabilir Bildirim Banner'ını Oluşturur.
    return Padding( // child'ın Etrafına Boşluk Ekler.
      padding: const EdgeInsets.symmetric(horizontal: 20), // Yatayda 20 Padding Verir.
      child: Material( // ListTile'ın Ink Efekti İçin Renkli Bir Material Yüzeyi Oluşturur.
        color: const Color(0xFFE0E7FF), // Arka Plan Rengini Açık Mor Yapar.
        borderRadius: BorderRadius.circular(16), // Köşeleri 16 Radius İle Yuvarlar.
        child: ListTile( // İkon, Başlık ve Alt Başlık İçeren Bir Satır Oluşturur.
          shape: RoundedRectangleBorder( // Tıklama Efektinin Şeklini Belirler.
            borderRadius: BorderRadius.circular(16), // Efekt Köşelerini 16 Radius İle Yuvarlar.
          ),
          leading: const Icon(Icons.notifications_outlined), // Sol Tarafta Bildirim İkonunu Gösterir.
          title: const Text('Cüzdanını takip et'), // ListTile'ın title'ıdır.
          subtitle: // ListTile'ın subtitle'ını Tanımlar.
              const Text('Gelir ve giderlerini düzenli olarak kontrol et.'), // subtitle Metnini Gösterir.
          trailing: const Icon(Icons.chevron_right), // Sağ Tarafta Ok İkonunu Gösterir.
          onTap: () { // ListTile'a Tıklanınca Çalışan Callback'tir.
            setState(() => lastAction = 'Bildirim görüntülendi.'); // lastAction'ı Güncelleyip build() Metodunu Tetikler.
          },
        ),
      ),
    );
  }

  Widget buildProfileHeader() { // Avatar ve Karşılama Metnini İçeren Profil Başlığını Oluşturur.
    return Padding( // child'ın Etrafına Boşluk Ekler.
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8), // Sol, Üst, Sağ ve Alt Padding'leri Ayrı Ayrı Verir.
      child: Row( // Avatar ve Metinleri Yatay Olarak Dizer.
        children: [ // Row İçindeki Widget Listesidir.
          Stack( // child'ları Üst Üste Bindirerek Gösterir.
            clipBehavior: Clip.none, // Stack Sınırı Dışına Taşan child'ların Kesilmesini Engeller.
            children: [ // Stack İçindeki Widget Listesidir.
              Container( // Yuvarlak Avatar Kutusunu Oluşturur.
                width: 56, // Genişliği 56 Yapar.
                height: 56, // Yüksekliği 56 Yapar.
                decoration: BoxDecoration( // Avatar'ın Dekorasyonunu Tanımlar.
                  shape: BoxShape.circle, // Şekli Daire Yapar.
                  color: const Color(0xFFEDE9FE), // Arka Plan Rengini Açık Mor Yapar.
                  border: Border.all( // Her Yönden Kenarlık Ekler.
                    color: const Color(0xFF6366F1), // Kenarlık Rengini Mor Yapar.
                    width: 2, // Kenarlık Kalınlığını 2 Yapar.
                  ),
                ),
                child: const Icon( // Avatar İçindeki Kişi İkonudur.
                  Icons.person, // person İkonunu Kullanır.
                  color: Color(0xFF6366F1), // İkon Rengini Mor Yapar.
                  size: 36, // İkon Boyutunu 36 Yapar.
                ),
              ),
              Positioned( // child'ı Stack İçinde Belirli Bir Konuma Yerleştirir.
                right: 0, // Sağ Kenara Yaslar.
                bottom: 0, // Alt Kenara Yaslar.
                child: Container( // Online Durumunu Gösteren Küçük Noktayı Oluşturur.
                  width: 14, // Genişliği 14 Yapar.
                  height: 14, // Yüksekliği 14 Yapar.
                  decoration: BoxDecoration( // Noktanın Dekorasyonunu Tanımlar.
                    color: Colors.green, // Rengini Yeşil Yapar.
                    shape: BoxShape.circle, // Şekli Daire Yapar.
                    border: Border.all( // Her Yönden Kenarlık Ekler.
                      color: const Color(0xFFF8FAFC), // Kenarlık Rengini Arka Plan Rengiyle Aynı Yapar.
                      width: 2, // Kenarlık Kalınlığını 2 Yapar.
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16), // Avatar İle Metin Arasında Yatayda 16 Boşluk Bırakır.
          const Expanded( // Row'daki Kalan Tüm Alanı Kaplar.
            child: Column( // Metinleri Dikey Olarak Dizer.
              crossAxisAlignment: CrossAxisAlignment.start, // child'ları Sola Hizalar.
              children: [ // Column İçindeki Widget Listesidir.
                Text( // Karşılama Metnini Gösterir.
                  'Hoş Geldin, Mustafa', // Karşılama Metnidir.
                  style: TextStyle( // Text'in Stilini Tanımlar.
                    fontSize: 18, // Font Size'ı 18 Yapar.
                    fontWeight: FontWeight.bold, // Text'i Bold Yapar.
                    color: Color(0xFF1E293B), // Text Rengini Koyu Lacivert Yapar.
                  ),
                ),
                SizedBox(height: 4), // Dikeyde 4 Birim Boşluk Bırakır.
                Text( // Alt Açıklama Metnini Gösterir.
                  'Cüzdanınıza genel bakış', // Açıklama Metnidir.
                  style: TextStyle(color: Color(0xFF64748B)), // Text Rengini Gri Yapar.
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
