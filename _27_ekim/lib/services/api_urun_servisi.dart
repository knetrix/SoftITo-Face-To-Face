// ============================================================================
// api_urun_servisi.dart → İnternetten Ürün Çeken Servis
// ----------------------------------------------------------------------------
// "API" (Application Programming Interface), Bir Sunucunun Dışarıya Veri
// Verdiği Kapıdır. Bir Adrese İstek Atarsınız, Sunucu Size Veri Gönderir.
//
// Bu Servis https://fakestoreapi.com/products Adresine İstek Atıyor.
// Bu Adres, Eğitim Amaçlı Hazırlanmış Ücretsiz Bir Sahte Mağaza API'si;
// 20 Ürünü JSON Formatında Döndürüyor. Tarayıcıda Açıp Görebilirsiniz.
//
// Akış:
//   1) http Paketi ile Adrese İstek At.
//   2) Gelen Cevap Metnini (JSON) Dart Listesine Çevir.
//   3) Listedeki Her Elemanı Urun.fromJson ile Urun Nesnesine Dönüştür.
// ============================================================================

// "dart:" ile Başlayan Kütüphaneler Dart'ın Kendi İçinde Gelir.
// dart:convert İçindeki jsonDecode, JSON Metnini Dart Nesnelerine Çevirir.
import 'dart:convert';

// http Paketi: İnternete İstek Atmak için Kullanılan Resmi Dart Paketi.
// pubspec.yaml Dosyasına Eklendiği için Kullanabiliyoruz.
// "as http": Paketin Fonksiyonlarına "http." Ön Ekiyle Ulaşırız (http.get Gibi).
// Böylece Kodu Okuyan Kişi get Fonksiyonunun Nereden Geldiğini Hemen Anlar.
import 'package:http/http.dart' as http;

import '../models/kategori.dart';
import '../models/urun.dart';
import 'i_urun_servisi.dart';

// "implements IUrunServisi": Bu Sınıf, Sözleşmedeki Üç Metodu Yazacağına
// Söz Veriyor. MockUrunServisi de Aynı Sözü Verdiği için Ekran İkisini
// Aynı Şekilde Kullanabiliyor.
class ApiUrunServisi implements IUrunServisi {
  // İstek Atılacak Adres.
  // "static": Bu Değer Nesneye Değil, Sınıfın Kendisine Aittir.
  //           Kaç Tane ApiUrunServisi Oluşturulursa Oluşturulsun Tek Kopya Vardır.
  // "const": Değeri Hiç Değişmeyen Sabit.
  // "_" ile Başlayan İsim: Sadece Bu Dosyanın İçinden Erişilebilir (Private).
  static const _url = 'https://fakestoreapi.com/products';

  // @override: Sözleşmedeki (IUrunServisi) Metodu Burada Yazıyoruz.
  // "async": Bu Metot İçinde "await" Kullanılabilir ve Sonuç Future Olarak Döner.
  @override
  Future<List<Urun>> tumUrunleriGetir() async {
    // Uri.parse: Metin Halindeki Adresi, http Paketinin Anladığı Uri Nesnesine Çevirir.
    // http.get: Adrese GET İsteği Atar ("Bana Veri Gönder" İsteği).
    // "await": Cevap Gelene Kadar Bu Satırda Bekle, Sonra Devam Et.
    // Beklerken Uygulama Donmaz; Ekran Çizilmeye Devam Eder.
    // .timeout: Sunucu 10 Saniye İçinde Cevap Vermezse Beklemeyi Bırak ve
    // TimeoutException Fırlat. Olmasaydı Sunucu Hiç Cevap Vermediğinde
    // Yükleniyor Çemberi Çok Uzun Süre Dönerdi. Bu Hata da 200 Dışı Cevaplar
    // Gibi Ekrandaki try/catch Bloğuna Düşer.
    final cevap = await http
        .get(Uri.parse(_url))
        .timeout(const Duration(seconds: 10));

    // statusCode: Sunucunun Cevap Kodu.
    //   200 = Başarılı
    //   404 = Adres Bulunamadı
    //   500 = Sunucu Hatası
    // Başarılı Değilse "throw" ile Hata Fırlatıyoruz. Bu Hatayı Ekrandaki
    // try/catch Bloğu Yakalayıp Kullanıcıya Mesaj Gösteriyor.
    if (cevap.statusCode != 200) {
      throw Exception('Ürünler Alınamadı: ${cevap.statusCode}');
    }

    // cevap.body: Sunucunun Gönderdiği Ham Metin (JSON).
    // jsonDecode: Bu Metni Dart Nesnesine Çevirir. Gelen Veri Bir Liste
    // Olduğu için "as List" Diyerek Tipini Belirtiyoruz.
    final liste = jsonDecode(cevap.body) as List;

    // map: Listedeki HER Elemana Aynı İşlemi Uygular ve Sonuçlardan Yeni Bir
    // Liste Üretir. Burada Her JSON Elemanını Urun.fromJson ile Urun'a Çeviriyoruz.
    // "(json) => ..." Kısa Fonksiyon Yazımıdır: "json Alır, Sağdakini Döndürür."
    // toList: map'in Sonucunu Gerçek Bir Listeye Çevirir.
    return liste
        .map((json) => Urun.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  // Verilen Kategorideki Ürünleri Getirir.
  // Ana Ekran, Açılışta ve Her Kategori Çipine Basıldığında Bu Metodu Çağırır.
  //
  // API'nin Kategoriye Göre Ürün Veren Bir Adresi Var, Ama İngilizce Kategori
  // Adı İstiyor ve Bizim "Giyim" Kategorimiz API'de İki Ayrı Kategoriye Denk Geliyor.
  // Basit Olsun Diye Tüm Ürünleri Çekiyoruz, Sonra Kategorisi Eşleşenleri Ayıklıyoruz.
  @override
  Future<List<Urun>> kategoriyeGoreGetir(Kategori kategori) async {
    final urunler = await tumUrunleriGetir();
    // "Tümü" Seçildiyse Süzmeden Hepsini Döndür.
    if (kategori == Kategori.hepsi) return urunler;
    // where: Koşulu Sağlayan Elemanları Seçer. Burada: Kategorisi Eşleşenler.
    return urunler.where((urun) => urun.kategori == kategori).toList();
  }

  // Başlığında Ya da Açıklamasında Aranan Metin Geçen Ürünleri Getirir.
  // Ana Ekran, Arama Kutusuna Yazı Yazılınca (Yazma Bitince) Bu Metodu Çağırır.
  //
  // Bu API'de Arama Özelliği Yok; Bu Yüzden Tüm Ürünleri Çekip Uygulama
  // İçinde Arıyoruz.
  @override
  Future<List<Urun>> adaGoreAra(String aramaMetni) async {
    // trim: Baştaki ve Sondaki Boşlukları Siler.
    // toLowerCase: Tüm Harfleri Küçültür. Böylece "Ceket" ile "ceket" Eşleşir.
    final aranan = aramaMetni.trim().toLowerCase();
    final urunler = await tumUrunleriGetir();
    // contains: Metnin İçinde Aranan Parça Geçiyor Mu?
    // "||" = "veya": Başlıkta Ya da Açıklamada Geçmesi Yeterli.
    return urunler
        .where(
          (urun) =>
              urun.baslik.toLowerCase().contains(aranan) ||
              urun.aciklama.toLowerCase().contains(aranan),
        )
        .toList();
  }
}
