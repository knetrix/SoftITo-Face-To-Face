# Mini Mağaza – `lib` Klasörü, Dosya Dosya Anlatım

> Bu Belgedeki Açıklamalar, `lib` Klasöründeki Kod Dosyalarına Da Yorum Satırı Olarak Eklenmiştir.

## 0. Büyük Resim: Bu Proje Ne Yapıyor?

Bu, **Flutter** ile Yazılmış Küçük Bir **Mağaza Uygulaması**. Açıldığında:

1. 1,5 Saniye Bir Yükleniyor Animasyonu Gösteriliyor (Sunucudan Veri Çekiliyormuş Gibi Yapılıyor).
2. 8 Ürünlük Bir Liste Geliyor. Ürünler Laptop, Telefon, Sweatshirt, Ayakkabı Gibi Şeyler.
3. Üstteki Arama Kutusuna Yazdıkça Liste Filtreleniyor.
4. Kategori Çiplerine (Tümü / Elektronik / Giyim …) Dokunarak Kategoriye Göre Filtre Yapılabiliyor.
5. Her Ürünün Yanındaki ❤️ ile Ürün Favorilere Eklenip Çıkarılabiliyor. Sağ Üstteki Sayaç Da Buna Göre Güncelleniyor.
6. Bir Ürün Kartına Dokunulunca Altta Kısa Bir Mesaj (SnackBar) Çıkıyor.

### Klasör Yapısı ve Katmanlar

```
lib/
├── main.dart                     → Uygulamanın Giriş Kapısı
├── models/                       → "Veri Neye Benziyor?" (Saf Veri Sınıfları)
│   ├── kategori.dart
│   └── urun.dart
├── services/                     → "Veri Nereden Geliyor?"
│   ├── i_urun_servisi.dart       → Sözleşme (Interface)
│   └── mock_urun_servisi.dart    → Sahte Veri Sağlayan Uygulama
├── screens/                      → Tam Sayfa Ekranlar
│   └── urun_listesi_ekrani.dart
└── widgets/                      → Tekrar Kullanılabilir Küçük UI Parçaları
    ├── urun_karti.dart
    └── stok_rozeti.dart
```

Bu Ayrım, Derste Anlatılan **Katmanlı Mimarinin** Basit Bir Örneği. Her Katmanın Tek Bir Sorumluluğu Var:

- **Model:** Verinin Şekli. Flutter'dan Haberi Yok.
- **Service:** Veriyi Getirir. Ekranın Nasıl Göründüğünü Bilmez.
- **Screen:** Durumu (State) Yönetir ve Parçaları Bir Araya Getirir.
- **Widget:** Sadece Kendisine Verileni Çizer. Veriyi Nereden Aldığını Bilmez.

Okuma Sırası Olarak **Model → Service → Widget → Screen → Main** Öneririm, Çünkü En Bağımsız Parçadan En Bağımlı Parçaya Doğru Gidiyor. Aşağıda Bu Sırayla Anlatıyorum.

---

## 1. `models/kategori.dart`: Kategori Listesi

```dart
enum Kategori {                         // enum = Sabit, Sınırlı Sayıda Seçenek Kümesi
  hepsi('Tümü', 'H'),                   // Her Seçenek Parantez İçinde 2 Değer Taşıyor:
  elektronik('Elektronik', 'E'),        //   1) Ekranda Görünecek Başlık
  giyim('Giyim', 'G'),                  //   2) Çipte Avatar Olarak Gösterilecek Kısa "İkon" Metni
  ayakkabi('Ayakkabı', 'A'),
  aksesuar('Aksesuar', 'AK');           // Son Elemandan Sonra ";" Gelir, Çünkü Aşağıda Alanlar Var

  final String baslik;                  // Her Enum Değerinin Taşıdığı Başlık
  final String ikon;                    // Her Enum Değerinin Taşıdığı Kısa Harf/İkon

  const Kategori(this.baslik, this.ikon); // Yukarıdaki Parantezli Değerleri Bu Alanlara Atayan Kurucu
}
```

**Neden Enum Kullanıldı?** Kategori `"elektronik"` Gibi Bir String Olsaydı, `"elektronık"` Diye Yazım Hatası Yapılabilirdi ve Derleyici Bunu Yakalayamazdı. Enum ile Sadece Tanımlı Değerler Kullanılabiliyor.

