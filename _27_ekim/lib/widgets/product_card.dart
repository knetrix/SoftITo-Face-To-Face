import 'package:flutter/material.dart'; // Flutter'ın Material Widget'larını import Eder.

import '../models/product.dart'; // Kartta Gösterilecek Product Class'ını import Eder.
import 'stock_badge.dart'; // Stok Etiketi Olan StockBadge Widget'ını import Eder.

class ProductCard extends StatelessWidget { // Listedeki Tek Bir Ürünü Gösteren StatelessWidget'tır.
  final Product product; // Kartta Gösterilecek Üründür.
  final VoidCallback onFavoriteTap; // Kalbe Basılınca Çağrılacak, Ekrandan Gelen Callback'tir.
  final VoidCallback onDetailTap; // Karta Basılınca Çağrılacak, Ekrandan Gelen Callback'tir.

  const ProductCard({ // Tüm Parametreleri required Alan const Constructor'dır.
    super.key, // key Parametresini Superclass'a İletir.
    required this.product, // product Field'ını required Yapar.
    required this.onFavoriteTap, // onFavoriteTap Field'ını required Yapar.
    required this.onDetailTap, // onDetailTap Field'ını required Yapar.
  });

  @override // Superclass'taki build Metodunun Override Edildiğini Belirtir.
  Widget build(BuildContext context) { // Kartın Widget Tree'sini Oluşturur.
    return Card( // Gölgeli ve Köşeleri Yuvarlak Bir Card Döndürür.
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Kartın Dışına Yatayda 16, Dikeyde 8 Boşluk Verir.
      elevation: 2, // Kartın Gölge Yüksekliğidir.
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), // Köşeleri 12 Logical Pixel Yuvarlatır.
      child: InkWell( // Kartı Tıklanabilir Yapıp Ripple Efekti Ekler.
        borderRadius: BorderRadius.circular(12), // Ripple Efektinin Kart Köşelerine Uymasını Sağlar.
        onTap: onDetailTap, // Karta Basılınca onDetailTap Callback'ini Çağırır.
        child: Padding( // İçeriğin Etrafına Boşluk Bırakır.
          padding: const EdgeInsets.all(12), // Dört Taraftan 12 Logical Pixel İç Boşluk Verir.
          child: Row( // Görsel, Bilgiler ve Kalbi Yatay Olarak Dizer.
            crossAxisAlignment: CrossAxisAlignment.start, // Row'daki Elemanları Üstten Hizalar.
            children: [ // Row'un children Listesidir.
              ClipRRect( // İçindeki Görseli Yuvarlak Köşeli Kırpar.
                borderRadius: BorderRadius.circular(10), // Görsel Köşelerini 10 Logical Pixel Yuvarlatır.
                child: Image.network( // Ürün Görselini Network'ten Yükler.
                  product.imageUrl, // Yüklenecek Görselin URL'idir.
                  width: 90, // Görselin width Değeridir.
                  height: 90, // Görselin height Değeridir.
                  fit: BoxFit.cover, // Görseli Alanı Dolduracak Şekilde Büyütüp Taşanı Kırpar.
                  errorBuilder: (context, error, stackTrace) { // Görsel Yüklenemezse Çalışan errorBuilder'dır.
                    return Container( // Görsel Yerine Gri Bir Container Döndürür.
                      width: 90, // Container'ın width Değeridir.
                      height: 90, // Container'ın height Değeridir.
                      color: Colors.grey.shade200, // Açık Gri Arka Plan Rengidir.
                      child: const Icon(Icons.broken_image, color: Colors.grey), // broken_image İkonunu Gösterir.
                    );
                  },
                  loadingBuilder: (context, child, progress) { // Görsel İndirilirken Tekrar Tekrar Çalışan loadingBuilder'dır.
                    if (progress == null) return child; // progress null İse İndirme Bitmiştir, Görseli Gösterir.
                    return Container( // İndirme Sürerken Gri Bir Container Döndürür.
                      width: 90, // Container'ın width Değeridir.
                      height: 90, // Container'ın height Değeridir.
                      color: Colors.grey.shade100, // Çok Açık Gri Arka Plan Rengidir.
                      child: const Center( // İçeriği Ortalar.
                        child: CircularProgressIndicator(strokeWidth: 2), // İnce Bir CircularProgressIndicator Gösterir.
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 14), // Görsel ile Bilgiler Arasına 14 Logical Pixel Boşluk Koyar.

              Expanded( // Row'da Kalan Tüm Genişliği Bu Column'a Verir, Overflow'u Önler.
                child: Column( // Ürün Bilgilerini Dikey Olarak Dizer.
                  crossAxisAlignment: CrossAxisAlignment.start, // Column'daki Elemanları Sola Yaslar.
                  children: [ // Column'un children Listesidir.
                    Row( // Kategori ve Stok Etiketini Aynı Satırda Dizer.
                      mainAxisAlignment: MainAxisAlignment.spaceBetween, // Kategoriyi En Sola, Etiketi En Sağa Yerleştirir.
                      children: [ // Row'un children Listesidir.
                        Text( // Kategori Metnini Gösterir.
                          '${product.category.icon} ${product.category.title}', // İkon ve Başlığı String Interpolation İle Birleştirir.
                          style: TextStyle( // Metnin Stilini Tanımlar.
                            color: Colors.grey.shade600, // Gri Metin Rengidir.
                            fontSize: 12, // Yazı Boyutudur.
                            fontWeight: FontWeight.w600, // Yarı Kalın Yazı Kalınlığıdır.
                          ),
                        ),
                        StockBadge(stock: product.stockCount), // Ürünün Stok Adedini StockBadge İle Gösterir.
                      ],
                    ),
                    const SizedBox(height: 6), // Satırlar Arasına 6 Logical Pixel Boşluk Koyar.
                    Text( // Ürün Adını Gösterir.
                      product.title, // Gösterilecek Ürün Adıdır.
                      maxLines: 1, // En Fazla 1 Satır Gösterir.
                      overflow: TextOverflow.ellipsis, // Sığmayan Metnin Sonuna ... Koyar.
                      style: const TextStyle( // Metnin Stilini Tanımlar.
                        fontSize: 15, // Yazı Boyutudur.
                        fontWeight: FontWeight.bold, // Yazıyı Kalın Yapar.
                      ),
                    ),
                    const SizedBox(height: 4), // 4 Logical Pixel Dikey Boşluk Koyar.
                    Text( // Ürün Açıklamasını Gösterir.
                      product.description, // Gösterilecek Açıklamadır.
                      maxLines: 2, // En Fazla 2 Satır Gösterir.
                      overflow: TextOverflow.ellipsis, // Sığmayan Metnin Sonuna ... Koyar.
                      style: TextStyle( // Metnin Stilini Tanımlar.
                        fontSize: 12, // Yazı Boyutudur.
                        color: Colors.grey.shade700, // Koyu Gri Metin Rengidir.
                        height: 1.2, // Satır Yüksekliğini Yazı Boyutunun 1,2 Katı Yapar.
                      ),
                    ),
                    const SizedBox(height: 8), // 8 Logical Pixel Dikey Boşluk Koyar.
                    Text( // Ürün Fiyatını Gösterir.
                      '${product.price.toStringAsFixed(2)} \$', // Fiyatı İki Ondalık Basamakla Yazıp Sonuna $ Ekler.
                      style: TextStyle( // Metnin Stilini Tanımlar.
                        color: Theme.of(context).colorScheme.primary, // Temanın primary Rengini Kullanır.
                        fontSize: 16, // Yazı Boyutudur.
                        fontWeight: FontWeight.w900, // En Kalın Yazı Kalınlığıdır.
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8), // Bilgiler ile Kalp Arasına 8 Logical Pixel Boşluk Koyar.

              IconButton( // Favori Durumunu Değiştiren Kalp Butonudur.
                padding: EdgeInsets.zero, // Default İç Boşluğu Kaldırır.
                constraints: const BoxConstraints(), // Default 48x48 Minimum Boyutu Kaldırır.
                style: IconButton.styleFrom( // Butonun Stilini Tanımlar.
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap, // Mobilde Dokunma Alanının Büyütülmesini Kapatıp Hizalamayı Korur.
                ),
                icon: Icon( // Butonda Gösterilecek İkondur.
                  product.isFavorite ? Icons.favorite : Icons.favorite_border, // Favoriyse Dolu, Değilse Boş Kalp Gösterir.
                  color: product.isFavorite ? Colors.red : Colors.grey, // Favoriyse Kırmızı, Değilse Gri Renk Kullanır.
                ),
                onPressed: onFavoriteTap, // Basılınca onFavoriteTap Callback'ini Çağırır.
              ),
            ],
          ),
        ),
      ),
    );
  }
}
