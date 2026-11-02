import 'package:flutter/material.dart'; // Flutter'ın Material Widget'larını import Eder.
import '../models/asset_model.dart'; // Asset Model Class'ını import Eder.
import '../models/transaction_model.dart'; // TransactionItem Model Class'ını import Eder.

class MarketsGridListScreen extends StatelessWidget { // Piyasa Kartlarını ve Son İşlemleri Gösteren StatelessWidget'tır.
  const MarketsGridListScreen({super.key}); // key Parametresini Superclass'a İleten const Constructor'dır.

  static const List<Asset> assets = [ // Ekranda Gösterilecek Örnek Asset Listesini Tutan static const Field'dır.
    Asset( // Bitcoin İçin Asset Nesnesi Oluşturur.
      symbol: 'BTC', // Varlığın Sembolüdür.
      name: 'Bitcoin', // Varlığın Adıdır.
      price: 67420.00, // Varlığın Fiyatıdır.
      change24h: 4.20, // 24 Saatlik Yüzdesel Değişimdir.
      balance: 0.4, // Kullanıcının Sahip Olduğu Miktardır.
    ),
    Asset( // Ethereum İçin Asset Nesnesi Oluşturur.
      symbol: 'ETH', // Varlığın Sembolüdür.
      name: 'Ethereum', // Varlığın Adıdır.
      price: 3500, // Varlığın Fiyatıdır.
      change24h: -1.80, // 24 Saatlik Yüzdesel Değişimdir.
      balance: 4.20, // Kullanıcının Sahip Olduğu Miktardır.
    ),
    Asset( // Solana İçin Asset Nesnesi Oluşturur.
      symbol: 'SOL', // Varlığın Sembolüdür.
      name: 'Solana', // Varlığın Adıdır.
      price: 200.00, // Varlığın Fiyatıdır.
      change24h: 0.5, // 24 Saatlik Yüzdesel Değişimdir.
      balance: 85.00, // Kullanıcının Sahip Olduğu Miktardır.
    ),
  ];

