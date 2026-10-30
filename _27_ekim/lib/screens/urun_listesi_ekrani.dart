import 'package:flutter/material.dart';

import '../models/kategori.dart';
import '../models/urun.dart';
import '../services/i_urun_servisi.dart';
import '../services/mock_urun_servisi.dart';
import '../widgets/urun_karti.dart';

// Uygulamanın Ana Ekranı. Durumu (State) Yönetir ve Parçaları Bir Araya Getirir.
// StatefulWidget: Zamanla DEĞİŞEN Bir Durumu Var (Liste, Filtre, Yükleniyor Bilgisi).
// İki Sınıftan Oluşur: Widget'ın Kendisi Sabittir, Değişen Veriler State Sınıfında Tutulur.
class UrunListesiEkrani extends StatefulWidget {
  const UrunListesiEkrani({super.key});

  // Durumu Tutacak Sınıfı Üretir. "=>" Tek Satırlık { return ...; } Yazmanın Kısa Yolu.
  @override
  State<UrunListesiEkrani> createState() => _UrunListesiEkraniState();
}

class _UrunListesiEkraniState extends State<UrunListesiEkrani> {
  // Tip Olarak Interface, Nesne Olarak Mock Kullanılıyor.
  // Gerçek API Gelince Sadece Eşittirin Sağ Tarafı Değiştirilir.
  final IUrunServisi _servis = MockUrunServisi();

  // Arama Kutusundaki Metni Okumak ve Temizlemek İçin Kullanılan "Kumanda".
  final TextEditingController _aramaController = TextEditingController();

  // Ekran Başta "Yükleniyor" Durumunda Açılır.
  bool _yukleniyorMu = true;
  // Lint Uyarısını Susturur (Aslında Gereksiz, Çünkü Değişken Sonradan Değiştiriliyor).
  // ignore: prefer_final_fields
  Kategori _seciliKategori = Kategori.hepsi;
  // EKRANDA GÖSTERİLEN, Filtrelenmiş Liste.
  List<Urun> _filtrelenmisUrunler = [];
  // Servisten Gelen ORİJİNAL Tam Liste. Hiç Küçülmez.
  // İki Ayrı Liste Olmasaydı, Filtreden Sonra Kaybolan Ürünler Geri Gelmezdi.
  List<Urun> _tumUrunler = [];

  // Ekran İLK Oluşturulduğunda BİR KEZ Çalışır.
  @override
  void initState() {
    // Önce Flutter'ın Kendi Hazırlığını Yapmasına İzin Ver.
    super.initState();
    // Sonra Ürünleri Çekmeye Başla.
    _urunleriYukle();
  }

  // Ekran Kapatılıp Yok Edilirken Çalışır.
  @override
  void dispose() {
    // Controller'ın Kullandığı Belleği Serbest Bırak. Unutulursa Bellek Sızıntısı Olur.
    _aramaController.dispose();
    super.dispose();
  }

  // Servisten Ürünleri Çeker ve Ekranı Günceller.
  Future<void> _urunleriYukle() async {
    // setState: "Durum Değişti, Ekranı Yeniden Çiz!" Demektir.
    // Değişken setState İçinde Değiştirilmezse Ekran Güncellenmez.
    setState(() {
      _yukleniyorMu = true;
    });

    // Servisten Cevap Gelene Kadar (1,5 Sn) Burada Beklenir.
    final urunler = await _servis.tumUrunleriGetir();

    // Bekleme Sırasında Kullanıcı Ekrandan Çıktıysa setState Hata Verir.
    // mounted: Ekran Hâlâ Görünüyor Mu Kontrolü.
    if (mounted) {
      setState(() {
        _tumUrunler = urunler;
        // Başta Filtre Yok, Bu Yüzden İki Liste Aynı.
        _filtrelenmisUrunler = urunler;
        // Yükleme Bitti.
        _yukleniyorMu = false;
      });
    }
  }

  // Kategori ve Arama Filtrelerini BİRLİKTE Uygular.
  // (İsimde Yazım Hatası Var: "_filtreyiUygula" Olmalı.)
  void _filteyiUygula() {
    // Kutudaki Metni Al, Baştaki/Sondaki Boşlukları Sil, Küçük Harfe Çevir.
    final aranan = _aramaController.text.trim().toLowerCase();

    setState(() {
      // HER ZAMAN Tam Listeden Süzülür, Böylece Kaybolan Ürün Olmaz.
      _filtrelenmisUrunler = _tumUrunler.where((urun) {
        // "Tümü" Seçiliyse Her Ürün Uygun; Değilse Kategorisi Eşleşmeli.
        final kategoriUygunMu =
            (_seciliKategori == Kategori.hepsi) ||
            (urun.kategori == _seciliKategori);
        // Arama Boşsa Her Ürün Uygun; Değilse Başlıkta Ya Da Açıklamada Geçmeli.
        final aramaUygunMu =
            aranan.isEmpty ||
            urun.baslik.toLowerCase().contains(aranan) ||
            urun.aciklama.toLowerCase().contains(aranan);
        // İki Koşul Birden Sağlanmalı.
        return kategoriUygunMu && aramaUygunMu;
      }).toList();
    });
  }