Bu Yapıya **"Enhanced Enum"** Deniyor. Dart 2.17'den Beri Enum'lar Alan ve Kurucu Taşıyabiliyor. Örneğin `Kategori.giyim.baslik` İfadesi `"Giyim"` Döner.

`hepsi` Gerçek Bir Ürün Kategorisi Değil. Filtrede "Hiçbir Kategori Ayrımı Yapma" Anlamında Kullanılıyor.

---

## 2. `models/urun.dart`: Ürün Veri Modeli

```dart
import 'kategori.dart';                 // Ürünün Kategorisi Kategori Tipinde Olacağı İçin

class Urun {
  final int id;                         // Benzersiz Kimlik (Favori Güncellemede Ürünü Bulmak İçin)
  final String baslik;                  // Ürün Adı
  final String aciklama;                // Uzun Açıklama
  final double fiyat;                   // Ondalıklı Fiyat
  final String resimUrl;                // İnternetten Yüklenecek Resmin Adresi
  final Kategori kategori;              // Enum'dan Bir Değer
  final int stokAdedi;                  // Stokta Kaç Adet Var
  final bool favoriMi;                  // Kullanıcı Favoriledi Mi?

  const Urun({                          // Süslü Parantez = İsimli Parametreler: Urun(id: 1, baslik: ...)
    required this.id,                   // required = Verilmesi Zorunlu
    required this.baslik,
    required this.aciklama,
    required this.fiyat,
    required this.resimUrl,
    required this.kategori,
    required this.stokAdedi,
    this.favoriMi = false,              // Zorunlu Değil; Verilmezse Varsayılan false
  });
```

Tüm Alanlar **`final`**. Yani Bir `Urun` Nesnesi Oluşturulduktan Sonra Değiştirilemez (**Immutable**). Kurucunun `const` Olması Sayesinde, Değerleri Derleme Anında Belli Olan Ürünler (Mock Listedeki Gibi) Bellekte Tek Kopya Olarak Tutulabiliyor.

Peki Alanlar Değişmiyorsa Favori Durumu Nasıl Değişecek? Bunun Cevabı `copyWith`:

```dart
  Urun copyWith({                       // "Kopyala Ama Şu Alanları Değiştir" Metodu
    int? id,                            // "?" = Nullable; Parametre Verilmezse null Kalır
    String? baslik,
    ...
    bool? favoriMi,
  }) {
    return Urun(                        // Yepyeni Bir Urun Nesnesi Döndürür
      id: id ?? this.id,                // "??" : Soldaki null İse Sağdakini Kullan
      baslik: baslik ?? this.baslik,    //   → Yeni Değer Verildiyse Onu, Verilmediyse Eskisini Al
      ...
      favoriMi: favoriMi ?? this.favoriMi,
    );
  }
```

Örnek Kullanım: `urun.copyWith(favoriMi: true)` Çağrısı, Diğer Her Şeyi Aynı Olan Ama Favorisi `true` Olan **Yeni** Bir Ürün Üretir. Eski Nesne Dokunulmadan Kalır. Flutter'da State Yönetiminin Temel Kalıplarından Biri Bu.

```dart
  @override                             // Object Sınıfındaki toString'i Eziyoruz
  String toString() {                   // print(urun) Yapınca Okunaklı Çıktı Versin Diye
    return 'Urun(id: $id, baslik: $baslik, fiyat: $fiyat ₺, favoriMi: $favoriMi)';
  }                                     // "$degisken" = String İçine Değer Gömme (Interpolation)
}
```

---

## 3. `services/i_urun_servisi.dart`: Sözleşme (Interface)

```dart
import '../models/kategori.dart';
import '../models/urun.dart';

abstract class IUrunServisi {           // abstract = Doğrudan Nesnesi Oluşturulamaz, Sadece Şablon
  Future<List<Urun>> tumUrunleriGetir();                    // Tüm Ürünleri Getir
  Future<List<Urun>> kategoriyeGoreGetir(Kategori kategori); // Kategoriye Göre Getir
  Future<List<Urun>> adaGoreAra(String aramaMetni);          // İsme Göre Ara
}
```

