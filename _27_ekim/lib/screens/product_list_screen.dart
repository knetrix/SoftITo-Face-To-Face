import 'dart:async'; // Debounce İçin Kullanılan Timer'ı import Eder.

import 'package:flutter/material.dart'; // Flutter'ın Material Widget'larını import Eder.

import '../models/product_category.dart'; // Kategori Chip'leri İçin ProductCategory Enum'unu import Eder.
import '../models/product.dart'; // Product Class'ını import Eder.
import '../services/i_product_service.dart'; // Servis Listesinin Tipi Olan IProductService Interface'ini import Eder.
import '../services/api_product_service.dart'; // Ürünleri API'den Çeken ApiProductService'i import Eder.
import '../services/mock_product_service.dart'; // Sahte Ürünleri Döndüren MockProductService'i import Eder.
import '../widgets/product_card.dart'; // Her Ürünü Gösteren ProductCard Widget'ını import Eder.

class ProductListScreen extends StatefulWidget { // Ürünlerin Listelendiği Ana Ekranın StatefulWidget'ıdır.
  const ProductListScreen({super.key}); // key Parametresini Superclass'a İleten const Constructor'dır.

  @override // Superclass'taki createState Metodunun Override Edildiğini Belirtir.
  State<ProductListScreen> createState() => _ProductListScreenState(); // Bu Widget'ın State Nesnesini Oluşturur.
}

class _ProductListScreenState extends State<ProductListScreen> { // ProductListScreen'in State'ini Tutan Class'tır.
  final List<IProductService> _services = [MockProductService(), ApiProductService()]; // Ürünlerin Çekileceği Servislerin List'idir.

  final TextEditingController _searchController = TextEditingController(); // Arama Kutusundaki Metni Okuyup Temizlemek İçin Controller'dır.

  bool _isLoading = true; // Ürünlerin Yüklenip Yüklenmediğini Tutar.

  ProductCategory _selectedCategory = ProductCategory.all; // Seçili Kategoridir, Başlangıçta all'dır.

  List<Product> _filteredProducts = []; // Ekranda Gösterilen Filtrelenmiş Ürün List'idir.

  final Set<int> _favoriteIds = {}; // Yeniden Yüklemelerde Kaybolmaması İçin Favori Ürünlerin id'lerini Tutan Set'tir.

  Timer? _searchDebounce; // Arama İçin Debounce Timer'ıdır, Başta null'dır.

  int _requestId = 0; // Eski Cevapları Ayırt Etmek İçin Her Yüklemede Artan Sayaçtır.

  @override // Superclass'taki initState Metodunun Override Edildiğini Belirtir.
  void initState() { // State Oluşturulduğunda Bir Kez Çalışan Lifecycle Metodudur.
    super.initState(); // Superclass'ın initState İşlemlerini Çalıştırır.
    _loadProducts(); // İlk Ürün Yüklemesini Başlatır.
  }

  @override // Superclass'taki dispose Metodunun Override Edildiğini Belirtir.
  void dispose() { // State Yok Edilirken Çalışan Lifecycle Metodudur.
    _searchController.dispose(); // Memory Leak Olmaması İçin Controller'ı dispose Eder.
    _searchDebounce?.cancel(); // Bekleyen Bir Timer Varsa İptal Eder.
    super.dispose(); // Superclass'ın dispose İşlemlerini Çalıştırır.
  }

