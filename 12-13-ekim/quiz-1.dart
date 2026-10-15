import 'dart:async';

void main() async {
  print('[1] Senkron Ana Akış Başladı (Main Thread)');
  Future(() {
    print('[2] Standart Future Görevi (Event Queue 1)');
  });
  scheduleMicrotask(() {
    print('[3] scheduleMicrotask Görevi (Microtask Queue 1)');
  });
  Future.microtask(() {
    print('[4] Future.microtask Görevi (Microtask Queue 2)');
  });
  Future.delayed(Duration.zero, () {
    print('[5] Future.delayed(Duration.zero) (Event Queue - Timer Bazlı)');
  });
  Future(() {
    print('[6] Standart Future Başladı (Event Queue 2)');
    scheduleMicrotask(() {
      print('[7] Future İçinden Tetiklenen Microtask (Öncelik Kapanı!)');
    });
  }).then((_) {
    print('[8] Future then() Bloğu');
  });
  scheduleMicrotask(() {
    print('[9] İkinci scheduleMicrotask Görevi (Microtask Queue 3)');
  });
  print('[10] Senkron Ana Akış Bitti (Main Thread Boşaldı)\n');

  await Future.delayed(const Duration(milliseconds: 500));
}

// Çıktı
// 1, 10, 3, 4, 9, 2, 6, 8, 7, 5
// Şuanki Kodda 5 Sonda Gözükmüyor, Fakat Gerçek Senaryoda 5 Sonda Olacaktır.