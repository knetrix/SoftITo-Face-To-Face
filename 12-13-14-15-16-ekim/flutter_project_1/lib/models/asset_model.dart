class Asset { // Tek Bir Kripto Varlığın Verisini Tutan Model Class'ıdır.
  final String symbol; // Varlığın Kısa Sembolüdür (Örn: BTC).
  final String name; // Varlığın Tam Adıdır.
  final double price; // Varlığın Güncel Fiyatıdır.
  final double change24h; // Son 24 Saatteki Yüzdesel Değişimdir.
  final double balance; // Kullanıcının Sahip Olduğu Varlık Miktarıdır.

  const Asset({
    required this.symbol, // symbol Field'ını required Yapar.
    required this.name, // name Field'ını required Yapar.
    required this.price, // price Field'ını required Yapar.
    required this.change24h, // change24h Field'ını required Yapar.
    required this.balance, // balance Field'ını required Yapar.
  });
}
