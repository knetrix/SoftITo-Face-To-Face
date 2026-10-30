import 'package:flutter/material.dart';

// Ürün Kartında Görünen Küçük Stok Etiketi.
// Stok Varsa Yeşil "Stok: 5", Stok Bittiyse Kırmızı "Tükendi" Gösterir.
// StatelessWidget: Kendi Değişen Durumu Yok, Sadece Kendisine Verileni Çizer.
class StokRozeti extends StatelessWidget {
  // Dışarıdan Gelen Tek Bilgi: Stok Adedi.
  final int stok;

  // super.key: Flutter'ın Widget Kimliği. stok Verilmesi Zorunlu.
  const StokRozeti({super.key, required this.stok});

  @override
  Widget build(BuildContext context) {
    // Stok 0 Mı? Renkler ve Metin Bu Değere Göre Seçilecek.
    final tukendiMi = stok == 0;

    // Container: İç Boşluk, Arka Plan ve Kenarlık Verilebilen Kutu.
    return Container(
      // İç Boşluk: Yatayda 8, Dikeyde 4 Piksel.
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        // Ternary Operatör: Koşul ? Doğruysa_Bu : Yanlışsa_Bu
        // shade100 Gibi Küçük Sayılar Açık, shade900 Gibi Büyük Sayılar Koyu Tondur.
        color: tukendiMi ? Colors.red.shade100 : Colors.green.shade100,
        // Yuvarlak Köşeler.
        borderRadius: BorderRadius.circular(6),
        // İnce Kenarlık.
        border: Border.all(
          color: tukendiMi ? Colors.red.shade400 : Colors.green.shade400,
          width: 0.8,
        ),
      ),
      child: Text(
        // Metin De Duruma Göre Değişir.
        tukendiMi ? "Tükendi" : 'Stok: $stok',
        style: TextStyle(
          color: tukendiMi ? Colors.red.shade900 : Colors.green.shade900,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
