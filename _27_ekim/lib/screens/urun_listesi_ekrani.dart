// ============================================================================
// urun_listesi_ekrani.dart → Ana Ekran (Uygulamanın Beyni)
// ----------------------------------------------------------------------------
// Bu Ekranın Görevleri:
//   1) Açılınca Servislerden Ürünleri Çekmek (Mock + API).
//   2) Kategori Ya da Arama Değişince, Uygun Ürünleri Servislerden Yeniden İstemek.
//   3) Favori Bilgisini Tutmak ve Güncellemek.
//   4) Bunların Hepsini Ekrana Çizmek.
//
// Ekranın Görünüşü (Yukarıdan Aşağı):
//   ┌─────────────────────────────┐
//   │      Mini Mağaza        ♥ 2 │  ← AppBar (Üst Bar) + Favori Sayacı
//   │ [🔍 Ürün veya marka ara...] │  ← Arama Kutusu
//   │ (Tümü)(Elektronik)(Giyim)…  │  ← Kategori Çipleri
//   │ ┌─────────────────────────┐ │
//   │ │ Ürün Kartı              │ │  ← Ürün Listesi
//   │ └─────────────────────────┘ │
//   └─────────────────────────────┘
// ============================================================================

// dart:async İçindeki Timer (Zamanlayıcı), Aramada "Yazma Bitince İstek At"
// Davranışı için Kullanılıyor.
import 'dart:async';

import 'package:flutter/material.dart';

import '../models/kategori.dart';
import '../models/urun.dart';
import '../services/i_urun_servisi.dart';
import '../services/api_urun_servisi.dart';
import '../services/mock_urun_servisi.dart';
import '../widgets/urun_karti.dart';

// StatefulWidget: Zamanla DEĞİŞEN Bilgileri Olan Widget.
// Bu Ekranda Değişen Bilgiler: Ürün Listesi, Seçili Kategori, Yükleniyor Durumu...
//
// StatefulWidget İki Sınıftan Oluşur:
//   1) UrunListesiEkrani        → Widget'ın Kendisi. Sabittir, Değişmez.
//   2) _UrunListesiEkraniState  → Değişen Bilgileri (State = Durum) Tutar.
// Neden İkiye Ayrılmış? Flutter Ekranı Yeniden Çizerken Widget'ı Baştan
// Oluşturabilir; Ama State Nesnesi Korunur, Böylece Bilgiler Kaybolmaz.
class UrunListesiEkrani extends StatefulWidget {
  const UrunListesiEkrani({super.key});

  // createState: Bu Widget'ın Durumunu Tutacak Nesneyi Oluşturur.
  // "=>" Tek Satırlık Fonksiyonların Kısa Yazımı: { return ...; } ile Aynı.
  @override
  State<UrunListesiEkrani> createState() => _UrunListesiEkraniState();
}

// Sınıf İsminin Başındaki "_": Bu Sınıf Sadece Bu Dosyada Kullanılabilir (Private).
class _UrunListesiEkraniState extends State<UrunListesiEkrani> {
  // --------------------------------------------------------------------------
  // DURUM DEĞİŞKENLERİ (Ekranın Hafızası)
  // --------------------------------------------------------------------------

  // Ürünlerin Çekileceği Servislerin Listesi.
  // Liste Tipi "IUrunServisi" (Sözleşme) Olduğu için, Bu Sözleşmeye Uyan
  // Her Servis Bu Listeye Konabilir. İki Farklı Servis Burada Yan Yana Duruyor.
  // Yeni Bir Veri Kaynağı Eklemek İsterseniz Listeye Eklemeniz Yeterli.
  final List<IUrunServisi> _servisler = [MockUrunServisi(), ApiUrunServisi()];

  // TextEditingController: Arama Kutusunun "Kumandası".
  // Kutudaki Metni Okumak (.text) ve Temizlemek (.clear()) için Kullanılır.
  final TextEditingController _aramaController = TextEditingController();

  // Ürünler Yükleniyor Mu? Ekran İlk Açıldığında true; Yükleme Bitince false.
  // true Olduğu Sürece Ekranda Dönen Bir Yükleniyor Çemberi Görünür.
  bool _yukleniyorMu = true;

  // Şu An Seçili Olan Kategori. Başta "Tümü" (Kategori.hepsi).
  // Aşağıdaki Satır Bir Uyarıyı Susturuyor (Aslında Gereksiz, Çünkü Bu
  // Değişken Sonradan Değiştiriliyor ve final Olamaz).
  // ignore: prefer_final_fields
  Kategori _seciliKategori = Kategori.hepsi;

