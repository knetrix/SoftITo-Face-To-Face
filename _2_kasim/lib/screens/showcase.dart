import 'package:flutter/material.dart'; // Flutter'ın Material Widget'larını import Eder.

import '../services/product_service.dart'; // ProductModel ve IProductService'i import Eder.
import 'cart.dart'; // Sepete Ürün Eklemek İçin CartController Class'ını import Eder.

class ShowcaseScreen extends StatefulWidget { // Ürünlerin Listelendiği Vitrin Sayfasının StatefulWidget'ıdır.
  const ShowcaseScreen({super.key}); // key Parametresini Superclass'a İleten const Constructor'dır.

  @override // Superclass'taki createState Metodunun Override Edildiğini Belirtir.
  State<ShowcaseScreen> createState() => _ShowcaseScreenState(); // Bu Widget'ın State Nesnesini Oluşturur.
}

class _ShowcaseScreenState extends State<ShowcaseScreen> { // ShowcaseScreen'in State'ini Tutan Class'tır.
  final IProductService _productService = LiveApiProductService(); // Ürünleri Gerçek API'den Çekecek Servis Instance'ını Oluşturur.
  late Future<List<ProductModel>> _productsFuture; // Ürün Listesinin Future'ını Tutar, late Olduğu İçin Sonradan Atanır.

  @override // Superclass'taki initState Metodunun Override Edildiğini Belirtir.
  void initState() { // State Oluşturulduğunda Bir Kez Çalışan Lifecycle Metodudur.
    super.initState(); // Superclass'ın initState İşlemlerini Çalıştırır.
    _productsFuture = _productService.fetchProducts(); // fetchProducts İsteğini Başlatıp Future'ı Saklar.
  }

  void _retry() { // Hata Sonrası Ürünleri Yeniden Yükler.
    setState(() { // build Metodunu Yeniden Tetikleyerek Widget'ı Rebuild Eder.
      _productsFuture = _productService.fetchProducts(); // Yeni Bir fetchProducts İsteği Başlatıp Future'ı Günceller.
    });
  }

  @override // Superclass'taki build Metodunun Override Edildiğini Belirtir.
  Widget build(BuildContext context) { // Vitrin Sayfasının Widget Tree'sini Oluşturur.
    return Scaffold( // Sayfanın Temel Material Layout'unu Oluşturur.
      body: SafeArea( // İçeriği Notch ve Status Bar Gibi Sistem Alanlarından Korur.
        child: FutureBuilder<List<ProductModel>>( // Future'ın Durumuna Göre UI'ı Build Eder.
          future: _productsFuture, // Takip Edilecek Future'dır.
          builder: (context, snapshot) { // Future'ın Anlık snapshot'ıyla UI'ı Oluşturur.
            if (snapshot.connectionState != ConnectionState.done) { // connectionState done Değilse, Yani İstek Sürüyorsa Bu Bloğa Girer.
              return const Center(child: CircularProgressIndicator()); // Ortada Bir CircularProgressIndicator Gösterir.
            }
            if (snapshot.hasError) { // Future Hatayla Tamamlandıysa Bu Bloğa Girer.
              return Center( // Hata İçeriğini Ortalar.
                child: Column( // Hata Mesajını ve Butonu Column İçinde Alt Alta Dizer.
                  mainAxisSize: MainAxisSize.min, // Column'un Yalnızca İçeriği Kadar Yer Kaplamasını Sağlar.
                  children: [ // Column'un children Listesidir.
                    const Text( // Hata Mesajını Text Olarak Gösterir.
                      'Ürünler yüklenemedi. Bağlantınızı kontrol edin.', // Kullanıcıya Gösterilen Hata Metnidir.
                    ),
                    const SizedBox(height: 8), // Mesaj ile Buton Arasına 8 Logical Pixel Boşluk Koyar.
                    ElevatedButton( // Elevation'lı Bir ElevatedButton Oluşturur.
                      onPressed: _retry, // Basılınca _retry Metodunu Çağırır.
                      child: const Text('Tekrar Dene'), // Butonun child'ı Olan Yazıdır.
                    ),
                  ],
                ),
              );
            }
            final products = snapshot.data ?? <ProductModel>[]; // snapshot.data'yı Alır, null İse Boş List Kullanır.
            if (products.isEmpty) { // List Boşsa Bu Bloğa Girer.
              return const Center(child: Text('Henüz ürün bulunmuyor.')); // Ortada Ürün Olmadığını Yazar.
            }
            return ListView.builder( // Item'ları Lazy Olarak Build Eden, Scroll Edilebilir Bir ListView Oluşturur.
              itemCount: products.length, // ListView'daki Item Sayısını Belirler.
              itemBuilder: (context, index) { // Her Item'ı Ekranda Görüneceği Zaman Build Eder.
                final product = products[index]; // index'teki Ürünü Alır.
                return ListTile( // Ürünü Bir ListTile Olarak Gösterir.
                  leading: SizedBox( // ListTile'ın leading Alanında Sabit Boyutlu Bir Görsel Alanı Oluşturur.
                    width: 56, // Görsel Alanının width Değeridir.
                    height: 56, // Görsel Alanının height Değeridir.
                    child: Image.network( // Ürün Görselini Network'ten Yükler.
                      product.imageUrl, // Yüklenecek Görselin URL'idir.
                      fit: BoxFit.contain, // Görseli Oranını Bozmadan Alana Sığdırır.
                      errorBuilder: (context, error, stackTrace) => // Görsel Yüklenemezse Çalışan errorBuilder'dır.
                          const Icon(Icons.image_not_supported), // Görsel Yerine image_not_supported İkonunu Gösterir.
                    ),
                  ),
                  title: Text(product.title), // ListTile'ın title Alanında Ürün Adını Gösterir.
                  subtitle: Text(product.category), // subtitle Alanında Ürünün Kategorisini Gösterir.
                  trailing: Text('\$${product.price.toStringAsFixed(2)}'), // trailing Alanında Fiyatı İki Ondalık Basamakla Gösterir.
                  onTap: CartController.instance.addToCart, // ListTile'a Tap Edilince addToCart İle Ürünü Sepete Ekler.
                );
              },
            );
          },
        ),
      ),
    );
  }
}
