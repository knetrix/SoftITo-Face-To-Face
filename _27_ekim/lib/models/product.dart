import 'product_category.dart'; // category Field'ının Tipi Olan ProductCategory Enum'unu import Eder.
import 'rating.dart'; // rating Field'ının Tipi Olan Rating Class'ını import Eder.

class Product { // Tek Bir Ürünün Verisini Tutan Immutable Model Class'ıdır.
  final int id; // Ürünün Benzersiz id'sidir.
  final String title; // Ürünün Adıdır.
  final String description; // Ürünün Açıklamasıdır.
  final double price; // Ürünün Dolar Cinsinden Fiyatıdır.
  final String imageUrl; // Ürün Görselinin URL'idir.
  final ProductCategory category; // Ürünün Ait Olduğu Kategoridir.
  final int stockCount; // Stok Adedidir, -1 Stok Bilgisinin Olmadığını Belirtir.
  final bool isFavorite; // Ürünün Favoride Olup Olmadığını Tutar.
  final Rating rating; // Ürünün Puan ve Oy Sayısını Tutan İç İçe Modeldir.

  const Product({ // Field'ları Named Parametre Olarak Alan const Constructor'dır.
    required this.id, // id Field'ını required Yapar.
    required this.title, // title Field'ını required Yapar.
    required this.description, // description Field'ını required Yapar.
    required this.price, // price Field'ını required Yapar.
    required this.imageUrl, // imageUrl Field'ını required Yapar.
    required this.category, // category Field'ını required Yapar.
    required this.stockCount, // stockCount Field'ını required Yapar.
    this.isFavorite = false, // isFavorite Verilmezse Default Değer false Olur.
    this.rating = const Rating(score: 0.0, voteCount: 0), // rating Verilmezse 0 Puan ve 0 Oy Kullanır.
  });

  factory Product.fromJson(Map<String, dynamic> json) { // API'den Gelen JSON Map'inden Product Üreten factory Constructor'dır.
    return Product( // Okunan Değerlerle Yeni Bir Product Döndürür.
      id: json['id'] as int, // id Değerini int Olarak Okur.
      title: json['title'] as String, // title Değerini String Olarak Okur.
      price: (json['price'] as num).toDouble(), // price'ı num Olarak Okuyup double'a Çevirir.
      description: json['description'] as String, // description Değerini String Olarak Okur.
      category: switch (json['category']) { // API'deki category Metnini switch Expression İle Enum'a Çevirir.
        'electronics' => ProductCategory.electronics, // electronics Değerini electronics Kategorisine Eşler.
        "men's clothing" || "women's clothing" => ProductCategory.clothing, // İki Giyim Kategorisini de clothing'e Eşler.
        'jewelery' => ProductCategory.accessories, // jewelery Değerini accessories Kategorisine Eşler.
        _ => ProductCategory.all, // Bilinmeyen Kategoriyi all'a Eşleyerek Uygulamanın Çökmesini Önler.
      },
      imageUrl: json['image'] as String, // JSON'daki image Değerini imageUrl Olarak Okur.
      rating: json['rating'] != null // rating Alanının Gelip Gelmediğini Kontrol Eder.
          ? Rating.fromJson(json['rating'] as Map<String, dynamic>) // rating Varsa İç İçe JSON'u Rating'e Çevirir.
          : const Rating(score: 0.0, voteCount: 0), // rating Yoksa 0 Puan ve 0 Oy Kullanır.
      isFavorite: false, // Favori Bilgisi API'den Gelmediği İçin false Başlar.
      stockCount: (json['stock'] as num?)?.toInt() ?? -1, // stock Yoksa Stok Bilgisinin Olmadığını Belirten -1 Kullanır.
    );
  }

  Product copyWith({ // Seçilen Field'ları Değiştirilmiş Yeni Bir Product Kopyası Üretir.
    int? id, // Yeni id Değeridir, null İse Mevcut Değer Korunur.
    String? title, // Yeni title Değeridir.
    String? description, // Yeni description Değeridir.
    double? price, // Yeni price Değeridir.
    String? imageUrl, // Yeni imageUrl Değeridir.
    ProductCategory? category, // Yeni category Değeridir.
    int? stockCount, // Yeni stockCount Değeridir.
    bool? isFavorite, // Yeni isFavorite Değeridir.
    Rating? rating, // Yeni rating Değeridir.
  }) {
    return Product( // Birleştirilmiş Değerlerle Yeni Bir Product Döndürür.
      id: id ?? this.id, // Yeni id null İse Mevcut id'yi Kullanır.
      title: title ?? this.title, // Yeni title null İse Mevcut title'ı Kullanır.
      description: description ?? this.description, // Yeni description null İse Mevcut Değeri Kullanır.
      price: price ?? this.price, // Yeni price null İse Mevcut price'ı Kullanır.
      imageUrl: imageUrl ?? this.imageUrl, // Yeni imageUrl null İse Mevcut Değeri Kullanır.
      category: category ?? this.category, // Yeni category null İse Mevcut category'yi Kullanır.
      stockCount: stockCount ?? this.stockCount, // Yeni stockCount null İse Mevcut Değeri Kullanır.
      isFavorite: isFavorite ?? this.isFavorite, // Yeni isFavorite null İse Mevcut Değeri Kullanır.
      rating: rating ?? this.rating, // Yeni rating null İse Mevcut rating'i Kullanır.
    );
  }

  @override // Object Class'ındaki toString Metodunun Override Edildiğini Belirtir.
  String toString() { // Debug Sırasında Okunaklı Çıktı Veren String Temsilini Döndürür.
    return 'Product(id: $id, title: $title, price: $price \$, isFavorite: $isFavorite)'; // String Interpolation İle Field'ları Metne Yerleştirir.
  }
}
