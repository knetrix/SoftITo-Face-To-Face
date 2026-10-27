import '../models/kategori.dart';
import '../models/urun.dart';
import 'i_urun_servisi.dart';

class MockUrunServisi implements IUrunServisi {
  final List<Urun> _urunDeposu = const [
    Urun(
      id: 1,
      baslik: "Macbook M5 Pro Laptop",
      aciklama: "Apple'ın en güçlü işlemcisine sahip yeni nesil Macbook Pro",
      fiyat: 179999.99,
      resimUrl: "https://picsum.photos/400/400?1",
      kategori: Kategori.elektronik,
      stokAdedi: 5,
    ),
    Urun(
      id: 2,
      baslik: "Apple iPhone 18 Pro Max",
      aciklama: "iPhone 18 Pro Max. Tıpkı iPhone 17 gibi, hem iPhone'larda hem de akıllı saatlerde kullanılan daha dayanıklı titanyumdan üretildi. Ayrıca iPhone 18 Pro Max, iPhone 17 Pro'dan daha fazla pil ömrü, daha güçlü bir kamera sistemi ve yeni kişiselleştirme seçenekleriyle geliyor.",
      fiyat: 149999.99,
      resimUrl: "https://picsum.photos/400/400?2",
      kategori: Kategori.elektronik,
      stokAdedi: 145,
    ),
    Urun(
      id: 3,
      baslik: "Oversize Pamuklu Kapüşonlu Sweatshirt",
      aciklama: "%100 pamuklu kumaştan üretilen, içi polarlı ve soğuk havalarda sıcak tutan rahat kesim sweatshirt.",
      fiyat: 1299.90,
      resimUrl: "https://picsum.photos/400/400?3",
      kategori: Kategori.giyim,
      stokAdedi: 50,
    ),
    Urun(
      id: 4,
      baslik: "Klasik Slim Fit Denim Pantolon",
      aciklama: "Esnek likralı kumaş yapısı sayesinde gün boyu maksimum konfor sağlayan modern kesim kot pantolon.",
      fiyat: 1499.50,
      resimUrl: "https://picsum.photos/400/400?4",
      kategori: Kategori.giyim,
      stokAdedi: 32,
    ),
    Urun(
      id: 5,
      baslik: "Air Cushion Koşu Ayakkabısı",
      aciklama: "Nefes alabilen file yüzey ve darbe emici hava tabanı ile spor ve günlük kullanım için mükemmel tercih.",
      fiyat: 3899.00,
      resimUrl: "https://picsum.photos/400/400?5",
      kategori: Kategori.ayakkabi,
      stokAdedi: 18,
    ),
    Urun(
      id: 6,
      baslik: "Hakiki Deri Klasik Bağcıklı Ayakkabı",
      aciklama: "Özel el işçiliği birinci sınıf hakiki deriden üretilen, şık takım elbiselerin tamamlayıcısı erkek ayakkabı.",
      fiyat: 4250.00,
      resimUrl: "https://picsum.photos/400/400?6",
      kategori: Kategori.ayakkabi,
      stokAdedi: 12,
    ),
    Urun(
      id: 7,
      baslik: "Polarize UV400 Güneş Gözlüğü",
      aciklama: "Hafif metal çerçeve, parlamayı önleyen polarize camlar ve %100 UV filtreli şık tasarım.",
      fiyat: 890.00,
      resimUrl: "https://picsum.photos/400/400?7",
      kategori: Kategori.aksesuar,
      stokAdedi: 65,
    ),
    Urun(
      id: 8,
      baslik: "Çelik Hasır Kordonlu Klasik Kol Saati",
      aciklama: "Su geçirmez paslanmaz çelik gövde, safir cam ve şık hasır kordonuyla zamansız bir aksesuar.",
      fiyat: 5499.90,
      resimUrl: "https://picsum.photos/400/400?8",
      kategori: Kategori.aksesuar,
      stokAdedi: 24,
    ),
  ];

  @override
  Future<List<Urun>> tumUrunleriGetir() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    return List.from(_urunDeposu);
  }

  @override
  Future<List<Urun>> kategoriyeGoreGetir(Kategori kategori) async {
    await Future.delayed(const Duration(milliseconds: 400));
    if (kategori == Kategori.hepsi) {
      return List.from(_urunDeposu);
    }
    return _urunDeposu.where((urun) => urun.kategori == kategori).toList();
  }

  @override
  Future<List<Urun>> adaGoreAra(String aramaMetni) async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (aramaMetni.trim().isEmpty) {
      return List.from(_urunDeposu);
    }

    return _urunDeposu.where((urun) {
      final baslikKucuk = urun.baslik.toLowerCase();
      final arananKucuk = aramaMetni.toLowerCase();
      return baslikKucuk.contains(arananKucuk);
    }).toList();
  }
}
