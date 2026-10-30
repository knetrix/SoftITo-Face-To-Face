// ============================================================================
// urun_karti.dart → Listedeki Her Bir Ürünün Kartı
// ----------------------------------------------------------------------------
// Kartın Yerleşimi (Soldan Sağa):
//
//   ┌──────────────────────────────────────────────────┐
//   │ ┌──────┐  E Elektronik            [Stok: 5]  ♡  │
//   │ │Resim │  Macbook M5 Pro Laptop                  │
//   │ │      │  Apple'ın en güçlü işlemcisine...       │
//   │ └──────┘  3999.99 $                              │
//   └──────────────────────────────────────────────────┘
//
// Önemli Fikir: Bu Kart "Aptal"dır. Favoriye Tıklanınca Ne Olacağını BİLMEZ.
// Sadece "Bana Tıklandı" Diye Haber Verir; Ne Yapılacağına Ekran Karar Verir.
// Buna "Lifting State Up" (Durumu Yukarı Taşıma) Denir. Böylece Kart Başka
// Ekranlarda da Kolayca Tekrar Kullanılabilir.
// ============================================================================

import 'package:flutter/material.dart';

import '../models/urun.dart';
import 'stok_rozeti.dart';

// StatelessWidget: Kendi Değişen Bir Bilgisi Yok. Ürün Favorilenince Ekran,
// Kartı Güncel Ürünle Yeniden Oluşturur.
class UrunKarti extends StatelessWidget {
  // Kartta Gösterilecek Ürün.
  final Urun urun;
  // VoidCallback: "Parametre Almayan ve Bir Şey Döndürmeyen Fonksiyon" Tipi.
  // Yani Bu Alanlar Bir Değer Değil, Bir FONKSİYON Tutar.
  // Ekran, Kartı Oluştururken "Kalbe Basılınca Şunu Yap" Diye Bir Fonksiyon Verir;
  // Kart da Kalbe Basılınca O Fonksiyonu Çağırır.
  final VoidCallback onFavoriTiklandi;
  // Kartın Kendisine (Kalp Dışında Bir Yere) Basılınca Çağrılacak Fonksiyon.
  final VoidCallback onDetayTiklandi;

  // Kurucu. Üç Bilginin Üçü de Zorunlu (required).
  const UrunKarti({
    super.key,
    required this.urun,
    required this.onFavoriTiklandi,
    required this.onDetayTiklandi,
  });

