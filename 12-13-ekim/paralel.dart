/*

Future<void> fetchDashboardData() async {
  try {
    final result = await Future.wait([
      fetchUserProfile(),
      fetchAccountBalance(),
      fetchNotification(),
    ], eagerError: true);
    print("Tüm Veriler Geldi $result");
  } catch (e) {
    print("İsteklerden Biri Başarısız Oldu $e");
  }
}

Future: Tek Bir Kere Veri Çekileceği Zaman Kullanılır. Hata veya Değer Döndürür.
Stream: Bir Boru Hattı Şeklinde Çalışır (Pipe) , Zaman İçinde 1 10 100 yada Sonsuz Sayida Veri Akılı Sağlanabilir.
(Borsa Fiyatları, GPS Konum Güncelleme, Firebase Canlı Dinleme).

----

import 'dart:async';

void main() {
  Controller Oluşturma
  final controller = StreamController<int>();

  Listener Bağlama
  final subscription = controller.stream.listen(
    (data) => print("Veri Geldi: $data"),
    onError: (error) => print("Hata Geldi: $error"),
    onDone: () => print("Stream Tamamlandı"),
  );

  controller.sink.add(10);
  controller.sink.add(20);
  controller.sink.add(30);

  controller.close(); // Stream'i Kapatma.
}

Veri Geldi: 10
Veri Geldi: 20
Veri Geldi: 30
Stream Tamamlandı.

*/

// ----

import 'dart:async';

void main() {
  // Controller Oluşturma
  final controller = StreamController<int>();

  final broadcastStream = controller.stream.asBroadcastStream();
  broadcastStream.listen((d) => print("Broadcast Stream 1: $d"));
  broadcastStream.listen((d) => print("Broadcast Stream 2: $d"));

  controller.close(); // Stream'i Kapatma.
}