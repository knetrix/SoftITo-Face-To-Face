// enum: Sabit, Sınırlı Sayıda Seçenekten Oluşan Bir Küme.
// Kategoriyi String Yerine Enum Yapmak, Yazım Hatalarını Derleme Anında Engeller.
// Bu Yapıya "Enhanced Enum" Denir: Her Değer Kendi Alanlarını Taşıyabilir.
enum Kategori {
  // Her Değer İki Bilgi Taşır: (Ekranda Görünecek Başlık, Çipte Gösterilecek Kısa İkon Metni).
  // "hepsi" Gerçek Bir Kategori Değil; Filtrede "Ayrım Yapma" Anlamında Kullanılır.
  hepsi('Tümü', 'H'),
  elektronik('Elektronik', 'E'),
  giyim('Giyim', 'G'),
  ayakkabi('Ayakkabı', 'A'),
  // Son Değerden Sonra ";" Gelir, Çünkü Aşağıda Alanlar ve Kurucu Tanımlanıyor.
  aksesuar('Aksesuar', 'AK');

  // Her Enum Değerinin Taşıdığı Başlık (Örn: Kategori.giyim.baslik → "Giyim").
  final String baslik;
  // Her Enum Değerinin Taşıdığı Kısa İkon Metni.
  final String ikon;

  // Yukarıdaki Parantez İçindeki Değerleri Bu Alanlara Atayan Sabit (const) Kurucu.
  const Kategori(this.baslik, this.ikon);
}