  @override
  Widget build(BuildContext context) {
    // Card: Gölgeli ve Hafifçe Yükseltilmiş Görünen Bir Kutu.
    return Card(
      // margin: Kartın DIŞ Boşluğu (Diğer Kartlarla ve Ekran Kenarıyla Mesafesi).
      // Yatayda (Sağ-Sol) 16, Dikeyde (Üst-Alt) 8 Piksel.
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      // elevation: Gölgenin Yüksekliği. Sayı Büyüdükçe Kart Daha "Havada" Görünür.
      elevation: 2,
      // shape: Kartın Şekli. Köşeleri 12 Piksel Yuvarlatılmış Dikdörtgen.
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      // InkWell: İçindekini Dokunulabilir Yapar. Dokununca Su Dalgası Gibi
      // Yayılan Bir Efekt (Ripple) Gösterir.
      child: InkWell(
        // Dalga Efekti de Kartın Yuvarlak Köşelerine Uysun, Köşelerden Taşmasın.
        borderRadius: BorderRadius.circular(12),
        // onTap: Dokunulunca Çalışacak Fonksiyon. Ekranın Verdiği Fonksiyonu Bağlıyoruz.
        onTap: onDetayTiklandi,
        // Padding: İçindeki Widget'ın Etrafına Boşluk Bırakır.
        child: Padding(
          // EdgeInsets.all(12): Dört Taraftan da 12 Piksel İç Boşluk.
          padding: const EdgeInsets.all(12),
          // Row: Çocuklarını (children) YATAY Olarak, Soldan Sağa Dizer.
          child: Row(
            // crossAxisAlignment: Row için "Dikey" Hizalama.
            // start: Tüm Çocukları En Üste Yasla.
            crossAxisAlignment: CrossAxisAlignment.start,
            // children: Row'un İçindeki Widget'ların Listesi.
            children: [
              // ── SOL TARAF: Ürün Resmi ──────────────────────────────────────
              // ClipRRect: İçindeki Widget'ı Yuvarlak Köşeli Olarak Kırpar.
              // Resmin Köşeleri Bu Sayede Yuvarlak Görünür.
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                // Image.network: Verilen İnternet Adresindeki Resmi İndirip Gösterir.
                child: Image.network(
                  urun.resimUrl,
                  width: 90,
                  height: 90,
                  // BoxFit.cover: Resmi 90x90 Kutuyu Tamamen Dolduracak Şekilde
                  // Büyütür; Taşan Kısımlar Kırpılır. Resim Sünmez, Oranı Bozulmaz.
                  fit: BoxFit.cover,
                  // errorBuilder: Resim Yüklenemezse (İnternet Yok, Adres Bozuk...)
                  // Bu Fonksiyon Çalışır ve Onun Döndürdüğü Widget Gösterilir.
                  // Burada Gri Bir Kutu İçinde "Kırık Resim" İkonu Gösteriyoruz.
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 90,
                      height: 90,
                      color: Colors.grey.shade200,
                      child: const Icon(Icons.broken_image, color: Colors.grey),
                    );
                  },
                  // loadingBuilder: Resim İndirilirken Tekrar Tekrar Çalışır.
                  // child: Resmin Kendisi. progress: İndirme İlerlemesi.
                  loadingBuilder: (context, child, progress) {
                    // progress null İse İndirme Bitmiş Demektir → Resmi Göster.
                    if (progress == null) return child;
                    // Henüz Bitmediyse, Resmin Yerinde Küçük Dönen Bir
                    // Yükleniyor Çemberi Göster.
                    return Container(
                      width: 90,
                      height: 90,
                      color: Colors.grey.shade100,
                      child: const Center(
                        // strokeWidth: Çemberin Çizgi Kalınlığı.
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    );
                  },
                ),
              ),
              // SizedBox: Belirli Boyutta Boş Bir Kutu. Burada Resim ile
              // Yazılar Arasına 14 Piksellik Boşluk Koymak için Kullanılıyor.
              const SizedBox(width: 14),

              // ── ORTA KISIM: Ürün Bilgileri ─────────────────────────────────
              // Expanded: Row'da Diğerlerinden Arta Kalan TÜM Genişliği Bu Widget'a Ver.
              // Olmasaydı Uzun Bir Başlık Satıra Sığmaz, Ekranda Sarı-Siyah
              // Çizgili "Overflow" (Taşma) Hatası Görünürdü.
              Expanded(
                // Column: Çocuklarını DİKEY Olarak, Yukarıdan Aşağı Dizer.
                child: Column(
                  // crossAxisAlignment: Column için "Yatay" Hizalama.
                  // start: Hepsini Sola Yasla.
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // En Üst Satır: Solda Kategori, Sağda Stok Rozeti.
                    Row(
                      // mainAxisAlignment: Row için "Yatay" Hizalama.
                      // spaceBetween: İlk Eleman En Sola, Son Eleman En Sağa,
                      // Aradaki Boşluk Eşit Dağıtılır.
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Kategori Yazısı. Örn: "E Elektronik".
                        // '${...}' Yazımı: Süslü Parantez İçindeki İfadenin
                        // Sonucunu Metne Yerleştirir.
                        Text(
                          '${urun.kategori.ikon} ${urun.kategori.baslik}',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                            // w600: Yarı Kalın Yazı (100 İnce ... 900 En Kalın).
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        // stok_rozeti.dart Dosyasındaki Widget. Stok Sayısını Verip
                        // Gerisini Ona Bırakıyoruz (Yeşil / Kırmızı / Gizli).
                        StokRozeti(stok: urun.stokAdedi),
                      ],
                    ),
                    // Satırlar Arası 6 Piksel Dikey Boşluk.
                    const SizedBox(height: 6),
                    // Ürün Başlığı.
                    Text(
                      urun.baslik,
                      // En Fazla 1 Satır Göster.
                      maxLines: 1,
                      // Sığmazsa Kes ve Sonuna "..." Koy.
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Ürün Açıklaması: En Fazla 2 Satır, Devamı "...".
                    Text(
                      urun.aciklama,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade700,
                        // height: Satır Yüksekliği Çarpanı. 1.2 = Yazı Boyutunun
                        // 1,2 Katı. Satırlar Biraz Ferah Dursun Diye.
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Fiyat. toStringAsFixed(2): Sayıyı Her Zaman 2 Ondalık
                    // Basamakla Yazar (22.3 → "22.30"). Tüm Fiyatlar Dolar Cinsinden.
                    // "\$": Dart Metinlerinde $ İşareti Değişken Başlatır
                    // ($stok Gibi). Düz Bir $ Yazmak için Önüne \ Konur.
                    Text(
                      '${urun.fiyat.toStringAsFixed(2)} \$',
                      style: TextStyle(
                        // Theme.of(context): Uygulamanın Temasına Ulaşır.
                        // colorScheme.primary: Temanın Ana Rengi; main.dart'taki
                        // seedColor (Çivit Mavisi) Renginden Üretilir.
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 16,
                        // w900: En Kalın Yazı.
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),

              // Stok Rozeti ile Kalp Arasında 8 Piksel Boşluk.
              const SizedBox(width: 8),

              // ── SAĞ TARAF: Favori Butonu ───────────────────────────────────
              // IconButton: Tıklanabilir Bir İkon.
              IconButton(
                // IconButton Varsayılan Olarak 48x48 Piksel Yer Kaplar ve İkonu
                // Bu Alanın Ortasına Koyar. Bu Yüzden Kalp, En Üstteki Stok
                // Rozetinden Aşağıda Kalıyordu. İç Boşluğu (padding) ve Minimum
                // Boyutu (constraints) Sıfırlayınca Buton Sadece İkon Kadar Yer
                // Kaplar, Üste Yaslanır ve Rozetle Aynı Hizaya Gelir.
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                // Mobilde (Android, iOS) Material 3, Dokunma Alanını Ayrıca En Az
                // 48x48 Piksele Büyütür (tapTargetSize: padded). Masaüstünde (macOS)
                // Bunu Yapmaz; Bu Yüzden Kalp macOS'ta Hizalı, Android'de 11 Piksel
                // Aşağıdaydı. shrinkWrap: Dokunma Alanını Büyütme, İkon Kadar Kalsın.
                style: IconButton.styleFrom(
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                icon: Icon(
                  // Ürün Favoriyse Dolu Kalp (favorite), Değilse Boş Kalp
                  // (favorite_border) İkonu.
                  urun.favoriMi ? Icons.favorite : Icons.favorite_border,
                  // Favoriyse Kırmızı, Değilse Gri.
                  color: urun.favoriMi ? Colors.red : Colors.grey,
                ),
                // onPressed: Basılınca Çalışacak Fonksiyon. Ekranın Verdiği
                // Fonksiyonu Çağırıyoruz; Favori Durumunu Ekran Değiştiriyor.
                onPressed: onFavoriTiklandi,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
