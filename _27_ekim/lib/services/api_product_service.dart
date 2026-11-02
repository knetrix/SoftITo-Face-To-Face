import 'dart:convert'; // jsonDecode İçin dart:convert Library'sini import Eder.

import 'package:http/http.dart' as http; // HTTP Request Atmak İçin http Package'ını http Adıyla import Eder.

import '../models/product_category.dart'; // ProductCategory Enum'unu import Eder.
import '../models/product.dart'; // Product Class'ını import Eder.
import 'i_product_service.dart'; // Uyulacak IProductService Interface'ini import Eder.

class ApiProductService implements IProductService { // IProductService'i implement Edip Ürünleri Fake Store API'den Çeken Servistir.
  static const _url = 'https://fakestoreapi.com/products'; // API'nin Endpoint URL'idir.

  @override // Interface'teki Metodun Override Edildiğini Belirtir.
  Future<List<Product>> getAllProducts() async { // Tüm Ürünleri API'den async Olarak Getirir.
    final response = await http // HTTP Response'unu await İle Bekler.
        .get(Uri.parse(_url)) // URL'e GET Request Atar.
        .timeout(const Duration(seconds: 10)); // 10 Saniyede Cevap Gelmezse TimeoutException Fırlatır.

    if (response.statusCode != 200) { // Status Code 200 Değilse Bu Bloğa Girer.
      throw Exception('Ürünler Alınamadı: ${response.statusCode}'); // Hatayı Ekranda catch Edilmek Üzere Fırlatır.
    }

    final list = jsonDecode(response.body) as List; // Response body'sini Decode Edip List'e Cast Eder.

    return list // Decode Edilen List'i İşler.
        .map((json) => Product.fromJson(json as Map<String, dynamic>)) // Her Elemanı fromJson İle Product'a Map'ler.
        .toList(); // Sonucu List Olarak Döndürür.
  }

  @override // Interface'teki Metodun Override Edildiğini Belirtir.
  Future<List<Product>> getByCategory(ProductCategory category) async { // Verilen Kategorideki API Ürünlerini Döndürür.
    final products = await getAllProducts(); // Önce Tüm Ürünleri Çeker.
    if (category == ProductCategory.all) return products; // Kategori all İse Filtrelemeden Döndürür.
    return products.where((product) => product.category == category).toList(); // Kategorisi Eşleşen Ürünleri Uygulama Tarafında Filtreler.
  }

  @override // Interface'teki Metodun Override Edildiğini Belirtir.
  Future<List<Product>> searchByName(String query) async { // title veya description'da query Geçen API Ürünlerini Döndürür.
    final normalizedQuery = query.trim().toLowerCase(); // query'yi Temizleyip Küçük Harfe Çevirir.
    final products = await getAllProducts(); // API'de Arama Olmadığı İçin Tüm Ürünleri Çeker.
    return products // Çekilen Ürünleri Filtreler.
        .where( // Koşulu Sağlayan Ürünleri Seçer.
          (product) => // Her Ürün İçin Koşulu Değerlendirir.
              product.title.toLowerCase().contains(normalizedQuery) || // title query'yi İçeriyorsa true Döndürür.
              product.description.toLowerCase().contains(normalizedQuery), // Ya da description query'yi İçeriyorsa true Döndürür.
        )
        .toList(); // Seçilen Ürünleri List'e Çevirir.
  }
}
