// ============================================================================
// kategori.dart → Ürün Kategorilerinin Listesi
// ----------------------------------------------------------------------------
// "enum" (Enumeration = Sayım), Önceden Belirlenmiş, Sınırlı Sayıda Seçenekten
// Oluşan Bir Tiptir. Haftanın Günleri, Trafik Lambası Renkleri Gibi Düşünün:
// Seçenekler Bellidir, Dışında Bir Değer Olamaz.
//
// Neden String ("elektronik") Yerine Enum Kullanıyoruz?
//   - String Kullansaydık "elektronık" Gibi Bir Yazım Hatası Yapabilirdik
//     ve Program Bunu Fark Etmezdi. Ürün Hiçbir Kategoride Görünmezdi.
//   - Enum Kullanınca Sadece Tanımlı Değerler Yazılabilir. Yanlış Yazarsanız
//     Kod Çalışmadan Önce (Derleme Anında) Hata Verir.
//   - Editör, "Kategori." Yazınca Tüm Seçenekleri Size Listeler.
// ============================================================================

// Bu Enum'un Her Değeri Ayrıca Kendi Bilgilerini Taşıyor (Başlık ve İkon).
// Buna "Enhanced Enum" (Geliştirilmiş Enum) Denir; Dart 2.17 ile Geldi.
enum Kategori {
  // Her Değerin Yanındaki Parantezde İki Bilgi Var:
  //   1. Bilgi: Ekranda Görünecek Başlık (Örn: 'Tümü')
  //   2. Bilgi: Kategori Çipinin Solunda Görünecek Kısa İkon Metni (Örn: 'H')
  //
  // "hepsi" Gerçek Bir Ürün Kategorisi Değildir. Filtrede
  // "Hiçbir Kategori Ayrımı Yapma, Hepsini Göster" Anlamında Kullanılır.
  hepsi('Tümü', 'H'),
  elektronik('Elektronik', 'E'),
  giyim('Giyim', 'G'),
  ayakkabi('Ayakkabı', 'A'),
  // Normal Enum'larda Son Değerden Sonra Hiçbir Şey Yazılmaz.
  // Burada ";" Var, Çünkü Aşağıda Alanlar ve Kurucu Tanımlıyoruz.
  aksesuar('Aksesuar', 'AK');

  // "final": Bu Değişkene Bir Kez Değer Verilir, Sonra Değiştirilemez.
  // "String": Metin Tipi.
  // Kullanım Örneği: Kategori.giyim.baslik → "Giyim"
  final String baslik;
  // Kullanım Örneği: Kategori.giyim.ikon → "G"
  final String ikon;

  // Kurucu: Yukarıdaki Parantez İçindeki İki Değeri Alır ve Sırasıyla
  // baslik ile ikon Alanlarına Yerleştirir.
  // "this.baslik" Yazımı, "Gelen Değeri Doğrudan baslik Alanına Koy" Demenin Kısa Yolu.
  // Enum Kurucuları Her Zaman "const" (Sabit) Olmak Zorundadır.
  const Kategori(this.baslik, this.ikon);
}
