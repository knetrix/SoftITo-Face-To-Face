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

  Future.value().then((_) {
    print('[5] Future.value().then Görevi (Microtask Queue 3)');
  });

  Future.delayed(Duration.zero, () {
    print('[6] Future.delayed(Duration.zero) Görevi 1 (Timer)');
  });

  Future(() {
    print('[7] Standart Future Başladı (Event Queue 2)');
    scheduleMicrotask(() {
      print('[8] Future İçinden Tetiklenen Microtask (Öncelikli)');
    });
  }).then((_) {
    print('[9] Future then() Bloğu');
  });

  scheduleMicrotask(() {
    print('[10] İkinci scheduleMicrotask Görevi (Microtask Queue 4)');
    scheduleMicrotask(() {
      print('[11] Microtask İçinden Tetiklenen Yeni Microtask');
    });
  });

  Future(() {
    print('[12] Standart Future Görevi (Event Queue 3)');
  }).then((_) {
    print('[13] Future 3 then() Bloğu');
  });

  Future.delayed(Duration.zero, () {
    print('[14] Future.delayed(Duration.zero) Görevi 2 (Timer)');
  });

  print('[15] Senkron Ana Akış Bitti (Main Thread Boşaldı)');
  await Future.delayed(const Duration(milliseconds: 500));
}