  // Bir Ürünün Favori Durumunu Tersine Çevirir.
  void _favoriyiDegistir(Urun hedefUrun) {
    setState(() {
      // "!" = Tersini Al. Ürün final Olduğu İçin copyWith ile Yeni Kopya Üretilir.
      final yeniUrun = hedefUrun.copyWith(favoriMi: !hedefUrun.favoriMi);
      // Ürünün Ana Listede Kaçıncı Sırada Olduğunu id'ye Göre Bul.
      final index = _tumUrunler.indexWhere((u) => u.id == hedefUrun.id);
      // -1 = Bulunamadı Demektir.
      if (index != -1) {
        // Eski Nesneyi Yenisiyle Değiştir. Değişiklik ANA Listeye Yazıldığı İçin
        // Filtre Değişse Bile Favori Durumu Korunur.
        _tumUrunler[index] = yeniUrun;
      }
      // Filtreli Listeyi Ana Listeden Yeniden Üret.
      _filteyiUygula();
    });
  }

  // setState Her Çağrıldığında Bu Metot Tekrar Çalışır ve Ekran Yeniden Çizilir.
  @override
  Widget build(BuildContext context) {
    // Scaffold: Sayfa İskeleti (Üst Bar + Gövde).
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Mini Mağaza",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        // Başlığı Ortala.
        centerTitle: true,
        // AppBar'ın Sağ Tarafındaki Öğeler.
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              // Badge: İkonun Köşesinde Küçük Sayı Rozeti.
              child: Badge(
                // Favori Olan Ürünleri Say. _tumUrunler Üzerinden Sayıldığı İçin
                // Filtre Uygulanmış Olsa Da TOPLAM Favori Sayısını Gösterir.
                label: Text(
                  '${_tumUrunler.where((u) => u.favoriMi).length}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                child: const Icon(Icons.favorite, color: Colors.red),
              ),
            ),
          ),
        ],
      ),
      // Gövde: Alt Alta 3 Parça (Arama Kutusu, Kategori Çipleri, Ürün Listesi).
      body: Column(
        children: [
          // ── 1) ARAMA KUTUSU ──
          Padding(
            // Sırasıyla Sol, Üst, Sağ, Alt Boşluk.
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: TextField(
              // Kutuyu Controller'a Bağla.
              controller: _aramaController,
              // Her Tuş Vuruşunda Filtrele. "_" = Gelen Parametreyi Kullanmıyorum.
              onChanged: (_) => _filteyiUygula(),
              decoration: InputDecoration(
                // Kutu Boşken Görünen Silik Yazı.
                hintText: "Ürün veya marka ara...",
                // Soldaki Büyüteç İkonu.
                prefixIcon: const Icon(Icons.search),
                // Kutuda Yazı VARSA Sağda "X" Butonu Göster, Yoksa Hiçbir Şey Gösterme.
                suffixIcon: _aramaController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          // Metni Sil ve Listeyi Yenile.
                          _aramaController.clear();
                          _filteyiUygula();
                        },
                      )
                    : null,
                // Açık Gri Arka Plan.
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  // Kenar Çizgisi Yok.
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),
          // ── 2) KATEGORİ ÇİPLERİ ──
          // Çipler Ekrana Sığmazsa Yatay Olarak Kaydırılabilsin.
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              // Enum'daki HER Değer İçin Bir Çip Üret. Enum'a Yeni Kategori
              // Eklenince Yeni Çip Otomatik Olarak Ekranda Belirir.
              children: Kategori.values.map((kategori) {
                final seciliMi = _seciliKategori == kategori;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  // ChoiceChip: Seçilebilir, Hap Şeklinde Buton.
                  child: ChoiceChip(
                    // Soldaki Küçük "E", "G" Vb. Metin.
                    avatar: Text(kategori.ikon),
                    label: Text(kategori.baslik),
                    // Seçili Olan Çip Farklı Renkte Görünür.
                    selected: seciliMi,
                    onSelected: (secildi) {
                      // Sadece Seçme Olayını Dinle (Seçimi Kaldırmayı Değil).
                      if (secildi) {
                        setState(() {
                          _seciliKategori = kategori;
                          _filteyiUygula();
                        });
                      }
                    },
                  ),
                );
                // map'in Sonucunu Widget Listesine Çevir.
              }).toList(),
            ),
          ),
          // ── 3) ÜRÜN LİSTESİ ──
          // Expanded: Kalan Tüm Dikey Alanı Kapla. ListView Sınırsız Yükseklik İster,
          // Column İse Sınır Koymaz; Expanded Olmadan Uygulama Hata Verirdi.
          Expanded(
            // İç İçe Ternary ile 3 Farklı Ekran Durumu Yönetilir.
            child: _yukleniyorMu
                // DURUM A: Yükleniyor → Ortada Dönen Çember.
                ? const Center(child: CircularProgressIndicator())
                : _filtrelenmisUrunler.isEmpty
                // DURUM B: Sonuç Yok → Büyüteç İkonu ve Bilgi Mesajı.
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
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
                // DURUM C: Ürünler Var → Liste.
                // ListView.builder Sadece Ekranda GÖRÜNEN Kartları Üretir;
                // Binlerce Ürün Olsa Bile Performanslı Çalışır.
                : ListView.builder(
                    // Listede Kaç Eleman Var.
                    itemCount: _filtrelenmisUrunler.length,
                    // Her Satır İçin Çağrılır ve O Satırın Widget'ını Döndürür.
                    itemBuilder: (context, index) {
                      final urun = _filtrelenmisUrunler[index];
                      // urun_karti.dart Dosyasındaki Widget.
                      return UrunKarti(
                        urun: urun,
                        // Kalbe Basılınca Favori Durumunu Değiştir.
                        onFavoriTiklandi: () => _favoriyiDegistir(urun),
                        // Karta Basılınca Alttan Kayan Kısa Bir Mesaj (SnackBar) Göster.
                        onDetayTiklandi: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${urun.baslik} tıklandı!'),
                              // Mesaj 1 Saniye Görünsün.
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