  // EKRANDA GÖSTERİLEN Liste. Servislerden, Seçili Kategoriye ve Arama
  // Metnine Göre Süzülmüş Olarak Gelir. Ekran Bu Listeyi Ayrıca Süzmez.
  List<Urun> _filtrelenmisUrunler = [];

  // Favori Ürünlerin id'leri. Set: Aynı Değeri İki Kez Tutmayan Liste.
  // Neden Ayrı Tutuluyor? Her Kategori Seçiminde ve Her Aramada Ürünler
  // Servisten Yeniden Çekiliyor ve Yeni Gelen Ürünlerin favoriMi Değeri Hep false.
  // Favoriler Ürünlerin Üstünde Tutulsaydı Her Yüklemede Kaybolurdu.
  // Burada Tutulunca Hangi Ürünlerin Favori Olduğu Hiç Unutulmaz.
  final Set<int> _favoriIdleri = {};

  // Arama için Zamanlayıcı (Debounce).
  // Kullanıcı "saat" Yazarken Her Harfte Servise Gidilseydi 4 Ayrı İstek
  // Atılırdı. Bunun Yerine Her Harfte Zamanlayıcı Sıfırlanıyor; Kullanıcı
  // 400 Milisaniye Boyunca Yeni Harf Yazmazsa Tek Bir İstek Atılıyor.
  // "Timer?": Henüz Bir Zamanlayıcı Kurulmamış Olabilir (null).
  Timer? _aramaZamanlayici;

  // Her Yükleme Başladığında Bir Artan Sayaç.
  // Aynı Anda Birden Fazla Yükleme Sürebilir (Örn: Kullanıcı Hızlıca Çip
  // Değiştirir Ya da Yazmaya Devam Eder). Cevap Geldiğinde Sayaç Değişmişse
  // Arkadan Yeni Bir Yükleme Başlamış Demektir; Eski Cevap Ekrana Yazılmaz.
  int _istekNo = 0;

  // --------------------------------------------------------------------------
  // YAŞAM DÖNGÜSÜ (Lifecycle) METOTLARI
  // --------------------------------------------------------------------------

  // initState: Ekran İLK Oluşturulduğunda Sadece BİR KEZ Çalışır.
  // Başlangıçta Yapılacak İşler (Veri Çekmek Gibi) Buraya Yazılır.
  @override
  void initState() {
    // Önce Flutter'ın Kendi Hazırlığını Yapması için Üst Sınıfın initState'i
    // Çağrılır. Bu Satır Her Zaman En Başta Olmalı.
    super.initState();
    // Sonra Ürünleri Çekmeye Başla.
    _urunleriYukle();
  }

  // dispose: Ekran Kapatılıp Yok Edilirken Çalışır.
  // Kullanılan Kaynakları Serbest Bırakmak (Temizlik) için Kullanılır.
  @override
  void dispose() {
    // Controller Bellekte Yer Tutar. Ekran Kapanınca Onu da Kapatıyoruz.
    // Unutulursa "Bellek Sızıntısı" (Memory Leak) Olur: Kullanılmayan
    // Nesneler Bellekte Kalmaya Devam Eder.
    _aramaController.dispose();
    // Bekleyen Bir Arama Zamanlayıcısı Varsa İptal Et. "?.": Zamanlayıcı
    // Hiç Kurulmadıysa (null) Hiçbir Şey Yapma.
    _aramaZamanlayici?.cancel();
    // Temizlik Bitince Üst Sınıfın dispose'u En Sonda Çağrılır.
    super.dispose();
  }

  // --------------------------------------------------------------------------
  // VERİ YÜKLEME
  // --------------------------------------------------------------------------

