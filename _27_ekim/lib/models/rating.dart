class Rating { // Ürünün Puan Bilgisini Tutan Model Class'ıdır.
  final double score; // Ürünün Ortalama Puanıdır.
  final int voteCount; // Ürüne Verilen Oy Sayısıdır.

  const Rating({required this.score, required this.voteCount}); // İki Field'ı da required Alan const Constructor'dır.

  factory Rating.fromJson(Map<String, dynamic> json) { // JSON Map'inden Rating Üreten factory Constructor'dır.
    return Rating( // Okunan Değerlerle Yeni Bir Rating Döndürür.
      score: (json['rate'] as num?)?.toDouble() ?? 0.0, // rate'i double'a Çevirir, null İse 0.0 Kullanır.
      voteCount: (json['count'] as num?)?.toInt() ?? 0, // count'u int'e Çevirir, null İse 0 Kullanır.
    );
  }
}
