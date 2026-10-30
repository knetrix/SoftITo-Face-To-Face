// ============================================================================
// mock_urun_servisi.dart → Uygulamanın Kendi (Sahte) Ürünleri
// ----------------------------------------------------------------------------
// "Mock" İngilizcede "Taklit" Demektir. Bu Servis Ürünleri İnternetten
// Çekmez; Ürünler Doğrudan Kodun İçine Yazılmıştır.
//
// Neden Böyle Bir Servis Var?
//   - Proje Başlarken Henüz Bir Sunucu (Backend) Yoktu. Ekranı Geliştirip
//     Denemek için Sahte Verilere İhtiyaç Vardı.
//   - İnternet Olmadan da Uygulamanın Çalıştığını Görmeyi Sağlar.
//   - Şu An Ekranda API Ürünleriyle Birlikte Gösteriliyor.
//
// Gerçek Bir Sunucu Gibi Davranması için Cevap Vermeden Önce Biraz Bekliyor
// (Ağ Gecikmesi Taklidi).
// ============================================================================

// Ürünleri Oluşturmak için Gereken Modeller.
import '../models/kategori.dart';
import '../models/urun.dart';
// Uyacağımız Sözleşme (Interface).
import 'i_urun_servisi.dart';

// "implements IUrunServisi": Sözleşmedeki TÜM Metotları Yazmak Zorundayız.
// Birini Unutursak Kod Hata Verir.
class MockUrunServisi implements IUrunServisi {
  // Ürünlerin Tutulduğu Liste ("Depo").
  // "_" ile Başlayan İsimler Sadece Bu Dosyanın İçinden Kullanılabilir (Private).
  // Dışarıdan Kimse Bu Listeye Doğrudan Erişip Değiştiremez.
  //
  // "const [ ... ]": Sabit Liste. İçindeki Urun Nesneleri de Sabittir ve
  // Liste Hiçbir Şekilde Değiştirilemez (Eleman Eklenemez, Silinemez).
  //
  // Toplam 8 Ürün Var: Her Kategoriden 2 Tane.
  // Fiyatlar API ile Uyumlu Olsun Diye Dolar Cinsinden.
  //
  // id'ler 101'den Başlıyor, Çünkü API Ürünlerinin id'leri 1-20 Arası.
  // Favori İşlemi Ürünü id ile Bulduğu için Aynı id İki Ürüne Verilirse
  // Birini Favorilemek Diğerini Değiştirirdi.
  final List<Urun> _urunDeposu = const [
    Urun(
      id: 101,
      baslik: "Macbook M5 Pro Laptop",
      aciklama: "Apple'ın en güçlü işlemcisine sahip yeni nesil Macbook Pro",
      fiyat: 3999.99,
      // picsum.photos: Rastgele Test Resmi Veren Ücretsiz Bir Site.
      // /400/400 = 400x400 Piksel Resim. Sondaki "?1", "?2"... Her Ürüne
      // Farklı Bir Resim Gelmesini Sağlar.
      resimUrl: "https://picsum.photos/400/400?1",
      kategori: Kategori.elektronik,
      stokAdedi: 5,
      // favoriMi ve degerlendirme Verilmedi → Varsayılan Değerlerini Alırlar
      // (Favori Değil, 0 Puan). Diğer Ürünler de Aynı Yapıda.
    ),
    Urun(
      id: 102,
      baslik: "Apple iPhone 18 Pro Max",
      aciklama: "iPhone 18 Pro Max. Tıpkı iPhone 17 gibi, hem iPhone'larda hem de akıllı saatlerde kullanılan daha dayanıklı titanyumdan üretildi. Ayrıca iPhone 18 Pro Max, iPhone 17 Pro'dan daha fazla pil ömrü, daha güçlü bir kamera sistemi ve yeni kişiselleştirme seçenekleriyle geliyor.",
      fiyat: 1599.99,
      resimUrl: "https://picsum.photos/400/400?2",
      kategori: Kategori.elektronik,
      stokAdedi: 145,
    ),
    Urun(
      id: 103,
      baslik: "Oversize Pamuklu Kapüşonlu Sweatshirt",
      aciklama: "%100 pamuklu kumaştan üretilen, içi polarlı ve soğuk havalarda sıcak tutan rahat kesim sweatshirt.",
      fiyat: 39.90,
      resimUrl: "https://picsum.photos/400/400?3",
      kategori: Kategori.giyim,
      stokAdedi: 50,
    ),
    Urun(
      id: 104,
      baslik: "Klasik Slim Fit Denim Pantolon",
      aciklama: "Esnek likralı kumaş yapısı sayesinde gün boyu maksimum konfor sağlayan modern kesim kot pantolon.",
      fiyat: 49.50,
      resimUrl: "https://picsum.photos/400/400?4",
      kategori: Kategori.giyim,
      stokAdedi: 32,
    ),
    Urun(
      id: 105,
      baslik: "Air Cushion Koşu Ayakkabısı",
      aciklama: "Nefes alabilen file yüzey ve darbe emici hava tabanı ile spor ve günlük kullanım için mükemmel tercih.",
      fiyat: 119.00,
      resimUrl: "https://picsum.photos/400/400?5",
      kategori: Kategori.ayakkabi,
      stokAdedi: 18,
    ),
    Urun(
      id: 106,
      baslik: "Hakiki Deri Klasik Bağcıklı Ayakkabı",
      aciklama: "Özel el işçiliği birinci sınıf hakiki deriden üretilen, şık takım elbiselerin tamamlayıcısı erkek ayakkabı.",
      fiyat: 129.00,
      resimUrl: "https://picsum.photos/400/400?6",
      kategori: Kategori.ayakkabi,
      stokAdedi: 12,
    ),
    Urun(
      id: 107,
      baslik: "Polarize UV400 Güneş Gözlüğü",
      aciklama: "Hafif metal çerçeve, parlamayı önleyen polarize camlar ve %100 UV filtreli şık tasarım.",
      fiyat: 24.90,
      resimUrl: "https://picsum.photos/400/400?7",
      kategori: Kategori.aksesuar,
      stokAdedi: 65,
    ),
    Urun(
      id: 108,
      baslik: "Çelik Hasır Kordonlu Klasik Kol Saati",
      aciklama: "Su geçirmez paslanmaz çelik gövde, safir cam ve şık hasır kordonuyla zamansız bir aksesuar.",
      fiyat: 159.90,
      resimUrl: "https://picsum.photos/400/400?8",
      kategori: Kategori.aksesuar,
      stokAdedi: 24,
    ),
  ];

