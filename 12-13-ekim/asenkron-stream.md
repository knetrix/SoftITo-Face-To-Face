# Intro

**Senkron kod**: Sırayla, Hemen Çalışır.

**Asenkron Kod**: Kuyruğa Alınır; Uygun Sırada Daha Sonra Çalışır.

Birden Fazla Asenkron İşlem Aynı Anda Başlatılabilir; Bitiş Süreleri Farklı Olabilir. Bir işlem Daha Kısa Sürerse, Çıktısı Diğerinden Önce Gelebilir.

Örnek

- Senkron Durumda: Önce A Biter, Sonra B Çalışır.
- Asenkron Durumda: A ve B Başlar; Hangisi Önce Biterse Sonucu Önce Gelir.

## Dart Asenkron Genel Öncelik Sırası

1. **Senkron**
2. **Microtask / scheduleMicrotask**
3. **Event Queue**
  1. **Future**
  2. **Future.delayed**

---

# Microtask / scheduleMicrotask

# Future

Gelecekte Tamamlanacak Bir İşlemi Temsil Eder.

Örnekler

- API’den Veri Çekmek.
- Veritabanı Sorgusu Yapmak.
- Dosya Okumak.
- Ağ İsteği Göndermek
- Uzun Süren Hesaplama Yürütmek.

Future için Üç Temel Durum Vardır:

1. **Devam Ediyor** — İşlem Henüz Bitmedi.
2. **Başarılı** — Değer/Veri Döndü.
3. **Başarısız** — Hata Oluştu.

- Future, Sadece Bir Tür Veriye Bağlı Değildir; `String`, `int`, `bool`, Liste veya Başka Türlerde Sonuç Döndürebilir.
- `then`, Future’ın Sonucuna Göre İşlem Yapmak için Kullanılır.

---

# Future.wait: Paralel API/Veri İstekleri

Birden Fazla Bağımsız Veriyi Aynı Anda Çekmek için `Future.wait` Kullanımı Anlatılıyor.

Örnek: Bir Dashboard Ekranı için Aynı Anda Şu Veriler Gerekli Olabilir:

- Kullanıcı Profili.
- Hesap Bakiyesi.
- Bildirimler.

Örnek Yapı:

```dart
Future<void> fetchDashboardData() async {
  try {
    final results = await Future.wait([
      fetchUserProfile(),
      fetchAccountBalance(),
      fetchNotifications(),
    ]);

    print('Tüm Veriler Geldi: $results');
  } catch (error) {
    print('İsteklerden Biri Başarısız Oldu: $error');
  }
}
```

- Tüm İşlemler Bitene Kadar `await` ile Bekler.
- İşlemlerden Biri Hata Verirse `catch` Bloğu Devreye Girer.
- Dashboard Gibi Birden Fazla Kaynağa İhtiyaç Duyulan Ekranlarda Kullanışlıdır.

Arayüz Açısından Önemli Not:

- Veriler Farklı Zamanlarda Gelebilir.
- Veri Gelene Kadar Ekranda **Skeleton Loading** Kullanılabilir.
- Örneğin Profil Geç Gelirken Bakiye Önce Gelebilir; İlgili Alanlar Veri Geldikçe Doldurulabilir.

---

# Future ve Stream Farkı

| Özellik | Future | Stream |
| --- | --- | --- |
| Veri Sayısı | Tek Sonuç | Birden Fazla Sonuç |
| Çalışma biçimi | Bir Kez Tamamlanır | Sürekli Veri Akışı Sağlar |
| Kullanım örneği | API’den Profil Bilgisi Çekme | Canlı Borsa Fiyatı, GPS, Bildirim |
| Sonuç | Değer veya Hata Döner, Biter | Veri Geldikçe Dinleyiciye İletir |
| Benzetme | Tek Seferlik Sipariş | Sürekli Açık Musluk / Boru Hattı |

---

# StreamController / Stream

## Single-Subscription Stream

```dart
import 'dart:async';

void main() {
  final controller = StreamController<int>();

  final subscription = controller.stream.listen(
    (data) {
      print('Yeni Veri: $data');
    },
    onError: (error) {
      print('Hata Oluştu: $error');
    },
    onDone: () {
      print('Stream Tamamlandı.');
    },
  );

  controller.add(10);
  controller.add(20);
  controller.add(30);

  controller.close();
}
```

1. `StreamController<int>` Oluşturulur.
2. `controller.stream.listen(...)` ile Veri Dinlenir.
3. `controller.add(...)` ile Akışa Yeni Veri Gönderilir.
4. Her Yeni Veri Geldiğinde `listen` İçindeki `data` Bölümü Çalışır.
5. Hata Varsa `onError` Çalışır.
6. Akış Kapatıldığında `onDone` Çalışır.

Beklenen Çıktı

```text
Yeni Veri: 10
Yeni Veri: 20
Yeni Veri: 30
Stream Tamamlandı.
```

---


## Broadcast Stream

Birden Fazla Dinleyicinin Aynı Akışı Dinlemesi Gerekiyorsa **Broadcast Stream** Kullanılır.

Örnek:

```dart
final controller = StreamController<int>.broadcast();

controller.stream.listen((data) {
  print('UI Ekranı: $data');
});

controller.stream.listen((data) {
  print('Analytics Servisi: $data');
});

controller.add(10);
```

Burada Aynı Veri Hem:

- Kullanıcı Arayüzüne,
- Analitik Sistemine

İletilebilir.