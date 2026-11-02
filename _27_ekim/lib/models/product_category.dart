enum ProductCategory { // Ürün Kategorilerini Sabit Değerler Olarak Tutan Enhanced Enum'dur.
  all('Tümü', 'H'), // Filtre Uygulanmadığını Belirten "Tümü" Değeridir.
  electronics('Elektronik', 'E'), // Elektronik Kategorisidir.
  clothing('Giyim', 'G'), // Giyim Kategorisidir.
  shoes('Ayakkabı', 'A'), // Ayakkabı Kategorisidir.
  accessories('Aksesuar', 'AK'); // Aksesuar Kategorisidir, Sondaki ; Değer Listesini Bitirir.

  final String title; // Ekranda Görünen Kategori Başlığıdır.
  final String icon; // Chip'in Solunda Görünen Kısa İkon Metnidir.

  const ProductCategory(this.title, this.icon); // title ve icon Field'larını Dolduran const Constructor'dır.
}
