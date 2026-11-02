import 'package:flutter/material.dart'; // Flutter'ın Material Widget'larını import Eder.

import 'cart.dart'; // Sepeti Temizlemek İçin CartController Class'ını import Eder.

class ProfileScreen extends StatelessWidget { // Kullanıcı Profili Sayfasının StatelessWidget'ıdır.
  const ProfileScreen({super.key}); // key Parametresini Superclass'a İleten const Constructor'dır.

  @override // Superclass'taki build Metodunun Override Edildiğini Belirtir.
  Widget build(BuildContext context) { // Profil Sayfasının Widget Tree'sini Oluşturur.
    return Scaffold( // Sayfanın Temel Material Layout'unu Oluşturur.
      appBar: AppBar(title: const Text('Kullanıcı Profili')), // Üstte 'Kullanıcı Profili' title'lı Bir AppBar Gösterir.
      body: Center( // child'ı Ekranın Ortasına Yerleştirir.
        child: TextButton( // Arka Planı Olmayan Bir TextButton Oluşturur.
          onPressed: () => CartController.instance.resetCart(), // Basılınca CartController Üzerinden Sepeti Sıfırlar.
          child: const Text('Sepeti Temizle (0)'), // Butonun child'ı Olan Yazıdır.
        ),
      ),
    );
  }
}