  Future<void> _loadProducts() async { // Seçili Kategori ve Aramaya Göre Ürünleri Tüm Servislerden Çeker.
    final currentRequest = ++_requestId; // Sayacı 1 Artırıp Bu Yüklemenin Numarasını Alır.
    final requestedCategory = _selectedCategory; // İstek Başlarkenki Kategoriyi Saklar.
    final query = _searchController.text.trim().toLowerCase(); // Arama Metnini Temizleyip Küçük Harfe Çevirir.

    setState(() { // build Metodunu Yeniden Tetikleyerek Widget'ı Rebuild Eder.
      _isLoading = true; // Yükleniyor Durumunu Açar.
    });

    List<Product> products = []; // Servislerden Gelen Ürünlerin Toplanacağı List'tir.
    for (final service in _services) { // Her Servis İçin Sırayla Döner.
      try { // Hataları Yakalamak İçin try Bloğu Açar.
        if (query.isEmpty) { // Arama Metni Boşsa Bu Bloğa Girer.
          products.addAll(await service.getByCategory(requestedCategory)); // Seçili Kategorideki Ürünleri İsteyip List'e Ekler.
        } else { // Arama Metni Varsa Bu Bloğa Girer.
          final results = await service.searchByName(query); // query İle Eşleşen Ürünleri İster.
          products.addAll( // Filtrelenen Sonuçları List'e Ekler.
            results.where( // Sonuçlardan Koşulu Sağlayanları Seçer.
              (p) => // Her Ürün İçin Koşulu Değerlendirir.
                  requestedCategory == ProductCategory.all || // Kategori all İse Ürünü Alır.
                  p.category == requestedCategory, // Ya da Ürünün Kategorisi Seçili Kategoriyse Alır.
            ),
          );
        }
      } catch (e) { // Servisten Fırlatılan Hatayı catch Eder.
        debugPrint('${service.runtimeType} Hatası: $e'); // Hatanın Hangi Servisten Geldiğini Console'a Yazar.
        if (mounted) { // Widget Hâlâ Tree'deyse Bu Bloğa Girer.
          ScaffoldMessenger.of(context).showSnackBar( // Ekranın Altında Bir SnackBar Gösterir.
            const SnackBar( // Gösterilecek SnackBar'ı Tanımlar.
              content: Text( // SnackBar'ın İçindeki Metindir.
                'Bazı ürünler yüklenemedi. İnternet bağlantınızı kontrol edin.', // Kullanıcıya Gösterilen Hata Metnidir.
              ),
            ),
          );
        }
      }
    }

    if (!mounted || currentRequest != _requestId) return; // Widget Kaldırıldıysa ya da Daha Yeni Bir İstek Başladıysa Sonucu Atar.

    setState(() { // build Metodunu Yeniden Tetikleyerek Widget'ı Rebuild Eder.
      _filteredProducts = products // Gelen Ürünleri Ekrandaki List'e Atar.
          .map((p) => p.copyWith(isFavorite: _favoriteIds.contains(p.id))) // Favori Bilgisini _favoriteIds'ten Geri Yükler.
          .toList(); // Sonucu List'e Çevirir.
      _isLoading = false; // Yükleniyor Durumunu Kapatır.
    });
  }

  void _onSearchChanged() { // Arama Kutusuna Her Harf Yazıldığında Çalışır.
    setState(() {}); // Temizle Butonunun Hemen Görünmesi İçin Widget'ı Rebuild Eder.
    _searchDebounce?.cancel(); // Önceki Harfte Kurulan Timer'ı İptal Eder.
    _searchDebounce = Timer( // Yeni Bir Debounce Timer'ı Kurar.
      const Duration(milliseconds: 400), // 400 ms Boyunca Yeni Harf Gelmesini Bekler.
      _loadProducts, // Süre Dolunca _loadProducts'ı Çağırır.
    );
  }

  void _toggleFavorite(Product target) { // Ürünün Favori Durumunu Tersine Çevirir.
    setState(() { // build Metodunu Yeniden Tetikleyerek Widget'ı Rebuild Eder.
      final updated = target.copyWith(isFavorite: !target.isFavorite); // isFavorite'i Tersine Çevrilmiş Yeni Bir Kopya Üretir.
      if (updated.isFavorite) { // Ürün Favori Olduysa Bu Bloğa Girer.
        _favoriteIds.add(target.id); // id'yi Favori Set'ine Ekler.
      } else { // Ürün Favoriden Çıktıysa Bu Bloğa Girer.
        _favoriteIds.remove(target.id); // id'yi Favori Set'inden Siler.
      }
      final index = _filteredProducts.indexWhere( // Ürünün List'teki index'ini Bulur.
        (p) => p.id == target.id, // id'si Eşleşen Ürünü Arar.
      );
      if (index != -1) { // Ürün List'te Bulunduysa Bu Bloğa Girer.
        _filteredProducts[index] = updated; // Eski Ürünü Güncel Kopyasıyla Değiştirir.
      }
    });
  }

