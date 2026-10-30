// ============================================================================
// i_urun_servisi.dart → Ürün Servisi Sözleşmesi (Interface)
// ----------------------------------------------------------------------------
// "Servis", Veriyi Bir Yerden Getiren Sınıftır (İnternet, Veritabanı, Dosya...).
// Bu Dosya İse Bir Servisin Kendisi Değil, Bir SÖZLEŞME.
//
// Günlük Hayattan Örnek: Bir Prize Hangi Cihazı Takarsanız Takın Çalışır,
// Çünkü Hepsi Aynı Fiş Standardına Uyar. Bu Sözleşme de O "Fiş Standardı".
// Bu Sözleşmeye Uyan Her Servis, Ekrana Hiçbir Değişiklik Yapmadan Takılabilir.
//
// Projede Bu Sözleşmeye Uyan İki Servis Var:
//   - MockUrunServisi: Kodun İçine Yazılmış Sahte Ürünler.
//   - ApiUrunServisi : İnternetten (Fake Store API) Çekilen Gerçek Ürünler.
// Ekran Bunların Hangisi Olduğunu Umursamaz; Sadece Sözleşmeyi Tanır.
// Bu Yaklaşıma "Dependency Inversion" (Bağımlılığı Soyutlamaya Yapmak) Denir.
//
// İsmin Başındaki "I" Harfi "Interface" Kelimesinden Gelir; Yaygın Bir Alışkanlık.
// ============================================================================

// Metotların Parametre ve Dönüş Tiplerinde Kullanılan Modeller.
import '../models/kategori.dart';
import '../models/urun.dart';

// "abstract class": Soyut Sınıf. Bu Sınıftan Doğrudan Nesne Oluşturulamaz
// (IUrunServisi() Yazılamaz). Sadece Şablon Görevi Görür.
// Aşağıdaki Metotların Gövdesi ({ ... } Kısmı) Yok; Sadece İsimleri ve
// Tipleri Var. Gövdeyi Bu Sözleşmeyi Uygulayan Sınıflar Yazmak Zorunda.
abstract class IUrunServisi {
  // "Future": Sonucun HEMEN Değil, İLERİDE Geleceğini Belirtir.
  // İnternetten Veri Çekmek Zaman Alır; Uygulama Bu Sırada Donmasın Diye
  // Sonuç Bir "Söz" (Future) Olarak Döner. Veri Gelince Söz Yerine Getirilir.
  // "Future<List<Urun>>": İleride Bir Ürün Listesi Gelecek Demek.
  //
  // Tüm Ürünleri Getirir.
  Future<List<Urun>> tumUrunleriGetir();

  // Sadece Verilen Kategorideki Ürünleri Getirir.
  // Örn: kategoriyeGoreGetir(Kategori.giyim) → Sadece Giyim Ürünleri.
  Future<List<Urun>> kategoriyeGoreGetir(Kategori kategori);

  // Başlığında Ya da Açıklamasında Arama Metni Geçen Ürünleri Getirir.
  // Örn: adaGoreAra("ayakkabı") → Adında Ya da Açıklamasında "ayakkabı" Geçen Ürünler.
  Future<List<Urun>> adaGoreAra(String aramaMetni);
}