  // Seçili Kategoriye ve Arama Metnine Uyan Ürünleri Tüm Servislerden Çeker,
  // Birleştirir ve Ekranı Günceller.
  // Ekran Açılınca, Her Kategori Seçiminde ve Arama Metni Değişince Çağrılır.
  // "Future<void>": İleride Biten Ama Geriye Bir Değer Döndürmeyen İşlem.
  // "async": İçinde await Kullanılabilir.
  Future<void> _urunleriYukle() async {
    // Bu Yüklemenin Numarasını Al. "++_istekNo": Önce Sayacı 1 Artır,
    // Sonra Yeni Değeri Kullan. Aşağıda Cevap Gelince Bu Numarayı Kontrol Edeceğiz.
    final buIstek = ++_istekNo;
    // İstek Başlarken Hangi Kategori ve Hangi Arama Metni İstendiğini Not Al.
    final istenenKategori = _seciliKategori;
    // Arama Kutusundaki Metni Al:
    //   .text        → Kutudaki Yazı
    //   .trim()      → Baştaki/Sondaki Boşlukları Sil
    //   .toLowerCase → Tüm Harfleri Küçült (Büyük/Küçük Harf Fark Etmesin)
    final aranan = _aramaController.text.trim().toLowerCase();

    // setState: Flutter'a "Durum Değişti, Ekranı Yeniden Çiz!" Der.
    // ÖNEMLİ: Bir Değişkeni setState Dışında Değiştirirseniz Değişken
    // Değişir Ama Ekran GÜNCELLENMEZ. Ekranı Etkileyen Değişiklikler
    // Mutlaka setState İçinde Yapılmalı.
    setState(() {
      _yukleniyorMu = true;
    });

    // Tüm Servislerden Gelen Ürünler Bu Listede Toplanacak.
    List<Urun> urunler = [];
    // for-in Döngüsü: _servisler Listesindeki Her Servis için Sırayla Çalışır.
    // İlk Turda servis = MockUrunServisi, İkinci Turda servis = ApiUrunServisi.
    for (final servis in _servisler) {
      // try/catch: Hata Çıkabilecek Kodu "try" İçine Yazarız. Hata Çıkarsa
      // Program Çökmez, "catch" Bloğu Çalışır.
      // Her Servis için Ayrı try/catch Var: İnternet Yoksa API Hata Verir,
      // Ama Mock Ürünler Yine de Listelenir.
      try {
        // await: Servis Cevap Verene Kadar Bekle.
        // addAll: Gelen Listenin Tüm Elemanlarını urunler Listesinin Sonuna Ekle.
        if (aranan.isEmpty) {
          // Arama Yoksa: kategoriyeGoreGetir ile Sadece İstenen Kategorinin
          // Ürünlerini İste. "Tümü" Seçiliyse Servisler Bütün Ürünleri Döndürür.
          urunler.addAll(await servis.kategoriyeGoreGetir(istenenKategori));
        } else {
          // Arama Varsa: adaGoreAra ile Aranan Metni İçeren Ürünleri İste.
          // adaGoreAra Kategoriye Bakmaz; Bütün Kategorilerden Sonuç Döndürür.
          final bulunanlar = await servis.adaGoreAra(aranan);
          // Bu Yüzden Sonuçlardan Sadece Seçili Kategoriye Ait Olanları Al.
          // "Tümü" Seçiliyse Hepsi Kalır.
          urunler.addAll(
            bulunanlar.where(
              (u) =>
                  istenenKategori == Kategori.hepsi ||
                  u.kategori == istenenKategori,
            ),
          );
        }
      } catch (e) {
        // e: Yakalanan Hata Nesnesi.
        // debugPrint: Hatayı Geliştiricinin Görebileceği Konsola (Terminal /
        // Debug Console) Yazar; Kullanıcı Bunu Görmez. Kullanıcıya Gösterilen
        // Mesaj Genel Olduğu için Asıl Sebebi (Örn: "Ürünler Alınamadı: 500",
        // TimeoutException) Burada Görürüz. runtimeType: Hatanın Hangi
        // Servisten Geldiğini Yazar (Örn: ApiUrunServisi).
        debugPrint('${servis.runtimeType} Hatası: $e');
        // mounted: Bu Ekran Hâlâ Görünüyor Mu? Beklerken Kullanıcı Ekrandan
        // Çıkmış Olabilir; O Zaman Mesaj Göstermeye Çalışmak Hata Verir.
        if (mounted) {
          // ScaffoldMessenger: Ekranın Altından Kısa Mesaj (SnackBar)
          // Göstermeyi Sağlar. Birkaç Saniye Sonra Kendiliğinden Kaybolur.
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Bazı ürünler yüklenemedi. İnternet bağlantınızı kontrol edin.',
              ),
            ),
          );
        }
      }
    }

    // Tüm Servisler Bitti. Sonuçları Ekrana Yansıtmadan Önce İki Kontrol:
    //   - !mounted: Ekran Kapandıysa Hiçbir Şey Yapma.
    //   - İstek Numarası Değiştiyse: Kullanıcı Beklerken Başka Bir Çipe Basmış
    //     Ya da Yazmaya Devam Etmiş; Arkadan Yeni Bir Yükleme Başlamış.
    //     Bu Cevap Artık Eski; Ekrana Yazarsak Yanlış Ürünler Görünür.
    if (!mounted || buIstek != _istekNo) return;

    setState(() {
      // Servisten Gelen Ürünlerin favoriMi Değeri Hep false. Favori id'leri
      // Kümesine Bakarak Her Ürünün Favori Bilgisini Geri Yükle.
      // map: Her Ürünü Favori Bilgisi Düzeltilmiş Kopyasıyla Değiştirir.
      _filtrelenmisUrunler = urunler
          .map((u) => u.copyWith(favoriMi: _favoriIdleri.contains(u.id)))
          .toList();
      // Yükleme Bitti → Yükleniyor Çemberi Kaybolur, Liste Görünür.
      _yukleniyorMu = false;
    });
  }

  // --------------------------------------------------------------------------
  // ARAMA
  // --------------------------------------------------------------------------

  // Arama Kutusuna Her Harf Yazıldığında Çağrılır.
  void _aramaDegisti() {
    // Boş Bir setState: Hiçbir Değişkeni Değiştirmiyor, Sadece Ekranı Yeniden
    // Çizdiriyor. Kutuya Yazı Yazılınca Sağdaki "X" Butonu Hemen Görünsün Diye.
    setState(() {});
    // Önceki Harfte Kurulmuş Bir Zamanlayıcı Varsa İptal Et; Henüz Servise Gitme.
    _aramaZamanlayici?.cancel();
    // Yeni Bir Zamanlayıcı Kur: 400 Milisaniye İçinde Yeni Harf Gelmezse
    // _urunleriYukle Çalışır ve Servislerden Arama Sonuçları İstenir.
    _aramaZamanlayici = Timer(
      const Duration(milliseconds: 400),
      _urunleriYukle,
    );
  }

  // --------------------------------------------------------------------------
  // FAVORİ DEĞİŞTİRME
  // --------------------------------------------------------------------------

  // Kalbe Basılınca Çağrılır: Ürün Favoriyse Favoriden Çıkarır, Değilse Ekler.
  void _favoriyiDegistir(Urun hedefUrun) {
    setState(() {
      // "!" Bir bool Değerin Tersini Alır: !true → false, !false → true.
      // Ürünün Alanları final Olduğu için Doğrudan Değiştiremiyoruz;
      // copyWith ile Favori Durumu Tersine Çevrilmiş YENİ Bir Kopya Üretiyoruz.
      final yeniUrun = hedefUrun.copyWith(favoriMi: !hedefUrun.favoriMi);
      // Favori Kümesini Güncelle: Favori Olduysa id'yi Ekle, Değilse Çıkar.
      // Kategori Değişip Ürünler Yeniden Çekildiğinde Bu Küme Kullanılıyor.
      if (yeniUrun.favoriMi) {
        _favoriIdleri.add(hedefUrun.id);
      } else {
        _favoriIdleri.remove(hedefUrun.id);
      }
      // indexWhere: Koşulu Sağlayan İlk Elemanın Sırasını (Index) Döndürür.
      // Listede Sıra Numaraları 0'dan Başlar. id'si Aynı Olan Ürünü Arıyoruz.
      final index = _filtrelenmisUrunler.indexWhere(
        (u) => u.id == hedefUrun.id,
      );
      // Bulunamazsa indexWhere -1 Döndürür. -1 Değilse Ürün Bulunmuş Demektir.
      if (index != -1) {
        // O Sıradaki Eski Ürünü Yenisiyle Değiştir; Kalp Hemen Kırmızı Olsun.
        _filtrelenmisUrunler[index] = yeniUrun;
      }
    });
  }

  // --------------------------------------------------------------------------
  // EKRANIN ÇİZİMİ
  // --------------------------------------------------------------------------

  // build: Ekranın Neye Benzeyeceğini Döndürür.
  // setState Her Çağrıldığında Flutter Bu Metodu Tekrar Çalıştırır ve Ekranı
  // Güncel Değişkenlerle Yeniden Çizer.
  @override
  Widget build(BuildContext context) {
    // Scaffold: Bir Sayfanın Hazır İskeleti. Üst Bar (appBar), Gövde (body)
    // Gibi Standart Bölümleri Vardır.
    return Scaffold(
      // AppBar: Sayfanın En Üstündeki Başlık Çubuğu.
      appBar: AppBar(
        title: const Text(
          "Mini Mağaza",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        // Başlığı Ortala (Bazı Platformlarda Varsayılan Olarak Solda Durur).
        centerTitle: true,
        // actions: AppBar'ın Sağ Tarafına Konan Widget'lar.
        actions: [
          Padding(
            // Sadece Sağ Tarafa 16 Piksel Boşluk.
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              // Badge: Bir İkonun Köşesine Küçük Bir Sayı Rozeti Ekler
              // (Bildirim Sayısı Gibi).
              child: Badge(
                // Rozetteki Sayı: Favori Olan Ürünlerin Adedi.
                // Favori Kümesindeki id Sayısı (.length) Kullanıldığı için
                // Başka Bir Kategori Seçili Olsa Bile TOPLAM Favori Sayısını Gösterir.
                label: Text(
                  '${_favoriIdleri.length}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                // Rozetin Takıldığı İkon: Kırmızı Kalp.
                child: const Icon(Icons.favorite, color: Colors.red),
              ),
            ),
          ),
        ],
      ),
      // body: Sayfanın Ana İçeriği. Column ile Alt Alta 3 Parça Diziliyor.
      body: Column(
        children: [
          // ── 1) ARAMA KUTUSU ────────────────────────────────────────────────
          Padding(
            // fromLTRB: Sırasıyla Sol (Left), Üst (Top), Sağ (Right), Alt (Bottom) Boşluk.
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            // TextField: Kullanıcının Yazı Yazabildiği Kutu.
            child: TextField(
              // Kutuyu Kumandaya (Controller) Bağla.
              controller: _aramaController,
              // onChanged: Kutudaki Yazı Her Değiştiğinde (Her Tuş Vuruşunda) Çalışır.
              // Gelen Parametre Yeni Metindir; Ama Biz Metni Controller'dan
              // Okuduğumuz için Kullanmıyoruz. Kullanılmayan Parametreye "_" Denir.
              // Her Harfte Doğrudan Servise Gitmiyoruz; _aramaDegisti Zamanlayıcıyı
              // Kurar, Yazma Bitince Tek Bir İstek Atılır.
              onChanged: (_) => _aramaDegisti(),
              // decoration: Kutunun Görünüşü.
              decoration: InputDecoration(
                // Kutu Boşken İçinde Görünen Silik İpucu Yazısı.
                hintText: "Ürün veya marka ara...",
                // Kutunun Solundaki İkon (Büyüteç).
                prefixIcon: const Icon(Icons.search),
                // Kutunun Sağındaki İkon: Kutuda Yazı VARSA Bir "X" Butonu
                // Göster, Yoksa Hiçbir Şey Gösterme (null).
                // isNotEmpty: Metin Boş Değil Mi?
                suffixIcon: _aramaController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        // "X"e Basılınca:
                        onPressed: () {
                          // Kutudaki Yazıyı Sil,
                          _aramaController.clear();
                          // Bekleyen Bir Arama Zamanlayıcısı Varsa İptal Et,
                          _aramaZamanlayici?.cancel();
                          // Seçili Kategorinin Ürünlerini Aramasız Olarak Yeniden Çek.
                          _urunleriYukle();
                        },
                      )
                    : null,
                // Kutunun İçini Renkle Doldur.
                filled: true,
                // Doldurma Rengi: Çok Açık Gri.
                fillColor: Colors.grey.shade100,
                // Kutunun Kenarı: 12 Piksel Yuvarlak Köşe, Kenar Çizgisi Yok.
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                // İç Boşluk: Dikeyde 0 (Kutu Daha İnce Görünür).
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),

          // ── 2) KATEGORİ ÇİPLERİ ────────────────────────────────────────────
          // SingleChildScrollView: İçindeki Widget Ekrana Sığmazsa Kaydırılabilir Yapar.
          SingleChildScrollView(
            // Yatay (Sağa-Sola) Kaydırma.
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              // Kategori.values: Enum'daki Tüm Değerlerin Listesi
              // (hepsi, elektronik, giyim, ayakkabi, aksesuar).
              // map: Her Kategori için Bir Çip Widget'ı Üretir.
              // Enum'a Yeni Kategori Eklenirse Yeni Çip de Otomatik Olarak Ekrana Gelir.
              children: Kategori.values.map((kategori) {
                // Bu Çip Şu An Seçili Olan Kategori Mi?
                final seciliMi = _seciliKategori == kategori;
                return Padding(
                  // Çipler Arasında Sağdan Soldan 4'er Piksel Boşluk.
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  // ChoiceChip: Seçilebilir, Hap Şeklinde Küçük Buton.
                  child: ChoiceChip(
                    // Çipin Solundaki Küçük Metin ("E", "G"...).
                    avatar: Text(kategori.ikon),
                    // Çipin Yazısı ("Elektronik", "Giyim"...).
                    label: Text(kategori.baslik),
                    // true İse Çip Seçili (Renkli) Görünür.
                    selected: seciliMi,
                    // Çipe Basılınca Çalışır. secildi: Çip Seçildi Mi (true),
                    // Yoksa Seçim Kaldırıldı Mı (false)?
                    onSelected: (secildi) {
                      // Sadece Seçme Durumunu Dikkate Al. Seçili Çipe Tekrar
                      // Basılınca Hiçbir Şey Yapma (Bir Kategori Hep Seçili Kalsın).
                      if (secildi) {
                        // Seçili Kategoriyi Güncelle (Çip Hemen Renklensin),
                        setState(() {
                          _seciliKategori = kategori;
                        });
                        // Sonra Bu Kategorinin Ürünlerini Servislerden Çek.
                        _urunleriYukle();
                      }
                    },
                  ),
                );
                // map'in Sonucunu Row'un İstediği Widget Listesine Çevir.
              }).toList(),
            ),
          ),

          // ── 3) ÜRÜN LİSTESİ ────────────────────────────────────────────────
          // Expanded: Column'da Kalan Tüm Dikey Alanı Bu Widget'a Ver.
          // ListView Sınırsız Uzayabilir, Column İse Ona Bir Sınır Koymaz.
          // Expanded Olmasaydı Flutter Listenin Yüksekliğini Bilemez ve Hata Verirdi.
          Expanded(
            // İç İçe Ternary ( ? : ) ile 3 Farklı Durum Yönetiliyor:
            //   Yükleniyorsa      → Dönen Çember
            //   Değilse, Liste Boşsa → "Ürün Bulunamadı" Mesajı
            //   Değilse           → Ürün Listesi
            child: _yukleniyorMu
                // DURUM A: Yükleniyor → Ortada Dönen Çember.
                ? const Center(child: CircularProgressIndicator())
                : _filtrelenmisUrunler.isEmpty
                // DURUM B: Hiç Ürün Yok (Arama/Filtre Sonucu Boş) → Bilgi Mesajı.
                ? Center(
                    child: Column(
                      // Column'un İçeriğini Dikeyde Ortala.
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Büyük, Silik Bir Büyüteç İkonu.
                        Icon(
                          Icons.search,
                          size: 64,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Aradığınız kriterlere uygun ürün bulunamadı.',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  )
                // DURUM C: Ürünler Var → Kaydırılabilir Liste.
                // ListView.builder: Sadece Ekranda GÖRÜNEN Satırları Oluşturur.
                // Kullanıcı Aşağı Kaydırdıkça Yeni Satırlar Oluşturulur.
                // Böylece Binlerce Ürün Olsa Bile Uygulama Yavaşlamaz.
                : ListView.builder(
                    // Listede Toplam Kaç Satır Olacak.
                    itemCount: _filtrelenmisUrunler.length,
                    // Her Satır için Çağrılır. index: Satırın Sıra Numarası (0, 1, 2...).
                    // Bu Fonksiyon O Satırda Gösterilecek Widget'ı Döndürür.
                    itemBuilder: (context, index) {
                      // O Sıradaki Ürünü Al.
                      final urun = _filtrelenmisUrunler[index];
                      // urun_karti.dart Dosyasındaki Kart Widget'ı.
                      return UrunKarti(
                        urun: urun,
                        // Kalbe Basılınca Ne Olsun: Bu Ürünün Favori Durumunu Değiştir.
                        // "() => ..." Parametresiz Kısa Fonksiyon.
                        onFavoriTiklandi: () => _favoriyiDegistir(urun),
                        // Karta Basılınca Ne Olsun: Alttan Kısa Bir Mesaj Göster.
                        onDetayTiklandi: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${urun.baslik} tıklandı!'),
                              // Mesaj 1000 Milisaniye (1 Saniye) Görünsün.
                              duration: const Duration(milliseconds: 1000),
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
