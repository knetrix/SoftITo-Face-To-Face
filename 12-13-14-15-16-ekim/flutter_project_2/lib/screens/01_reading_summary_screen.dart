import 'package:flutter/material.dart'; // Flutter'ın Material Widget'larını import Eder.

import '../models/book_model.dart'; // Book Model Class'ını import Eder.
import '../models/reading_session_model.dart'; // ReadingSession Model Class'ını import Eder.

class ReadingSummaryScreen extends StatefulWidget { // Günlük Hedefleri ve Okuma Özetini Gösteren StatefulWidget'tır.
  const ReadingSummaryScreen({ // Named Parametreler Alan const Constructor'dır.
    super.key, // key Parametresini Superclass'a İletir.
    required this.books, // books Parametresini required Yapar.
    required this.sessions, // sessions Parametresini required Yapar.
    required this.onStartReading, // onStartReading Parametresini required Yapar.
  });

  final List<Book> books; // Parent'tan Gelen Kitap Listesidir.
  final List<ReadingSession> sessions; // Parent'tan Gelen Okuma Oturumları Listesidir.
  final VoidCallback onStartReading; // Okuma Kaydı Sekmesine Geçmek İçin Kullanılan Callback'tir.

  @override // Superclass'taki createState Metodunun Override Edildiğini Belirtir.
  State<ReadingSummaryScreen> createState() => _ReadingSummaryScreenState(); // Bu Widget'a Ait State Nesnesini Oluşturur.
}

class _ReadingSummaryScreenState extends State<ReadingSummaryScreen> { // ReadingSummaryScreen'in State'ini Yöneten Private Class'tır.
  int _dailyGoal = 30; // Günlük Sayfa Hedefini Tutar.
  int _dailyMinutesGoal = 20; // Günlük Dakika Hedefini Tutar.

  Future<void> _editGoals() async { // Hedefleri Düzenlemek İçin Dialog Açıp Sonucu İşler.
    final formKey = GlobalKey<FormState>(); // Dialog İçindeki Form'u Validate Etmek İçin GlobalKey Oluşturur.
    var pages = _dailyGoal; // Geçici Sayfa Hedefi Değişkenidir.
    var minutes = _dailyMinutesGoal; // Geçici Dakika Hedefi Değişkenidir.
    final result = await showDialog<(int, int)>( // Dialog Açar ve Dönen (int, int) Record'unu await İle Bekler.
      context: context, // Dialog'un Açılacağı BuildContext'tir.
      builder: (context) => AlertDialog( // Bir AlertDialog Build Eder.
        title: const Text('Günlük hedefler'), // Dialog'un title'ıdır.
        content: SingleChildScrollView( // Dialog İçeriğini Scroll Edilebilir Yapar.
          child: Form( // TextFormField'ları Gruplayıp Validation Yönetimini Sağlar.
            key: formKey, // Form'a GlobalKey'i Bağlar.
            child: Column( // Form Alanlarını Dikey Olarak Dizer.
              mainAxisSize: MainAxisSize.min, // Column'un Yüksekliğini İçeriği Kadar Yapar.
              children: [ // Column İçindeki Widget Listesidir.
                for (final field in [ // Collection for İle Her Record İçin Bir Alan Üretir.
                  (pages, 'Sayfa hedefi'), // Sayfa Hedefi İçin (değer, label) Record'udur.
                  (minutes, 'Dakika hedefi'), // Dakika Hedefi İçin (değer, label) Record'udur.
                ])
                  Padding( // Alanın Altına Boşluk Ekler.
                    padding: const EdgeInsets.only(bottom: 16), // Sadece Alt Tarafa 16 Padding Verir.
                    child: TextFormField( // Hedef Giriş Alanını Oluşturur.
                      initialValue: '${field.$1}', // Record'un İlk Elemanını Başlangıç Değeri Olarak Yazar.
                      onSaved: (value) { // Form save Edildiğinde Çalışan Callback'tir.
                        if (field.$2 == 'Sayfa hedefi') { // Alan Sayfa Hedefiyse Bu Bloğa Girer.
                          pages = int.parse(value!.trim()); // Değeri int'e Parse Edip pages'e Atar.
                        } else { // Alan Dakika Hedefiyse Bu Bloğa Girer.
                          minutes = int.parse(value!.trim()); // Değeri int'e Parse Edip minutes'a Atar.
                        }
                      },
                      keyboardType: TextInputType.number, // Sayısal Klavye Açar.
                      decoration: InputDecoration(labelText: field.$2), // Record'un İkinci Elemanını labelText Yapar.
                      validator: (value) => // Alanın Değerini Doğrulayan validator Callback'idir.
                          (int.tryParse(value?.trim() ?? '') ?? 0) <= 0 // Değer Parse Edilemiyorsa veya 0'dan Küçükse Kontrol Eder.
                          ? 'Pozitif bir tam sayı girin.' // Geçersizse Hata Mesajını Döndürür.
                          : null, // Geçerliyse null Döndürür.
                    ),
                  ),
              ],
            ),
          ),
        ),
        actions: [ // Dialog'un Alt Kısmındaki Butonlardır.
          TextButton( // Düz Bir Metin Butonu Oluşturur.
            onPressed: () => Navigator.pop(context), // Tıklanınca Sonuç Döndürmeden Dialog'u Kapatır.
            child: const Text('Vazgeç'), // Butonun Metnidir.
          ),
          FilledButton( // Dolgulu Kaydet Butonunu Oluşturur.
            onPressed: () { // Butona Tıklanınca Çalışan Callback'tir.
              if (!formKey.currentState!.validate()) return; // Validation Başarısızsa Metottan Çıkar.
              formKey.currentState!.save(); // Tüm Alanların onSaved Callback'lerini Tetikler.
              Navigator.pop(context, (pages, minutes)); // Dialog'u Kapatıp Yeni Hedefleri Record Olarak Döndürür.
            },
            child: const Text('Kaydet'), // Butonun Metnidir.
          ),
        ],
      ),
    );
    if (!mounted || result == null) return; // Widget Ağaçtan Kalktıysa veya İptal Edildiyse Metottan Çıkar.
    setState(() { // State'i Güncelleyip build() Metodunu Tetikler.
      _dailyGoal = result.$1; // Record'un İlk Elemanını Sayfa Hedefine Atar.
      _dailyMinutesGoal = result.$2; // Record'un İkinci Elemanını Dakika Hedefine Atar.
    });
  }

