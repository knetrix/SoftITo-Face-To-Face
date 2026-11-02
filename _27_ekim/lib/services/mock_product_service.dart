import '../models/product_category.dart'; // Ürünlerin Kategorisi İçin ProductCategory Enum'unu import Eder.
import '../models/product.dart'; // Product Class'ını import Eder.
import 'i_product_service.dart'; // Uyulacak IProductService Interface'ini import Eder.

class MockProductService implements IProductService { // IProductService'i implement Edip Kod İçindeki Sahte Ürünleri Döndüren Servistir.
  final List<Product> _productStore = const [ // 8 Mock Ürünü Tutan Private ve const List'tir.
    Product( // 1. Mock Ürün.
      id: 101, // API id'leriyle (1-20) Çakışmaması İçin 101'den Başlar.
      title: "Macbook M5 Pro Laptop", // Ürünün Adıdır.
      description: "Apple'ın en güçlü işlemcisine sahip yeni nesil Macbook Pro", // Ürünün Açıklamasıdır.
      price: 3999.99, // Dolar Cinsinden Fiyatıdır.
      imageUrl: "https://picsum.photos/400/400?1", // picsum'dan 400x400 Test Görseli URL'idir.
      category: ProductCategory.electronics, // Elektronik Kategorisindedir.
      stockCount: 5, // Stok Adedidir.
    ),
    Product( // 2. Mock Ürün.
      id: 102, // Ürünün id'sidir.
      title: "Apple iPhone 18 Pro Max", // Ürünün Adıdır.
      description: "iPhone 18 Pro Max. Tıpkı iPhone 17 gibi, hem iPhone'larda hem de akıllı saatlerde kullanılan daha dayanıklı titanyumdan üretildi. Ayrıca iPhone 18 Pro Max, iPhone 17 Pro'dan daha fazla pil ömrü, daha güçlü bir kamera sistemi ve yeni kişiselleştirme seçenekleriyle geliyor.", // Ürünün Açıklamasıdır.
      price: 1599.99, // Dolar Cinsinden Fiyatıdır.
      imageUrl: "https://picsum.photos/400/400?2", // Test Görseli URL'idir.
      category: ProductCategory.electronics, // Elektronik Kategorisindedir.
      stockCount: 145, // Stok Adedidir.
    ),
    Product( // 3. Mock Ürün.
      id: 103, // Ürünün id'sidir.
      title: "Oversize Pamuklu Kapüşonlu Sweatshirt", // Ürünün Adıdır.
      description: "%100 pamuklu kumaştan üretilen, içi polarlı ve soğuk havalarda sıcak tutan rahat kesim sweatshirt.", // Ürünün Açıklamasıdır.
      price: 39.90, // Dolar Cinsinden Fiyatıdır.
      imageUrl: "https://picsum.photos/400/400?3", // Test Görseli URL'idir.
      category: ProductCategory.clothing, // Giyim Kategorisindedir.
      stockCount: 50, // Stok Adedidir.
    ),
    Product( // 4. Mock Ürün.
      id: 104, // Ürünün id'sidir.
      title: "Klasik Slim Fit Denim Pantolon", // Ürünün Adıdır.
      description: "Esnek likralı kumaş yapısı sayesinde gün boyu maksimum konfor sağlayan modern kesim kot pantolon.", // Ürünün Açıklamasıdır.
      price: 49.50, // Dolar Cinsinden Fiyatıdır.
      imageUrl: "https://picsum.photos/400/400?4", // Test Görseli URL'idir.
      category: ProductCategory.clothing, // Giyim Kategorisindedir.
      stockCount: 32, // Stok Adedidir.
    ),
    Product( // 5. Mock Ürün.
      id: 105, // Ürünün id'sidir.
      title: "Air Cushion Koşu Ayakkabısı", // Ürünün Adıdır.
      description: "Nefes alabilen file yüzey ve darbe emici hava tabanı ile spor ve günlük kullanım için mükemmel tercih.", // Ürünün Açıklamasıdır.
      price: 119.00, // Dolar Cinsinden Fiyatıdır.
      imageUrl: "https://picsum.photos/400/400?5", // Test Görseli URL'idir.
      category: ProductCategory.shoes, // Ayakkabı Kategorisindedir.
      stockCount: 18, // Stok Adedidir.
    ),
    Product( // 6. Mock Ürün.
      id: 106, // Ürünün id'sidir.
      title: "Hakiki Deri Klasik Bağcıklı Ayakkabı", // Ürünün Adıdır.
      description: "Özel el işçiliği birinci sınıf hakiki deriden üretilen, şık takım elbiselerin tamamlayıcısı erkek ayakkabı.", // Ürünün Açıklamasıdır.
      price: 129.00, // Dolar Cinsinden Fiyatıdır.
      imageUrl: "https://picsum.photos/400/400?6", // Test Görseli URL'idir.
      category: ProductCategory.shoes, // Ayakkabı Kategorisindedir.
      stockCount: 12, // Stok Adedidir.
    ),
    Product( // 7. Mock Ürün.
      id: 107, // Ürünün id'sidir.
      title: "Polarize UV400 Güneş Gözlüğü", // Ürünün Adıdır.
      description: "Hafif metal çerçeve, parlamayı önleyen polarize camlar ve %100 UV filtreli şık tasarım.", // Ürünün Açıklamasıdır.
      price: 24.90, // Dolar Cinsinden Fiyatıdır.
      imageUrl: "https://picsum.photos/400/400?7", // Test Görseli URL'idir.
      category: ProductCategory.accessories, // Aksesuar Kategorisindedir.
      stockCount: 65, // Stok Adedidir.
    ),
    Product( // 8. Mock Ürün.
      id: 108, // Ürünün id'sidir.
      title: "Çelik Hasır Kordonlu Klasik Kol Saati", // Ürünün Adıdır.
      description: "Su geçirmez paslanmaz çelik gövde, safir cam ve şık hasır kordonuyla zamansız bir aksesuar.", // Ürünün Açıklamasıdır.
      price: 159.90, // Dolar Cinsinden Fiyatıdır.
      imageUrl: "https://picsum.photos/400/400?8", // Test Görseli URL'idir.
      category: ProductCategory.accessories, // Aksesuar Kategorisindedir.
      stockCount: 24, // Stok Adedidir.
    ),
  ];