  @override // Superclass'taki build Metodunun Override Edildiğini Belirtir.
  Widget build(BuildContext context) { // Piyasalar Ekranının Widget Tree'sini Oluşturur.
    final now = DateTime.now(); // Şu Anki Tarih ve Saati Alır.
    final today = DateTime(now.year, now.month, now.day); // Saat Bilgisi Olmadan Bugünün Tarihini Oluşturur.
    final yesterday = today.subtract(const Duration(days: 1)); // Bugünden 1 Gün Çıkararak Dünün Tarihini Bulur.
    final transactions = [ // Örnek TransactionItem Listesini Oluşturur.
      TransactionItem( // Birinci Örnek İşlemi Oluşturur.
        id: 'tx_1', // İşlemin id'sidir.
        title: 'Apple Store', // İşlemin Başlığıdır.
        category: 'Teknoloji', // İşlemin Kategorisidir.
        date: DateTime(today.year, today.month, today.day, 14, 20), // Bugün Saat 14:20 Tarihini Verir.
        amount: 64500, // İşlemin Tutarıdır.
        isExpense: true, // Bu İşlemin Bir Gider Olduğunu Belirtir.
        icon: Icons.laptop_mac, // Laptop İkonunu Kullanır.
      ),
      TransactionItem( // İkinci Örnek İşlemi Oluşturur.
        id: 'tx_2', // İşlemin id'sidir.
        title: 'Kodusta Danışmanlık Hakediş', // İşlemin Başlığıdır.
        category: 'Kurumsal Gelir', // İşlemin Kategorisidir.
        date: DateTime(yesterday.year, yesterday.month, yesterday.day, 9), // Dün Saat 09:00 Tarihini Verir.
        amount: 125000.00, // İşlemin Tutarıdır.
        isExpense: false, // Bu İşlemin Bir Gelir Olduğunu Belirtir.
        icon: Icons.account_balance, // Banka İkonunu Kullanır.
      ),
      TransactionItem( // Üçüncü Örnek İşlemi Oluşturur.
        id: 'tx_3', // İşlemin id'sidir.
        title: 'Apple Store', // İşlemin Başlığıdır.
        category: 'Teknoloji', // İşlemin Kategorisidir.
        date: DateTime(today.year, today.month, today.day, 14, 20), // Bugün Saat 14:20 Tarihini Verir.
        amount: 64500, // İşlemin Tutarıdır.
        isExpense: true, // Bu İşlemin Bir Gider Olduğunu Belirtir.
        icon: Icons.laptop_mac, // Laptop İkonunu Kullanır.
      ),
      TransactionItem( // Dördüncü Örnek İşlemi Oluşturur.
        id: 'tx_4', // İşlemin id'sidir.
        title: 'Apple Store', // İşlemin Başlığıdır.
        category: 'Teknoloji', // İşlemin Kategorisidir.
        date: DateTime(today.year, today.month, today.day, 14, 20), // Bugün Saat 14:20 Tarihini Verir.
        amount: 64500, // İşlemin Tutarıdır.
        isExpense: true, // Bu İşlemin Bir Gider Olduğunu Belirtir.
        icon: Icons.laptop_mac, // Laptop İkonunu Kullanır.
      ),
    ]..sort((a, b) => b.date.compareTo(a.date)); // Cascade Operator İle Listeyi Tarihe Göre Yeniden Eskiye Sort Eder.

    final headingStyle = Theme.of(context).textTheme.titleLarge; // Başlıklar İçin Theme'deki titleLarge Stilini Alır.

    return SingleChildScrollView( // İçeriği Dikey Olarak Scroll Edilebilir Yapar.
      physics: const BouncingScrollPhysics(), // Scroll Sonunda iOS Tarzı Esneme Efekti Verir.
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32), // Sol, Üst, Sağ ve Alt Padding'leri Ayrı Ayrı Verir.
      child: Column( // child'ları Dikey Olarak Alt Alta Dizer.
        crossAxisAlignment: CrossAxisAlignment.start, // child'ları Sola Hizalar.
        children: [ // Column İçindeki Widget Listesidir.
          Text('Piyasalar', style: headingStyle), // 'Piyasalar' Başlığını headingStyle İle Gösterir.
          const SizedBox(height: 4), // Dikeyde 4 Birim Boşluk Bırakır.
          const Text('Örnek veriler; canlı piyasa fiyatları değildir.'), // Verilerin Örnek Olduğunu Belirten Text'tir.
          const SizedBox(height: 16), // Dikeyde 16 Birim Boşluk Bırakır.
          LayoutBuilder( // Parent'ın Constraints Bilgisine Göre Responsive UI Oluşturur.
            builder: (context, constraints) { // Mevcut constraints İle Widget'ı Build Eder.
              final columns = constraints.maxWidth >= 900 // Genişlik 900 ve Üzeriyse 3 Sütun Kullanır.
                  ? 3 // Geniş Ekranlar İçin Sütun Sayısıdır.
                  : constraints.maxWidth >= 560 // Genişlik 560 ve Üzeriyse 2 Sütun Kullanır.
                      ? 2 // Orta Ekranlar İçin Sütun Sayısıdır.
                      : 1; // Dar Ekranlar İçin Sütun Sayısıdır.
              final cardWidth = // Her Bir Kartın Genişliğini Hesaplar.
                  (constraints.maxWidth - (columns - 1) * 12) / columns; // Toplam Genişlikten Boşlukları Çıkarıp Sütun Sayısına Böler.

              return Wrap( // Kartları Sığmadığında Alt Satıra Geçirerek Dizer.
                spacing: 12, // Kartlar Arasında Yatayda 12 Boşluk Bırakır.
                runSpacing: 12, // Satırlar Arasında Dikeyde 12 Boşluk Bırakır.
                children: assets // assets Listesinden Kart Widget'ları Üretir.
                    .map((asset) => SizedBox( // Her Asset'i Sabit Genişlikli Bir SizedBox'a Map'ler.
                          width: cardWidth, // SizedBox Genişliğini cardWidth Yapar.
                          child: _buildAssetCard(context, asset), // Asset Kartını Oluşturur.
                        ))
                    .toList(), // Sonucu List'e Çevirir.
              );
            },
          ),
          const SizedBox(height: 24), // Dikeyde 24 Birim Boşluk Bırakır.
          Text('Son İşlemler', style: headingStyle), // 'Son İşlemler' Başlığını headingStyle İle Gösterir.
          const SizedBox(height: 12), // Dikeyde 12 Birim Boşluk Bırakır.
          ListView.separated( // Elemanlar Arasına Ayraç Koyan Bir ListView Oluşturur.
            shrinkWrap: true, // ListView'in Yüksekliğini İçeriği Kadar Yapar.
            physics: const NeverScrollableScrollPhysics(), // Kendi Scroll'unu Kapatıp Parent Scroll'u Kullanır.
            padding: EdgeInsets.zero, // ListView'in Varsayılan Padding'ini Sıfırlar.
            itemCount: transactions.length, // Liste Eleman Sayısını Belirler.
            separatorBuilder: (context, index) => const Divider(height: 1), // Elemanlar Arasına 1 Yükseklikte Divider Koyar.
            itemBuilder: (context, index) => // Her Index İçin Bir Liste Elemanı Build Eder.
                _buildTransactionTile(transactions[index], today), // İlgili İşlem İçin Tile Oluşturur.
          ),
        ],
      ),
    );
  }

  Widget _buildAssetCard(BuildContext context, Asset asset) { // Tek Bir Asset İçin Bilgi Kartı Oluşturur.
    final isPositive = asset.change24h >= 0; // 24 Saatlik Değişimin Pozitif Olup Olmadığını Kontrol Eder.
    final changeColor = // Değişim Yönüne Göre Kullanılacak Rengi Belirler.
        isPositive ? Colors.green.shade700 : Colors.red.shade700; // Pozitifse Yeşil, Negatifse Kırmızı Seçer.

    return Card( // Gölgeli ve Yuvarlak Köşeli Bir Card Döndürür.
      margin: EdgeInsets.zero, // Card'ın Varsayılan Margin'ini Sıfırlar.
      child: Padding( // Card İçeriğine Boşluk Ekler.
        padding: const EdgeInsets.all(16), // Her Yönden 16 Padding Verir.
        child: Column( // Kart İçeriğini Dikey Olarak Dizer.
          crossAxisAlignment: CrossAxisAlignment.start, // child'ları Sola Hizalar.
          children: [ // Column İçindeki Widget Listesidir.
            Text(asset.symbol, style: Theme.of(context).textTheme.titleMedium), // Asset Sembolünü titleMedium Stiliyle Gösterir.
            Text(asset.name), // Asset Adını Gösterir.
            const SizedBox(height: 16), // Dikeyde 16 Birim Boşluk Bırakır.
            Text( // Fiyatı Gösteren Text'tir.
              '\$${asset.price.toStringAsFixed(2)}', // Fiyatı $ İşaretiyle ve 2 Ondalık Basamakla Yazar.
              style: Theme.of(context).textTheme.headlineSmall, // Theme'deki headlineSmall Stilini Uygular.
            ),
            const SizedBox(height: 8), // Dikeyde 8 Birim Boşluk Bırakır.
            Row( // Trend İkonu ve Yüzdeyi Yatay Olarak Dizer.
              children: [ // Row İçindeki Widget Listesidir.
                Icon( // Trend Yönünü Gösteren İkondur.
                  isPositive ? Icons.trending_up : Icons.trending_down, // Pozitifse Yukarı, Negatifse Aşağı Trend İkonu Seçer.
                  color: changeColor, // İkon Rengini changeColor Yapar.
                  size: 20, // İkon Boyutunu 20 Yapar.
                ),
                const SizedBox(width: 4), // Yatayda 4 Birim Boşluk Bırakır.
                Flexible( // Text'in Taşmadan Kalan Alana Sığmasını Sağlar.
                  child: Text( // Yüzdesel Değişimi Gösteren Text'tir.
                    '${isPositive ? '+' : ''}${asset.change24h.toStringAsFixed(2)}% (24s)', // Pozitifse + Ekleyip Değişimi 2 Ondalıkla Yazar.
                    style: TextStyle(color: changeColor), // Text Rengini changeColor Yapar.
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12), // Dikeyde 12 Birim Boşluk Bırakır.
            Text('Bakiye: ${asset.balance} ${asset.symbol}'), // Kullanıcının Bakiyesini Sembolle Birlikte Gösterir.
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionTile(TransactionItem transaction, DateTime today) { // Tek Bir İşlem İçin ListTile Oluşturur.
    final color = // Gider/Gelir Durumuna Göre Rengi Belirler.
        transaction.isExpense ? Colors.red.shade700 : Colors.green.shade700; // Giderse Kırmızı, Gelirse Yeşil Seçer.

    return ListTile( // İkon, Başlık ve Tutar İçeren Bir Satır Döndürür.
      contentPadding: const EdgeInsets.symmetric(vertical: 8), // Dikeyde 8 İç Boşluk Verir.
      leading: CircleAvatar( // Sol Tarafta Yuvarlak Bir Avatar Gösterir.
        child: Icon(transaction.icon), // Avatar İçinde İşlemin İkonunu Gösterir.
      ),
      title: Text(transaction.title), // İşlem Başlığını title Olarak Gösterir.
      subtitle: Text( // Kategori ve Tarihi subtitle Olarak Gösterir.
        '${transaction.category}\n${_formatDate(transaction.date, today)}', // Kategori ve Formatlanmış Tarihi Alt Alta Yazar.
      ),
      isThreeLine: true, // ListTile'ın Üç Satırlık Yükseklikte Olmasını Sağlar.
      trailing: Text( // Sağ Tarafta Tutarı Gösterir.
        '${transaction.isExpense ? '-' : '+'}₺${transaction.amount.toStringAsFixed(2)}', // Gider/Gelir İşaretiyle Tutarı 2 Ondalıkla Yazar.
        style: TextStyle(color: color, fontWeight: FontWeight.bold), // Tutarı Renkli ve Bold Yapar.
      ),
    );
  }

  String _formatDate(DateTime date, DateTime today) { // Tarihi 'Bugün', 'Dün' veya gg.aa.yyyy Formatında String'e Çevirir.
    final day = DateTime(date.year, date.month, date.day); // Saat Bilgisini Atıp Sadece Gün Bilgisini Alır.
    final yesterday = today.subtract(const Duration(days: 1)); // Dünün Tarihini Hesaplar.
    final String label; // Gün Etiketini Tutacak final Değişkeni Tanımlar.
    if (day == today) { // Tarih Bugünse Bu Bloğa Girer.
      label = 'Bugün'; // label'a 'Bugün' Atar.
    } else if (day == yesterday) { // Tarih Dünse Bu Bloğa Girer.
      label = 'Dün'; // label'a 'Dün' Atar.
    } else { // Diğer Tüm Tarihler İçin Bu Bloğa Girer.
      label = '${date.day.toString().padLeft(2, '0')}.' // Günü padLeft İle 2 Haneli Yazar.
          '${date.month.toString().padLeft(2, '0')}.${date.year}'; // Ayı 2 Haneli Yazıp Yılı Ekler.
    }
    final hour = date.hour.toString().padLeft(2, '0'); // Saati 2 Haneli String'e Çevirir.
    final minute = date.minute.toString().padLeft(2, '0'); // Dakikayı 2 Haneli String'e Çevirir.
    return '$label $hour:$minute'; // Etiket, Saat ve Dakikayı Birleştirerek Döndürür.
  }
}
