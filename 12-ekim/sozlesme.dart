// Soyutlama Abstraction Kavramı

/*
// 1. Adım (sözleşmeler) Contract
abstract class AutReposity {
  Future<String> login(String email, String password);
  Future<void> logout();
  bool get isAuth;
}

// Canlı Uygulama
class FirebaseAuthReposity implements AutReposity {
  @override
  Future<String> login(String email, String password) async {
    //gerçek Firebase SDK Çaprısı
    return "firebase_token_xyz_123";
  }

  @override
  Future<void> logout() async {
    // Firebase Logout
  }

  @override
  bool get isAuth => true;
}

// Test ve offline simulasyon
class MockAuthReposity implements AutReposity {
  @override
  Future<String> login(String email, String password) async {
    await Future.delayed(Duration(seconds: 1));
    return "mock_token_abc_789";
  }

  @override
  Future<void> logout() async {}

  @override
  bool get isAuth => false;
}

mixin Logger {
  void log(String msg) => print("LOG: $msg");
}

mixin Analytics {
  void log(String msg) => print("ANALYTICS: $msg");
}

class PaymentService with Logger, Analytics {
  void pay() {
    log("Payment Processed");
  }
}

// ANALYTICS: Payment Processed -> Asenkron Değil, Sol Sağa Çalışıyor, Öncekini Ezdi, Logger Çalışmadı.

abstract class BaseWidget {
}

// Sadece BaseWidget ve Alt Sınıflarda Kullanılabilir.

mixin LifeLogger on BaseWidget {
  void logInit() => print("Widget Initialized");
}

// Extension Kullanımı.

extension StringValidator on String {
  bool get isValidEmail  {
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
    return emailRegex.hasMatch(this);
  }

  String toCapitalize() {
    if (this.isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }
}

void main() {
  String email = "user@example.com";
  if (email.isValidEmail) {
    print("$email is A Valid Email.");
  } 
  else {
    print("$email is Not A Valid Email.");
  }
}

// Generic Kullanımı

abstract class Identifiable {
  String get id;
}

// T Tipi Mutlaka Identifiable Arayüzünü Uygulamak Zorundadır.
class GenericCache<T extends Identifiable> {
  final Map<String, T> _storage = {};

  void save(T item) {
    _storage[item.id] = item;
    print("ID: ${item.id} Önbelleğe Alındı.");
  }

  T? getById(String id) => _storage[id];
}
  */

// Asenkron - Loop

import 'dart:async';

void main() {
  print("1. Senkron Başladı");
  scheduleMicrotask(() {
    print("2. Task Oluştu (VIP Kuyruk).");
  });
  Future(() {
    print("3. Standart Event Kuyruğu");
  });
  Future.microtask(() {
    print("4. Future.microtask Çalıştı");
  });

  print("5. Senkron Kod Tamamlandı");
}

// Veri Tipi Bağımsız Çalışmak İstiyoruz.
// İşlem Hata Mı Fırlatıyor, Devam Mı Ediyor, ...

// 1. Senkron Başladı
// 5. Senkron Kod Tamamlandı
// 2. Task Oluştu (VIP Kuyruk).
// 4. Future.microtask Çalıştı
// 3. Standart Event Kuyruğu
