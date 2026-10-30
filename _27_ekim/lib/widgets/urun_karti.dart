import 'package:flutter/material.dart';

import '../models/urun.dart';
import 'stok_rozeti.dart';

// Listedeki Her Bir Ürünü Gösteren Kart. Yerleşim: [Resim] [Bilgiler] [Kalp].
class UrunKarti extends StatelessWidget {
  // Gösterilecek Ürün.
  final Urun urun;
  // VoidCallback = Parametresiz, Değer Döndürmeyen Fonksiyon Tipi.
  // Kart, Tıklanınca Ne Yapılacağını BİLMEZ; Sadece Ekranın Verdiği Fonksiyonu Çağırır.
  // Buna "State'i Yukarı Taşıma" (Lifting State Up) Denir.
  final VoidCallback onFavoriTiklandi;
  final VoidCallback onDetayTiklandi;

  const UrunKarti({
    super.key,
    required this.urun,
    required this.onFavoriTiklandi,
    required this.onDetayTiklandi,
  });

  @override
  Widget build(BuildContext context) {
    // Card: Gölgeli, Yükseltilmiş Kart Görünümü.
    return Card(
      // Dış Boşluk: Yatayda 16, Dikeyde 8 Piksel.
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      // Gölge Yüksekliği.
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      // InkWell: Dokunulabilir Alan + Dokununca Dalga (Ripple) Efekti.
      child: InkWell(
        // Dalga Efekti De Kartın Yuvarlak Köşesine Uysun.
        borderRadius: BorderRadius.circular(12),
        // Karta Dokunulunca Ekranın Verdiği Fonksiyonu Çağır.
        onTap: onDetayTiklandi,
        child: Padding(
          padding: const EdgeInsets.all(12),
          // Row: Çocukları YATAY Olarak Dizer.
          child: Row(
            // Tüm Çocukları Üstten Hizala.
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── SOL TARAF: Resim ──
              // ClipRRect: İçindekini Yuvarlak Köşeli Olarak Kırpar.
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                // İnternetten Resim Yükler.
                child: Image.network(
                  urun.resimUrl,
                  width: 90,
                  height: 90,
                  // Kutuyu Tamamen Doldur, Taşan Kısmı Kırp.
                  fit: BoxFit.cover,
                  // Resim Yüklenemezse Gri Kutu İçinde "Kırık Resim" İkonu Göster.
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 90,
                      height: 90,
                      color: Colors.grey.shade200,
                      child: const Icon(Icons.broken_image, color: Colors.grey),
                    );
                  },
                  // Resim Yüklenirken Çalışır.
                  loadingBuilder: (context, child, progress) {
                    // progress null = Yükleme Bitti → Resmin Kendisini (child) Göster.
                    if (progress == null) return child;
                    // Bitmediyse Küçük Dönen Yükleniyor İkonu Göster.
                    return Container(
                      width: 90,
                      height: 90,
                      color: Colors.grey.shade100,
                      child: const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    );
                  },
                ),
              ),
              // Resim ile Yazılar Arasında 14 Piksel Boşluk.
              const SizedBox(width: 14),
              // ── ORTA KISIM: Bilgiler ──
              // Expanded: Row'da Kalan TÜM Genişliği Bu Sütun Alsın.
              // Olmasaydı Uzun Metinler Taşar, Ekranda Sarı-Siyah Overflow Çizgileri Çıkardı.
              Expanded(
                // Column: Çocukları DİKEY Olarak Dizer.
                child: Column(
                  // Sola Yasla.
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      // Biri En Sola, Diğeri En Sağa Yerleşsin.
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Örn: "E Elektronik".
                        Text(
                          '${urun.kategori.ikon} ${urun.kategori.baslik}',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        // stok_rozeti.dart Dosyasındaki Widget Burada Kullanılıyor.
                        StokRozeti(stok: urun.stokAdedi),
                      ],
                    ),
                    const SizedBox(height: 6),
                    // Ürün Başlığı.
                    Text(
                      urun.baslik,
                      // Tek Satır.
                      maxLines: 1,
                      // Sığmazsa Sonuna "..." Koy.
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Ürün Açıklaması: En Fazla 2 Satır.
                    Text(
                      urun.aciklama,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade700,
                        // Satır Aralığı Çarpanı.
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Fiyat: toStringAsFixed(2) Her Zaman 2 Ondalık Basar (Örn: 1299.90 ₺).
                    Text(
                      '${urun.fiyat.toStringAsFixed(2)} ₺',
                      style: TextStyle(
                        // Uygulama Temasının Ana Rengi (main.dart'taki seedColor'dan Gelir).
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 16,
                        // En Kalın Yazı.
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
              // ── SAĞ TARAF: Favori Butonu ──
              IconButton(
                icon: Icon(
                  // Favoriyse Dolu Kırmızı Kalp, Değilse Boş Gri Kalp.
                  urun.favoriMi ? Icons.favorite : Icons.favorite_border,
                  color: urun.favoriMi ? Colors.red : Colors.grey,
                ),
                // Basılınca Ekranın Verdiği Fonksiyonu Çağır.
                onPressed: onFavoriTiklandi,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