  @override // Superclass'taki build Metodunun Override Edildiğini Belirtir.
  Widget build(BuildContext context) { // Ana Ekranın Widget Tree'sini Oluşturur.
    return Scaffold( // Sayfanın Temel Material Layout'unu Oluşturur.
      appBar: AppBar( // Sayfanın Üst Bar'ıdır.
        title: const Text( // AppBar'ın title'ıdır.
          "Mini Mağaza", // AppBar'da Görünen Başlık Metnidir.
          style: TextStyle(fontWeight: FontWeight.bold), // Başlığı Kalın Yapar.
        ),
        centerTitle: true, // title'ı Ortalar.
        actions: [ // AppBar'ın Sağ Tarafındaki Widget'lardır.
          Padding( // Sağ Tarafa Boşluk Bırakır.
            padding: const EdgeInsets.only(right: 16.0), // Yalnızca Sağa 16 Logical Pixel Boşluk Verir.
            child: Center( // Badge'i Dikeyde Ortalar.
              child: Badge( // İkonun Üzerine Bir Badge Ekler.
                label: Text( // Badge Üzerindeki Metindir.
                  '${_favoriteIds.length}', // Toplam Favori Sayısını Yazar.
                  style: const TextStyle(fontWeight: FontWeight.bold), // Sayıyı Kalın Yapar.
                ),
                child: const Icon(Icons.favorite, color: Colors.red), // Badge'in child'ı Olan Kırmızı Kalp İkonudur.
              ),
            ),
          ),
        ],
      ),
      body: Column( // Arama Kutusu, Chip'ler ve Listeyi Alt Alta Dizer.
        children: [ // Column'un children Listesidir.
          Padding( // Arama Kutusunun Etrafına Boşluk Bırakır.
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4), // Sol, Üst, Sağ ve Alt Boşlukları Ayrı Ayrı Verir.
            child: TextField( // Kullanıcının Arama Metni Yazdığı TextField'dır.
              controller: _searchController, // TextField'ı _searchController'a Bağlar.
              onChanged: (_) => _onSearchChanged(), // Metin Her Değiştiğinde _onSearchChanged'i Çağırır.
              decoration: InputDecoration( // TextField'ın Görünüşünü Tanımlar.
                hintText: "Ürün veya marka ara...", // Kutu Boşken Görünen hint Metnidir.
                prefixIcon: const Icon(Icons.search), // Solda search İkonunu Gösterir.
                suffixIcon: _searchController.text.isNotEmpty // Kutuda Metin Varsa Temizle Butonunu Gösterir.
                    ? IconButton( // Metni Temizleyen IconButton'dır.
                        icon: const Icon(Icons.clear), // clear İkonunu Gösterir.
                        onPressed: () { // Basılınca Çalışan Callback'tir.
                          _searchController.clear(); // Arama Metnini Siler.
                          _searchDebounce?.cancel(); // Bekleyen Debounce Timer'ını İptal Eder.
                          _loadProducts(); // Ürünleri Aramasız Olarak Yeniden Yükler.
                        },
                      )
                    : null, // Metin Yoksa suffixIcon Göstermez.
                filled: true, // TextField'ın İçini Renkle Doldurur.
                fillColor: Colors.grey.shade100, // Dolgu Rengi Çok Açık Gridir.
                border: OutlineInputBorder( // TextField'ın Kenarlığını Tanımlar.
                  borderRadius: BorderRadius.circular(12), // Köşeleri 12 Logical Pixel Yuvarlatır.
                  borderSide: BorderSide.none, // Kenar Çizgisini Kaldırır.
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0), // Dikey İç Boşluğu Sıfırlar.
              ),
            ),
          ),

          SingleChildScrollView( // Chip'ler Ekrana Sığmazsa Kaydırılabilir Yapar.
            scrollDirection: Axis.horizontal, // Yatay Scroll Kullanır.
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), // Yatayda 12, Dikeyde 8 Boşluk Verir.
            child: Row( // Chip'leri Yatay Olarak Dizer.
              children: ProductCategory.values.map((category) { // Enum'daki Her Kategori İçin Bir Chip Üretir.
                final isSelected = _selectedCategory == category; // Bu Chip'in Seçili Olup Olmadığını Tutar.
                return Padding( // Chip'in Etrafına Boşluk Bırakır.
                  padding: const EdgeInsets.symmetric(horizontal: 4.0), // Chip'ler Arasına Yatayda 4 Boşluk Verir.
                  child: ChoiceChip( // Seçilebilir Bir ChoiceChip Oluşturur.
                    avatar: Text(category.icon), // Chip'in Solunda Kısa İkon Metnini Gösterir.
                    label: Text(category.title), // Chip'in label'ında Kategori Başlığını Gösterir.
                    selected: isSelected, // Chip'in Seçili Görünüp Görünmeyeceğini Belirler.
                    onSelected: (selected) { // Chip'e Basılınca Çalışan Callback'tir.
                      if (selected) { // Yalnızca Seçme Durumunda Bu Bloğa Girer.
                        setState(() { // build Metodunu Yeniden Tetikleyerek Widget'ı Rebuild Eder.
                          _selectedCategory = category; // Seçili Kategoriyi Günceller.
                        });
                        _loadProducts(); // Yeni Kategorinin Ürünlerini Yükler.
                      }
                    },
                  ),
                );
              }).toList(), // Üretilen Chip'leri List'e Çevirir.
            ),
          ),

          Expanded( // Column'da Kalan Tüm Dikey Alanı Listeye Verir.
            child: _isLoading // Yükleniyorsa İlk Dalı Seçer.
                ? const Center(child: CircularProgressIndicator()) // Ortada Bir CircularProgressIndicator Gösterir.
                : _filteredProducts.isEmpty // Yükleme Bittiyse List'in Boş Olup Olmadığına Bakar.
                ? Center( // List Boşsa İçeriği Ortalar.
                    child: Column( // İkon ve Mesajı Alt Alta Dizer.
                      mainAxisAlignment: MainAxisAlignment.center, // Column İçeriğini Dikeyde Ortalar.
                      children: [ // Column'un children Listesidir.
                        Icon( // Büyük Bir search İkonu Gösterir.
                          Icons.search, // Gösterilecek İkondur.
                          size: 64, // İkonun Boyutudur.
                          color: Colors.grey.shade400, // İkonun Rengidir.
                        ),
                        const SizedBox(height: 12), // İkon ile Mesaj Arasına 12 Logical Pixel Boşluk Koyar.
                        Text( // Sonuç Bulunamadı Mesajını Gösterir.
                          'Aradığınız kriterlere uygun ürün bulunamadı.', // Kullanıcıya Gösterilen Mesajdır.
                          style: TextStyle( // Metnin Stilini Tanımlar.
                            color: Colors.grey.shade600, // Gri Metin Rengidir.
                            fontSize: 16, // Yazı Boyutudur.
                            fontWeight: FontWeight.w600, // Yarı Kalın Yazı Kalınlığıdır.
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder( // Item'ları Lazy Olarak Build Eden, Scroll Edilebilir Bir ListView Oluşturur.
                    itemCount: _filteredProducts.length, // ListView'daki Item Sayısını Belirler.
                    itemBuilder: (context, index) { // Her Item'ı Ekranda Görüneceği Zaman Build Eder.
                      final product = _filteredProducts[index]; // index'teki Ürünü Alır.
                      return ProductCard( // Ürünü ProductCard İle Gösterir.
                        product: product, // Karta Gösterilecek Ürünü Verir.
                        onFavoriteTap: () => _toggleFavorite(product), // Kalbe Basılınca Ürünün Favori Durumunu Değiştirir.
                        onDetailTap: () { // Karta Basılınca Çalışan Callback'tir.
                          ScaffoldMessenger.of(context).showSnackBar( // Ekranın Altında Bir SnackBar Gösterir.
                            SnackBar( // Gösterilecek SnackBar'ı Tanımlar.
                              content: Text('${product.title} tıklandı!'), // Tıklanan Ürünün Adını Yazar.
                              duration: const Duration(milliseconds: 1000), // SnackBar 1 Saniye Görünür.
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