- Baştaki **`I`** Harfi "Interface" Anlamına Gelen Yaygın Bir İsimlendirme Alışkanlığı.
- Metotların Gövdesi Yok. Burada Sadece *"Bir Ürün Servisi Bu 3 İşi Yapabilmeli"* Deniyor.
- **`Future<...>`**, Sonucun Hemen Değil **İleride** Geleceği Anlamına Gelir (Ağ İsteği, Veritabanı Vb.). Türkçede "Vaat" Gibi Düşünülebilir.

**Neden Böyle Bir Dosya Var?** Ekran, `MockUrunServisi`'ni Değil `IUrunServisi`'ni Tanır. Yarın Gerçek Bir API Servisi (`ApiUrunServisi implements IUrunServisi`) Yazıldığında, Ekranda Tek Bir Satır Değiştirmek Yeterli Olur. Buna **Dependency Inversion** (Bağımlılığı Soyutlamaya Yapmak) Deniyor.

---

## 4. `services/mock_urun_servisi.dart`: Sahte Veri Kaynağı

```dart
class MockUrunServisi implements IUrunServisi {   // implements = Sözleşmedeki TÜM Metotları Yazmak Zorundayım
  final List<Urun> _urunDeposu = const [          // "_" ile Başlayan İsim = Bu Dosyaya Özel (Private)
    Urun(                                         // const Liste Olduğu İçin İçindeki Urun'lar Da const
      id: 1,
      baslik: "Macbook M5 Pro Laptop",
      ...
      resimUrl: "https://picsum.photos/400/400?1", // picsum: Rastgele Test Resmi Veren Site
      kategori: Kategori.elektronik,
      stokAdedi: 5,
    ),                                            // favoriMi Verilmedi → Varsayılan false
    ... // Toplam 8 Ürün, Her Kategoriden 2 Tane
  ];
```

"Mock" Kelimesi **Taklit** Anlamına Geliyor. Henüz Backend Olmadığı İçin Veriler Kodun İçine Gömülmüş Durumda.

```dart
  @override                                       // Sözleşmedeki Metodu Uyguluyoruz
  Future<List<Urun>> tumUrunleriGetir() async {   // async = İçinde await Kullanabilirim
    await Future.delayed(const Duration(milliseconds: 1500)); // 1,5 Sn Bekle → Ağ Gecikmesini Taklit Et
    return List.from(_urunDeposu);                // Listenin KOPYASINI Döndür
  }
```

**Neden `List.from` ile Kopya Döndürülüyor?** `_urunDeposu` Bir `const` Liste ve Const Listeler Değiştirilemez. Ekran İse Favori Güncellerken Listede `_tumUrunler[index] = yeniUrun` Yapıyor. Orijinal Const Liste Dönseydi Bu Satır **Hata Fırlatırdı**. Kopya Değiştirilebilir Bir Liste Olduğu İçin Sorun Çıkmıyor.

```dart
  @override
  Future<List<Urun>> kategoriyeGoreGetir(Kategori kategori) async {
    await Future.delayed(const Duration(milliseconds: 400));
    if (kategori == Kategori.hepsi) {             // "Tümü" Seçildiyse Filtreleme Yapma
      return List.from(_urunDeposu);
    }
    return _urunDeposu.where((urun) => urun.kategori == kategori).toList();
    // where: Koşulu Sağlayanları Süzer (Lazy), toList: Sonucu Gerçek Listeye Çevirir
  }

  @override
  Future<List<Urun>> adaGoreAra(String aramaMetni) async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (aramaMetni.trim().isEmpty) {              // trim: Baştaki/Sondaki Boşlukları Sil
      return List.from(_urunDeposu);              // Boş Arama → Hepsini Döndür
    }
    return _urunDeposu.where((urun) {
      final baslikKucuk = urun.baslik.toLowerCase();   // Büyük/Küçük Harf Duyarsız
      final arananKucuk = aramaMetni.toLowerCase();    //   Karşılaştırma İçin İkisini De Küçült
      return baslikKucuk.contains(arananKucuk);        // Başlıkta Geçiyor Mu?
    }).toList();
  }
}
```

