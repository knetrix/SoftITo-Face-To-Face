import 'package:flutter/material.dart'; // Flutter'ın Material Widget'larını import Eder.

class CartController { // Sepet Verisini Yöneten Controller Class'ıdır.
  static final CartController instance = CartController._internal(); // Uygulama Boyunca Kullanılacak Tek (Singleton) Instance'ı Oluşturur.
  CartController._internal(); // Dışarıdan Yeni Instance Oluşturulmasını Engelleyen Private Named Constructor'dır.

  final ValueNotifier<int> itemCount = ValueNotifier<int>(0); // Sepetteki Ürün Sayısını Tutan ValueNotifier'dır, Değer Değişince Listener'ları Bilgilendirir.

  void addToCart() { // Sepete Bir Ürün Ekler.
    itemCount.value++; // itemCount'un value'sunu Bir Artırır.
  }

  void resetCart() { // Sepeti Boşaltır.
    itemCount.value = 0; // itemCount'un value'sunu 0'a Çeker.
  }
}

class CartScreen extends StatelessWidget { // Sepet Sayfasının StatelessWidget'ıdır.
  const CartScreen({super.key}); // key Parametresini Superclass'a İleten const Constructor'dır.

  @override // Superclass'taki build Metodunun Override Edildiğini Belirtir.
  Widget build(BuildContext context) { // Sepet Sayfasının Widget Tree'sini Oluşturur.
    return Scaffold( // Sayfanın Temel Material Layout'unu Oluşturur.
      appBar: AppBar(title: const Text('Sepet')), // Üstte 'Sepet' title'lı Bir AppBar Gösterir.
      body: Center( // child'ı Ekranın Ortasına Yerleştirir.
        child: ValueListenableBuilder<int>( // itemCount Değiştikçe Yalnızca Bu Kısmı Rebuild Eder.
          valueListenable: CartController.instance.itemCount, // CartController'daki itemCount ValueNotifier'ını Dinler.
          builder: (context, count, child) { // Güncel count Değeriyle Widget'ı Build Eder.
            return Text('Sepetteki ürün sayısı: $count'); // Ürün Sayısını Text Olarak Gösterir.
          },
        ),
      ),
    );
  }
}
