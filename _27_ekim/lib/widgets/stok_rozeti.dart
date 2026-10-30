// ============================================================================
// stok_rozeti.dart → Ürün Kartındaki Küçük Stok Etiketi
// ----------------------------------------------------------------------------
// Ekranda Üç Farklı Şekilde Görünür:
//   - Stok Varsa       → Yeşil Kutu: "Stok: 5"
//   - Stok Bittiyse (0) → Kırmızı Kutu: "Tükendi"
//   - Stok Bilinmiyorsa (-1, API Ürünleri) → Hiç Görünmez
//
// "widgets" Klasöründeki Dosyalar, Birden Fazla Yerde Kullanılabilecek
// Küçük Ekran Parçalarıdır. Lego Parçaları Gibi Düşünün: Bir Kez Yapılır,
// İstenen Yere Takılır.
// ============================================================================

import 'package:flutter/material.dart';

// StatelessWidget: Kendi İçinde Değişen Bir Bilgi Tutmaz.
// Sadece Kendisine Verilen stok Sayısına Bakar ve Ona Göre Çizilir.
// Stok Sayısı Değişirse, Bu Widget'ı Kullanan Üst Widget Onu Yeni Değerle
// Tekrar Oluşturur.
class StokRozeti extends StatelessWidget {
  // Dışarıdan Gelen Tek Bilgi: Stok Adedi.
  final int stok;

  // Kurucu. Kullanımı: StokRozeti(stok: 5)
  // super.key: Flutter'ın Widget Kimliği. "required this.stok": stok Verilmesi Zorunlu.
  const StokRozeti({super.key, required this.stok});

  // build: Bu Widget'ın Ekranda Neye Benzeyeceğini Döndürür.
  @override
  Widget build(BuildContext context) {
    // Stok Bilgisi Yoksa (-1) Rozeti Hiç Gösterme.
    // SizedBox.shrink(): Boş, Hiç Yer Kaplamayan Bir Widget. build Metodu Mutlaka
    // Bir Widget Döndürmek Zorunda Olduğu için "Hiçbir Şey" Yerine Bunu Döndürüyoruz.
    // "return" Metodu Burada Bitirir; Aşağıdaki Satırlar Çalışmaz.
    if (stok < 0) return const SizedBox.shrink();

    // Stok 0 Mı? Sonuç true Ya da false Olur ve Aşağıda Renk/Metin Seçerken Kullanılır.
    final tukendiMi = stok == 0;

    // Container: Etrafına Boşluk, Arka Plan Rengi, Kenarlık Verilebilen Kutu.
    return Container(
      // padding: Kutunun İÇ Boşluğu (Yazı ile Kenar Arasındaki Mesafe).
      // EdgeInsets.symmetric: Yatayda (Sağ-Sol) 8, Dikeyde (Üst-Alt) 4 Piksel.
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      // decoration: Kutunun Görünüşü (Renk, Köşe, Kenarlık).
      decoration: BoxDecoration(
        // "koşul ? A : B" (Ternary Operatör): tukendiMi true İse Kırmızı, Değilse Yeşil.
        // shade100 Gibi Küçük Sayılar Rengin Açık Tonu, shade900 Gibi Büyük
        // Sayılar Koyu Tonudur.
        color: tukendiMi ? Colors.red.shade100 : Colors.green.shade100,
        // Köşeleri 6 Piksel Yuvarlat.
        borderRadius: BorderRadius.circular(6),
        // Kutunun Etrafına İnce Bir Çizgi (Kenarlık) Çek.
        border: Border.all(
          color: tukendiMi ? Colors.red.shade400 : Colors.green.shade400,
          width: 0.8,
        ),
      ),
      // child: Kutunun İçine Konan Widget. Burada Bir Yazı.
      child: Text(
        // Metin de Duruma Göre Değişir. '$stok' Yazımı, stok Değişkeninin
        // Değerini Metnin İçine Yerleştirir (Örn: "Stok: 5").
        tukendiMi ? "Tükendi" : 'Stok: $stok',
        // TextStyle: Yazının Rengi, Boyutu, Kalınlığı.
        style: TextStyle(
          color: tukendiMi ? Colors.red.shade900 : Colors.green.shade900,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
