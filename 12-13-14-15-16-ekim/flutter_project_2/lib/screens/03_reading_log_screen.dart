import 'package:flutter/material.dart'; // Flutter'ın Material Widget'larını import Eder.

import '../models/book_model.dart'; // Book Model Class'ını import Eder.
import '../models/reading_session_model.dart'; // ReadingSession Model Class'ını import Eder.

class ReadingLogScreen extends StatefulWidget { // Okuma Kaydı Formunu ve Günlüğünü Gösteren StatefulWidget'tır.
  const ReadingLogScreen({ // Named Parametreler Alan const Constructor'dır.
    super.key, // key Parametresini Superclass'a İletir.
    required this.books, // books Parametresini required Yapar.
    required this.sessions, // sessions Parametresini required Yapar.
    required this.onSave, // onSave Parametresini required Yapar.
  });

  final List<Book> books; // Parent'tan Gelen Kitap Listesidir.
  final List<ReadingSession> sessions; // Parent'tan Gelen Okuma Oturumları Listesidir.
  final ValueChanged<ReadingSession> onSave; // Yeni Oturumu Parent'a İletmek İçin Kullanılan Callback'tir.

  @override // Superclass'taki createState Metodunun Override Edildiğini Belirtir.
  State<ReadingLogScreen> createState() => _ReadingLogScreenState(); // Bu Widget'a Ait State Nesnesini Oluşturur.
}

class _ReadingLogScreenState extends State<ReadingLogScreen> { // ReadingLogScreen'in State'ini Yöneten Private Class'tır.
  final _formKey = GlobalKey<FormState>(); // Form'u Validate Etmek İçin Kullanılan GlobalKey'dir.
  final _pagesController = TextEditingController(); // Sayfa Sayısı TextFormField'ının Controller'ıdır.
  final _minutesController = TextEditingController(); // Dakika TextFormField'ının Controller'ıdır.
  final _noteController = TextEditingController(); // Not TextFormField'ının Controller'ıdır.
  String? _selectedBookId; // Dropdown'da Seçili Kitabın id'sini Tutar, Seçim Yoksa null Olur.

  @override // Superclass'taki dispose Metodunun Override Edildiğini Belirtir.
  void dispose() { // State Kalıcı Olarak Kaldırılırken Çalışan Lifecycle Metodudur.
    _pagesController.dispose(); // Memory Leak Olmaması İçin Controller'ı dispose Eder.
    _minutesController.dispose(); // Memory Leak Olmaması İçin Controller'ı dispose Eder.
    _noteController.dispose(); // Memory Leak Olmaması İçin Controller'ı dispose Eder.
    super.dispose(); // Superclass'ın dispose Metodunu Çağırır.
  }

  void _submit() { // Formu Doğrulayıp Yeni Oturumu Kaydeder ve Formu Temizler.
    if (!_formKey.currentState!.validate()) return; // Validation Başarısızsa Metottan Çıkar.
    final session = ReadingSession( // Formdaki Verilerle Yeni Bir ReadingSession Oluşturur.
      bookId: _selectedBookId!, // Seçili Kitabın id'sini Null Olmadığını Garanti Ederek Atar.
      pages: int.parse(_pagesController.text.trim()), // Sayfa Sayısını int'e Parse Eder.
      minutes: int.parse(_minutesController.text.trim()), // Dakikayı int'e Parse Eder.
      date: DateTime.now(), // Oturum Tarihini Şu An Olarak Atar.
      note: _noteController.text.trim(), // Notu Boşluklardan Temizleyerek Atar.
    );
    widget.onSave(session); // Yeni Oturumu onSave Callback'i İle Parent'a İletir.
    _formKey.currentState!.reset(); // Form Alanlarını ve Validation Durumunu Sıfırlar.
    setState(() => _selectedBookId = null); // Kitap Seçimini Temizleyip build() Metodunu Tetikler.
    _pagesController.clear(); // Sayfa Alanını Temizler.
    _minutesController.clear(); // Dakika Alanını Temizler.
    _noteController.clear(); // Not Alanını Temizler.
    FocusScope.of(context).unfocus(); // Aktif Focus'u Kaldırıp Klavyeyi Kapatır.
  }

