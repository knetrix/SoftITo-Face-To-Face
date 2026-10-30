# Mini Mağaza – `lib` Klasörü, Dosya Dosya Anlatım

> Bu Belge, Flutter'a Yeni Başlayan Birinin Projeyi Baştan Sona Anlayabilmesi için Yazıldı.
> Aynı Açıklamaların Kısa Halleri `lib` Klasöründeki Kod Dosyalarına da Yorum Satırı Olarak Eklenmiştir.

## İçindekiler

- [0. Başlamadan Önce: Temel Kavramlar](#0-başlamadan-önce-temel-kavramlar)
- [1. Büyük Resim: Bu Proje Ne Yapıyor?](#1-büyük-resim-bu-proje-ne-yapıyor)
- [2. `models/kategori.dart`: Kategori Listesi](#2-modelskategoridart-kategori-listesi)
- [3. `models/degerlendirme.dart`: Puan Modeli](#3-modelsdegerlendirmedart-puan-modeli)
- [4. `models/urun.dart`: Ürün Modeli](#4-modelsurundart-ürün-modeli)
- [5. `services/i_urun_servisi.dart`: Sözleşme (Interface)](#5-servicesi_urun_servisidart-sözleşme-interface)
- [6. `services/mock_urun_servisi.dart`: Sahte Ürünler](#6-servicesmock_urun_servisidart-sahte-ürünler)
- [7. `services/api_urun_servisi.dart`: Gerçek API Servisi](#7-servicesapi_urun_servisidart-gerçek-api-servisi)
- [8. `widgets/stok_rozeti.dart`: Stok Etiketi](#8-widgetsstok_rozetidart-stok-etiketi)
- [9. `widgets/urun_karti.dart`: Ürün Kartı](#9-widgetsurun_kartidart-ürün-kartı)
- [10. `screens/urun_listesi_ekrani.dart`: Ana Ekran](#10-screensurun_listesi_ekranidart-ana-ekran)
- [11. `main.dart`: Uygulamanın Giriş Kapısı](#11-maindart-uygulamanın-giriş-kapısı)
- [12. Proje Ayarları: `pubspec.yaml` ve `AndroidManifest.xml`](#12-proje-ayarları-pubspecyaml-ve-androidmanifestxml)
- [13. Her Şey Birlikte: Adım Adım Ne Olur?](#13-her-şey-birlikte-adım-adım-ne-olur)
- [14. Kodda Fark Ettiğim Küçük Şeyler](#14-kodda-fark-ettiğim-küçük-şeyler)
- [15. Kendin Dene: Küçük Alıştırmalar](#15-kendin-dene-küçük-alıştırmalar)

---

## 0. Başlamadan Önce: Temel Kavramlar

Kodu Okurken Sürekli Karşına Çıkacak Kelimeler Bunlar. İlk Okumada Hepsini Ezberlemen Gerekmiyor; Takıldığında Buraya Dönebilirsin.

### Dart ve Flutter

- **Dart:** Google'ın Geliştirdiği Programlama Dili. Bu Projedeki Tüm `.dart` Dosyaları Dart ile Yazılmış.
- **Flutter:** Dart ile Mobil (Android, iOS), Web ve Masaüstü Uygulamaları Yapmayı Sağlayan Araç Takımı. Tek Bir Kodla Birden Fazla Platformda Çalışan Uygulama Yazılabiliyor.

### Widget

Flutter'da **Ekranda Görünen Her Şey Bir Widget'tır**: Bir Yazı (`Text`), Bir Buton (`IconButton`), Bir Kutu (`Container`), Bir Liste (`ListView`), Hatta Sayfanın Kendisi (`Scaffold`) ve Uygulamanın Kendisi (`MaterialApp`).

Widget'lar Birbirinin İçine Konarak Bir **Ağaç** Oluşturur:

```
MaterialApp
 └─ Scaffold
     ├─ AppBar
     │   └─ Text("Mini Mağaza")
     └─ Column
         ├─ TextField   (Arama Kutusu)
         ├─ Row         (Kategori Çipleri)
         └─ ListView    (Ürün Listesi)
             └─ UrunKarti × N
```

Bir Widget'ın İçine Tek Bir Widget Konuyorsa Bu Genelde `child:` ile, Birden Fazla Konuyorsa `children: [ ... ]` ile Yapılır.

### StatelessWidget ve StatefulWidget

| | StatelessWidget | StatefulWidget |
|---|---|---|
| Ne Demek? | Durumu (Değişen Bilgisi) **Olmayan** Widget | Durumu **Olan** Widget |
| Ne Zaman Kullanılır? | Sadece Kendisine Verileni Gösterecekse | Zamanla Değişen Bir Bilgi Tutacaksa |
| Bu Projedeki Örnekler | `UrunKarti`, `StokRozeti`, `MiniMagazaUygulamasi` | `UrunListesiEkrani` |

**State (Durum):** Bir Ekranın "Hafızası". Örneğin Ürün Listesi, Hangi Kategorinin Seçili Olduğu, Yükleniyor Mu Bilgisi.

**setState:** State'i Değiştirip Flutter'a "Ekranı Yeniden Çiz" Demenin Yolu. Bir Değişkeni `setState` Dışında Değiştirirsen Değişken Değişir Ama **Ekran Güncellenmez**.

### Sınıf, Nesne, Alan, Metot

- **Sınıf (`class`):** Bir Kalıp. Örneğin `Urun` Sınıfı, "Bir Ürünün Adı, Fiyatı, Resmi Olur" Der.
- **Nesne:** Kalıptan Üretilmiş Somut Bir Örnek. "MacBook, 3999.99 $" Bir `Urun` Nesnesidir.
- **Alan (Field):** Sınıfın Taşıdığı Bilgi. `baslik`, `fiyat` Gibi.
- **Metot:** Sınıfın Yapabildiği İş (Fonksiyon). `copyWith`, `build` Gibi.
- **Kurucu (Constructor):** Sınıftan Nesne Üretirken Çalışan Özel Metot. `Urun(id: 1, baslik: "...")` Gibi.

### Sık Kullanılan Dart Kelimeleri

| Kelime | Anlamı | Örnek |
|---|---|---|
| `final` | Bir Kez Değer Verilir, Sonra Değiştirilemez | `final int id;` |
| `const` | Derleme Anında Belli Olan, Hiç Değişmeyen Sabit | `const SizedBox(width: 8)` |
| `required` | Bu Parametre Verilmek Zorunda | `required this.id` |
| `?` (Tipten Sonra) | Bu Değer `null` (Boş) Olabilir | `int? id` |
| `??` | Soldaki `null` İse Sağdakini Kullan | `id ?? this.id` |
| `?.` | Değer `null` Değilse Devam Et, `null` İse Dur | `deger?.toDouble()` |
| `koşul ? A : B` | Koşul Doğruysa A, Yanlışsa B (Ternary) | `favoriMi ? Colors.red : Colors.grey` |
| `!` | `bool` Değeri Tersine Çevirir | `!true` → `false` |
| `&&` / `\|\|` | "ve" / "veya" | `a && b`, `a \|\| b` |
| `=>` | Tek Satırlık Fonksiyon Kısa Yazımı | `() => _favoriyiDegistir(urun)` |
| `_isim` | Alt Çizgiyle Başlayan İsim Sadece O Dosyada Kullanılabilir (Private) | `_favoriIdleri` |
| `@override` | Üst Sınıftaki Aynı İsimli Metodu Kendi Versiyonumla Değiştiriyorum | `@override Widget build(...)` |

### Future, async, await

İnternetten Veri Çekmek Zaman Alır. Uygulama Bu Sırada **Donmasın** Diye Dart, Sonucu Bir "Söz" Olarak Verir: **`Future`**.

```dart
Future<List<Urun>> tumUrunleriGetir() async {   // async: İçinde await Kullanabilirim
  final cevap = await http.get(...);            // await: Cevap Gelene Kadar Bu Satırda Bekle
  ...
}
```

Bir Restoranda Sipariş Vermek Gibi Düşün: Sipariş Verirsin (İstek), Sana Bir Sıra Numarası Verilir (`Future`), Yemek Hazır Olunca Çağrılırsın (`await` Biter). Beklerken Başka İşler Yapabilirsin (Ekran Donmaz).

### JSON ve API

- **API:** Bir Sunucunun Dışarıya Veri Verdiği Kapı. Bir Adrese İstek Atarsın, Sunucu Veri Döndürür.
- **JSON:** Bu Verinin Formatı. İnsan da Okuyabilir:

```json
{ "id": 1, "title": "Backpack", "price": 109.95 }
```

Dart'ta JSON Okununca Bir **`Map`** (Sözlük) Olur ve Değerlere Anahtarla Ulaşılır: `json['title']` → `"Backpack"`.

---

## 1. Büyük Resim: Bu Proje Ne Yapıyor?

Bu, **Flutter** ile Yazılmış Küçük Bir **Mağaza Uygulaması**. Açıldığında:

1. Ürünler Çekilirken Ekranın Ortasında Dönen Bir **Yükleniyor** Çemberi Görünüyor.
2. **28 Ürünlük** Bir Liste Geliyor:
   - 8 Tanesi Uygulamanın Kendi (Mock) Ürünleri,
   - 20 Tanesi İnternetten, [Fake Store API](https://fakestoreapi.com/products)'den.
   - Bütün Fiyatlar Dolar (`$`) Cinsinden.
3. Üstteki **Arama Kutusuna** Yazdıkça Liste Anında Filtreleniyor.
4. **Kategori Çiplerine** (Tümü / Elektronik / Giyim / Ayakkabı / Aksesuar) Dokunarak Kategoriye Göre Filtre Yapılabiliyor.
5. Her Ürünün Yanındaki ❤️ ile Ürün **Favorilere** Eklenip Çıkarılabiliyor. Sağ Üstteki **Sayaç** da Buna Göre Güncelleniyor.
6. Bir Ürün Kartına Dokunulunca Altta Kısa Bir Mesaj (**SnackBar**) Çıkıyor.
7. İnternet Yoksa Altta Bir Uyarı Çıkıyor, Ama Mock Ürünler Yine de Görünüyor.

### Projenin Hikayesi

Proje İlk Başta Sadece Kodun İçine Gömülü Sahte (Mock) Verilerle Çalışıyordu. Sonra:

- Ürünler için Bir **Değerlendirme (Puan)** Modeli Eklendi.
- Modellere JSON'dan Nesne Üreten **`fromJson`** Metotları Eklendi.
- **`http`** Paketi ve Android **İnternet İzni** Eklendi.
- Gerçek Servis **`api_urun_servisi.dart`** Yazıldı.
- Ekran Artık **Mock ve API Servislerinden** Gelen Ürünleri Tek Listede Gösteriyor.

### Uygulamayı Çalıştırmak

Terminalde Proje Klasöründe:

```bash
flutter pub get    # pubspec.yaml'daki Paketleri (http Gibi) İndirir
flutter run        # Uygulamayı Bağlı Cihazda / Emülatörde Başlatır
```

Uygulama Çalışırken Kodda Değişiklik Yapıp Terminalde **`r`** Tuşuna Basarsan (**Hot Reload**) Değişiklik Saniyeler İçinde Ekrana Yansır. Uygulamayı Baştan Başlatmak için **`R`** (Hot Restart).

### Klasör Yapısı ve Katmanlar

```
lib/
├── main.dart                     → Uygulamanın Giriş Kapısı
├── models/                       → "Veri Neye Benziyor?" (Saf Veri Sınıfları)
│   ├── kategori.dart
│   ├── degerlendirme.dart
│   └── urun.dart
├── services/                     → "Veri Nereden Geliyor?"
│   ├── i_urun_servisi.dart       → Sözleşme (Interface)
│   ├── mock_urun_servisi.dart    → Uygulamanın Kendi (Sahte) Ürünleri
│   └── api_urun_servisi.dart     → İnternetten Ürün Çeken Servis
├── screens/                      → Tam Sayfa Ekranlar
│   └── urun_listesi_ekrani.dart
└── widgets/                      → Tekrar Kullanılabilir Küçük Ekran Parçaları
    ├── urun_karti.dart
    └── stok_rozeti.dart
```

Bu Ayrım, Derste Anlatılan **Katmanlı Mimarinin** Basit Bir Örneği. Bir Restoran Gibi Düşün:

| Katman | Restorandaki Karşılığı | Görevi | Neyi Bilmez? |
|---|---|---|---|
| **Model** | Menüdeki Yemek Tarifi | Verinin Şeklini Tanımlar | Ekranı, İnterneti |
| **Service** | Mutfak | Veriyi Hazırlar / Getirir | Ekranın Nasıl Göründüğünü |
| **Screen** | Garson | Durumu Yönetir, Parçaları Birleştirir | Verinin Nereden Geldiğini (Sadece Sözleşmeyi Tanır) |
| **Widget** | Tabak | Kendisine Verileni Gösterir | Verinin Nereden Geldiğini, Tıklanınca Ne Olacağını |

Her Katmanın **Tek Bir Sorumluluğu** Olunca Kod Daha Kolay Okunur, Değiştirilir ve Test Edilir. Örneğin Mock Servisten API'ye Geçerken Kartlara Hiç Dokunmak Gerekmedi.

Okuma Sırası Olarak **Model → Service → Widget → Screen → Main** Öneririm, Çünkü En Bağımsız Parçadan En Bağımlı Parçaya Doğru Gidiyor. Aşağıda Bu Sırayla Anlatıyorum.

---

## 2. `models/kategori.dart`: Kategori Listesi

```dart
enum Kategori {                         // enum = Sınırlı Sayıda, Önceden Belli Seçenek
  hepsi('Tümü', 'H'),                   // Her Seçenek Parantez İçinde 2 Bilgi Taşıyor:
  elektronik('Elektronik', 'E'),        //   1) Ekranda Görünecek Başlık
  giyim('Giyim', 'G'),                  //   2) Çipin Solunda Görünecek Kısa "İkon" Metni
  ayakkabi('Ayakkabı', 'A'),
  aksesuar('Aksesuar', 'AK');           // Son Değerden Sonra ";" Gelir, Çünkü Aşağıda Alanlar Var

  final String baslik;                  // Her Değerin Başlığı
  final String ikon;                    // Her Değerin Kısa İkon Metni

  const Kategori(this.baslik, this.ikon); // Parantezdeki Değerleri Alanlara Yerleştiren Kurucu
}
```

### Enum Nedir?

**Enum**, Seçenekleri Önceden Belli Olan Bir Tiptir. Haftanın Günleri, Trafik Lambasının Renkleri Gibi: Liste Bellidir, Dışında Bir Değer Olamaz.

### Neden String Yerine Enum?

Kategoriyi `"elektronik"` Gibi Bir Metin (String) Olarak Tutsaydık:

- `"elektronık"` Diye Yazım Hatası Yapabilirdik ve **Program Bunu Fark Etmezdi**. Ürün Hiçbir Filtrede Görünmezdi ve Hatayı Bulmak Saatler Sürebilirdi.

Enum Kullanınca:

- Sadece Tanımlı Değerler Yazılabilir. `Kategori.elektronık` Yazarsan Kod **Çalışmadan Önce** Hata Verir.
- Editörde `Kategori.` Yazınca Tüm Seçenekler Listelenir.

### Enhanced Enum

Bu Enum'un Her Değeri Kendi Bilgilerini (Başlık ve İkon) Taşıyor. Buna **"Enhanced Enum"** (Geliştirilmiş Enum) Deniyor; Dart 2.17'den Beri Var.

```dart
Kategori.giyim.baslik   // → "Giyim"
Kategori.giyim.ikon     // → "G"
Kategori.values         // → [hepsi, elektronik, giyim, ayakkabi, aksesuar]
```

`Kategori.values` Tüm Değerlerin Listesini Verir. Ana Ekran Çipleri Bununla Üretiyor; Bu Yüzden Enum'a Yeni Bir Kategori Eklenince Çipi **Otomatik Olarak** Ekrana Gelir.

`hepsi` Gerçek Bir Ürün Kategorisi Değil. Filtrede **"Hiçbir Kategori Ayrımı Yapma, Hepsini Göster"** Anlamında Kullanılıyor.

---

## 3. `models/degerlendirme.dart`: Puan Modeli

```dart
class Degerlendirme {
  final double puan;                    // Ortalama Puan (Örn: 4.5). double = Ondalıklı Sayı
  final int oySayisi;                   // Kaç Kişinin Oy Verdiği. int = Tam Sayı

  const Degerlendirme({required this.puan, required this.oySayisi}); // İki Alan da Zorunlu

  factory Degerlendirme.fromJson(Map<String, dynamic> json) { // JSON'dan Nesne Üreten Kurucu
    return Degerlendirme(
      puan: (json['rate'] as num?)?.toDouble() ?? 0.0,  // API'deki "rate" → puan
      oySayisi: (json['count'] as num?)?.toInt() ?? 0,  // API'deki "count" → oySayisi
    );
  }
}
```

### Model Nedir?

**Model**, Bir Verinin Hangi Parçalardan Oluştuğunu Tarif Eden Sınıftır. Bu Model "Bir Puan Bilgisi; Ortalama Puan ve Oy Sayısından Oluşur" Diyor.

### İç İçe Model

Bu Model Tek Başına Kullanılmıyor; `Urun` Modelinin **İçinde Bir Alan** Olarak Duruyor. Buna **İç İçe Model** Deniyor. API'den Gelen JSON da Aynı Şekilde İç İçe:

```json
{
  "id": 1,
  "title": "...",
  "rating": { "rate": 4.5, "count": 120 }
}
```

`rating` Kısmı Kendi Başına Küçük Bir JSON Nesnesi. `Degerlendirme.fromJson` Tam Olarak Bu Küçük Kısmı Okuyor.

### Yeni Kavramlar

- **İsimli Parametreler `{ }`:** Kurucudaki Süslü Parantez, Değer Verirken Parametre Adının Yazılmasını Sağlar: `Degerlendirme(puan: 4.5, oySayisi: 120)`. Sıra Karışsa Bile Hangi Değerin Neye Ait Olduğu Bellidir.
- **`factory` Kurucu:** Normal Kurucudan Farklı Olarak İçinde Önce Bazı İşlemler Yapıp (Burada: Veriyi Okuyup Dönüştürmek) Sonra Nesne Döndürebilir. JSON Okumak için Standart Kalıp Bu.
- **`Map<String, dynamic>`:** Anahtarları Metin (`String`), Değerleri Herhangi Bir Tipte (`dynamic`) Olabilen Sözlük. JSON'daki Değerlerin Tipi Önceden Bilinmediği için `dynamic` Kullanılır.

### Bir Satırı Parça Parça Okuyalım

```dart
(json['rate'] as num?)?.toDouble() ?? 0.0
```

| Parça | Ne Yapıyor? |
|---|---|
| `json['rate']` | Sözlükten `"rate"` Anahtarının Değerini Al |
| `as num?` | Bu Değer Bir Sayıdır. `num` Hem `int` Hem `double`'ı Kapsar. `?`: Hiç Gelmemiş (`null`) Olabilir |
| `?.toDouble()` | Değer Varsa Ondalıklı Sayıya Çevir. `null` İse Hiçbir Şey Yapma, Sonuç `null` Kalsın (Program Çökmesin) |
| `?? 0.0` | Sonuç `null` İse Yerine `0.0` Kullan |

Yani Bu Satır **"Puan Geldiyse Onu Al, Gelmediyse Ya da Bozuk Geldiyse 0 Kabul Et"** Diyor.

---

## 4. `models/urun.dart`: Ürün Modeli

Projenin En Önemli Modeli. Bir Ürünün Taşıdığı Tüm Bilgileri Tanımlıyor. Modeller Sadece Veri Tutar; Ekrana Bir Şey Çizmez, İnternete Bağlanmaz. Bu Yüzden Bu Dosyada Flutter Kütüphanesi Bile Import Edilmiyor.

### Alanlar ve Kurucu

```dart
import 'kategori.dart';                 // Ürünün Kategorisi Kategori Tipinde Olacağı için
import 'degerlendirme.dart';            // Ürünün Puan Bilgisi Degerlendirme Tipinde Olacağı için

class Urun {
  final int id;                         // Benzersiz Kimlik (Favori Güncellemede Ürünü Bulmak için)
  final String baslik;                  // Ürün Adı
  final String aciklama;                // Uzun Açıklama
  final double fiyat;                   // Ondalıklı Fiyat
  final String resimUrl;                // İnternetten Yüklenecek Resmin Adresi
  final Kategori kategori;              // Enum'dan Bir Değer
  final int stokAdedi;                  // Stokta Kaç Adet Var (-1 = Bilinmiyor)
  final bool favoriMi;                  // Kullanıcı Favoriledi Mi? bool = true / false
  final Degerlendirme degerlendirme;    // Puan ve Oy Sayısı (İç İçe Model)

  const Urun({                          // Süslü Parantez = İsimli Parametreler
    required this.id,                   // required = Verilmesi Zorunlu
    required this.baslik,               // this.baslik = Gelen Değeri Doğrudan baslik Alanına Koy
    required this.aciklama,
    required this.fiyat,
    required this.resimUrl,
    required this.kategori,
    required this.stokAdedi,
    this.favoriMi = false,              // Zorunlu Değil; Verilmezse false
    this.degerlendirme = const Degerlendirme(puan: 0.0, oySayisi: 0), // Verilmezse 0 Puan, 0 Oy
  });
```

#### Neden Tüm Alanlar `final`?

`final` Alanlara Bir Kez Değer Verilir, Sonra Değiştirilemez. Değiştirilemeyen Nesnelere **Immutable** Denir.

Neden Böyle Yapılıyor? Bir Ürünün Bilgisi Kodun Herhangi Bir Yerinde Habersizce Değişebilseydi, "Bu Fiyat Neden Değişti?" Sorusunun Cevabını Bulmak Çok Zorlaşırdı. Immutable Nesnelerde Değişiklik Her Zaman **Yeni Bir Nesne** Üretilerek Yapılır (Aşağıdaki `copyWith`), Bu da Kodun Takibini Kolaylaştırır.

#### Varsayılan Değerler

`favoriMi` ve `degerlendirme` Zorunlu Değil. Verilmezlerse `=` İşaretinden Sonraki Değeri Alırlar. Dart'ta Varsayılan Değerler **Sabit (`const`)** Olmak Zorunda; Bu Yüzden `Degerlendirme` Sınıfının Kurucusu da `const` Tanımlanmış. Mock Servisteki Ürünlere Puan Verilmediği için Hepsi Bu Varsayılan Değeri Alıyor.

### JSON'dan Ürün Üretmek: `fromJson`

API'den Gelen Her Ürün Şöyle Görünüyor:

```json
{
  "id": 1,
  "title": "Fjallraven - Foldsack No. 1 Backpack, Fits 15 Laptops",
  "price": 109.95,
  "description": "Your perfect pack for everyday use...",
  "category": "men's clothing",
  "image": "https://fakestoreapi.com/img/81fPKd-2AYL._AC_SL1500_t.png",
  "rating": { "rate": 3.9, "count": 120 }
}
```

`fromJson` Bu Veriyi `Urun` Nesnesine Çeviriyor:

```dart
  factory Urun.fromJson(Map<String, dynamic> json) {
    return Urun(
      id: json['id'] as int,                          // "as int": "Bu Bir Tam Sayı" Diyoruz; Değilse Hata
      baslik: json['title'] as String,                // API İngilizce (title), Model Türkçe (baslik)
      fiyat: (json['price'] as num).toDouble(),       // 10 Ya da 10.5 Gelebilir → Her Zaman double Yap
      aciklama: json['description'] as String,
      kategori: switch (json['category']) {           // API Kategorisi (İngilizce) → Bizim Enum
        'electronics' => Kategori.elektronik,
        "men's clothing" || "women's clothing" => Kategori.giyim, // "||": İkisinden Biri Gelirse
        'jewelery' => Kategori.aksesuar,
        _ => Kategori.hepsi,                          // "_": Hiçbiri Tutmazsa (Bilinmeyen Kategori)
      },
      resimUrl: json['image'] as String,
      degerlendirme: json['rating'] != null           // "rating" Alanı Varsa...
          ? Degerlendirme.fromJson(json['rating'] as Map<String, dynamic>) // ...İç İçe JSON'u Çevir
          : const Degerlendirme(puan: 0.0, oySayisi: 0), // ...Yoksa 0 Puan, 0 Oy
      favoriMi: false,                                // Favori Bilgisi API'den Gelmez, Uygulamada Tutulur
      stokAdedi: (json['stock'] as num?)?.toInt() ?? -1, // "stock" Yoksa -1 = "Stok Bilgisi Yok"
    );
  }
```

#### Neden Böyle Bir "Çevirmen" Var?

API'nin Alan Adları (`title`, `price`, `image`) ile Bizim Modelin Alan Adları (`baslik`, `fiyat`, `resimUrl`) Farklı. Eşleştirme **Tek Bir Yerde** Yapılıyor. Böylece:

- Uygulamanın Geri Kalanı API'nin Yapısını Hiç Bilmek Zorunda Kalmıyor.
- API Bir Gün `title` Yerine `name` Gönderirse Sadece Bu Satırı Değiştirmek Yetiyor.

#### Kategori Eşleştirme: `switch` İfadesi

`switch` Bir Değeri Sırayla Seçeneklerle Karşılaştırır ve Eşleşen İlk Seçeneğin Sonucunu Döndürür. `=>` İşareti "Sonuç Şu Olsun" Demek.

API Kategorileri İngilizce, Bizim Enum İsimleri Türkçe. Bu Yüzden İsimleri Doğrudan Eşlemek (`Kategori.values.byName(...)`) Çalışmaz ve Hata Fırlatır. `switch` Her API Metnini Karşılığına Çeviriyor:

| API'den Gelen | Bizim Enum Değeri |
|---|---|
| `electronics` | `Kategori.elektronik` |
| `men's clothing`, `women's clothing` | `Kategori.giyim` |
| `jewelery` | `Kategori.aksesuar` (Takı için Ayrı Kategorimiz Yok) |
| Bilinmeyen Herhangi Bir Değer (`_`) | `Kategori.hepsi` |

Son Satırdaki `_` Bir **Güvenlik Ağı**: API Yarın Yeni Bir Kategori Eklese Bile Uygulama Çökmez; O Ürün Sadece "Tümü" Filtresinde Görünür.

#### Stok Bilgisi Neden `-1`?

Fake Store API Stok Bilgisi **Göndermiyor**. Eksik Stok için:

- `0` Kullansaydık Bütün API Ürünleri Yanlışlıkla Kırmızı **"Tükendi"** Etiketiyle Görünürdü.
- Bu Yüzden `-1` Kullanılıyor ve "Stok Bilgisi Yok" Anlamına Geliyor. `StokRozeti` Bu Durumda Hiç Çizilmiyor.

### Değiştirmeden Değiştirmek: `copyWith`

Alanlar `final` Olduğu için `urun.favoriMi = true` Yazamayız; Kod Hata Verir. Peki Favori Durumu Nasıl Değişecek? Cevabı `copyWith`:

```dart
  Urun copyWith({                       // "Kopyala Ama Şu Alanları Değiştir"
    int? id,                            // "?" = Nullable; Verilmezse null Kalır = "Bu Alanı Değiştirme"
    String? baslik,
    ...
    bool? favoriMi,
    Degerlendirme? degerlendirme,       // Yeni Alan copyWith'e de Eklenmeli, Yoksa Kopyalarken Kaybolur
  }) {
    return Urun(                        // Yepyeni Bir Urun Nesnesi Döndürür
      id: id ?? this.id,                // "??": Yeni Değer Verildiyse Onu, Verilmediyse Eskisini Al
      baslik: baslik ?? this.baslik,
      ...
      favoriMi: favoriMi ?? this.favoriMi,
      degerlendirme: degerlendirme ?? this.degerlendirme,
    );
  }
```

Örnek:

```dart
final eski = Urun(id: 1, baslik: "Saat", ..., favoriMi: false);
final yeni = eski.copyWith(favoriMi: true);
// yeni → Her Şeyi eski ile Aynı, Sadece favoriMi: true
// eski → Hâlâ favoriMi: false (Hiç Dokunulmadı)
```

`this.id` Bu Nesnenin Kendi `id`'si; Sadece `id` İse Parametre Olarak Gelen Değer. Flutter'da State Yönetiminin Temel Kalıplarından Biri Bu.

### `toString`: Nesnenin Metin Hali

```dart
  @override                             // Object Sınıfındaki toString'i Eziyoruz
  String toString() {                   // print(urun) Yapınca Okunaklı Çıktı Versin Diye
    return 'Urun(id: $id, baslik: $baslik, fiyat: $fiyat \$, favoriMi: $favoriMi)';
  }                                     // "$degisken" = Metnin İçine Değer Yerleştirme (Interpolation)
}
```

Dart'ta Her Sınıfın Gizli Bir `toString` Metodu Vardır. Varsayılan Hali `print(urun)` Yazınca Sadece `Instance of 'Urun'` Yazar; Pek İşe Yaramaz. Bu Metot Değiştirilince Çıktı Şöyle Olur:

```
Urun(id: 101, baslik: Macbook M5 Pro Laptop, fiyat: 3999.99 $, favoriMi: false)
```

`\$` Düz Bir Dolar İşareti Yazar. Başına `\` Konmasa Dart Onu Bir Değişkenin Başlangıcı Sanardı.

---

## 5. `services/i_urun_servisi.dart`: Sözleşme (Interface)

```dart
import '../models/kategori.dart';
import '../models/urun.dart';

abstract class IUrunServisi {           // abstract = Doğrudan Nesnesi Oluşturulamaz, Sadece Şablon
  Future<List<Urun>> tumUrunleriGetir();                    // Tüm Ürünleri Getir
  Future<List<Urun>> kategoriyeGoreGetir(Kategori kategori); // Kategoriye Göre Getir
  Future<List<Urun>> adaGoreAra(String aramaMetni);          // Başlıkta Ya da Açıklamada Ara
}
```

### Servis Nedir?

**Servis**, Veriyi Bir Yerden Getiren Sınıftır: İnternet, Veritabanı, Dosya... Bu Dosya İse Bir Servisin Kendisi Değil, Bir **Sözleşme**.

### Priz Benzetmesi

Duvardaki Prize Hangi Cihazı Takarsan Tak Çalışır, Çünkü Hepsi Aynı **Fiş Standardına** Uyar. Bu Sözleşme de O Standart:

> "Bir Ürün Servisi Olmak İstiyorsan Şu 3 İşi Yapabilmelisin."

Bu Projede Sözleşmeye Uyan İki Servis Var:

```
              IUrunServisi (Sözleşme)
               ▲                  ▲
               │ implements       │ implements
     MockUrunServisi        ApiUrunServisi
     (Koddaki Ürünler)      (İnternetteki Ürünler)
```

Ekran Bunların **Hangisi Olduğunu Umursamaz**; Sadece Sözleşmeyi Tanır. Buna **Dependency Inversion** (Bağımlılığı Somut Sınıfa Değil, Soyutlamaya Yapmak) Deniyor.

### Ayrıntılar

- **`abstract class`:** Soyut Sınıf. `IUrunServisi()` Diye Nesne Oluşturulamaz. Metotların Gövdesi (`{ ... }` Kısmı) Yok; Sadece İsimleri ve Tipleri Var. Gövdeyi Sözleşmeyi Uygulayan Sınıflar Yazmak Zorunda.
- **İsmin Başındaki `I`:** "Interface" Kelimesinden Gelir; Yaygın Bir Alışkanlık.
- **`Future<List<Urun>>`:** "İleride Bir Ürün Listesi Gelecek" Demek. (Bkz. [Temel Kavramlar](#future-async-await))

---

## 6. `services/mock_urun_servisi.dart`: Sahte Ürünler

"Mock" İngilizcede **Taklit** Demek. Bu Servis Ürünleri İnternetten Çekmez; Ürünler Doğrudan Kodun İçine Yazılmıştır.

**Neden Böyle Bir Servis Var?**

- Proje Başlarken Henüz Bir Sunucu (Backend) Yoktu. Ekranı Geliştirip Denemek için Sahte Verilere İhtiyaç Vardı.
- İnternet Olmadan da Uygulamanın Çalıştığını Görmeyi Sağlıyor.
- Şu An Ekranda API Ürünleriyle Birlikte Gösteriliyor.

### Ürün Deposu

```dart
class MockUrunServisi implements IUrunServisi {   // implements = Sözleşmedeki TÜM Metotları Yazmak Zorundayım
  final List<Urun> _urunDeposu = const [          // "_" = Sadece Bu Dosyadan Erişilebilir (Private)
    Urun(                                         // const Liste Olduğu için İçindeki Urun'lar da const
      id: 101,                                    // 101'den Başlar → API id'leriyle (1-20) Çakışmaz
      baslik: "Macbook M5 Pro Laptop",
      aciklama: "Apple'ın en güçlü işlemcisine sahip yeni nesil Macbook Pro",
      fiyat: 3999.99,                             // Dolar Cinsinden
      resimUrl: "https://picsum.photos/400/400?1", // picsum: Rastgele Test Resmi Veren Site
      kategori: Kategori.elektronik,
      stokAdedi: 5,
    ),                                            // favoriMi, degerlendirme Verilmedi → Varsayılanlar
    ... // Toplam 8 Ürün, Her Kategoriden 2 Tane
  ];
```

- **`const [ ... ]`:** Sabit Liste. Eleman Eklenemez, Silinemez, Değiştirilemez.
- **`picsum.photos/400/400?1`:** 400x400 Piksellik Rastgele Bir Test Resmi. Sondaki `?1`, `?2`... Her Ürüne Farklı Resim Gelmesini Sağlıyor.
- **id'ler Neden 101'den Başlıyor?** API Ürünlerinin id'leri 1-20 Arası. Favori İşlemi Ürünü `id` ile Bulduğu için Aynı `id` İki Ürüne Verilseydi, Birini Favorilemek Diğerini Değiştirirdi.

### Tüm Ürünleri Getirmek

```dart
  @override                                       // Sözleşmedeki Metodu Yazıyoruz
  Future<List<Urun>> tumUrunleriGetir() async {   // async = İçinde await Kullanabilirim
    await Future.delayed(const Duration(milliseconds: 1500)); // 1,5 Sn Bekle → Ağ Gecikmesini Taklit Et
    return List.from(_urunDeposu);                // Listenin KOPYASINI Döndür
  }
```

**Neden Bekliyor?** Gerçek Bir Sunucu Gibi Davranması için. Bekleme Olmasaydı Ekrandaki "Yükleniyor" Animasyonunu Hiç Göremezdik.

**Neden `List.from` ile Kopya Döndürülüyor?** `_urunDeposu` Sabit (`const`) Bir Liste ve Değiştirilemez. Ekran İse Favori Güncellerken Listedeki Bir Ürünü Yenisiyle Değiştiriyor (`_filtrelenmisUrunler[index] = yeniUrun`). Orijinal Liste Verilseydi Bu Satır **Hata Fırlatırdı**. `List.from` Değiştirilebilir Bir Kopya Üretiyor.

### Diğer İki Metot

```dart
  @override
  Future<List<Urun>> kategoriyeGoreGetir(Kategori kategori) async {
    await Future.delayed(const Duration(milliseconds: 400));
    if (kategori == Kategori.hepsi) {             // "Tümü" Seçildiyse Süzmeden Hepsini Döndür
      return List.from(_urunDeposu);
    }
    return _urunDeposu.where((urun) => urun.kategori == kategori).toList();
  }

  @override
  Future<List<Urun>> adaGoreAra(String aramaMetni) async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (aramaMetni.trim().isEmpty) {              // trim: Baştaki/Sondaki Boşlukları Sil
      return List.from(_urunDeposu);              // Boş Arama → Hepsini Döndür
    }
    return _urunDeposu.where((urun) {
      final baslikKucuk = urun.baslik.toLowerCase();     // Büyük/Küçük Harf Duyarsız
      final aciklamaKucuk = urun.aciklama.toLowerCase(); //   Karşılaştırma için Hepsini Küçült
      final arananKucuk = aramaMetni.trim().toLowerCase();
      return baslikKucuk.contains(arananKucuk) ||        // Başlıkta Ya da
          aciklamaKucuk.contains(arananKucuk);           // Açıklamada Geçiyor Mu?
    }).toList();
  }
}
```

Burada Liste İşlemlerinin En Çok Kullanılanları Var:

| Metot | Ne Yapar? | Örnek |
|---|---|---|
| `where(...)` | Koşulu Sağlayan Elemanları Seçer | `[1,2,3,4].where((s) => s > 2)` → `3, 4` |
| `toList()` | Sonucu Gerçek Bir Listeye Çevirir | `where` ve `map`'ten Sonra Gerekir |
| `trim()` | Metnin Başındaki/Sonundaki Boşlukları Siler | `"  saat ".trim()` → `"saat"` |
| `toLowerCase()` | Tüm Harfleri Küçültür | `"Saat"` → `"saat"` |
| `contains(...)` | Metnin İçinde Aranan Parça Geçiyor Mu? | `"kol saati".contains("saat")` → `true` |

`(urun) => urun.kategori == kategori` Kısa Bir Fonksiyon: "Bir Ürün Al, Kategorisi Aranan Kategoriye Eşit Mi Söyle."

> 📝 **Not:** Ana Ekran Ürünleri **`kategoriyeGoreGetir`** ile Çekiyor: Açılışta "Tümü" ile, Sonra Her Çip Seçiminde O Kategoriyle (Bkz. [10.4 Veri Yükleme](#104-veri-yükleme)). Bu Yüzden Ekranda Görülen Bekleme Süresi 1,5 Saniye Değil, 0,4 Saniye. Arama Kutusuna Yazı Yazılınca İse **`adaGoreAra`** Çağrılıyor (Bkz. [10.5 Arama](#105-arama)). `tumUrunleriGetir` Ekran Tarafından Kullanılmıyor.

---

## 7. `services/api_urun_servisi.dart`: Gerçek API Servisi

Ürünleri [Fake Store API](https://fakestoreapi.com/products)'den Çeken Servis. Bu Adres, Eğitim Amaçlı Hazırlanmış Ücretsiz Bir Sahte Mağaza API'si; 20 Ürünü JSON Olarak Döndürüyor. Linke Tarayıcıda Tıklayıp Ham Veriyi Kendin de Görebilirsin.

### Akış

```
1) http.get ile Adrese İstek At
          │
2) Sunucu JSON Metni Döndürür  →  "[{"id":1,"title":"..."}, {...}, ...]"
          │
3) jsonDecode ile Metni Dart Listesine Çevir
          │
4) Her Elemanı Urun.fromJson ile Urun Nesnesine Dönüştür
          │
5) List<Urun> Olarak Döndür
```

### Kod

```dart
import 'dart:convert';                            // jsonDecode için (Dart'ın Kendi Kütüphanesi)
import 'package:http/http.dart' as http;          // "as http": Fonksiyonlara http.get(...) Diye Ulaş

class ApiUrunServisi implements IUrunServisi {    // Mock ile Aynı Sözleşme → Ekran Farkı Anlamaz
  static const _url = 'https://fakestoreapi.com/products';

  @override
  Future<List<Urun>> tumUrunleriGetir() async {
    final cevap = await http
        .get(Uri.parse(_url))                      // GET İsteği At, Cevabı Bekle
        .timeout(const Duration(seconds: 10));     // 10 Sn'de Cevap Gelmezse Vazgeç
    if (cevap.statusCode != 200) {                 // 200 = Başarılı
      throw Exception('Ürünler Alınamadı: ${cevap.statusCode}');
    }
    final liste = jsonDecode(cevap.body) as List;  // Metni JSON Listesine Çevir
    return liste
        .map((json) => Urun.fromJson(json as Map<String, dynamic>)) // Her Elemanı Modele Dönüştür
        .toList();
  }
```

Satır Satır:

- **`import 'dart:convert'`:** `dart:` ile Başlayan Kütüphaneler Dart'ın Kendisiyle Gelir; Ayrıca Yüklemek Gerekmez.
- **`import 'package:http/http.dart' as http`:** `http` Paketi `pubspec.yaml`'a Eklendiği için Kullanılabiliyor. `as http` Sayesinde Kodu Okuyan Kişi `get` Fonksiyonunun Nereden Geldiğini Hemen Anlıyor.
- **`static const _url`:**
  - `static`: Değer Nesneye Değil, Sınıfa Ait. Kaç Tane Servis Oluşturulursa Oluşturulsun Tek Kopya Var.
  - `const`: Hiç Değişmeyen Sabit.
  - `_`: Sadece Bu Dosyadan Erişilebilir.
- **`Uri.parse(_url)`:** Metin Halindeki Adresi `http` Paketinin Anladığı `Uri` Nesnesine Çevirir.
- **`http.get(...)`:** Adrese **GET** İsteği Atar ("Bana Veri Gönder").
- **`.timeout(...)`:** Zaman Aşımı. Sunucu 10 Saniye İçinde Cevap Vermezse Beklemeyi Bırakıp `TimeoutException` Fırlatır. Olmasaydı Sunucu Hiç Cevap Vermediğinde Kullanıcı Dönen Çemberi Çok Uzun Süre İzlerdi.
- **`statusCode`:** Sunucunun Cevap Kodu:

  | Kod | Anlamı |
  |---|---|
  | 200 | Başarılı |
  | 404 | Adres Bulunamadı |
  | 500 | Sunucu Hatası |

- **`throw Exception(...)`:** Hata Fırlatır. Bu Hatayı Ana Ekrandaki `try/catch` Yakalayıp Kullanıcıya Mesaj Gösteriyor.

#### Neden Servis Hatayı Kendisi Yakalamıyor?

Servis Hatayı **Yakalamıyor, Bilerek Fırlatıyor**. Dart'ta `try/catch` Olmayan Bir Yerde Fırlatılan Hata, Bir `try/catch` Bulana Kadar Kendisini Çağıran Yere Doğru Yukarı Çıkar:

```
tumUrunleriGetir()          → throw Exception('Ürünler Alınamadı: 500')
   ▲ (Yakalanmaz, Yukarı Çıkar)
kategoriyeGoreGetir()       → await tumUrunleriGetir()
   ▲ (Yakalanmaz, Yukarı Çıkar)
_urunleriYukle() (Ekran)    → try { ... } catch (e) { ... }   ← BURADA YAKALANIR
```

Aynı Yoldan Gelen Hatalar:

| Durum | Hatayı Kim Fırlatıyor? |
|---|---|
| Sunucu 404 / 500 Döndürdü | Bizim `throw Exception(...)` Satırımız |
| Sunucu 10 Sn'de Cevap Vermedi | `.timeout` (`TimeoutException`) |
| İnternet Yok | `http.get` Kendisi (`ClientException`) |
| Gelen Veri Bozuk JSON | `jsonDecode` (`FormatException`) |

Servis Hatayı Kendisi Yakalasaydı İki Seçeneği Olurdu, İkisi de Kötü:

1. **Boş Liste Döndürmek:** Ekran "Hiç Ürün Yok" ile "İnternet Koptu"yu Ayırt Edemezdi; Kullanıcı İnternet Yokken "Ürün Bulunamadı" Görürdü.
2. **Mesajı Kendisi Göstermek:** Servis Ekranla İlgili Hiçbir Şey Bilmemeli. Servis **Veriyi Getirir**, Kullanıcıya **Ne Gösterileceğine** Ekran Karar Verir. Başka Bir Ekran Aynı Hatada SnackBar Yerine "Tekrar Dene" Butonu Göstermek İsteyebilir.
- **`cevap.body`:** Sunucunun Gönderdiği Ham Metin.
- **`jsonDecode(...) as List`:** Metni Dart Nesnesine Çevirir. Gelen Veri Bir Liste Olduğu için Tipini Belirtiyoruz.
- **`map(...)`:** Listedeki **Her** Elemana Aynı İşlemi Uygulayıp Yeni Bir Liste Üretir. Burada Her JSON Elemanı `Urun`'a Dönüşüyor.

### Diğer İki Metot

```dart
  @override
  Future<List<Urun>> kategoriyeGoreGetir(Kategori kategori) async {
    final urunler = await tumUrunleriGetir();      // Tüm Listeyi Çekip...
    if (kategori == Kategori.hepsi) return urunler;
    return urunler.where((urun) => urun.kategori == kategori).toList(); // ...Uygulama Tarafında Süz
  }

  @override
  Future<List<Urun>> adaGoreAra(String aramaMetni) async {
    final aranan = aramaMetni.trim().toLowerCase();
    final urunler = await tumUrunleriGetir();      // API'de Arama Yok → Uygulama Tarafında Ara
    return urunler
        .where(
          (urun) =>
              urun.baslik.toLowerCase().contains(aranan) ||   // Başlıkta Ya da
              urun.aciklama.toLowerCase().contains(aranan),   // Açıklamada Geçiyor Mu?
        )
        .toList();
  }
}
```

Bu API'de Arama Özelliği Yok, Kategori Adresi de İngilizce İsim İstiyor. Basit Olsun Diye Her İkisi de Tüm Ürünleri Çekip Uygulama İçinde Süzüyor.

### İki Servisin Birleştirilmesi

Ana Ekranda Servis Tanımı Şöyle Değişti:

```dart
final IUrunServisi _servis = MockUrunServisi();                            // Önce: Tek Servis
final List<IUrunServisi> _servisler = [MockUrunServisi(), ApiUrunServisi()]; // Şimdi: İki Servis
```

Sözleşme (Interface) Kullanmanın Faydası Tam Olarak Burada Ortaya Çıkıyor: Liste Tipi `IUrunServisi` Olduğu için **İki Farklı Servis Aynı Listeye Konabiliyor**. Kartlar ve Filtreleme Kodu Hiç Değişmedi. Yeni Bir Veri Kaynağı Eklemek için Listeye Bir Eleman Eklemek Yeterli.

**Birleştirirken Dikkat Edilenler:**

- **id Çakışması:** Mock Ürünlerin `id`'leri 101-108 Yapıldı (Bkz. [6. Bölüm](#6-servicesmock_urun_servisidart-sahte-ürünler)).
- **Para Birimi:** API Fiyatları Dolar. Mock Fiyatları da Yaklaşık Dolar Karşılıklarına Çevrildi (Örn: MacBook 3999.99 $). Kart Her Yerde `$` Gösteriyor.

---

## 8. `widgets/stok_rozeti.dart`: Stok Etiketi

Ürün Kartının Sağ Üstündeki Küçük Etiket. Üç Farklı Şekilde Görünür:

| Durum | Görünüş |
|---|---|
| Stok Var (Örn: 5) | 🟩 Yeşil Kutu: **Stok: 5** |
| Stok Bitti (0) | 🟥 Kırmızı Kutu: **Tükendi** |
| Stok Bilinmiyor (-1, API Ürünleri) | Hiç Görünmez |

```dart
import 'package:flutter/material.dart';

class StokRozeti extends StatelessWidget {        // Kendi Değişen Durumu YOK
  final int stok;                                 // Dışarıdan Gelen Tek Bilgi

  const StokRozeti({super.key, required this.stok}); // Kullanımı: StokRozeti(stok: 5)

  @override
  Widget build(BuildContext context) {            // Ekrana Ne Çizileceğini Döndüren Metot
    if (stok < 0) return const SizedBox.shrink(); // Stok Bilgisi Yoksa (-1) Rozeti Hiç Gösterme
    final tukendiMi = stok == 0;                  // Stok 0 Mı? Renkler/Metin Buna Göre Seçilecek

    return Container(                             // Kutu: Dolgu + Arka Plan + Kenarlık için
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), // İç Boşluk
      decoration: BoxDecoration(
        color: tukendiMi ? Colors.red.shade100 : Colors.green.shade100,
        //     Koşul    ?  Doğruysa Bu         :  Yanlışsa Bu  (Ternary Operatör)
        borderRadius: BorderRadius.circular(6),   // Yuvarlak Köşeler
        border: Border.all(
          color: tukendiMi ? Colors.red.shade400 : Colors.green.shade400,
          width: 0.8,                             // İnce Kenarlık
        ),
      ),
      child: Text(
        tukendiMi ? "Tükendi" : 'Stok: $stok',    // Metin de Duruma Göre Değişiyor
        style: TextStyle(
          color: tukendiMi ? Colors.red.shade900 : Colors.green.shade900,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
```

### Yeni Kavramlar

- **`widgets` Klasörü:** Birden Fazla Yerde Kullanılabilecek Küçük Ekran Parçaları. Lego Parçası Gibi: Bir Kez Yapılır, İstenen Yere Takılır.
- **`SizedBox.shrink()`:** Boş, Hiç Yer Kaplamayan Bir Widget. `build` Metodu **Mutlaka** Bir Widget Döndürmek Zorunda; "Hiçbir Şey Gösterme" Demenin Yolu Bu.
- **`return` Erken Çıkış:** `if (stok < 0) return ...;` Satırı Metodu Orada Bitirir; Aşağıdaki Satırlar Çalışmaz.
- **`Container`:** Etrafına Boşluk, Arka Plan Rengi, Kenarlık Verilebilen Çok Amaçlı Kutu.
- **`padding` (İç Boşluk):** Kutunun Kenarı ile İçindeki Yazı Arasındaki Mesafe.
- **`EdgeInsets.symmetric(horizontal: 8, vertical: 4)`:** Sağ ve Sola 8, Üst ve Alta 4 Piksel.
- **Renk Tonları:** `Colors.green.shade100` Gibi Küçük Sayılar Rengin **Açık** Tonu, `shade900` Gibi Büyük Sayılar **Koyu** Tonudur. Açık Arka Plan + Koyu Yazı Okunaklı Bir Etiket Verir.

---

## 9. `widgets/urun_karti.dart`: Ürün Kartı

Listedeki Her Bir Ürün Bu Kartla Gösteriliyor:

```
┌──────────────────────────────────────────────────┐
│ ┌──────┐  E Elektronik            [Stok: 5]  ♡  │
│ │Resim │  Macbook M5 Pro Laptop                  │
│ │      │  Apple'ın en güçlü işlemcisine...       │
│ └──────┘  3999.99 $                              │
└──────────────────────────────────────────────────┘
   SOL           ORTA                          SAĞ
```

### Kartın Dışarıdan Aldığı Bilgiler

```dart
class UrunKarti extends StatelessWidget {
  final Urun urun;                                // Gösterilecek Ürün
  final VoidCallback onFavoriTiklandi;            // Kalbe Basılınca Çağrılacak FONKSİYON
  final VoidCallback onDetayTiklandi;             // Karta Basılınca Çağrılacak FONKSİYON
```

**`VoidCallback`:** "Parametre Almayan ve Bir Şey Döndürmeyen Fonksiyon" Tipi. Yani Bu Alanlar Bir Değer Değil, **Bir Fonksiyon** Tutar.

**Bu Kısım Önemli.** Kart, Favoriye Tıklandığında Ne Yapılacağını **Bilmez**. Ekran, Kartı Oluştururken "Kalbe Basılınca Şunu Yap" Diye Bir Fonksiyon Verir; Kart da Kalbe Basılınca O Fonksiyonu Çağırır:

```
Ekran:  UrunKarti(onFavoriTiklandi: () => _favoriyiDegistir(urun))
                         │
Kart:   Kalbe Basıldı → onFavoriTiklandi() Çağrıldı
                         │
Ekran:  _favoriyiDegistir(urun) Çalıştı → Favori Değişti → Ekran Yeniden Çizildi
```

Buna **"Lifting State Up" (Durumu Yukarı Taşıma)** Deniyor. Bu Sayede Kart "Aptal" ve **Tekrar Kullanılabilir** Kalıyor: Başka Bir Ekranda Kalbe Basınca Bambaşka Bir Şey Yaptırmak İstersen Kartı Değiştirmen Gerekmez.

### Kartın Dış Kabuğu

```dart
  @override
  Widget build(BuildContext context) {
    return Card(                                  // Gölgeli, Hafifçe Yükseltilmiş Kutu
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), // DIŞ Boşluk
      elevation: 2,                               // Gölge Yüksekliği (Büyüdükçe Daha "Havada")
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), // Yuvarlak Köşe
      child: InkWell(                             // Dokunulabilir Alan + Dalga (Ripple) Efekti
        borderRadius: BorderRadius.circular(12),  // Dalga da Kart Köşesine Uysun
        onTap: onDetayTiklandi,                   // Karta Dokunulunca Ekranın Verdiği Fonksiyonu Çağır
        child: Padding(
          padding: const EdgeInsets.all(12),      // Dört Taraftan 12 Piksel İÇ Boşluk
          child: Row(                             // YATAY Dizilim: [Resim] [Bilgiler] [Kalp]
            crossAxisAlignment: CrossAxisAlignment.start, // Hepsini Üstten Hizala
            children: [
```

**`margin` ve `padding` Farkı:**

```
┌─────────── margin (Dış Boşluk) ───────────┐
│  ┌─────── Kartın Kenarı ───────────────┐  │
│  │  ┌──── padding (İç Boşluk) ──────┐  │  │
│  │  │         İçerik                 │  │  │
│  │  └────────────────────────────────┘  │  │
│  └──────────────────────────────────────┘  │
└────────────────────────────────────────────┘
```

**`Row` ve `Column`:** `Row` Çocuklarını **Yatay** (Soldan Sağa), `Column` **Dikey** (Yukarıdan Aşağı) Dizer.

**Hizalama Eksenleri:**

| | Row | Column |
|---|---|---|
| `mainAxisAlignment` (Ana Eksen) | Yatay Hizalama | Dikey Hizalama |
| `crossAxisAlignment` (Çapraz Eksen) | Dikey Hizalama | Yatay Hizalama |

### Sol Taraf: Resim

```dart
              ClipRRect(                          // İçindekini Yuvarlak Köşeli Kırp
                borderRadius: BorderRadius.circular(10),
                child: Image.network(             // İnternetten Resim İndirip Göster
                  urun.resimUrl,
                  width: 90,
                  height: 90,
                  fit: BoxFit.cover,              // Kutuyu Tamamen Doldur, Taşanı Kırp (Resim Sünmez)
                  errorBuilder: (context, error, stackTrace) {   // Resim Yüklenemezse...
                    return Container(             // ...Gri Kutu İçinde "Kırık Resim" İkonu Göster
                      width: 90,
                      height: 90,
                      color: Colors.grey.shade200,
                      child: const Icon(Icons.broken_image, color: Colors.grey),
                    );
                  },
                  loadingBuilder: (context, child, progress) {   // İndirilirken...
                    if (progress == null) return child;          // progress null = Bitti → Resmi Göster
                    return Container(                            // Bitmediyse Küçük Dönen Çember
                      width: 90,
                      height: 90,
                      color: Colors.grey.shade100,
                      child: const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 14),          // Resimle Yazılar Arasında 14 Piksel Boşluk
```

- **`Image.network`:** İnternetteki Bir Resmi İndirip Gösterir.
- **`errorBuilder`:** İnternet Yoksa Ya da Adres Bozuksa Çalışır. Olmasaydı Ekranda Çirkin Bir Hata Görünürdü.
- **`loadingBuilder`:** İndirme Sürerken Tekrar Tekrar Çalışır. Kullanıcı Boş Bir Alan Yerine "Yükleniyor" Görür.
- **`SizedBox`:** Belirli Boyutta Boş Kutu. Widget'lar Arasına **Boşluk** Koymanın En Kolay Yolu.

### Orta Kısım: Bilgiler

```dart
              Expanded(                           // Row'da Kalan TÜM Genişliği Bu Sütun Alsın
                child: Column(                    // DİKEY Dizilim
                  crossAxisAlignment: CrossAxisAlignment.start, // Sola Yasla
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween, // Biri En Sola, Diğeri En Sağa
                      children: [
                        Text('${urun.kategori.ikon} ${urun.kategori.baslik}', ...), // Örn: "E Elektronik"
                        StokRozeti(stok: urun.stokAdedi),   // 8. Bölümdeki Widget Burada Kullanılıyor
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      urun.baslik,
                      maxLines: 1,                          // En Fazla 1 Satır
                      overflow: TextOverflow.ellipsis,      // Sığmazsa Sonuna "..." Koy
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      urun.aciklama,
                      maxLines: 2,                          // Açıklama En Fazla 2 Satır
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade700, height: 1.2),
                    ),                                      // height: Satır Yüksekliği Çarpanı
                    const SizedBox(height: 8),
                    Text(
                      '${urun.fiyat.toStringAsFixed(2)} \$', // Her Zaman 2 Ondalık: 22.30 $
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary, // Uygulama Temasının Ana Rengi
                        fontSize: 16,
                        fontWeight: FontWeight.w900,        // En Kalın
                      ),
                    ),
                  ],
                ),
              ),
```

- **`Expanded`:** Önemli Bir Parça. Resim (90 Piksel) ve Kalp Yerini Aldıktan Sonra **Kalan Tüm Genişlik** Bu Sütuna Verilir. Olmasaydı Uzun Bir Başlık Satıra Sığmaz ve Ekranda Sarı-Siyah Çizgili **"Overflow" (Taşma)** Hatası Görünürdü.
- **`'${...}'`:** Süslü Parantez İçindeki İfadenin Sonucunu Metne Yerleştirir. Tek Bir Değişken için `$isim`, Bir İfade için `${urun.baslik}` Yazılır.
- **`maxLines` + `TextOverflow.ellipsis`:** Uzun Metni Kesip Sonuna `...` Koyar. Kartların Boyu Eşit Kalır.
- **`FontWeight.w600`, `w900`:** Yazı Kalınlığı. 100 En İnce, 900 En Kalın; `bold` = 700.
- **`toStringAsFixed(2)`:** Sayıyı Her Zaman 2 Ondalık Basamakla Yazar: `22.3` → `"22.30"`.
- **`\$`:** Dart Metinlerinde `$` Bir Değişken Başlatır. Düz Bir `$` Yazmak için Önüne `\` Konur.
- **`Theme.of(context).colorScheme.primary`:** Uygulama Temasının Ana Rengi. `main.dart`'taki `seedColor`'dan Üretiliyor; Tema Değişince Fiyatın Rengi de Kendiliğinden Değişiyor.

### Sağ Taraf: Favori Butonu

```dart
              const SizedBox(width: 8),           // Stok Rozeti ile Kalp Arasında Boşluk
              IconButton(
                padding: EdgeInsets.zero,         // Varsayılan İç Boşluğu Kaldır
                constraints: const BoxConstraints(), // Varsayılan 48x48 Minimum Boyutu Kaldır
                style: IconButton.styleFrom(
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap, // Mobilde de Dokunma Alanını Büyütme
                ),
                icon: Icon(
                  urun.favoriMi ? Icons.favorite : Icons.favorite_border, // Dolu Kalp / Boş Kalp
                  color: urun.favoriMi ? Colors.red : Colors.grey,
                ),
                onPressed: onFavoriTiklandi,      // Ekranın Verdiği Fonksiyonu Çağır
              ),
```

**Hizalama Sorunu ve Çözümü:** `IconButton` Varsayılan Olarak 48x48 Piksellik Bir Dokunma Alanı Kaplar ve İkonu Bu Alanın **Ortasına** Koyar. Satırdaki Elemanlar Üste Yaslı Olduğu için Kalp, Stok Rozetinden Yaklaşık 12 Piksel Aşağıda Kalıyordu:

```
Önce:                       Sonra:
[Stok: 5]                   [Stok: 5] ♡
           ♡
```

`padding` ve `constraints` Sıfırlanınca Buton Sadece İkon Kadar Yer Kaplar ve Rozetle Aynı Hizaya Gelir.

**Platform Tuzağı:** İlk Düzeltmede Sadece `padding` ve `constraints` Vardı; macOS'ta Hizalıydı, Ama **Android'de Kalp Yine 11 Piksel Aşağıdaydı**. Sebebi: Material 3, **Mobil Platformlarda** (Android, iOS) Dokunma Alanını Ayrıca En Az 48x48 Piksele Büyütüyor (`tapTargetSize: padded`). Parmakla Dokunmak Fareyle Tıklamaktan Daha Az Hassas Olduğu için Bu Bilinçli Bir Tercih. Masaüstünde Bu Büyütme Yapılmıyor. `MaterialTapTargetSize.shrinkWrap` Bu Büyütmeyi Kapatıyor:

| Platform | Sadece `padding` + `constraints` | + `shrinkWrap` |
|---|---|---|
| macOS | Hizalı | Hizalı |
| Android / iOS | Kalp 11 px Aşağıda | Hizalı |

> 💡 **Ders:** Bir Görünüm Değişikliğini Sadece Tek Platformda Denemek Yetmez. Flutter Aynı Widget'ı Platforma Göre Farklı Boyutlandırabilir.

**Bedeli:** Dokunma Alanı 24x24 Piksele Küçülüyor, Yani Telefonda Biraz Daha Hassas Basmak Gerekiyor.

---

## 10. `screens/urun_listesi_ekrani.dart`: Ana Ekran

Uygulamanın **Beyni** Burası. Görevleri:

1. Açılınca Servislerden Ürünleri Çekmek (Mock + API).
2. Ürünleri Arama Kutusuna ve Seçili Kategoriye Göre Filtrelemek.
3. Favori Bilgisini Tutmak ve Güncellemek.
4. Bunların Hepsini Ekrana Çizmek.

```
┌─────────────────────────────┐
│      Mini Mağaza        ♥ 2 │  ← AppBar + Favori Sayacı
│ [🔍 Ürün veya marka ara...] │  ← Arama Kutusu
│ (Tümü)(Elektronik)(Giyim)…  │  ← Kategori Çipleri
│ ┌─────────────────────────┐ │
│ │ Ürün Kartı              │ │  ← Ürün Listesi
│ └─────────────────────────┘ │
└─────────────────────────────┘
```

### 10.1 Widget ve State Ayrımı

```dart
class UrunListesiEkrani extends StatefulWidget {  // Zamanla DEĞİŞEN Bilgileri Var
  const UrunListesiEkrani({super.key});

  @override
  State<UrunListesiEkrani> createState() => _UrunListesiEkraniState(); // Durumu Tutacak Nesneyi Üret
}
```

StatefulWidget **İki Sınıftan** Oluşur:

| Sınıf | Görevi |
|---|---|
| `UrunListesiEkrani` | Widget'ın Kendisi. Sabittir, Değişmez |
| `_UrunListesiEkraniState` | Değişen Bilgileri (State) ve Ekranın Çizimini Tutar |

**Neden İkiye Ayrılmış?** Flutter Ekranı Yeniden Çizerken Widget'ı Baştan Oluşturabilir. State Nesnesi İse **Korunur**; Böylece Ürün Listesi, Seçili Kategori Gibi Bilgiler Kaybolmaz.

`=>` İfadesi, Tek Satırlık `{ return ...; }` Yazmanın Kısa Yolu.

### 10.2 Durum Değişkenleri (Ekranın Hafızası)

```dart
class _UrunListesiEkraniState extends State<UrunListesiEkrani> {
  final List<IUrunServisi> _servisler = [MockUrunServisi(), ApiUrunServisi()];
                                                  // Ürünlerin Çekileceği Servisler

  final TextEditingController _aramaController = TextEditingController();
                                                  // Arama Kutusunun "Kumandası"

  bool _yukleniyorMu = true;                      // Başta Yükleniyor Durumunda
  // ignore: prefer_final_fields                  // Bir Uyarıyı Susturur (Bkz. 14. Bölüm)
  Kategori _seciliKategori = Kategori.hepsi;      // Başta "Tümü" Seçili
  List<Urun> _filtrelenmisUrunler = [];           // EKRANDA GÖSTERİLEN Liste (Servisten Süzülmüş Gelir)
  final Set<int> _favoriIdleri = {};              // Favori Ürünlerin id'leri
  Timer? _aramaZamanlayici;                       // Arama için Zamanlayıcı (Debounce)
  int _istekNo = 0;                               // Her Yüklemede Bir Artan Sayaç
```

| Değişken | Ne Tutuyor? | Ne Zaman Değişiyor? |
|---|---|---|
| `_servisler` | Veri Kaynakları | Hiç (final) |
| `_aramaController` | Arama Kutusundaki Metin | Kullanıcı Yazdıkça |
| `_yukleniyorMu` | Ürünler Yükleniyor Mu? | Yükleme Başlayınca / Bitince |
| `_seciliKategori` | Hangi Çip Seçili? | Çipe Basılınca |
| `_filtrelenmisUrunler` | Ekranda Görünen Ürünler | Her Yükleme Bitince, Favori Değişince |
| `_favoriIdleri` | Favori Ürünlerin id'leri | Kalbe Basılınca |
| `_aramaZamanlayici` | Bekleyen Arama İsteği | Arama Kutusuna Her Harf Yazıldığında |
| `_istekNo` | Son Başlatılan Yüklemenin Numarası | Her Yükleme Başladığında |

**`TextEditingController`:** Arama Kutusunun Kumandası. Kutudaki Metni Okumak (`.text`) ve Temizlemek (`.clear()`) için Kullanılır.

**Neden Tek Liste Yetiyor?** Hem Kategori Hem Arama Filtresini Artık **Servisler** Yapıyor. Servisten Gelen Liste Zaten Süzülmüş Oluyor; Ekranın Ayrıca Süzmesine Gerek Kalmıyor. Kategori Ya da Arama Değişince Liste Servisten **Yeniden İsteniyor**; Böylece Kutu Temizlenince Ürünler de Geri Geliyor.

**`Set` ve Favori Kümesi:** `Set`, Aynı Değeri İki Kez Tutmayan Bir Liste Türü. Favoriler Neden Ürünlerin Üstünde Değil de Ayrı Bir Kümede Tutuluyor? Çünkü **Her Kategori Seçiminde ve Her Aramada Ürünler Servisten Yeniden Çekiliyor** ve Yeni Gelen Ürünlerin `favoriMi` Değeri Hep `false`. Favoriler Sadece Ürünlerin Üstünde Tutulsaydı, Her Yüklemede Kaybolurdu. Kümede Tutulunca Hangi Ürünlerin Favori Olduğu Hiç Unutulmuyor.

**`Timer?` ve `int`:** Bunların Ne İşe Yaradığını [10.4](#104-veri-yükleme) ve [10.5](#105-arama) Bölümlerinde Anlatıyorum.

### 10.3 Yaşam Döngüsü (Lifecycle) Metotları

Bir Ekranın Hayatı: **Doğar** (`initState`) → **Çizilir** (`build`, Defalarca) → **Ölür** (`dispose`).

```dart
  @override
  void initState() {                              // Ekran İLK Oluşturulduğunda BİR KEZ Çalışır
    super.initState();                            // Önce Flutter'ın Kendi Hazırlığı (Hep En Başta)
    _urunleriYukle();                             // Sonra Ürünleri Çekmeye Başla
  }

  @override
  void dispose() {                                // Ekran Kapatılıp Yok Edilirken Çalışır
    _aramaController.dispose();                   // Controller'ın Kullandığı Belleği Serbest Bırak
    _aramaZamanlayici?.cancel();                  // Bekleyen Bir Arama Zamanlayıcısı Varsa İptal Et
    super.dispose();                              // Flutter'ın Kendi Temizliği (Hep En Sonda)
  }
```

- **`initState`:** Başlangıçta Bir Kez Yapılacak İşler (Veri Çekmek Gibi) Buraya Yazılır.
- **`dispose`:** Temizlik Yeri. Controller Gibi Nesneler Bellekte Yer Tutar; Kapatılmazsa **Bellek Sızıntısı** (Memory Leak) Olur: Kullanılmayan Nesneler Bellekte Kalmaya Devam Eder. Zamanlayıcı İptal Edilmezse, Ekran Kapandıktan Sonra Çalışıp Artık Var Olmayan Bir Ekranda Yükleme Başlatmaya Çalışırdı.
- **`?.cancel()`:** Zamanlayıcı Hiç Kurulmadıysa (`null`) Hiçbir Şey Yapma; Kurulduysa İptal Et.

### 10.4 Veri Yükleme

Bu Metot Ekran Açılınca, **Her Kategori Çipine Basıldığında ve Arama Metni Değiştiğinde** Çağrılıyor. Servislerden Sadece Seçili Kategoriye ve Aramaya Uyan Ürünleri İstiyor.

```dart
  Future<void> _urunleriYukle() async {
    final buIstek = ++_istekNo;                   // Bu Yüklemenin Numarası (Sayacı 1 Artır, Yeni Değeri Al)
    final istenenKategori = _seciliKategori;      // Hangi Kategori İstendi? Not Al
    final aranan = _aramaController.text.trim().toLowerCase(); // Hangi Metin Arandı? Not Al

    setState(() {                                 // "Durum Değişti, Ekranı Yeniden Çiz!"
      _yukleniyorMu = true;
    });

    List<Urun> urunler = [];                      // Tüm Servislerin Ürünleri Burada Toplanacak
    for (final servis in _servisler) {            // Her Servis için Sırayla...
      try {                                       // try: Hata Çıkabilecek Kodu Dene...
        if (aranan.isEmpty) {                     // Arama Yoksa: Kategoriye Göre İste
          urunler.addAll(await servis.kategoriyeGoreGetir(istenenKategori));
        } else {                                  // Arama Varsa: İsme Göre Ara...
          final bulunanlar = await servis.adaGoreAra(aranan);
          urunler.addAll(                         // ...Sonuçlardan Seçili Kategoridekileri Al
            bulunanlar.where(
              (u) =>
                  istenenKategori == Kategori.hepsi ||
                  u.kategori == istenenKategori,
            ),
          );
        }
      } catch (e) {                               // ...catch: Hata Çıkarsa Buraya Düş, Uygulama Çökmesin
        debugPrint('${servis.runtimeType} Hatası: $e'); // Asıl Sebebi Konsola Yaz (Kullanıcı Görmez)
        if (mounted) {                            // Ekran Hâlâ Açık Mı?
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Bazı ürünler yüklenemedi. İnternet bağlantınızı kontrol edin.',
              ),
            ),
          );                                      // Kullanıcıya Alttan Hata Mesajı Göster
        }
      }
    }

    if (!mounted || buIstek != _istekNo) return;  // Ekran Kapandıysa Ya da Cevap Eskidiyse Dur

    setState(() {
      _filtrelenmisUrunler = urunler
          .map((u) => u.copyWith(favoriMi: _favoriIdleri.contains(u.id))) // Favori Bilgisini Geri Yükle
          .toList();
      _yukleniyorMu = false;                      // Yükleme Bitti
    });
  }
```

**Hangi Servis Metodu Çağrılıyor?**

| Arama Kutusu | Çağrılan Metot | Sonra Ne Yapılıyor? |
|---|---|---|
| Boş | `kategoriyeGoreGetir(istenenKategori)` | Hiçbir Şey; Sonuç Zaten Doğru Kategoride |
| Dolu | `adaGoreAra(aranan)` | Sonuçlardan Seçili Kategoriye Ait Olanlar Alınıyor |

`adaGoreAra` Sözleşmede Sadece Arama Metni Alıyor, Kategori Almıyor; Bütün Kategorilerden Sonuç Döndürüyor. Bu Yüzden Kategori Seçiliyse Sonuçlar Ekranda Bir Kez Daha Süzülüyor.

Adım Adım ("Tümü" Seçiliyken, Uygulama Açılışı):

1. `buIstek = 1`, `istenenKategori = Kategori.hepsi`, `aranan = ""` Olarak Not Alınır.
2. `_yukleniyorMu = true` → Ekranda Dönen Çember Görünür.
3. `for` Döngüsü İlk Turda `MockUrunServisi`'nden "Tümü" Kategorisi İster → 8 Ürün (0,4 Sn Sürer).
4. İkinci Turda `ApiUrunServisi`'nden İster → 20 Ürün (İnternet Hızına Bağlı).
5. `urunler` Listesinde 28 Ürün Birikir.
6. Her Ürünün Favori Bilgisi `_favoriIdleri` Kümesine Bakılarak Geri Yüklenir.
7. `_yukleniyorMu = false` → Çember Kaybolur, Liste Görünür.

"Giyim" Çipine Basılınca Aynı Adımlar Tekrar Çalışır; Bu Sefer Servisler Sadece Giyim Ürünlerini Döndürür (2 Mock + 10 API).

**Eski Cevap Kontrolü (`buIstek != _istekNo`):** Kullanıcı "Elektronik"e Basıp Cevap Gelmeden "Aksesuar"a Basarsa İki Yükleme Aynı Anda Sürer. Elektronik'in Cevabı Daha Geç Gelirse Ekrana Yazılıp Yanlış Kategoriyi Gösterebilirdi. Aynı Şey Arama için de Geçerli. Bunu Önlemek için Her Yükleme Bir Sıra Numarası Alıyor:

```
Elektronik'e Basıldı → buIstek = 5, _istekNo = 5
Aksesuar'a Basıldı   → buIstek = 6, _istekNo = 6
Elektronik Cevabı Geldi → 5 != 6 → Eski, Çöpe At
Aksesuar Cevabı Geldi   → 6 == 6 → Güncel, Ekrana Yaz
```

`++_istekNo` Yazımı: Önce Sayacı 1 Artır, Sonra Yeni Değeri Kullan.

**`map` ile Favori Bilgisini Geri Yüklemek:** Servisten Gelen Ürünlerin `favoriMi` Değeri Hep `false`. `map` Her Ürünü, `favoriMi` Değeri Favori Kümesine Göre Düzeltilmiş Bir Kopyasıyla Değiştiriyor.

**`try/catch`:** Hata Çıkabilecek Kod `try` İçine Yazılır. Hata Çıkarsa Program Çökmez, `catch` Bloğu Çalışır. `e` Yakalanan Hatanın Kendisi. Servislerin Fırlattığı Bütün Hatalar (200 Dışı Cevap, Zaman Aşımı, İnternet Yok...) Buraya Düşüyor (Bkz. [7. Bölüm](#neden-servis-hatayı-kendisi-yakalamıyor)).

**`debugPrint`:** Hatayı Geliştiricinin Gördüğü Konsola (Terminal / Debug Console) Yazar; Kullanıcı Bunu Görmez. Kullanıcıya Gösterilen Mesaj Genel ("Bazı ürünler yüklenemedi"), Ama Konsolda Asıl Sebep Görünür:

```
ApiUrunServisi Hatası: Exception: Ürünler Alınamadı: 500
ApiUrunServisi Hatası: TimeoutException after 0:00:10.000000: Future not completed
```

`runtimeType` Hatanın Hangi Servisten Geldiğini Yazar. Hata Ayıklarken (Debug) Çok İşe Yarar.

**Neden Her Servis için Ayrı `try/catch`?** İnternet Yoksa Sadece API Hata Verir; Mock Ürünler Yine de Listelenir. Tek Bir `try/catch` Olsaydı, API'nin Hatası Mock Ürünleri de Kaybettirebilirdi. `try/catch` Hiç Olmasaydı Hata Yukarı Fırlar ve **Yükleniyor Çemberi Sonsuza Kadar Dönerdi**.

**`mounted`:** "Bu Ekran Hâlâ Görünüyor Mu?" Sorusu. Beklerken Kullanıcı Ekrandan Çıkmış Olabilir; O Zaman `setState` Ya da Mesaj Göstermek Hata Verir.

**`ScaffoldMessenger` / `SnackBar`:** Ekranın Altından Kayan, Birkaç Saniye Sonra Kendiliğinden Kaybolan Kısa Mesaj.

> 🔑 **Flutter'ın Altın Kuralı:** Bir Değişkeni Değiştirmek Tek Başına Ekranı Güncellemez. Değişikliğin **`setState(() { ... })`** İçinde Yapılması Gerekir Ki Flutter `build` Metodunu Tekrar Çalıştırsın.

### 10.5 Arama

```dart
  void _aramaDegisti() {
    setState(() {});                              // Boş setState: Sadece Ekranı Yeniden Çiz ("X" Görünsün)
    _aramaZamanlayici?.cancel();                  // Önceki Harfin Zamanlayıcısını İptal Et
    _aramaZamanlayici = Timer(                    // Yeni Zamanlayıcı Kur:
      const Duration(milliseconds: 400),          //   400 ms İçinde Yeni Harf Gelmezse...
      _urunleriYukle,                             //   ...Servislerden Arama Sonuçlarını İste
    );
  }
```

Arama Kutusuna Her Harf Yazıldığında Bu Metot Çağrılıyor. Ama Her Harfte Servise **Gitmiyor**.

#### Debounce: "Yazma Bitince İstek At"

Kullanıcı "saat" Yazarken Her Harfte Servise Gidilseydi 4 Ayrı İstek Atılırdı: "s", "sa", "saa", "saat". İlk Üçü Boşa Gider, İnternet ve Pil Harcanırdı.

Bunun Yerine Bir **Zamanlayıcı** (`Timer`) Kullanılıyor. Asansör Kapısı Gibi Düşün: Biri Girdikçe Kapı Kapanmayı Erteler; Bir Süre Kimse Girmeyince Kapanır.

```
"s"    yazıldı → Zamanlayıcı Kuruldu (400 ms)
"sa"   yazıldı → Eski Zamanlayıcı İptal, Yenisi Kuruldu
"saa"  yazıldı → Eski Zamanlayıcı İptal, Yenisi Kuruldu
"saat" yazıldı → Eski Zamanlayıcı İptal, Yenisi Kuruldu
  ...400 ms Boyunca Yeni Harf Yok...
               → Zamanlayıcı Doldu → _urunleriYukle() → TEK İstek
```

Bu Tekniğe **Debounce** Deniyor; Arama Kutularında Çok Yaygın.

- **`Timer(süre, fonksiyon)`:** Verilen Süre Dolunca Fonksiyonu Bir Kez Çalıştırır. `dart:async` Kütüphanesinden Geliyor.
- **`setState(() {})`:** Hiçbir Değişkeni Değiştirmeyen Boş Bir `setState`. Sadece Ekranı Yeniden Çizdiriyor; Kutuya İlk Harf Yazılınca Sağdaki "X" Butonu Hemen Görünsün Diye.

#### Arama Nerede Yapılıyor?

Filtrelemenin Hepsi Artık Servislerde:

| Filtre | Kim Yapıyor? | Ne Zaman? |
|---|---|---|
| **Kategori** | Servisler (`kategoriyeGoreGetir`) | Çipe Basılınca |
| **Arama** | Servisler (`adaGoreAra`) | Yazma Bitince (400 ms Sonra) |

Servislerdeki `adaGoreAra`, Aranan Metnin Ürünün **Başlığında Ya da Açıklamasında** Geçip Geçmediğine Bakıyor.

**Örnek:** "Giyim" Seçili, Kutuya "pamuk" Yazıldı:

1. Zamanlayıcı Dolunca `_urunleriYukle()` Çalışır.
2. Her Servisten `adaGoreAra("pamuk")` İstenir; Bütün Kategorilerden "pamuk" Geçen Ürünler Gelir.
3. Bunlardan Kategorisi "Giyim" Olanlar Alınır → Pamuklu Sweatshirt.

**Bedeli:** Her Aramada Servise Gidiliyor. Mock Serviste Bu 0,3 Saniyelik Bir Bekleme; API Servisinde İse İnternetten Yeni Bir İstek. Debounce Sayesinde Bu, Her Harfte Değil, Her Arama Bitiminde Bir Kez Oluyor.

### 10.6 Favori Değiştirme

```dart
  void _favoriyiDegistir(Urun hedefUrun) {
    setState(() {
      final yeniUrun = hedefUrun.copyWith(favoriMi: !hedefUrun.favoriMi); // "!" = Tersini Al
      if (yeniUrun.favoriMi) {
        _favoriIdleri.add(hedefUrun.id);          // Favori Olduysa id'yi Kümeye Ekle
      } else {
        _favoriIdleri.remove(hedefUrun.id);       // Favoriden Çıktıysa Kümeden Sil
      }
      final index = _filtrelenmisUrunler.indexWhere(
        (u) => u.id == hedefUrun.id,              // Listede Kaçıncı Sırada?
      );
      if (index != -1) {                          // -1 = Bulunamadı Demek
        _filtrelenmisUrunler[index] = yeniUrun;   // Eski Nesneyi Yenisiyle Değiştir
      }
    });
  }
```

Adım Adım (Favori Olmayan MacBook'un Kalbine Basıldı):

1. `!hedefUrun.favoriMi` → `!false` → `true`.
2. `copyWith(favoriMi: true)` → Favorisi `true` Olan **Yeni** Bir MacBook Nesnesi Üretilir.
3. `_favoriIdleri.add(101)` → MacBook'un `id`'si Favori Kümesine Eklenir.
4. `indexWhere(...)` → `id`'si 101 Olan Ürünün Listedeki Sırası Bulunur (Örn: `0`). Liste Sıra Numaraları **0'dan** Başlar.
5. `_filtrelenmisUrunler[0] = yeniUrun` → Eski MacBook'un Yerine Yenisi Konur.
6. `setState` → Ekran Yeniden Çizilir: Kalp Kırmızı Olur, Sayaç 1 Artar.

Adım 5 Kalbin **Hemen** Kırmızı Olması için. Adım 3 İse Favorinin **Kalıcı** Olması için: Kullanıcı "Giyim"e Geçip "Tümü"ye Döndüğünde Ya da Bir Arama Yaptığında Ürünler Servisten Yeniden Çekilir; MacBook'un Favori Olduğu Bu Kümeden Hatırlanır.

### 10.7 `build`: Ekranın Çizimi

`setState` Her Çağrıldığında Flutter Bu Metodu Tekrar Çalıştırır ve Ekranı Güncel Değişkenlerle Yeniden Çizer.

#### Üst Bar ve Favori Sayacı

```dart
  @override
  Widget build(BuildContext context) {
    return Scaffold(                              // Sayfa İskeleti: Üst Bar + Gövde
      appBar: AppBar(
        title: const Text(
          "Mini Mağaza",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,                        // Başlığı Ortala
        actions: [                                // AppBar'ın Sağ Tarafındaki Öğeler
          Padding(
            padding: const EdgeInsets.only(right: 16.0), // Sadece Sağa 16 Piksel Boşluk
            child: Center(
              child: Badge(                       // İkonun Köşesinde Küçük Sayı Rozeti
                label: Text(
                  '${_favoriIdleri.length}',          // Favori Kümesindeki id Sayısı
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                child: const Icon(Icons.favorite, color: Colors.red), // Kırmızı Kalp
              ),
            ),
          ),
        ],
      ),
```

- **`Scaffold`:** Bir Sayfanın Hazır İskeleti. Üst Bar (`appBar`), Gövde (`body`) Gibi Standart Bölümleri Var.
- **`Badge`:** Bir İkonun Köşesine Bildirim Sayısı Gibi Küçük Bir Rozet Ekler.
- **`_favoriIdleri.length`:** Favori Kümesinde Kaç id Olduğunu Sayar. Ekranda Sadece Seçili Kategorinin Ürünleri Olsa Bile, Küme Tüm Favorileri Tuttuğu için **Toplam** Favori Sayısını Gösterir.

#### Gövde 1: Arama Kutusu

Gövde, Alt Alta 3 Parçadan Oluşan Bir `Column`:

```dart
      body: Column(
        children: [
          // ── 1) ARAMA KUTUSU ──
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4), // Sol, Üst, Sağ, Alt
            child: TextField(                     // Kullanıcının Yazı Yazabildiği Kutu
              controller: _aramaController,       // Kutuyu Kumandaya Bağla
              onChanged: (_) => _aramaDegisti(),  // Her Tuş Vuruşunda Zamanlayıcıyı Kur (Bkz. 10.5)
              decoration: InputDecoration(
                hintText: "Ürün veya marka ara...", // Kutu Boşken Görünen Silik Yazı
                prefixIcon: const Icon(Icons.search), // Soldaki Büyüteç
                suffixIcon: _aramaController.text.isNotEmpty  // Kutuda Yazı VARSA...
                    ? IconButton(                             // ...Sağda "X" Butonu Göster
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _aramaController.clear();           // Metni Sil
                          _aramaZamanlayici?.cancel();        // Bekleyen Aramayı İptal Et
                          _urunleriYukle();                   // Aramasız Listeyi Servisten Yeniden Çek
                        },
                      )
                    : null,                                   // Yazı Yoksa Buton Yok
                filled: true,                                 // İçini Renkle Doldur
                fillColor: Colors.grey.shade100,              // Açık Gri Arka Plan
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,                // Kenar Çizgisi Yok
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),
```

- **`EdgeInsets.fromLTRB`:** Dört Tarafa Ayrı Ayrı Boşluk: **L**eft (Sol), **T**op (Üst), **R**ight (Sağ), **B**ottom (Alt).
- **`onChanged: (_) => ...`:** Kutudaki Yazı Her Değiştiğinde Çalışır. Gelen Parametre Yeni Metin; Ama Biz Metni Controller'dan Okuduğumuz için Kullanmıyoruz. Kullanılmayan Parametreye `_` Adı Verilir.
- **`suffixIcon`:** Ternary ile Kutuda Yazı Varsa Bir "X" Butonu, Yoksa `null` (Hiçbir Şey).

#### Gövde 2: Kategori Çipleri

```dart
          // ── 2) KATEGORİ ÇİPLERİ ──
          SingleChildScrollView(                  // Sığmazsa Kaydırılabilsin
            scrollDirection: Axis.horizontal,     // ...Yatay Olarak
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: Kategori.values.map((kategori) {  // Enum'daki HER Değer için Bir Çip Üret
                final seciliMi = _seciliKategori == kategori;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: ChoiceChip(              // Seçilebilir Hap Şeklinde Buton
                    avatar: Text(kategori.ikon),  // Soldaki Küçük "E", "G" Vb.
                    label: Text(kategori.baslik), // "Elektronik"
                    selected: seciliMi,           // Seçili Olan Farklı Renkte Görünür
                    onSelected: (secildi) {
                      if (secildi) {              // Sadece Seçme Olayını Dinle
                        setState(() {
                          _seciliKategori = kategori; // Çip Hemen Renklensin
                        });
                        _urunleriYukle();         // Bu Kategorinin Ürünlerini Servislerden Çek
                      }
                    },
                  ),
                );
              }).toList(),                        // map'in Sonucunu Widget Listesine Çevir
            ),
          ),
```

- **`SingleChildScrollView`:** Çipler Ekrana Sığmazsa Sağa-Sola Kaydırılabilsin Diye.
- **`Kategori.values.map(...)`:** 5 Kategori için 5 Çip **Elle Yazmak Yerine** Döngüyle Üretiliyor. Enum'a Yeni Bir Kategori Eklenince Çipi **Otomatik Olarak** Ekrana Gelir; Ekran Kodunda Değişiklik Gerekmez.
- **`if (secildi)`:** Seçili Çipe Tekrar Basılınca `secildi` `false` Gelir. Bu Durumda Hiçbir Şey Yapılmıyor; Böylece Her Zaman Bir Kategori Seçili Kalıyor.

#### Gövde 3: Ürün Listesi

```dart
          // ── 3) ÜRÜN LİSTESİ ──
          Expanded(                               // Kalan Tüm Dikey Alanı Kapla
            child: _yukleniyorMu
                ? const Center(child: CircularProgressIndicator())   // DURUM A: Yükleniyor
                : _filtrelenmisUrunler.isEmpty
                ? Center(                                            // DURUM B: Sonuç Yok
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search, size: 64, color: Colors.grey.shade400),
                        const SizedBox(height: 12),
                        Text('Aradığınız kriterlere uygun ürün bulunamadı.', ...),
                      ],
                    ),
                  )
                : ListView.builder(                                  // DURUM C: Ürünler Var
                    itemCount: _filtrelenmisUrunler.length,          // Toplam Kaç Satır
                    itemBuilder: (context, index) {                  // Her Satır için Çağrılır
                      final urun = _filtrelenmisUrunler[index];
                      return UrunKarti(                              // 9. Bölümdeki Widget
                        urun: urun,
                        onFavoriTiklandi: () => _favoriyiDegistir(urun), // Kalbe Basılınca Ne Olsun
                        onDetayTiklandi: () {                            // Karta Basılınca Ne Olsun
                          ScaffoldMessenger.of(context).showSnackBar(    // Alttan Kayan Mesaj
                            SnackBar(
                              content: Text('${urun.baslik} tıklandı!'),
                              duration: const Duration(milliseconds: 1000), // 1 Sn Görünsün
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
```

**3 Ekran Durumu:** İç İçe Ternary (`? :`) ile Yönetiliyor:

```
_yukleniyorMu true Mu?
   ├─ Evet  → DURUM A: Dönen Çember
   └─ Hayır → Liste Boş Mu?
                ├─ Evet  → DURUM B: "Ürün Bulunamadı" Mesajı
                └─ Hayır → DURUM C: Ürün Listesi
```

Yükleniyor / Boş / Dolu: Gerçek Uygulamalarda Çok Sık Karşılaşılan Bir Kalıp. Kullanıcı Hiçbir Zaman Boş, Ne Olduğu Belirsiz Bir Ekranla Karşılaşmıyor.

**`ListView.builder`:** Sadece **Ekranda Görünen** Satırları Oluşturur. Kullanıcı Aşağı Kaydırdıkça Yeni Satırlar Üretilir, Ekrandan Çıkanlar Atılır. Böylece 10.000 Ürün Olsa Bile Uygulama Yavaşlamaz. `index` Satırın Sıra Numarası (0, 1, 2...).

**`Expanded` Burada da Kritik:** `ListView` Sınırsız Uzayabilir, `Column` İse Ona Bir Sınır Koymaz. `Expanded` Olmadan Flutter Listenin Yüksekliğini Bilemez ve Hata Verirdi.

---

## 11. `main.dart`: Uygulamanın Giriş Kapısı

Uygulama Çalıştırıldığında İlk Okunan Dosya. İki İş Yapıyor: Uygulamayı Başlatmak ve Genel Ayarları (Tema, Başlık, İlk Sayfa) Belirlemek.

```dart
import 'package:flutter/material.dart';           // Flutter'ın Hazır Görsel Parçaları
import 'screens/urun_listesi_ekrani.dart';        // Açılışta Gösterilecek Ekran

void main() {                                     // Dart'ta HER Program main()'den Başlar
  runApp(const MiniMagazaUygulamasi());           // Verilen Widget'ı Ekranın Köküne Yerleştir
}

class MiniMagazaUygulamasi extends StatelessWidget {
  const MiniMagazaUygulamasi({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(                           // Tüm Uygulamayı Saran En Dış Kap
      debugShowCheckedModeBanner: false,          // Sağ Üstteki Kırmızı "DEBUG" Şeridini Gizle
      title: "Mini Mağaza",                       // İşletim Sisteminin Gördüğü Uygulama Adı
      theme: ThemeData(                           // Tüm Uygulamanın Görsel Teması
        useMaterial3: true,                       // Google'ın En Yeni Tasarım Dili
        colorScheme: ColorScheme.fromSeed(        // Tek Bir "Tohum" Renkten Tüm Paleti Üret
          seedColor: Colors.indigo,               // Tohum: Çivit Mavisi
          brightness: Brightness.light,           // Açık Tema
        ),
      ),
      home: const UrunListesiEkrani(),            // İlk Açılacak Sayfa
    );
  }
}
```

### Satır Satır

- **`import 'package:flutter/material.dart'`:** Buton, Yazı, Liste, Renk, İkon Gibi Hazır Parçaları İçeren Ana Kütüphane. Google'ın **Material Design** Tasarım Diline Göre Hazırlanmış.
- **`import 'screens/...'`:** `package:` ile Başlamayan Yollar Projenin Kendi Dosyalarını Gösterir.
- **`void main()`:** `void` = Geriye Değer Döndürmez. Uygulama Açılınca Önce Bu Çalışır.
- **`runApp(...)`:** Verilen Widget'ı Ekranın En Üstüne (Köküne) Yerleştirir. Ekranda Görünen Her Şey Bu Widget'ın İçinden Çıkar.
- **`const`:** Bu Nesne Hiç Değişmeyecek. Flutter Onu Tekrar Tekrar Oluşturmak Zorunda Kalmaz; Performans Artar.
- **`extends StatelessWidget`:** `extends` = Miras Alma. Bu Sınıf StatelessWidget'ın Tüm Özelliklerini Alır. Ayarlar Değişmediği için Stateless.
- **`super.key`:** Flutter'ın Widget'ları Birbirinden Ayırt Etmek için Kullandığı Kimlik. Şimdilik Bilmen Gereken: Her Widget Kurucusunda Bulunur.
- **`BuildContext context`:** Widget'ın Ekran Ağacındaki Yerini Bilen Nesne. Tema Rengine Ulaşmak (`Theme.of(context)`) Gibi İşlerde Kullanılır.

### Renk Paleti: `ColorScheme.fromSeed`

Tek Bir Renk Veriyorsun, Flutter O Renkten Uyumlu Bir **Renk Paleti** Üretiyor: Ana Renk (Primary), İkincil Renk (Secondary), Arka Plan Rengi... Ürün Kartındaki Fiyatın Rengi (`Theme.of(context).colorScheme.primary`) Buradan Geliyor.

> 💡 `seedColor`'u `Colors.green` Yapıp Uygulamayı Yeniden Başlatırsan Bütün Uygulamanın Renginin Değiştiğini Görürsün.

---

## 12. Proje Ayarları: `pubspec.yaml` ve `AndroidManifest.xml`

API'den Veri Çekebilmek için `lib` Dışında İki Ayar Yapıldı.

### `pubspec.yaml`: `http` Paketi

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  http: ^1.6.0                # İnternete HTTP İsteği (GET, POST...) Atmak için Resmi Dart Paketi
```

`pubspec.yaml` Projenin **Kimlik Kartı ve Alışveriş Listesi** Gibi:

- **Kimlik Kartı:** Projenin Adı, Sürümü, Açıklaması.
- **Alışveriş Listesi:** Projenin Kullandığı Hazır Paketler (`dependencies`).

**Paket Nedir?** Başkalarının Yazıp Paylaştığı Hazır Kod. Her Şeyi Sıfırdan Yazmak Yerine Kullanılır. Paketler [pub.dev](https://pub.dev) Sitesinde Bulunur.

**Nasıl Eklenir?** `pubspec.yaml`'a Paketin Adını ve Sürümünü Yazıp `flutter pub get` Çalıştırınca Paket İndirilir. (Ya da Terminalde `flutter pub add http` Komutu İkisini Birden Yapar.)

**`^1.6.0` Ne Demek?** "1.6.0 ve Üzeri, Ama 2.0.0'dan Küçük Sürümler". Büyük Sürüm Değişiklikleri (1 → 2) Genelde Kodu Bozabileceği için Engellenir. İndirilen Kesin Sürümler `pubspec.lock` Dosyasına Yazılır.

> ⚠️ **YAML Dosyalarında Girintiler (Boşluklar) Önemlidir.** Bir Satırı Yanlış Hizalarsan Dosya Okunamaz.

### `AndroidManifest.xml`: İnternet İzni

Dosyanın Yeri: `android/app/src/main/AndroidManifest.xml`

```xml
<uses-permission android:name="android.permission.INTERNET"/>  <!-- Uygulama İnternete Çıkabilsin -->
```

Android'de Uygulamalar Varsayılan Olarak **İnternete Çıkamaz**; Bu İzin Açıkça İstenmeli.

Dikkat Edilecek Bir Tuzak: Debug (Geliştirme) Modunda Flutter Bu İzni Kendisi Eklediği için Eksikliği **Fark Edilmez**. Ama **Release (Yayın) Sürümünde** İzin Yoksa Ne API İsteği Ne de `Image.network` ile Resim Yüklemesi Çalışır. Yani Uygulama Geliştirirken Çalışır, Mağazaya Yüklenince Bozulur.

---

## 13. Her Şey Birlikte: Adım Adım Ne Olur?

### Genel Akış

```
main() → MaterialApp → UrunListesiEkrani
                            │
                 initState → _urunleriYukle()
                            │       │
                            │       └─► [MockUrunServisi, ApiUrunServisi] → Listeler Birleşir
                            │               └─ Hepsi Gelince Tek List<Urun>
                            │
                 setState → build() Yeniden Çalışır
                            │
          ┌─────────────────┼──────────────────┐
     TextField         ChoiceChip'ler     ListView
   (onChanged)         (onSelected)          │
         │                  │             UrunKarti ×N
   _aramaDegisti()          │
   (400 ms Bekle)           │
         └──► _urunleriYukle() ◄──┘
              (kategoriyeGoreGetir / adaGoreAra)
                                             ├─ StokRozeti
                                             └─ ❤️ onFavoriTiklandi
                                                    │
                                          _favoriyiDegistir()
                                          (copyWith → Listeyi Güncelle → Filtrele → setState)
```

### Senaryo 1: Uygulama Açılıyor

1. `main()` Çalışır, `runApp` ile `MiniMagazaUygulamasi` Ekrana Konur.
2. `MaterialApp` Temayı Ayarlar ve `home` Olarak `UrunListesiEkrani`'nı Açar.
3. Ekranın `initState`'i Çalışır ve `_urunleriYukle()` Çağrılır.
4. `_yukleniyorMu = true` → `build` Çalışır → Ekranda **Dönen Çember** Görünür.
5. Mock Servisin `kategoriyeGoreGetir`'i "Tümü" için 0,4 Saniye Bekleyip 8 Ürün Döndürür.
6. API Servisi İnternetten 20 Ürün Çeker, `fromJson` ile Modele Çevirir.
7. `setState` ile Listeler Doldurulur, `_yukleniyorMu = false` Olur.
8. `build` Tekrar Çalışır → Çember Kaybolur, **28 Ürün Kartı** Görünür.

### Senaryo 2: Arama Kutusuna "saat" Yazılıyor

1. İlk Harfte `TextField`'ın `onChanged`'i Çalışır → `_aramaDegisti()` Çağrılır. Kutunun Sağında "X" Butonu Belirir.
2. Her Harfte Zamanlayıcı Sıfırlanır; Henüz Servise Gidilmez, Liste Değişmez.
3. Son Harften 400 ms Sonra Zamanlayıcı Dolar → `_urunleriYukle()` Çalışır, Yükleniyor Çemberi Görünür.
4. Her Servisten `adaGoreAra("saat")` İstenir; Başlığında Ya da Açıklamasında "saat" Geçen Ürünler Gelir.
5. Sonuçlardan Seçili Kategoriye Ait Olanlar Alınır ("Tümü" Seçiliyse Hepsi).
6. `setState` → `build` → Ekranda Sadece O Ürünler Kalır.

### Senaryo 3: Bir Ürünün Kalbine Basılıyor

1. `UrunKarti` İçindeki `IconButton`'ın `onPressed`'i Çalışır.
2. Bu, Ekranın Verdiği `onFavoriTiklandi` Fonksiyonunu Çağırır → `_favoriyiDegistir(urun)`.
3. `copyWith` ile Favorisi Tersine Çevrilmiş Yeni Ürün Üretilir.
4. Ürünün `id`'si Favori Kümesine (`_favoriIdleri`) Eklenir.
5. `id` ile Listede Bulunup Eskisinin Yerine Konur.
6. Filtre Yeniden Uygulanır, `setState` → `build`.
7. Kalp **Kırmızıya** Döner, Sağ Üstteki **Sayaç Bir Artar**.

### Senaryo 4: "Giyim" Çipine Basılıyor

1. Çipin `onSelected`'ı Çalışır, `_seciliKategori = Kategori.giyim` Olur → Çip Hemen Renklenir.
2. `_urunleriYukle()` Çağrılır, `istenenKategori = Kategori.giyim` Not Alınır.
3. Ekranda Yükleniyor Çemberi Görünür.
4. Mock Servisin `kategoriyeGoreGetir(Kategori.giyim)`'i 2 Ürün Döndürür.
5. API Servisi 20 Ürünü Çekip İçinden Giyim Olan 10 Tanesini Ayıklar.
6. Cevap Geldiğinde Kategori Hâlâ "Giyim" Mi Diye Bakılır; Öyleyse 12 Ürün Ekrana Yazılır.
7. Favori Kümesine Bakılarak Favori Ürünlerin Kalpleri Kırmızı Olarak Gelir.
8. Arama Kutusunda Yazı Varsa Yeni Listeye de Uygulanır.

### Senaryo 5: İnternet Yok

1. Mock Servis Normal Çalışır, 8 Ürün Gelir.
2. API Servisi Hata Fırlatır → `catch` Bloğu Çalışır → Altta **"Bazı ürünler yüklenemedi"** Mesajı Çıkar.
3. `_yukleniyorMu = false` Olur, Ekranda 8 Mock Ürün Görünür. Uygulama Çökmez, Takılı Kalmaz.

### Temel Felsefe

**Veri Yukarıdan Aşağı Akar** (Ekran → Kart → Rozet), **Olaylar Aşağıdan Yukarı Çıkar** (Kalbe Tıklama → Callback → Ekran). Flutter'ın Temel Felsefesi Bu.

```
        Ekran (State Burada)
       ▼ Veri         ▲ Olay
        Ürün Kartı
       ▼ Veri
        Stok Rozeti
```

---

## 14. Kodda Fark Ettiğim Küçük Şeyler

Bunlar Uygulamayı Bozmuyor, Ama İyileştirilebilir:

1. **`tumUrunleriGetir`** Ekran Tarafından Kullanılmıyor; Sadece API Servisinin Kendi İçinde Çağrılıyor.
2. **`// ignore: prefer_final_fields`** Satırı Aslında Gereksiz. `_seciliKategori` Sonradan Değiştirildiği için `final` Olamaz; Lint (Kod Kalitesi Aracı) Zaten Uyarı Vermez.
3. Arama Kutusu "Ürün veya Marka Ara..." Diyor, Ama Modelde Marka Alanı Yok. Arama Sadece Başlık ve Açıklamada Yapılıyor.
4. **Değerlendirme (Puan) Henüz Ekranda Gösterilmiyor.** Model Hazır, Ama `UrunKarti` Bu Alanı Kullanmıyor.
5. **Servisler Sırayla Çağrılıyor.** Mock Servisin Yapay Beklemesi Bittikten Sonra API İsteği Başlıyor; Her Yükleme Bu Yüzden Biraz Uzun Sürüyor.
6. **Her Çip Seçiminde ve Her Aramada İnternete Yeniden Gidiliyor.** API Servisi Her Seferinde 20 Ürünün Hepsini Çekip Ayıklıyor. Ürünler Değişmediği Sürece Bu Gereksiz Bir İstek; İleride Gelen Ürünler Bellekte Saklanarak (Cache) Önlenebilir.
7. **İnternet Yokken Her Aramada Uyarı Çıkar.** API Her Seferinde Hata Verdiği için "Bazı ürünler yüklenemedi" Mesajı Her Aramada Tekrar Görünür.

---

## 15. Kendin Dene: Küçük Alıştırmalar

Öğrenmenin En İyi Yolu Kodu Değiştirip Ne Olduğunu Görmek. Her Değişiklikten Sonra Terminalde `r` (Hot Reload) Ya da `R` (Hot Restart) Tuşuna Bas.

1. **Temayı Değiştir:** `main.dart`'ta `seedColor: Colors.indigo` Satırını `Colors.teal` Yap. Fiyatların ve Çiplerin Rengi Nasıl Değişti?
2. **Koyu Tema:** Aynı Yerde `Brightness.light`'ı `Brightness.dark` Yap.
3. **Yeni Mock Ürün Ekle:** `mock_urun_servisi.dart`'taki Listeye `id: 109` ile Yeni Bir Ürün Ekle. Listede Göründü Mü? Toplam Ürün Sayısı Kaç Oldu?
4. **Stok Rozetini Dene:** Bir Mock Ürünün `stokAdedi`'ni `0` Yap. Rozet Kırmızı "Tükendi" Oldu Mu?
5. **Yeni Kategori Ekle:** `kategori.dart`'a `kitap('Kitap', 'K')` Ekle. Ekranda Yeni Çip Kendiliğinden Belirdi Mi? (İpucu: `aksesuar` Satırının Sonundaki `;` Yeni Son Satıra Taşınmalı.)
6. **Puanı Göster:** `urun_karti.dart`'ta Fiyatın Altına `Text('⭐ ${urun.degerlendirme.puan}')` Ekle. API Ürünlerinde Puan, Mock Ürünlerde 0 Görünmeli. Neden?
7. **Bekleme Süresini Değiştir:** Mock Servisin `kategoriyeGoreGetir` Metodundaki `400`'ü `3000` Yap. Bir Çipe Basınca Yükleniyor Çemberi Ne Kadar Görünüyor? (Not: `tumUrunleriGetir`'deki `1500`'ü Değiştirmek Bir Şey Değiştirmez; Ekran O Metodu Kullanmıyor.)
8. **İnterneti Kapat:** Cihazın İnternetini Kapatıp Uygulamayı Yeniden Başlat. Hangi Ürünler Görünüyor, Hangi Mesaj Çıkıyor?
