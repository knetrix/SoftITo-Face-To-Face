import '../models/product_category.dart'; // Metot Parametresinde Kullanılan ProductCategory Enum'unu import Eder.
import '../models/product.dart'; // Dönüş Tipinde Kullanılan Product Class'ını import Eder.

abstract class IProductService { // Ürün Servislerinin Uyması Gereken abstract Interface'tir.
  Future<List<Product>> getAllProducts(); // Tüm Ürünleri Future<List<Product>> Olarak Döndüren Metodu Tanımlar.

  Future<List<Product>> getByCategory(ProductCategory category); // Verilen Kategorideki Ürünleri Döndüren Metodu Tanımlar.

  Future<List<Product>> searchByName(String query); // title veya description'da query Geçen Ürünleri Döndüren Metodu Tanımlar.
}
