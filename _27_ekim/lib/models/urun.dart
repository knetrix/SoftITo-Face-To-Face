// ============================================================================
// urun.dart → Ürün Modeli
// ----------------------------------------------------------------------------
// "Model", Bir Verinin Hangi Parçalardan Oluştuğunu Tarif Eden Sınıftır.
// Bir Formu Düşünün: Ürün Adı, Fiyatı, Resmi... Her Ürün Bu Formu Doldurur.
// Bu Dosyada O "Form" Tanımlanıyor.
//
// Modeller Sadece Veri Tutar; Ekrana Bir Şey Çizmez, İnternete Bağlanmaz.
// Bu Yüzden Bu Dosyada Flutter Kütüphanesi Bile Import Edilmiyor.
// ============================================================================

// Ürünün Kategorisi, Kategori Enum'u Tipinde Olacağı için İçeri Aktarılır.
import 'kategori.dart';
// Ürünün Puan Bilgisi, Degerlendirme Modeli Tipinde Olacağı için İçeri Aktarılır.
import 'degerlendirme.dart';

class Urun {
  // --------------------------------------------------------------------------
  // ALANLAR (Bir Ürünün Taşıdığı Bilgiler)
  // --------------------------------------------------------------------------
  // Tüm Alanlar "final": Bir Kez Değer Verilir, Sonra Değiştirilemez.
  // Değiştirilemeyen Nesnelere "Immutable" Denir. Neden Böyle?
  // Bir Ürünün Bilgisi Kodun Herhangi Bir Yerinde Habersizce Değişirse
  // Hatayı Bulmak Çok Zorlaşır. Değişiklik Gerektiğinde Aşağıdaki copyWith
  // Metodu ile Yeni Bir Kopya Üretilir.

  // Benzersiz Kimlik Numarası. Her Ürünün id'si Farklıdır.
  // Favori Güncellenirken Doğru Ürünü Listede Bulmak için Kullanılır.
  // "int": Tam Sayı Tipi.
  final int id;
  // Ürün Adı. "String": Metin Tipi.
  final String baslik;
  // Ürünün Uzun Açıklaması.
  final String aciklama;
  // Fiyat. "double": Ondalıklı Sayı Tipi (Örn: 22.30).
  final double fiyat;
  // İnternetten Yüklenecek Resmin Adresi (URL).
  final String resimUrl;
  // Ürünün Kategorisi. Sadece Kategori Enum'undaki Değerlerden Biri Olabilir.
  final Kategori kategori;
  // Stokta Kaç Adet Var. -1 Değeri "Stok Bilgisi Bilinmiyor" Anlamına Gelir
  // (API Stok Bilgisi Göndermediği için Kullanılıyor).
  final int stokAdedi;
  // Kullanıcı Bu Ürünü Favorilere Ekledi Mi? "bool": Sadece true (Evet)
  // Ya da false (Hayır) Olabilen Tip. İsimdeki "Mi" Eki Bunun Bir Soru
  // Olduğunu Hatırlatır.
  final bool favoriMi;
  // Ürünün Puanı ve Oy Sayısı. Başka Bir Modeli Alan Olarak Tutuyor (İç İçe Model).
  final Degerlendirme degerlendirme;

  // --------------------------------------------------------------------------
  // KURUCU (Constructor): Yeni Bir Urun Nesnesi Oluşturur.
  // --------------------------------------------------------------------------
  // Süslü Parantez { } = İsimli Parametreler. Değer Verirken Adını Yazarız:
  //   Urun(id: 1, baslik: "Kalem", fiyat: 5.0, ...)
  // Böylece Sıra Karışsa Bile Hangi Değerin Neye Ait Olduğu Bellidir.
  //
  // "const": Tüm Değerleri Önceden Belli Olan Ürünler (Mock Servisteki Gibi)
  // Sabit Olarak Oluşturulabilir. Flutter Bunları Bellekte Tek Kopya Tutar.
  const Urun({
    // "required": Bu Parametre Verilmek Zorunda. Unutulursa Kod Hata Verir.
    // "this.id": Gelen Değeri Doğrudan Yukarıdaki id Alanına Koy.
    required this.id,
    required this.baslik,
    required this.aciklama,
    required this.fiyat,
    required this.resimUrl,
    required this.kategori,
    required this.stokAdedi,
    // Zorunlu Değil. Verilmezse Varsayılan Değer false Olur
    // (Yeni Ürün Başta Favori Değildir).
    this.favoriMi = false,
    // Zorunlu Değil. Verilmezse 0 Puan, 0 Oy Kabul Edilir.
    // Dart'ta Varsayılan Değerlerin "const" (Sabit) Olması Gerekir;
    // Bu Yüzden Degerlendirme Sınıfının Kurucusu da const Tanımlanmıştır.
    this.degerlendirme = const Degerlendirme(puan: 0.0, oySayisi: 0),
  });

