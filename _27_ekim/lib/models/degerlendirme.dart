// ============================================================================
// degerlendirme.dart → Ürün Puanı Modeli
// ----------------------------------------------------------------------------
// "Model" Bir Verinin Hangi Parçalardan Oluştuğunu Tarif Eden Sınıftır.
// Bu Model, Bir Ürüne Kullanıcıların Verdiği Puanı Tutar:
//   - Ortalama Puan (Örn: 4.5 Yıldız)
//   - Kaç Kişinin Oy Verdiği (Örn: 120 Kişi)
//
// Bu Sınıf Tek Başına Kullanılmaz; Urun Modelinin İçinde Bir Alan Olarak Durur.
// Bir Modelin İçinde Başka Bir Model Olmasına "İç İçe Model" Denir.
// API'den Gelen Veri de Aynı Şekilde İç İçedir:
//   { "id": 1, "title": "...", "rating": { "rate": 4.5, "count": 120 } }
// ============================================================================

class Degerlendirme {
  // "double": Ondalıklı Sayı Tipi (Örn: 4.5, 3.9).
  final double puan;
  // "int": Tam Sayı Tipi (Örn: 120). Oy Sayısı Ondalıklı Olamaz.
  final int oySayisi;

  // Kurucu (Constructor): Bu Sınıftan Nesne Üretirken Çalışır.
  // Süslü Parantez { } İçindeki Parametreler "İsimli Parametre"dir. Yani
  // Değer Verirken Adını Yazarız: Degerlendirme(puan: 4.5, oySayisi: 120)
  // "required": Bu Parametre Verilmek Zorunda; Unutulursa Kod Hata Verir.
  // "const": Değerleri Önceden Belli Olan Nesneler Sabit Olarak Oluşturulabilir.
  // Urun Modelindeki Varsayılan Değer için Bu const Kurucu Gerekli.
  const Degerlendirme({required this.puan, required this.oySayisi});

  // ---------------------------------------------------------------------------
  // fromJson: İnternetten Gelen JSON Verisini Degerlendirme Nesnesine Çevirir.
  // ---------------------------------------------------------------------------
  // JSON Nedir? İnternette Veri Taşımak için Kullanılan Metin Formatı.
  // Dart'ta JSON Okunduğunda Bir "Map" (Sözlük) Haline Gelir:
  //   { "rate": 4.5, "count": 120 }  →  json['rate'] = 4.5, json['count'] = 120
  //
  // "factory": Özel Bir Kurucu Türü. Normal Kurucudan Farkı, İçinde Önce Bazı
  // İşlemler Yapıp (Burada: Veriyi Okuyup Dönüştürmek) Sonra Nesne Döndürebilmesi.
  //
  // Map<String, dynamic>: Anahtarları Metin (String), Değerleri Herhangi Bir
  // Tipte (dynamic) Olabilen Sözlük. JSON'daki Değerlerin Tipi Önceden
  // Bilinmediği için "dynamic" Kullanılır.
  factory Degerlendirme.fromJson(Map<String, dynamic> json) {
    return Degerlendirme(
      // Bu Satırı Parça Parça Okuyalım:
      //   json['rate']  → Sözlükten "rate" Anahtarının Değerini Al.
      //   as num?       → Bu Değer Bir Sayıdır (num = int Ya da double Olabilir).
      //                   Sondaki "?" İşareti: Değer Hiç Gelmeyebilir (null Olabilir).
      //   ?.toDouble()  → Değer Varsa Ondalıklı Sayıya Çevir. Değer null İse
      //                   Hiçbir Şey Yapma, Sonuç Yine null Olsun (Program Çökmesin).
      //   ?? 0.0        → Sonuç null İse Yerine 0.0 Kullan.
      // Kısacası: "Puan Geldiyse Onu Al, Gelmediyse 0 Kabul Et."
      puan: (json['rate'] as num?)?.toDouble() ?? 0.0,
      // Aynı Mantık: "count" Değerini Tam Sayıya (toInt) Çevir, Yoksa 0 Kabul Et.
      oySayisi: (json['count'] as num?)?.toInt() ?? 0,
    );
  }
}
