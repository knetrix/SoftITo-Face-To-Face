import 'package:flutter/material.dart'; // Flutter'ın Material Widget'larını import Eder.

class StockBadge extends StatelessWidget { // Ürün Kartındaki Stok Etiketini Gösteren StatelessWidget'tır.
  final int stock; // Gösterilecek Stok Adedidir.

  const StockBadge({super.key, required this.stock}); // stock'u required Alan const Constructor'dır.

  @override // Superclass'taki build Metodunun Override Edildiğini Belirtir.
  Widget build(BuildContext context) { // Etiketin Widget Tree'sini Oluşturur.
    if (stock < 0) return const SizedBox.shrink(); // Stok Bilgisi Yoksa (-1) Hiç Yer Kaplamayan Boş Bir Widget Döndürür.

    final isOutOfStock = stock == 0; // Stoğun Tükenip Tükenmediğini Tutar.

    return Container( // Padding, Renk ve Kenarlık Verilebilen Bir Container Döndürür.
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), // Yatayda 8, Dikeyde 4 Logical Pixel İç Boşluk Verir.
      decoration: BoxDecoration( // Container'ın Görünüşünü Tanımlar.
        color: isOutOfStock ? Colors.red.shade100 : Colors.green.shade100, // Tükendiyse Açık Kırmızı, Değilse Açık Yeşil Arka Plan Kullanır.
        borderRadius: BorderRadius.circular(6), // Köşeleri 6 Logical Pixel Yuvarlatır.
        border: Border.all( // Etrafına Kenarlık Çizer.
          color: isOutOfStock ? Colors.red.shade400 : Colors.green.shade400, // Duruma Göre Kenarlık Rengini Seçer.
          width: 0.8, // Kenarlık Kalınlığıdır.
        ),
      ),
      child: Text( // Container'ın İçindeki Metindir.
        isOutOfStock ? "Tükendi" : 'Stok: $stock', // Tükendiyse "Tükendi", Değilse Stok Adedini Yazar.
        style: TextStyle( // Metnin Stilini Tanımlar.
          color: isOutOfStock ? Colors.red.shade900 : Colors.green.shade900, // Duruma Göre Koyu Metin Rengini Seçer.
          fontSize: 11, // Yazı Boyutudur.
          fontWeight: FontWeight.bold, // Yazıyı Kalın Yapar.
        ),
      ),
    );
  }
}