  // --------------------------------------------------------------------------
  // fromJson: İnternetten (API) Gelen Veriyi Urun Nesnesine Çevirir.
  // --------------------------------------------------------------------------
  // API'den Gelen Her Ürün Şöyle Bir JSON'dur:
  //   {
  //     "id": 1,
  //     "title": "Fjallraven Backpack",
  //     "price": 109.95,
  //     "description": "...",
  //     "category": "men's clothing",
  //     "image": "https://...",
  //     "rating": { "rate": 3.9, "count": 120 }
  //   }
  // Dart Bu Metni Okuyunca Bir Map (Sözlük) Elde Eder: json['title'] Gibi
  // Anahtarla Değere Ulaşılır.
  //
  // API İngilizce Anahtarlar Kullanıyor (title, price...), Modelimiz Türkçe
  // (baslik, fiyat...). Bu Metot İkisi Arasında Çevirmen Görevi Görür.
  // Böylece Uygulamanın Geri Kalanı API'nin Yapısını Hiç Bilmek Zorunda Kalmaz.
  //
  // "factory": Özel Bir Kurucu Türü. İçinde Önce Bazı İşlemler Yapıp
  // (Burada: Veriyi Okuyup Dönüştürmek) Sonra Nesne Döndürebilir.
  factory Urun.fromJson(Map<String, dynamic> json) {
    return Urun(
      // "as int": "Bu Değerin Tam Sayı Olduğundan Eminim" Demektir.
      // Eğer Değer Gerçekte Tam Sayı Değilse Program Burada Hata Verir.
      id: json['id'] as int,
      // API'deki "title" → Bizim Modeldeki baslik.
      baslik: json['title'] as String,
      // "num": Hem int Hem double'ı Kapsayan Sayı Tipi. API Bazen 10, Bazen
      // 10.5 Gönderebilir. toDouble() ile Her Durumda Ondalıklı Sayıya Çeviriyoruz.
      fiyat: (json['price'] as num).toDouble(),
      aciklama: json['description'] as String,
      // switch İfadesi: Bir Değeri Sırayla Seçeneklerle Karşılaştırır,
      // Eşleşen İlk Seçeneğin Sonucunu Döndürür. "=>" İşareti "Sonuç Şu Olsun" Demek.
      // API Kategorileri İngilizce Geldiği için Burada Kendi Enum'umuza Çeviriyoruz.
      kategori: switch (json['category']) {
        // "electronics" Gelirse → Kategori.elektronik
        'electronics' => Kategori.elektronik,
        // "||" Burada "Ya da" Demek: İki Değerden Biri Gelirse → Kategori.giyim
        "men's clothing" || "women's clothing" => Kategori.giyim,
        // Takı (jewelery) için Ayrı Kategorimiz Yok; En Yakını Aksesuar.
        'jewelery' => Kategori.aksesuar,
        // "_" = "Yukarıdakilerin Hiçbiri Tutmazsa". API İleride Yeni Bir
        // Kategori Eklese Bile Uygulama Çökmez; Ürün "Tümü" Altında Görünür.
        _ => Kategori.hepsi,
      },
      // API'deki "image" → Bizim Modeldeki resimUrl.
      resimUrl: json['image'] as String,
      // "koşul ? A : B" Yazımına Ternary Operatör Denir: Koşul Doğruysa A,
      // Yanlışsa B Kullanılır. Kısa Bir if-else Gibi Düşünün.
      // "!= null": "Boş Değilse". Yani "rating" Alanı Geldiyse İçindeki
      // Sözlüğü Degerlendirme.fromJson ile Modele Çevir; Gelmediyse 0 Puan Kullan.
      degerlendirme: json['rating'] != null
          ? Degerlendirme.fromJson(json['rating'] as Map<String, dynamic>)
          : const Degerlendirme(puan: 0.0, oySayisi: 0),
      // Favori Bilgisi API'den Gelmez; Kullanıcı Uygulama İçinde Seçer.
      // Bu Yüzden Her Ürün Başta Favori Değildir.
      favoriMi: false,
      // API "stock" Alanı Göndermiyor. Gönderirse Onu Kullan (as num? → ?.toInt()),
      // Göndermezse (null) -1 Kullan. -1 = "Stok Bilgisi Yok"; Bu Durumda
      // StokRozeti Hiç Gösterilmez. (0 Kullansaydık Her Ürün "Tükendi" Görünürdü.)
      stokAdedi: (json['stock'] as num?)?.toInt() ?? -1,
    );
  }