  @override // Superclass'taki build Metodunun Override Edildiğini Belirtir.
  Widget build(BuildContext context) { // Özet Ekranının Widget Tree'sini Oluşturur.
    final now = DateTime.now(); // Şu Anki Tarih ve Saati Alır.
    final todaySessions = widget.sessions.where( // Sadece Bugüne Ait Oturumları Filtreler.
      (session) => // Her Oturum İçin Koşulu Kontrol Eder.
          session.date.year == now.year && // Yıl Aynı Mı Kontrol Eder.
          session.date.month == now.month && // Ay Aynı Mı Kontrol Eder.
          session.date.day == now.day, // Gün Aynı Mı Kontrol Eder.
    );
    final todayPages = todaySessions.fold( // fold İle Bugün Okunan Toplam Sayfayı Hesaplar.
      0, // Başlangıç Değeri 0'dır.
      (sum, session) => sum + session.pages, // Her Oturumun Sayfa Sayısını Toplama Ekler.
    );
    final todayMinutes = todaySessions.fold( // fold İle Bugün Harcanan Toplam Dakikayı Hesaplar.
      0, // Başlangıç Değeri 0'dır.
      (sum, session) => sum + session.minutes, // Her Oturumun Dakikasını Toplama Ekler.
    );
    final totalMinutes = widget.sessions.fold( // fold İle Tüm Oturumların Toplam Dakikasını Hesaplar.
      0, // Başlangıç Değeri 0'dır.
      (sum, session) => sum + session.minutes, // Her Oturumun Dakikasını Toplama Ekler.
    );
    final completed = widget.books.where((book) => book.isCompleted).length; // Tamamlanan Kitap Sayısını Hesaplar.
    final readingBooks = widget.books.where( // Okunmaya Devam Eden Kitapları Filtreler.
      (book) => book.readPages > 0 && !book.isCompleted, // Başlanmış Ama Bitmemiş Kitapları Seçer.
    );

    return SingleChildScrollView( // İçeriği Dikey Olarak Scroll Edilebilir Yapar.
      padding: const EdgeInsets.all(20), // Her Yönden 20 Padding Verir.
      child: Column( // child'ları Dikey Olarak Alt Alta Dizer.
        crossAxisAlignment: CrossAxisAlignment.stretch, // child'ları Yatayda Tam Genişliğe Uzatır.
        children: [ // Column İçindeki Widget Listesidir.
          const ListTile( // Karşılama Satırını Oluşturur.
            contentPadding: EdgeInsets.zero, // ListTile'ın İç Boşluğunu Sıfırlar.
            leading: CircleAvatar(child: Icon(Icons.person_outline)), // Sol Tarafta Kişi İkonlu Avatar Gösterir.
            title: Text( // ListTile'ın title'ıdır.
              'Yeni bir hikâyeye hazır mısın?', // Karşılama Metnidir.
              style: TextStyle(fontWeight: FontWeight.bold), // Metni Bold Yapar.
            ),
            subtitle: Text('Her sayfa, yeni bir keşif.'), // ListTile'ın subtitle'ıdır.
          ),
          const SizedBox(height: 20), // Dikeyde 20 Birim Boşluk Bırakır.
          Container( // Günlük Hedef Kartını Oluşturur.
            padding: const EdgeInsets.all(24), // Her Yönden 24 Padding Verir.
            decoration: BoxDecoration( // Container'ın Görsel Dekorasyonunu Tanımlar.
              color: const Color(0xFF285447), // Arka Plan Rengini Koyu Yeşil Yapar.
              borderRadius: BorderRadius.circular(24), // Köşeleri 24 Radius İle Yuvarlar.
            ),
            child: Column( // Kart İçeriğini Dikey Olarak Dizer.
              crossAxisAlignment: CrossAxisAlignment.start, // child'ları Sola Hizalar.
              children: [ // Column İçindeki Widget Listesidir.
                const Icon( // Kitap İkonunu Gösterir.
                  Icons.menu_book_rounded, // menu_book_rounded İkonunu Kullanır.
                  color: Color(0xFFEACB94), // İkon Rengini Altın Tonuna Ayarlar.
                  size: 40, // İkon Boyutunu 40 Yapar.
                ),
                const SizedBox(height: 16), // Dikeyde 16 Birim Boşluk Bırakır.
                const Text( // Kart Başlığını Gösterir.
                  'Bugünün okuma hedefi', // Başlık Metnidir.
                  style: TextStyle(color: Colors.white70), // Text Rengini Yarı Saydam Beyaz Yapar.
                ),
                const SizedBox(height: 8), // Dikeyde 8 Birim Boşluk Bırakır.
                Text( // Sayfa İlerlemesini Gösteren Text'tir.
                  '$todayPages / $_dailyGoal sayfa', // Okunan ve Hedeflenen Sayfayı Yazar.
                  style: const TextStyle( // Text'in Stilini Tanımlar.
                    fontSize: 30, // Font Size'ı 30 Yapar.
                    fontWeight: FontWeight.bold, // Text'i Bold Yapar.
                    color: Colors.white, // Text Rengini Beyaz Yapar.
                  ),
                ),
                const SizedBox(height: 16), // Dikeyde 16 Birim Boşluk Bırakır.
                LinearProgressIndicator( // Sayfa Hedefi İçin İlerleme Çubuğu Gösterir.
                  value: (todayPages / _dailyGoal).clamp(0.0, 1.0), // Oranı clamp İle 0-1 Arasında Tutar.
                  color: const Color(0xFFEACB94), // Dolu Kısmın Rengini Belirler.
                  backgroundColor: Colors.white24, // Boş Kısmın Rengini Belirler.
                  minHeight: 8, // Çubuğun Yüksekliğini 8 Yapar.
                  borderRadius: BorderRadius.circular(8), // Köşeleri 8 Radius İle Yuvarlar.
                ),
                const SizedBox(height: 16), // Dikeyde 16 Birim Boşluk Bırakır.
                Text( // Dakika İlerlemesini Gösteren Text'tir.
                  '$todayMinutes / $_dailyMinutesGoal dakika', // Harcanan ve Hedeflenen Dakikayı Yazar.
                  style: const TextStyle(color: Colors.white), // Text Rengini Beyaz Yapar.
                ),
                const SizedBox(height: 8), // Dikeyde 8 Birim Boşluk Bırakır.
                LinearProgressIndicator( // Dakika Hedefi İçin İlerleme Çubuğu Gösterir.
                  value: (todayMinutes / _dailyMinutesGoal).clamp(0.0, 1.0), // Oranı clamp İle 0-1 Arasında Tutar.
                  color: const Color(0xFFEACB94), // Dolu Kısmın Rengini Belirler.
                  backgroundColor: Colors.white24, // Boş Kısmın Rengini Belirler.
                  minHeight: 8, // Çubuğun Yüksekliğini 8 Yapar.
                  borderRadius: BorderRadius.circular(8), // Köşeleri 8 Radius İle Yuvarlar.
                ),
                const SizedBox(height: 12), // Dikeyde 12 Birim Boşluk Bırakır.
                Text( // Motivasyon Mesajını Gösteren Text'tir.
                  todayPages >= _dailyGoal && todayMinutes >= _dailyMinutesGoal // İki Hedefe de Ulaşılıp Ulaşılmadığını Kontrol Eder.
                      ? 'Tebrikler! Günlük hedefine ulaştın.' // Hedeflere Ulaşıldıysa Bu Mesajı Gösterir.
                      : 'Küçük adımlar, büyük hikâyeler.', // Ulaşılmadıysa Bu Mesajı Gösterir.
                  style: const TextStyle(color: Colors.white), // Text Rengini Beyaz Yapar.
                ),
              ],
            ),
          ),
          const SizedBox(height: 16), // Dikeyde 16 Birim Boşluk Bırakır.
          Wrap( // Butonları Sığmadığında Alt Satıra Geçirerek Dizer.
            spacing: 12, // Butonlar Arasında Yatayda 12 Boşluk Bırakır.
            runSpacing: 8, // Satırlar Arasında Dikeyde 8 Boşluk Bırakır.
            children: [ // Wrap İçindeki Butonların Listesidir.
              FilledButton.icon( // İkonlu ve Dolgulu Bir Buton Oluşturur.
                onPressed: widget.onStartReading, // Tıklanınca Okuma Kaydı Sekmesine Geçer.
                icon: const Icon(Icons.add), // Ekle İkonunu Gösterir.
                label: const Text('Okuma Kaydı Ekle'), // Butonun label'ıdır.
              ),
              OutlinedButton.icon( // İkonlu ve Kenarlıklı Bir Buton Oluşturur.
                onPressed: _editGoals, // Tıklanınca Hedef Düzenleme Dialog'unu Açar.
                icon: const Icon(Icons.flag_outlined), // Bayrak İkonunu Gösterir.
                label: const Text('Hedefleri düzenle'), // Butonun label'ıdır.
              ),
            ],
          ),
          const SizedBox(height: 20), // Dikeyde 20 Birim Boşluk Bırakır.
          Wrap( // İstatistik Kartlarını Sığmadığında Alt Satıra Geçirerek Dizer.
            spacing: 12, // Kartlar Arasında Yatayda 12 Boşluk Bırakır.
            runSpacing: 12, // Satırlar Arasında Dikeyde 12 Boşluk Bırakır.
            children: [ // Wrap İçindeki Kartların Listesidir.
              _statCard( // Kitaplık İstatistik Kartını Oluşturur.
                context, // BuildContext'i Gönderir.
                Icons.library_books_outlined, // Kartın İkonudur.
                'Kitaplık', // Kartın label'ıdır.
                '${widget.books.length} kitap', // Toplam Kitap Sayısını Değer Olarak Gönderir.
              ),
              _statCard( // Tamamlanan Kitaplar İstatistik Kartını Oluşturur.
                context, // BuildContext'i Gönderir.
                Icons.task_alt, // Kartın İkonudur.
                'Tamamlanan', // Kartın label'ıdır.
                '$completed kitap', // Tamamlanan Kitap Sayısını Değer Olarak Gönderir.
              ),
              _statCard( // Toplam Süre İstatistik Kartını Oluşturur.
                context, // BuildContext'i Gönderir.
                Icons.timer_outlined, // Kartın İkonudur.
                'Kaydedilen süre', // Kartın label'ıdır.
                '$totalMinutes dakika', // Toplam Dakikayı Değer Olarak Gönderir.
              ),
            ],
          ),
          const SizedBox(height: 24), // Dikeyde 24 Birim Boşluk Bırakır.
          Text( // Bölüm Başlığını Gösterir.
            'Okumaya devam et', // Başlık Metnidir.
            style: Theme.of(context).textTheme.titleLarge, // Theme'deki titleLarge Stilini Uygular.
          ),
          const SizedBox(height: 8), // Dikeyde 8 Birim Boşluk Bırakır.
          if (readingBooks.isEmpty) // Collection if İle Okunan Kitap Yoksa Aşağıdaki Widget'ı Ekler.
            const Padding( // Mesajın Etrafına Boşluk Ekler.
              padding: EdgeInsets.all(16), // Her Yönden 16 Padding Verir.
              child: Text( // Boş Durum Mesajını Gösterir.
                'Kitaplıktan yeni bir kitap seçerek başlayabilirsin.', // Boş Durum Metnidir.
              ),
            ),
          for (final book in readingBooks) // Collection for İle Her Okunan Kitap İçin Bir Card Üretir.
            Card( // Kitap Bilgisini Gösteren Card'ı Oluşturur.
              child: ListTile( // Card İçinde Bir Satır Oluşturur.
                contentPadding: const EdgeInsets.all(16), // Her Yönden 16 İç Boşluk Verir.
                leading: const CircleAvatar(child: Icon(Icons.book_outlined)), // Sol Tarafta Kitap İkonlu Avatar Gösterir.
                title: Text(book.title), // Kitap Adını title Olarak Gösterir.
                subtitle: Column( // subtitle Alanında Bilgileri Dikey Olarak Dizer.
                  crossAxisAlignment: CrossAxisAlignment.start, // child'ları Sola Hizalar.
                  children: [ // Column İçindeki Widget Listesidir.
                    Text('${book.readPages} / ${book.totalPages} sayfa'), // Okunan ve Toplam Sayfayı Yazar.
                    const SizedBox(height: 8), // Dikeyde 8 Birim Boşluk Bırakır.
                    LinearProgressIndicator(value: book.progress), // Kitabın İlerlemesini Çubuk Olarak Gösterir.
                  ],
                ),
                onTap: widget.onStartReading, // Tıklanınca Okuma Kaydı Sekmesine Geçer.
              ),
            ),
          const SizedBox(height: 20), // Dikeyde 20 Birim Boşluk Bırakır.
          Text( // Bilgilendirme Metnini Gösterir.
            'Örnek kitaplık verileri kullanılır. Eklediğin kayıtlar yalnızca uygulama açıkken saklanır.', // Bilgilendirme Metnidir.
            style: TextStyle( // Text'in Stilini Tanımlar.
              color: Theme.of(context).colorScheme.onSurfaceVariant, // ColorScheme'deki onSurfaceVariant Rengini Kullanır.
            ),
          ),
        ],
      ),
    );
  }