  @override // Interface'teki Metodun Override Edildiğini Belirtir.
  Future<List<Product>> getAllProducts() async { // Tüm Mock Ürünleri async Olarak Döndürür.
    await Future.delayed(const Duration(milliseconds: 1500)); // Network Gecikmesini Taklit Etmek İçin 1,5 Saniye Bekler.
    return List.from(_productStore); // const List Değiştirilemediği İçin Değiştirilebilir Bir Kopya Döndürür.
  }

  @override // Interface'teki Metodun Override Edildiğini Belirtir.
  Future<List<Product>> getByCategory(ProductCategory category) async { // Verilen Kategorideki Mock Ürünleri Döndürür.
    await Future.delayed(const Duration(milliseconds: 400)); // Network Gecikmesini Taklit Etmek İçin 400 ms Bekler.
    if (category == ProductCategory.all) { // Kategori all İse Bu Bloğa Girer.
      return List.from(_productStore); // Filtrelemeden Tüm Ürünlerin Kopyasını Döndürür.
    }
    return _productStore.where((product) => product.category == category).toList(); // where İle Kategorisi Eşleşen Ürünleri Seçip List Döndürür.
  }

  @override // Interface'teki Metodun Override Edildiğini Belirtir.
  Future<List<Product>> searchByName(String query) async { // title veya description'da query Geçen Mock Ürünleri Döndürür.
    await Future.delayed(const Duration(milliseconds: 300)); // Network Gecikmesini Taklit Etmek İçin 300 ms Bekler.
    if (query.trim().isEmpty) { // Boşlukları Temizlenmiş query Boşsa Bu Bloğa Girer.
      return List.from(_productStore); // Tüm Ürünlerin Kopyasını Döndürür.
    }

    return _productStore.where((product) { // Koşulu Sağlayan Ürünleri where İle Seçer.
      final titleLower = product.title.toLowerCase(); // title'ı Küçük Harfe Çevirir.
      final descriptionLower = product.description.toLowerCase(); // description'ı Küçük Harfe Çevirir.
      final queryLower = query.trim().toLowerCase(); // query'yi Temizleyip Küçük Harfe Çevirir.
      return titleLower.contains(queryLower) || // title query'yi İçeriyorsa true Döndürür.
          descriptionLower.contains(queryLower); // Ya da description query'yi İçeriyorsa true Döndürür.
    }).toList(); // Seçilen Ürünleri List'e Çevirir.
  }
}