  // --------------------------------------------------------------------------
  // copyWith: "Kopyala Ama Şu Alanları Değiştir"
  // --------------------------------------------------------------------------
  // Alanlar final Olduğu için urun.favoriMi = true Yazamayız, Hata Verir.
  // Bunun Yerine, Diğer Her Şeyi Aynı Olan Ama İstediğimiz Alanı Değişmiş
  // YENİ Bir Ürün Üretiriz. Eski Ürün Olduğu Gibi Kalır.
  //
  // Örnek Kullanım:
  //   final yeni = urun.copyWith(favoriMi: true);
  //   → yeni Ürünün Her Şeyi urun ile Aynı, Sadece favoriMi true.
  Urun copyWith({
    // Tipin Sonundaki "?" = Nullable: Bu Değer null (Boş) Olabilir.
    // Hangi Parametre Verilmezse O null Kalır ve "Bu Alanı Değiştirme" Anlamına Gelir.
    int? id,
    String? baslik,
    String? aciklama,
    double? fiyat,
    String? resimUrl,
    Kategori? kategori,
    int? stokAdedi,
    bool? favoriMi,
    // Modele Yeni Bir Alan Eklendiğinde copyWith'e de Eklenmeli;
    // Yoksa Kopyalama Sırasında O Alan Varsayılan Değerine Döner.
    Degerlendirme? degerlendirme,
  }) {
    // Yepyeni Bir Urun Nesnesi Oluşturup Döndürüyoruz.
    return Urun(
      // "??" Operatörü: Soldaki Değer null İse Sağdakini Kullan.
      // Yani: Yeni Bir id Verildiyse Onu, Verilmediyse Mevcut id'yi (this.id) Al.
      // "this.id" Bu Nesnenin Kendi id'si; Sadece "id" Ise Parametre Olarak Gelen.
      id: id ?? this.id,
      baslik: baslik ?? this.baslik,
      aciklama: aciklama ?? this.aciklama,
      fiyat: fiyat ?? this.fiyat,
      resimUrl: resimUrl ?? this.resimUrl,
      kategori: kategori ?? this.kategori,
      stokAdedi: stokAdedi ?? this.stokAdedi,
      favoriMi: favoriMi ?? this.favoriMi,
      degerlendirme: degerlendirme ?? this.degerlendirme,
    );
  }

  // --------------------------------------------------------------------------
  // toString: Nesnenin Metin Hali
  // --------------------------------------------------------------------------
  // Dart'ta Her Sınıfın Gizli Bir toString Metodu Vardır. print(urun) Yazınca
  // Varsayılan Olarak Sadece "Instance of 'Urun'" Yazar; Bu Pek İşe Yaramaz.
  // @override ile Bu Metodu Değiştirip Okunaklı Bir Çıktı Veriyoruz.
  // Hata Ayıklarken (Debug) Çok İşe Yarar.
  @override
  String toString() {
    // "$id" Yazımı, id Değişkeninin Değerini Metnin İçine Yerleştirir
    // (Buna "String Interpolation" Denir).
    // "\$" İse Düz Bir Dolar İşareti Yazar; Başına \ Konmasa Dart Onu
    // Değişken Başlangıcı Sanardı.
    return 'Urun(id: $id, baslik: $baslik, fiyat: $fiyat \$, favoriMi: $favoriMi)';
  }
}