  String _formatDate(DateTime date) => // Tarihi gg.aa.yyyy ss:dd Formatında String'e Çevirir.
      '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year} ' // Gün, Ay ve Yılı padLeft İle 2 Haneli Yazar.
      '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}'; // Saat ve Dakikayı 2 Haneli Yazar.

  @override // Superclass'taki build Metodunun Override Edildiğini Belirtir.
  Widget build(BuildContext context) { // Okuma Kaydı Ekranının Widget Tree'sini Oluşturur.
    return SingleChildScrollView( // İçeriği Dikey Olarak Scroll Edilebilir Yapar.
      padding: const EdgeInsets.all(20), // Her Yönden 20 Padding Verir.
      child: Column( // child'ları Dikey Olarak Alt Alta Dizer.
        crossAxisAlignment: CrossAxisAlignment.stretch, // child'ları Yatayda Tam Genişliğe Uzatır.
        children: [ // Column İçindeki Widget Listesidir.
          Text( // Sayfa Başlığını Gösterir.
            'Bugün neler okudun?', // Başlık Metnidir.
            style: Theme.of(context).textTheme.headlineSmall, // Theme'deki headlineSmall Stilini Uygular.
          ),
          const SizedBox(height: 8), // Dikeyde 8 Birim Boşluk Bırakır.
          const Text('Okuduğun yeni sayfaları kaydet, ilerlemeni takip et.'), // Alt Açıklama Metnini Gösterir.
          const SizedBox(height: 20), // Dikeyde 20 Birim Boşluk Bırakır.
          Card( // Formu Saran Card'ı Oluşturur.
            margin: EdgeInsets.zero, // Card'ın Varsayılan Margin'ini Sıfırlar.
            child: Padding( // Card İçeriğine Boşluk Ekler.
              padding: const EdgeInsets.all(20), // Her Yönden 20 Padding Verir.
              child: Form( // TextFormField'ları Gruplayıp Validation Yönetimini Sağlar.
                key: _formKey, // Form'a GlobalKey'i Bağlar.
                child: Column( // Form Alanlarını Dikey Olarak Dizer.
                  crossAxisAlignment: CrossAxisAlignment.stretch, // child'ları Tam Genişliğe Uzatır.
                  children: [ // Column İçindeki Widget Listesidir.
                    DropdownButtonFormField<String>( // Kitap Seçimi İçin Dropdown Alanı Oluşturur.
                      isExpanded: true, // Dropdown'u Tam Genişliğe Uzatır.
                      decoration: const InputDecoration(labelText: 'Kitap seç'), // Alanın labelText'ini Tanımlar.
                      items: [ // Dropdown Seçeneklerinin Listesidir.
                        for (final book in widget.books) // Collection for İle Her Kitap İçin Bir Seçenek Üretir.
                          DropdownMenuItem( // Tek Bir Dropdown Seçeneği Oluşturur.
                            value: book.id, // Seçeneğin Değeri Olarak Kitap id'sini Kullanır.
                            enabled: !book.isCompleted, // Tamamlanan Kitapları Seçilemez Yapar.
                            child: Text( // Seçenekte Gösterilecek Metindir.
                              '${book.title}${book.isCompleted ? ' (bitti)' : ''}', // Tamamlandıysa Kitap Adının Yanına '(bitti)' Ekler.
                              overflow: TextOverflow.ellipsis, // Taşan Metni ... İle Keser.
                            ),
                          ),
                      ],
                      onChanged: (value) => // Seçim Değiştiğinde Çalışan Callback'tir.
                          setState(() => _selectedBookId = value), // Seçilen id'yi Kaydedip build() Metodunu Tetikler.
                      validator: (value) => // Alanın Değerini Doğrulayan validator Callback'idir.
                          value == null ? 'Bir kitap seçin.' : null, // Seçim Yoksa Hata Mesajı, Varsa null Döndürür.
                    ),
                    if (_selectedBookId != null) ...[ // Collection if ve Spread Operator İle Kitap Seçiliyse Kalan Sayfa Bilgisini Ekler.
                      const SizedBox(height: 8), // Dikeyde 8 Birim Boşluk Bırakır.
                      Text( // Kalan Sayfa Sayısını Gösteren Text'tir.
                        'Kalan: ${widget.books.firstWhere((book) => book.id == _selectedBookId).totalPages - widget.books.firstWhere((book) => book.id == _selectedBookId).readPages} sayfa', // Seçili Kitabın Toplam Sayfasından Okunanı Çıkararak Yazar.
                      ),
                    ],
                    const SizedBox(height: 16), // Dikeyde 16 Birim Boşluk Bırakır.
                    TextFormField( // Sayfa Sayısı Giriş Alanını Oluşturur.
                      controller: _pagesController, // Alana _pagesController'ı Bağlar.
                      keyboardType: TextInputType.number, // Sayısal Klavye Açar.
                      textInputAction: TextInputAction.next, // Klavyede 'İleri' Butonunu Gösterir.
                      decoration: const InputDecoration( // Alanın Görünümünü Tanımlar.
                        labelText: 'Yeni okunan sayfa sayısı', // Alanın labelText'idir.
                        prefixIcon: Icon(Icons.menu_book), // Alanın Başında Kitap İkonu Gösterir.
                      ),
                      validator: (value) { // Alanın Değerini Doğrulayan validator Callback'idir.
                        final pages = int.tryParse((value ?? '').trim()); // Değeri int'e Parse Etmeyi Dener.
                        if (pages == null || pages <= 0) { // Parse Başarısızsa veya Pozitif Değilse Bu Bloğa Girer.
                          return 'Pozitif bir tam sayı girin.'; // Hata Mesajını Döndürür.
                        }
                        if (_selectedBookId != null) { // Kitap Seçiliyse Kalan Sayfa Kontrolü Yapar.
                          final book = widget.books.firstWhere( // Seçili Kitabı Listeden Bulur.
                            (book) => book.id == _selectedBookId, // id'si Eşleşen Kitabı Seçer.
                          );
                          if (pages > book.totalPages - book.readPages) { // Girilen Sayfa Kalan Sayfadan Fazlaysa Bu Bloğa Girer.
                            return 'Kalan sayfa sayısını aşamazsınız.'; // Hata Mesajını Döndürür.
                          }
                        }
                        return null; // Hata Yoksa null Döndürür.
                      },
                    ),
                    const SizedBox(height: 16), // Dikeyde 16 Birim Boşluk Bırakır.
                    TextFormField( // Okuma Süresi Giriş Alanını Oluşturur.
                      controller: _minutesController, // Alana _minutesController'ı Bağlar.
                      keyboardType: TextInputType.number, // Sayısal Klavye Açar.
                      textInputAction: TextInputAction.next, // Klavyede 'İleri' Butonunu Gösterir.
                      decoration: const InputDecoration( // Alanın Görünümünü Tanımlar.
                        labelText: 'Okuma süresi (dakika)', // Alanın labelText'idir.
                        prefixIcon: Icon(Icons.timer_outlined), // Alanın Başında Zamanlayıcı İkonu Gösterir.
                      ),
                      validator: (value) { // Alanın Değerini Doğrulayan validator Callback'idir.
                        final minutes = int.tryParse((value ?? '').trim()); // Değeri int'e Parse Etmeyi Dener.
                        return minutes == null || minutes <= 0 // Parse Başarısızsa veya Pozitif Değilse Kontrol Eder.
                            ? 'Pozitif bir tam sayı girin.' // Geçersizse Hata Mesajını Döndürür.
                            : null; // Geçerliyse null Döndürür.
                      },
                    ),
                    const SizedBox(height: 16), // Dikeyde 16 Birim Boşluk Bırakır.
                    TextFormField( // Not Giriş Alanını Oluşturur.
                      controller: _noteController, // Alana _noteController'ı Bağlar.
                      maxLines: 3, // Alanın En Fazla 3 Satır Yüksekliğinde Olmasını Sağlar.
                      maxLength: 300, // En Fazla 300 Karakter Girişine İzin Verir.
                      decoration: const InputDecoration( // Alanın Görünümünü Tanımlar.
                        labelText: 'Aklında kalanlar (isteğe bağlı)', // Alanın labelText'idir.
                        alignLabelWithHint: true, // labelText'i Çok Satırlı Alanın Üstüne Hizalar.
                      ),
                    ),
                    const SizedBox(height: 12), // Dikeyde 12 Birim Boşluk Bırakır.
                    FilledButton.icon( // İkonlu ve Dolgulu Kaydet Butonunu Oluşturur.
                      onPressed: _submit, // Tıklanınca Formu Gönderir.
                      icon: const Icon(Icons.check), // Onay İkonunu Gösterir.
                      label: const Text('Okumayı Kaydet'), // Butonun label'ıdır.
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 28), // Dikeyde 28 Birim Boşluk Bırakır.
          Text('Okuma günlüğün', style: Theme.of(context).textTheme.titleLarge), // Günlük Bölümünün Başlığını titleLarge Stiliyle Gösterir.
          const SizedBox(height: 12), // Dikeyde 12 Birim Boşluk Bırakır.
          if (widget.sessions.isEmpty) // Collection if İle Hiç Oturum Yoksa Aşağıdaki Widget'ı Ekler.
            const Card( // Boş Durum Card'ını Oluşturur.
              child: Padding( // Card İçeriğine Boşluk Ekler.
                padding: EdgeInsets.all(24), // Her Yönden 24 Padding Verir.
                child: Text( // Boş Durum Mesajını Gösterir.
                  'Henüz kayıt yok. İlk okuma kaydını yukarıdan ekle.', // Boş Durum Metnidir.
                ),
              ),
            ),
          for (final session in widget.sessions) // Collection for İle Her Oturum İçin Bir Card Üretir.
            Card( // Oturum Bilgisini Gösteren Card'ı Oluşturur.
              child: Padding( // Card İçeriğine Boşluk Ekler.
                padding: const EdgeInsets.all(16), // Her Yönden 16 Padding Verir.
                child: Column( // Oturum Bilgilerini Dikey Olarak Dizer.
                  crossAxisAlignment: CrossAxisAlignment.start, // child'ları Sola Hizalar.
                  children: [ // Column İçindeki Widget Listesidir.
                    Text( // Kitap Adını Gösteren Text'tir.
                      widget.books // Kitap Listesinde Arama Yapar.
                          .firstWhere( // Koşulu Sağlayan İlk Kitabı Bulur.
                            (book) => book.id == session.bookId, // Oturumun bookId'si İle Eşleşen Kitabı Seçer.
                            orElse: () => const Book( // Kitap Bulunamazsa Varsayılan Bir Book Döndürür.
                              id: '', // Boş id Atar.
                              title: 'Bilinmeyen kitap', // Varsayılan Başlığı Atar.
                              author: '', // Boş Yazar Atar.
                              category: '', // Boş Kategori Atar.
                              totalPages: 1, // Sıfıra Bölmeyi Önlemek İçin 1 Atar.
                            ),
                          )
                          .title, // Bulunan Kitabın title Değerini Alır.
                      style: const TextStyle(fontWeight: FontWeight.bold), // Text'i Bold Yapar.
                    ),
                    const SizedBox(height: 4), // Dikeyde 4 Birim Boşluk Bırakır.
                    Text('${session.pages} sayfa • ${session.minutes} dakika'), // Sayfa ve Dakika Bilgisini Yazar.
                    Text(_formatDate(session.date)), // Formatlanmış Tarihi Gösterir.
                    if (session.note.isNotEmpty) ...[ // Collection if ve Spread Operator İle Not Varsa Aşağıdaki Widget'ları Ekler.
                      const SizedBox(height: 8), // Dikeyde 8 Birim Boşluk Bırakır.
                      Text(session.note), // Oturum Notunu Gösterir.
                    ],
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