  // --------------------------------------------------------------------------
  // Sözleşmedeki Metotları Burada Yazıyoruz (@override).
  // --------------------------------------------------------------------------

  // Tüm Ürünleri Getirir.
  // "async": Bu Metot İçinde "await" Kullanılabilir. Sonuç Hemen Değil,
  // İleride Gelir; Bu Yüzden Dönüş Tipi Future<...>.
  @override
  Future<List<Urun>> tumUrunleriGetir() async {
    // Future.delayed: Belirtilen Süre Kadar Bekler.
    // "await": Bekleme Bitene Kadar Bir Sonraki Satıra Geçme.
    // 1500 Milisaniye = 1,5 Saniye. Gerçek Bir İnternet İsteğinin Süresini
    // Taklit Eder; Böylece Ekrandaki "Yükleniyor" Animasyonunu Görebiliriz.
    await Future.delayed(const Duration(milliseconds: 1500));
    // Listenin Kendisi Değil KOPYASI Döndürülür. Neden?
    // _urunDeposu Sabit (const) Bir Liste ve Değiştirilemez. Ekran İse Favori
    // Güncellerken Listedeki Bir Ürünü Yenisiyle Değiştiriyor. Orijinal Liste
    // Verilseydi Program Hata Verirdi. List.from Değiştirilebilir Bir Kopya Üretir.
    return List.from(_urunDeposu);
  }

  // Verilen Kategorideki Ürünleri Getirir.
  // Ana Ekran, Açılışta ve Her Kategori Çipine Basıldığında Bu Metodu Çağırır.
  @override
  Future<List<Urun>> kategoriyeGoreGetir(Kategori kategori) async {
    // 400 Milisaniye Bekle (Ağ Gecikmesi Taklidi).
    await Future.delayed(const Duration(milliseconds: 400));
    // "Tümü" Seçildiyse Süzmeden Hepsini Döndür.
    if (kategori == Kategori.hepsi) {
      return List.from(_urunDeposu);
    }
    // where: Listedeki Her Elemana Koşulu Sorar, "Evet" Diyenleri Seçer.
    // "(urun) => urun.kategori == kategori": Kısa Fonksiyon Yazımı.
    // "Ürünü Al, Kategorisi Aranan Kategoriye Eşit Mi Söyle" Demek.
    // toList: Seçilenleri Gerçek Bir Listeye Çevirir.
    return _urunDeposu.where((urun) => urun.kategori == kategori).toList();
  }

  // Başlığında Ya da Açıklamasında Aranan Metin Geçen Ürünleri Getirir.
  // Ana Ekran, Arama Kutusuna Yazı Yazılınca (Yazma Bitince) Bu Metodu Çağırır.
  @override
  Future<List<Urun>> adaGoreAra(String aramaMetni) async {
    await Future.delayed(const Duration(milliseconds: 300));
    // trim: Baştaki ve Sondaki Boşlukları Siler. ("  ayakkabı " → "ayakkabı")
    // isEmpty: Metin Boş Mu? Arama Kutusu Boşsa Hepsini Döndür.
    if (aramaMetni.trim().isEmpty) {
      return List.from(_urunDeposu);
    }

    return _urunDeposu.where((urun) {
      // toLowerCase: Tüm Harfleri Küçültür. İki Metni de Küçültünce
      // "Saat" ile "saat" Aynı Kabul Edilir (Büyük/Küçük Harf Duyarsız Arama).
      final baslikKucuk = urun.baslik.toLowerCase();
      final aciklamaKucuk = urun.aciklama.toLowerCase();
      final arananKucuk = aramaMetni.trim().toLowerCase();
      // contains: Metnin İçinde Aranan Parça Geçiyor Mu? (true / false)
      // "||" = "veya": Başlıkta Ya da Açıklamada Geçmesi Yeterli.
      return baslikKucuk.contains(arananKucuk) ||
          aciklamaKucuk.contains(arananKucuk);
    }).toList();
  }
}