> 📝 **Not:** `kategoriyeGoreGetir` ve `adaGoreAra` Şu An **Hiçbir Yerde Çağrılmıyor**. Ekran Filtrelemeyi Kendi İçinde, Bellekte Yapıyor (Aşağıda Göreceğiz). Bu Metotlar İleride Sunucu Tarafında Filtreleme Yapılacak Senaryo İçin Hazır Duruyor.

---

## 5. `widgets/stok_rozeti.dart`: Küçük Stok Etiketi

```dart
import 'package:flutter/material.dart';

class StokRozeti extends StatelessWidget {        // StatelessWidget = Kendi Değişen Durumu YOK
  final int stok;                                 // Dışarıdan Gelen Tek Bilgi

  const StokRozeti({super.key, required this.stok}); // super.key: Flutter'ın Widget Kimliği

  @override
  Widget build(BuildContext context) {            // Ekrana Ne Çizileceğini Döndüren Metot
    final tukendiMi = stok == 0;                  // Stok 0 Mı? Renkler/Metin Buna Göre Seçilecek

    return Container(                             // Kutu: Dolgu + Arka Plan + Kenarlık İçin
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
        tukendiMi ? "Tükendi" : 'Stok: $stok',    // Metin De Duruma Göre Değişiyor
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

Sonuçta Stoğu Olan Ürünlerde Yeşil "Stok: 5" Etiketi, Stoğu Bitmiş Ürünlerde Kırmızı "Tükendi" Etiketi Görünür. `.shade100`, `.shade900` Gibi Değerler Renk Tonları: Küçük Sayı Açık, Büyük Sayı Koyu Ton Demek.

---

## 6. `widgets/urun_karti.dart`: Listedeki Her Bir Ürün Kartı

```dart
class UrunKarti extends StatelessWidget {
  final Urun urun;                                // Gösterilecek Ürün
  final VoidCallback onFavoriTiklandi;            // VoidCallback = Parametresiz, Değer Döndürmeyen Fonksiyon
  final VoidCallback onDetayTiklandi;             //   Tipi; Yani "Tıklanınca ÇAĞIRILACAK Fonksiyon"
```

**Bu Kısım Önemli.** Kart, Favoriye Tıklandığında Ne Yapılacağını **Bilmez**. Sadece "Tıklandı" Diye Haber Verir; Ne Yapılacağına Ekran Karar Verir. Buna **"State'i Yukarı Taşıma" (Lifting State Up)** Deniyor. Bu Sayede Kart Aptal ve Tekrar Kullanılabilir Kalıyor.

```dart
  @override
  Widget build(BuildContext context) {
    return Card(                                  // Gölgeli, Yükseltilmiş Kart
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Dış Boşluk
      elevation: 2,                               // Gölge Yüksekliği
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(                             // Dokunulabilir Alan + Dalga (Ripple) Efekti
        borderRadius: BorderRadius.circular(12),  // Ripple Da Kart Köşesine Uysun
        onTap: onDetayTiklandi,                   // Karta Dokunulunca Ekranın Verdiği Fonksiyonu Çağır
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(                             // YATAY Dizilim: [Resim] [Bilgiler] [Kalp]
            crossAxisAlignment: CrossAxisAlignment.start, // Hepsini Üstten Hizala
            children: [
```

**Sol Taraf: Resim**

```dart
              ClipRRect(                          // İçindekini Yuvarlak Köşeli Kırp
                borderRadius: BorderRadius.circular(10),
                child: Image.network(             // İnternetten Resim Yükle
                  urun.resimUrl,
                  width: 90, height: 90,
                  fit: BoxFit.cover,              // Kutuyu Tamamen Doldur, Taşanı Kırp
                  errorBuilder: (context, error, stackTrace) {   // Resim Yüklenemezse...
                    return Container(             // ...Gri Kutu İçinde "Kırık Resim" İkonu Göster
                      width: 90, height: 90,
                      color: Colors.grey.shade200,
                      child: const Icon(Icons.broken_image, color: Colors.grey),
                    );
                  },
                  loadingBuilder: (context, child, progress) {   // Yüklenirken...
                    if (progress == null) return child;          // progress null = Yükleme Bitti → Resmi Göster
                    return Container(                            // Bitmediyse Küçük Dönen Yükleniyor İkonu
                      width: 90, height: 90,
                      color: Colors.grey.shade100,
                      child: const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 14),          // Resimle Yazılar Arasında 14px Boşluk
```

**Orta Kısım: Bilgiler**

```dart
              Expanded(                           // Row'da Kalan TÜM Genişliği Bu Sütun Alsın
                child: Column(                    // DİKEY Dizilim
                  crossAxisAlignment: CrossAxisAlignment.start, // Sola Yasla
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween, // Biri En Sola, Diğeri En Sağa
                      children: [
                        Text('${urun.kategori.ikon} ${urun.kategori.baslik}', ...), // Örn: "E Elektronik"
                        StokRozeti(stok: urun.stokAdedi),   // 5. Dosyadaki Widget Burada Kullanılıyor
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      urun.baslik,
                      maxLines: 1,                          // Tek Satır
                      overflow: TextOverflow.ellipsis,      // Sığmazsa Sonuna "..." Koy
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      urun.aciklama,
                      maxLines: 2,                          // Açıklama En Fazla 2 Satır
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade700, height: 1.2),
                    ),                                      // height: Satır Aralığı Çarpanı
                    const SizedBox(height: 8),
                    Text(
                      '${urun.fiyat.toStringAsFixed(2)} ₺', // Her Zaman 2 Ondalık: 1299.90 ₺
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

`Expanded` Önemli Bir Parça. Olmasaydı Uzun Metinler Satırdan Taşar ve Ekranda Sarı-Siyah "Overflow" Çizgileri Çıkardı.

**Sağ Taraf: Favori Butonu**

```dart
              IconButton(
                icon: Icon(
                  urun.favoriMi ? Icons.favorite : Icons.favorite_border, // Dolu Kalp / Boş Kalp
                  color: urun.favoriMi ? Colors.red : Colors.grey,
                ),
                onPressed: onFavoriTiklandi,      // Ekranın Verdiği Fonksiyonu Çağır
              ),
```

---

## 7. `screens/urun_listesi_ekrani.dart`: Ana Ekran (Beyin Burası)

### 7.1 Widget ve State Ayrımı

```dart
class UrunListesiEkrani extends StatefulWidget {  // StatefulWidget = Zamanla DEĞİŞEN Durumu Var
  const UrunListesiEkrani({super.key});

  @override
  State<UrunListesiEkrani> createState() => _UrunListesiEkraniState(); // Durumu Tutacak Sınıfı Üret
}
```

StatefulWidget İki Sınıftan Oluşur. Widget Sınıfının Kendisi Sabittir; Değişen Veriler İkinci Sınıf Olan `State` İçinde Tutulur. `=>` İfadesi, Tek Satırlık `{ return ...; }` Yazmanın Kısa Yolu.

### 7.2 Durum Değişkenleri

```dart
class _UrunListesiEkraniState extends State<UrunListesiEkrani> {
  final IUrunServisi _servis = MockUrunServisi(); // Tip: Interface, Nesne: Mock
                                                  // → Gerçek API Gelince Sadece Sağ Tarafı Değiştir

  final TextEditingController _aramaController = TextEditingController();
                                                  // Arama Kutusundaki Metni Okumak/Temizlemek İçin Kumanda

  bool _yukleniyorMu = true;                      // Başta Yükleniyor Durumunda Başla
  // ignore: prefer_final_fields                  // Lint Uyarısını Sustur (Aşağıdaki Not)
  Kategori _seciliKategori = Kategori.hepsi;      // Başta "Tümü" Seçili
  List<Urun> _filtrelenmisUrunler = [];           // EKRANDA GÖSTERİLEN Liste
  List<Urun> _tumUrunler = [];                    // Servisten Gelen ORİJİNAL Tam Liste
```

**Neden İki Ayrı Liste Var?** `_tumUrunler` Asıl Veri Kaynağı ve Hiç Küçülmüyor. `_filtrelenmisUrunler` İse Onun Filtrelenmiş Bir Görüntüsü. Tek Liste Olsaydı, "Giyim" Filtresinden Sonra Elektronik Ürünler Kaybolurdu ve "Tümü"ye Dönünce Geri Gelmezdi.

### 7.3 Yaşam Döngüsü (Lifecycle) Metotları

```dart
  @override
  void initState() {                              // Ekran İLK Oluşturulduğunda BİR KEZ Çalışır
    super.initState();                            // Önce Flutter'ın Kendi İşini Yapmasına İzin Ver
    _urunleriYukle();                             // Sonra Ürünleri Çekmeye Başla
  }

  @override
  void dispose() {                                // Ekran Kapatılıp Yok Edilirken Çalışır
    _aramaController.dispose();                   // Controller'ın Kullandığı Belleği Serbest Bırak
    super.dispose();                              // (Unutulursa Bellek Sızıntısı Olur)
  }
```

### 7.4 Veri Yükleme

```dart
  Future<void> _urunleriYukle() async {
    setState(() {                                 // setState = "Durum Değişti, Ekranı Yeniden Çiz!"
      _yukleniyorMu = true;
    });

    final urunler = await _servis.tumUrunleriGetir(); // 1,5 Sn Bekler, Liste Gelir

    if (mounted) {                                // Bu 1,5 Sn İçinde Kullanıcı Ekrandan Çıktıysa
      setState(() {                               //   setState Çağırmak Hata Verir; mounted Bunu Kontrol Eder
        _tumUrunler = urunler;
        _filtrelenmisUrunler = urunler;           // Başta Filtre Yok → İkisi Aynı
        _yukleniyorMu = false;                    // Yükleme Bitti
      });
    }
  }
```

> 🔑 **Flutter'ın Altın Kuralı:** Bir Değişkeni Değiştirmek Tek Başına Ekranı Güncellemez. Değişikliğin **`setState(() { ... })`** İçinde Yapılması Gerekir Ki Flutter `build` Metodunu Tekrar Çalıştırsın.

### 7.5 Filtreleme

```dart
  void _filteyiUygula() {                         // (İsimde Yazım Hatası Var: "Filtreyi" Olmalı)
    final aranan = _aramaController.text.trim().toLowerCase(); // Kutudaki Metni Al, Temizle, Küçült

    setState(() {
      _filtrelenmisUrunler = _tumUrunler.where((urun) {   // HER ZAMAN Tam Listeden Süz
        final kategoriUygunMu =
            (_seciliKategori == Kategori.hepsi) ||        // "Tümü" Seçiliyse Her Ürün Uygun
            (urun.kategori == _seciliKategori);           // Değilse Kategorisi Eşleşmeli
        final aramaUygunMu =
            aranan.isEmpty ||                             // Arama Boşsa Her Ürün Uygun
            urun.baslik.toLowerCase().contains(aranan) || // Ya Başlıkta
            urun.aciklama.toLowerCase().contains(aranan); // Ya Açıklamada Geçmeli
        return kategoriUygunMu && aramaUygunMu;           // İKİ Koşul Birden Sağlanmalı
      }).toList();
    });
  }
```

Kategori Filtresi ve Arama Filtresi **Birlikte** Çalışıyor. Örneğin "Giyim" Seçiliyken "Pamuk" Yazılırsa, Sadece Giyim Kategorisinde ve İçinde "Pamuk" Geçen Ürünler Kalır.

### 7.6 Favori Değiştirme

```dart
  void _favoriyiDegistir(Urun hedefUrun) {
    setState(() {
      final yeniUrun = hedefUrun.copyWith(favoriMi: !hedefUrun.favoriMi); // "!" = Tersini Al
      final index = _tumUrunler.indexWhere((u) => u.id == hedefUrun.id);  // Ana Listede Kaçıncı Sırada?
      if (index != -1) {                          // -1 = Bulunamadı Demek
        _tumUrunler[index] = yeniUrun;            // Eski Nesneyi Yenisiyle Değiştir
      }
      _filteyiUygula();                           // Filtreli Listeyi Ana Listeden Yeniden Üret
    });
  }
```

Akış Şöyle: Kalbe Basılır, `copyWith` ile Yeni Ürün Üretilir, Ana Listede Eskisinin Yerine Konur, Filtreli Liste Yeniden Hesaplanır ve Ekran Yeniden Çizilir. Değişiklik **Ana Listeye** Yazıldığı İçin Favori Durumu Filtre Değişse Bile Korunuyor.

### 7.7 `build`: Ekranın Çizimi

```dart
  @override
  Widget build(BuildContext context) {            // setState Her Çağrıldığında Bu Metot Tekrar Çalışır
    return Scaffold(                              // Sayfa İskeleti: Üst Bar + Gövde
      appBar: AppBar(
        title: const Text("Mini Mağaza", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,                        // Başlığı Ortala
        actions: [                                // AppBar'ın Sağ Tarafındaki Öğeler
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Badge(                       // İkonun Köşesinde Küçük Sayı Rozeti
                label: Text(
                  '${_tumUrunler.where((u) => u.favoriMi).length}', // Favori Olanları Say
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                child: const Icon(Icons.favorite, color: Colors.red), // Kırmızı Kalp
              ),
            ),
          ),
        ],
      ),
```

Sayaç `_tumUrunler` Üzerinden Sayıyor. Bu Yüzden Filtre Uygulanmış Olsa Da **Toplam** Favori Sayısını Gösteriyor.

Gövde, Alt Alta 3 Parçadan Oluşan Bir `Column`:

```dart
      body: Column(
        children: [
          // ── 1) ARAMA KUTUSU ──
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4), // Sol, Üst, Sağ, Alt
            child: TextField(
              controller: _aramaController,       // Kutuyu Controller'a Bağla
              onChanged: (_) => _filteyiUygula(), // Her Tuş Vuruşunda Filtrele ("_" = Parametreyi Kullanmıyorum)
              decoration: InputDecoration(
                hintText: "Ürün veya marka ara...", // Kutu Boşken Görünen Silik Yazı
                prefixIcon: const Icon(Icons.search), // Soldaki Büyüteç
                suffixIcon: _aramaController.text.isNotEmpty  // Kutuda Yazı VARSA...
                    ? IconButton(                             // ...Sağda "X" Butonu Göster
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _aramaController.clear();           // Metni Sil
                          _filteyiUygula();                   // Listeyi Yenile
                        },
                      )
                    : null,                                   // Yazı Yoksa Buton Yok
                filled: true,
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

```dart
          // ── 2) KATEGORİ ÇİPLERİ ──
          SingleChildScrollView(                  // Sığmazsa Kaydırılabilsin
            scrollDirection: Axis.horizontal,     // ...Yatay Olarak
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: Kategori.values.map((kategori) {  // Enum'daki HER Değer İçin Bir Çip Üret
                final seciliMi = _seciliKategori == kategori;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: ChoiceChip(              // Seçilebilir Hap Şeklinde Buton
                    avatar: Text(kategori.ikon),  // Soldaki Küçük "E", "G" Vb.
                    label: Text(kategori.baslik), // "Elektronik"
                    selected: seciliMi,           // Seçili Olan Farklı Renkte Görünür
                    onSelected: (secildi) {
                      if (secildi) {              // Sadece Seçme Olayını Dinle (Seçimi Kaldırmayı Değil)
                        setState(() {
                          _seciliKategori = kategori;
                          _filteyiUygula();
                        });
                      }
                    },
                  ),
                );
              }).toList(),                        // map'in Sonucunu Widget Listesine Çevir
            ),
          ),
```

`Kategori.values` Sayesinde Enum'a Yeni Bir Kategori Eklendiğinde Çip **Otomatik Olarak** Ekrana Gelir. Ekran Kodunda Değişiklik Gerekmez.

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
                    itemCount: _filtrelenmisUrunler.length,          // Kaç Eleman Var
                    itemBuilder: (context, index) {                  // Her Satır İçin Çağrılır
                      final urun = _filtrelenmisUrunler[index];
                      return UrunKarti(                              // 6. Dosyadaki Widget
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

Burada İç İçe Ternary (`? :`) ile **3 Farklı Ekran Durumu** Yönetiliyor: Yükleniyor, Boş ve Dolu. Bu, Gerçek Uygulamalarda Çok Sık Karşılaşılan Bir Kalıp.

`ListView.builder` Sadece **Ekranda Görünen** Kartları Üretir. 10.000 Ürün Olsa Bile Performanslı Çalışır.

`Expanded` Burada Da Kritik. `ListView` Sonsuz Yükseklik İster, `Column` İse Sınır Koymaz. `Expanded` Olmadan Uygulama Hata Verirdi.

---

## 8. `main.dart`: Uygulamanın Başlangıç Noktası

```dart
import 'package:flutter/material.dart';           // Material Design Widget'ları
import 'screens/urun_listesi_ekrani.dart';        // Açılışta Gösterilecek Ekran

void main() {                                     // Dart'ta HER Program main()'den Başlar
  runApp(const MiniMagazaUygulamasi());           // Verilen Widget'ı Ekranın Köküne Yerleştir
}

class MiniMagazaUygulamasi extends StatelessWidget {
  const MiniMagazaUygulamasi({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(                           // Uygulama Çapında Ayarları Tutan En Dış Widget
      debugShowCheckedModeBanner: false,          // Sağ Üstteki Kırmızı "DEBUG" Şeridini Gizle
      title: "Mini Mağaza",                       // İşletim Sisteminin Gördüğü Uygulama Adı
      theme: ThemeData(                           // Tüm Uygulamanın Görsel Teması
        useMaterial3: true,                       // Google'ın En Yeni Tasarım Dili
        colorScheme: ColorScheme.fromSeed(        // Tek Bir "Tohum" Renkten Tüm Paleti Otomatik Üret
          seedColor: Colors.indigo,               // Tohum: Çivit Mavisi
          brightness: Brightness.light,           // Açık Tema
        ),
      ),
      home: const UrunListesiEkrani(),            // İlk Açılacak Sayfa
    );
  }
}
```

`ColorScheme.fromSeed` Tek Bir Renkten Primary, Secondary, Arka Plan Gibi Tüm Renkleri Üretiyor. Ürün Kartındaki Fiyatın Rengi (`Theme.of(context).colorScheme.primary`) Buradan Geliyor. `seedColor`'u `Colors.green` Yapıp Denerseniz Bütün Uygulamanın Renginin Değiştiğini Görebilirsiniz.

---

## 9. Her Şey Birlikte Nasıl Çalışıyor?

```
main() → MaterialApp → UrunListesiEkrani
                            │
                 initState → _urunleriYukle()
                            │       │
                            │       └─► IUrunServisi (MockUrunServisi)
                            │               └─ 1,5 Sn Sonra List<Urun> Döner
                            │
                 setState → build() Yeniden Çalışır
                            │
          ┌─────────────────┼──────────────────┐
     TextField         ChoiceChip'ler     ListView
   (onChanged)         (onSelected)          │
          └──► _filteyiUygula() ◄──┘      UrunKarti ×N
                                             ├─ StokRozeti
                                             └─ ❤️ onFavoriTiklandi
                                                    │
                                          _favoriyiDegistir()
                                          (copyWith → Listeyi Güncelle → Filtrele → setState)
```

**Veri Yukarıdan Aşağı Akar** (Ekran → Kart → Rozet), **Olaylar Aşağıdan Yukarı Çıkar** (Kalbe Tıklama → Callback → Ekran). Flutter'ın Temel Felsefesi Bu.

---

## 10. Kodda Fark Ettiğim Küçük Şeyler

Bunlar Uygulamayı Bozmuyor:

1. **`_filteyiUygula`** İsminde Bir Harf Eksik; `_filtreyiUygula` Olmalı.
2. Servisteki **`kategoriyeGoreGetir`** ve **`adaGoreAra`** Hiçbir Yerde Kullanılmıyor.
3. **`// ignore: prefer_final_fields`** Satırı Aslında Gereksiz. `_seciliKategori` Sonradan Değiştiriliyor, Bu Yüzden Lint Zaten Uyarı Vermez.
4. `_favoriyiDegistir` ve Çip `onSelected` İçinde **`setState` İç İçe** Çağrılıyor, Çünkü `_filteyiUygula` Da Kendi İçinde `setState` Yapıyor. Çalışıyor Ama Gereksiz.
5. Arama Kutusu "Ürün veya Marka Ara..." Diyor, Ama Modelde Marka Alanı Yok. Arama Sadece Başlık ve Açıklamada Yapılıyor.