  Widget _statCard( // İkon, Etiket ve Değerden Oluşan İstatistik Kartı Oluşturur.
    BuildContext context, // Theme Erişimi İçin BuildContext'tir.
    IconData icon, // Kartta Gösterilecek İkondur.
    String label, // Kartın Etiket Metnidir.
    String value, // Kartın Değer Metnidir.
  ) {
    return SizedBox( // Kartı Sabit Genişlikte Tutar.
      width: 200, // Genişliği 200 Yapar.
      child: Card( // Gölgeli ve Yuvarlak Köşeli Bir Card Oluşturur.
        margin: EdgeInsets.zero, // Card'ın Varsayılan Margin'ini Sıfırlar.
        child: Padding( // Card İçeriğine Boşluk Ekler.
          padding: const EdgeInsets.all(16), // Her Yönden 16 Padding Verir.
          child: Column( // Kart İçeriğini Dikey Olarak Dizer.
            crossAxisAlignment: CrossAxisAlignment.start, // child'ları Sola Hizalar.
            children: [ // Column İçindeki Widget Listesidir.
              Icon(icon, color: Theme.of(context).colorScheme.primary), // İkonu primary Renkte Gösterir.
              const SizedBox(height: 8), // Dikeyde 8 Birim Boşluk Bırakır.
              Text(label), // Etiket Metnini Gösterir.
              Text(value, style: const TextStyle(fontWeight: FontWeight.bold)), // Değer Metnini Bold Olarak Gösterir.
            ],
          ),
        ),
      ),
    );
  }
}
