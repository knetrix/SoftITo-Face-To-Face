import 'package:flutter/material.dart'; // Flutter'ın Material Widget'larını import Eder.

import '../models/book_model.dart'; // Book Model Class'ını import Eder.

class LibraryScreen extends StatefulWidget { // Kitapları Listeleyen, Filtreleyen ve Ekleyen StatefulWidget'tır.
  const LibraryScreen({ // Named Parametreler Alan const Constructor'dır.
    super.key, // key Parametresini Superclass'a İletir.
    required this.books, // books Parametresini required Yapar.
    required this.onAddBook, // onAddBook Parametresini required Yapar.
  });

  final List<Book> books; // Parent'tan Gelen Kitap Listesidir.
  final ValueChanged<Book> onAddBook; // Yeni Kitabı Parent'a İletmek İçin Kullanılan Callback'tir.

  @override // Superclass'taki createState Metodunun Override Edildiğini Belirtir.
  State<LibraryScreen> createState() => _LibraryScreenState(); // Bu Widget'a Ait State Nesnesini Oluşturur.
}

class _LibraryScreenState extends State<LibraryScreen> { // LibraryScreen'in State'ini Yöneten Private Class'tır.
  String _query = ''; // Arama Kutusuna Girilen Metni Tutar.
  String _category = 'Tümü'; // Seçili Kategori Filtresini Tutar.
  bool _onlyUnread = false; // Sadece Bitmemiş Kitapları Gösterme Filtresini Tutar.
  final Set<String> _addedCategories = {}; // Kullanıcının Eklediği Kategorileri Tutan Set'tir.

  List<String> get _categories => { // Tüm Kategorileri Tekrarsız Olarak Döndüren Getter'dır.
    'Roman', // Varsayılan Kategori.
    'Öykü', // Varsayılan Kategori.
    'Bilim', // Varsayılan Kategori.
    ...widget.books.map((book) => book.category), // Spread Operator İle Kitaplardaki Kategorileri Ekler.
    ..._addedCategories, // Spread Operator İle Kullanıcının Eklediği Kategorileri Ekler.
  }.toList(); // Set'i List'e Çevirir.

  Future<void> _addCategory() async { // Yeni Kategori Eklemek İçin Dialog Açıp Sonucu İşler.
    final formKey = GlobalKey<FormState>(); // Dialog İçindeki Form'u Validate Etmek İçin GlobalKey Oluşturur.
    var name = ''; // Girilen Kategori Adını Tutacak Geçici Değişkendir.
    final category = await showDialog<String>( // Dialog Açar ve Dönen String'i await İle Bekler.
      context: context, // Dialog'un Açılacağı BuildContext'tir.
      builder: (context) => AlertDialog( // Bir AlertDialog Build Eder.
        title: const Text('Kategori ekle'), // Dialog'un title'ıdır.
        content: Form( // TextFormField'ı Saran ve Validation Yönetimini Sağlayan Form'dur.
          key: formKey, // Form'a GlobalKey'i Bağlar.
          child: TextFormField( // Kategori Adı Giriş Alanını Oluşturur.
            autofocus: true, // Dialog Açılınca Alana Otomatik Focus Verir.
            decoration: const InputDecoration(labelText: 'Kategori adı'), // Alanın labelText'ini Tanımlar.
            onSaved: (value) => name = value!.trim(), // Form save Edildiğinde Değeri name'e Atar.
            validator: (value) { // Alanın Değerini Doğrulayan validator Callback'idir.
              final text = value?.trim() ?? ''; // Değer null İse Boş String Kullanıp Boşlukları Temizler.
              if (text.isEmpty) return 'Kategori adı girin.'; // Boşsa Hata Mesajını Döndürür.
              if ([ // Mevcut Kategoriler Listesini Oluşturur.
                'Tümü', // 'Tümü' Seçeneğini de Kontrole Dahil Eder.
                ..._categories, // Spread Operator İle Mevcut Kategorileri Ekler.
              ].any((category) => _normalize(category) == _normalize(text))) { // Normalize Edilmiş Aynı İsim Var Mı Kontrol Eder.
                return 'Bu kategori zaten var.'; // Varsa Hata Mesajını Döndürür.
              }
              return null; // Hata Yoksa null Döndürür.
            },
          ),
        ),
        actions: [ // Dialog'un Alt Kısmındaki Butonlardır.
          TextButton( // Düz Bir Metin Butonu Oluşturur.
            onPressed: () => Navigator.pop(context), // Tıklanınca Sonuç Döndürmeden Dialog'u Kapatır.
            child: const Text('Vazgeç'), // Butonun Metnidir.
          ),
          FilledButton( // Dolgulu Ekle Butonunu Oluşturur.
            onPressed: () { // Butona Tıklanınca Çalışan Callback'tir.
              if (!formKey.currentState!.validate()) return; // Validation Başarısızsa Metottan Çıkar.
              formKey.currentState!.save(); // Alanın onSaved Callback'ini Tetikler.
              Navigator.pop(context, name); // Dialog'u Kapatıp Kategori Adını Döndürür.
            },
            child: const Text('Ekle'), // Butonun Metnidir.
          ),
        ],
      ),
    );
    if (!mounted || category == null) return; // Widget Ağaçtan Kalktıysa veya İptal Edildiyse Metottan Çıkar.
    setState(() => _addedCategories.add(category)); // Yeni Kategoriyi Set'e Ekleyip build() Metodunu Tetikler.
  }

  Future<void> _addBook() async { // Yeni Kitap Eklemek İçin Dialog Açıp Sonucu Parent'a İletir.
    final formKey = GlobalKey<FormState>(); // Dialog İçindeki Form'u Validate Etmek İçin GlobalKey Oluşturur.
    var title = ''; // Kitap Adını Tutacak Geçici Değişkendir.
    var author = ''; // Yazar Adını Tutacak Geçici Değişkendir.
    var totalPages = 0; // Toplam Sayfa Sayısını Tutacak Geçici Değişkendir.
    var category = _category == 'Tümü' ? _categories.first : _category; // Seçili Filtre 'Tümü' İse İlk Kategoriyi, Değilse Seçili Kategoriyi Kullanır.
    final book = await showDialog<Book>( // Dialog Açar ve Dönen Book'u await İle Bekler.
      context: context, // Dialog'un Açılacağı BuildContext'tir.
      builder: (context) => AlertDialog( // Bir AlertDialog Build Eder.
        title: const Text('Kitap ekle'), // Dialog'un title'ıdır.
        content: SingleChildScrollView( // Dialog İçeriğini Scroll Edilebilir Yapar.
          child: Form( // TextFormField'ları Gruplayıp Validation Yönetimini Sağlar.
            key: formKey, // Form'a GlobalKey'i Bağlar.
            child: Column( // Form Alanlarını Dikey Olarak Dizer.
              mainAxisSize: MainAxisSize.min, // Column'un Yüksekliğini İçeriği Kadar Yapar.
              children: [ // Column İçindeki Widget Listesidir.
                TextFormField( // Kitap Adı Giriş Alanını Oluşturur.
                  decoration: const InputDecoration(labelText: 'Kitap adı'), // Alanın labelText'ini Tanımlar.
                  validator: (value) => value == null || value.trim().isEmpty // Değer Boş Mu Kontrol Eder.
                      ? 'Kitap adı girin.' // Boşsa Hata Mesajını Döndürür.
                      : null, // Doluysa null Döndürür.
                  onSaved: (value) => title = value!.trim(), // Form save Edildiğinde Değeri title'a Atar.
                ),
                const SizedBox(height: 16), // Dikeyde 16 Birim Boşluk Bırakır.
                TextFormField( // Yazar Giriş Alanını Oluşturur.
                  decoration: const InputDecoration(labelText: 'Yazar'), // Alanın labelText'ini Tanımlar.
                  validator: (value) => value == null || value.trim().isEmpty // Değer Boş Mu Kontrol Eder.
                      ? 'Yazar girin.' // Boşsa Hata Mesajını Döndürür.
                      : null, // Doluysa null Döndürür.
                  onSaved: (value) => author = value!.trim(), // Form save Edildiğinde Değeri author'a Atar.
                ),
                const SizedBox(height: 16), // Dikeyde 16 Birim Boşluk Bırakır.
                DropdownButtonFormField<String>( // Kategori Seçimi İçin Dropdown Alanı Oluşturur.
                  initialValue: category, // Dropdown'un Başlangıç Değerini Belirler.
                  isExpanded: true, // Dropdown'u Tam Genişliğe Uzatır.
                  decoration: const InputDecoration(labelText: 'Kategori'), // Alanın labelText'ini Tanımlar.
                  items: [ // Dropdown Seçeneklerinin Listesidir.
                    for (final name in _categories) // Collection for İle Her Kategori İçin Bir Seçenek Üretir.
                      DropdownMenuItem(value: name, child: Text(name)), // Kategori Adını Değer ve Metin Olarak Kullanır.
                  ],
                  onChanged: (value) => category = value!, // Seçim Değişince category'yi Günceller.
                ),
                const SizedBox(height: 16), // Dikeyde 16 Birim Boşluk Bırakır.
                TextFormField( // Toplam Sayfa Giriş Alanını Oluşturur.
                  decoration: const InputDecoration(labelText: 'Toplam sayfa'), // Alanın labelText'ini Tanımlar.
                  keyboardType: TextInputType.number, // Sayısal Klavye Açar.
                  validator: (value) => // Alanın Değerini Doğrulayan validator Callback'idir.
                      (int.tryParse(value?.trim() ?? '') ?? 0) <= 0 // Değer Parse Edilemiyorsa veya 0'dan Küçükse Kontrol Eder.
                      ? 'Pozitif bir tam sayı girin.' // Geçersizse Hata Mesajını Döndürür.
                      : null, // Geçerliyse null Döndürür.
                  onSaved: (value) => totalPages = int.parse(value!.trim()), // Değeri int'e Parse Edip totalPages'e Atar.
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
          FilledButton( // Dolgulu Ekle Butonunu Oluşturur.
            onPressed: () { // Butona Tıklanınca Çalışan Callback'tir.
              if (!formKey.currentState!.validate()) return; // Validation Başarısızsa Metottan Çıkar.
              formKey.currentState!.save(); // Tüm Alanların onSaved Callback'lerini Tetikler.
              Navigator.pop( // Dialog'u Kapatıp Yeni Kitabı Döndürür.
                context, // Dialog'un BuildContext'idir.
                Book( // Formdaki Verilerle Yeni Bir Book Oluşturur.
                  id: DateTime.now().microsecondsSinceEpoch.toString(), // Zaman Damgasından Benzersiz Bir id Üretir.
                  title: title, // Girilen Kitap Adını Atar.
                  author: author, // Girilen Yazarı Atar.
                  category: category, // Seçilen Kategoriyi Atar.
                  totalPages: totalPages, // Girilen Toplam Sayfayı Atar.
                ),
              );
            },
            child: const Text('Ekle'), // Butonun Metnidir.
          ),
        ],
      ),
    );
    if (!mounted || book == null) return; // Widget Ağaçtan Kalktıysa veya İptal Edildiyse Metottan Çıkar.
    widget.onAddBook(book); // Yeni Kitabı onAddBook Callback'i İle Parent'a İletir.
  }

  String _normalize(String text) => // Türkçe Karakterleri Dikkate Alarak Metni Küçük Harfe Çevirir.
      text.replaceAll('İ', 'i').replaceAll('I', 'ı').toLowerCase(); // İ'yi i'ye, I'yı ı'ya Çevirip toLowerCase Uygular.

  @override // Superclass'taki build Metodunun Override Edildiğini Belirtir.
  Widget build(BuildContext context) { // Kitaplık Ekranının Widget Tree'sini Oluşturur.
    final filteredBooks = widget.books // Kitap Listesini Filtrelemeye Başlar.
        .where( // Koşulu Sağlayan Kitapları Seçer.
          (book) => // Her Kitap İçin Koşulu Kontrol Eder.
              (_category == 'Tümü' || book.category == _category) && // Kategori Filtresini Uygular.
              (!_onlyUnread || !book.isCompleted) && // 'Yalnızca Bitirmediklerim' Filtresini Uygular.
              _normalize('${book.title} ${book.author}') // Kitap Adı ve Yazarı Normalize Eder.
                  .contains(_normalize(_query.trim())), // Arama Metnini İçerip İçermediğini Kontrol Eder.
        )
        .toList(); // Sonucu List'e Çevirir.

    return SingleChildScrollView( // İçeriği Dikey Olarak Scroll Edilebilir Yapar.
      padding: const EdgeInsets.all(20), // Her Yönden 20 Padding Verir.
      child: Column( // child'ları Dikey Olarak Alt Alta Dizer.
        crossAxisAlignment: CrossAxisAlignment.stretch, // child'ları Yatayda Tam Genişliğe Uzatır.
        children: [ // Column İçindeki Widget Listesidir.
          Text( // Sayfa Başlığını Gösterir.
            'Kendi dünyanı keşfet', // Başlık Metnidir.
            style: Theme.of(context).textTheme.headlineSmall, // Theme'deki headlineSmall Stilini Uygular.
          ),
          const SizedBox(height: 8), // Dikeyde 8 Birim Boşluk Bırakır.
          const Text('Bir sonraki yolculuğun kitaplığında seni bekliyor.'), // Alt Açıklama Metnini Gösterir.
          const SizedBox(height: 12), // Dikeyde 12 Birim Boşluk Bırakır.
          Wrap( // Butonları Sığmadığında Alt Satıra Geçirerek Dizer.
            spacing: 8, // Butonlar Arasında Yatayda 8 Boşluk Bırakır.
            runSpacing: 8, // Satırlar Arasında Dikeyde 8 Boşluk Bırakır.
            children: [ // Wrap İçindeki Butonların Listesidir.
              FilledButton.icon( // İkonlu ve Dolgulu Bir Buton Oluşturur.
                onPressed: _addBook, // Tıklanınca Kitap Ekleme Dialog'unu Açar.
                icon: const Icon(Icons.add), // Ekle İkonunu Gösterir.
                label: const Text('Kitap ekle'), // Butonun label'ıdır.
              ),
              OutlinedButton.icon( // İkonlu ve Kenarlıklı Bir Buton Oluşturur.
                onPressed: _addCategory, // Tıklanınca Kategori Ekleme Dialog'unu Açar.
                icon: const Icon(Icons.create_new_folder_outlined), // Yeni Klasör İkonunu Gösterir.
                label: const Text('Kategori ekle'), // Butonun label'ıdır.
              ),
            ],
          ),
          const SizedBox(height: 20), // Dikeyde 20 Birim Boşluk Bırakır.
          TextField( // Arama Kutusunu Oluşturur.
            onChanged: (value) => setState(() => _query = value), // Her Değişiklikte _query'yi Güncelleyip build() Metodunu Tetikler.
            decoration: const InputDecoration( // Alanın Görünümünü Tanımlar.
              labelText: 'Kitap veya yazar ara', // Alanın labelText'idir.
              prefixIcon: Icon(Icons.search), // Alanın Başında Arama İkonu Gösterir.
            ),
          ),
          const SizedBox(height: 12), // Dikeyde 12 Birim Boşluk Bırakır.
          Wrap( // Kategori Chip'lerini Sığmadığında Alt Satıra Geçirerek Dizer.
            spacing: 8, // Chip'ler Arasında Yatayda 8 Boşluk Bırakır.
            children: [ // Wrap İçindeki Chip'lerin Listesidir.
              for (final category in ['Tümü', ..._categories]) // Collection for İle 'Tümü' ve Tüm Kategoriler İçin Chip Üretir.
                ChoiceChip( // Tek Seçimli Bir Chip Oluşturur.
                  label: Text(category), // Chip'in label'ıdır.
                  selected: _category == category, // Seçili Kategoriyle Eşleşiyorsa Chip'i Seçili Gösterir.
                  onSelected: (_) => setState(() => _category = category), // Seçilince _category'yi Güncelleyip build() Metodunu Tetikler.
                ),
            ],
          ),
          SwitchListTile( // Switch İçeren Bir ListTile Oluşturur.
            contentPadding: EdgeInsets.zero, // ListTile'ın İç Boşluğunu Sıfırlar.
            title: const Text('Yalnızca bitirmediklerim'), // ListTile'ın title'ıdır.
            value: _onlyUnread, // Switch'in Mevcut Değerini Belirler.
            onChanged: (value) => setState(() => _onlyUnread = value), // Switch Değişince _onlyUnread'i Güncelleyip build() Metodunu Tetikler.
          ),
          Text('${filteredBooks.length} kitap bulundu'), // Filtrelenen Kitap Sayısını Gösterir.
          const SizedBox(height: 16), // Dikeyde 16 Birim Boşluk Bırakır.
          if (filteredBooks.isEmpty) // Collection if İle Sonuç Yoksa Aşağıdaki Widget'ı Ekler.
            const Padding( // Mesajın Etrafına Boşluk Ekler.
              padding: EdgeInsets.symmetric(vertical: 40), // Dikeyde 40 Padding Verir.
              child: Center(child: Text('Aramana uygun kitap bulunamadı.')), // Boş Durum Mesajını Ortalanmış Gösterir.
            ),
          LayoutBuilder( // Parent'ın Constraints Bilgisine Göre Responsive UI Oluşturur.
            builder: (context, constraints) { // Mevcut constraints İle Widget'ı Build Eder.
              final columns = constraints.maxWidth >= 850 // Genişlik 850 ve Üzeriyse 3 Sütun Kullanır.
                  ? 3 // Geniş Ekranlar İçin Sütun Sayısıdır.
                  : constraints.maxWidth >= 550 // Genişlik 550 ve Üzeriyse 2 Sütun Kullanır.
                  ? 2 // Orta Ekranlar İçin Sütun Sayısıdır.
                  : 1; // Dar Ekranlar İçin Sütun Sayısıdır.
              final width = // Her Bir Kartın Genişliğini Hesaplar.
                  (constraints.maxWidth - (columns - 1) * 16) / columns; // Toplam Genişlikten Boşlukları Çıkarıp Sütun Sayısına Böler.
              return Wrap( // Kartları Sığmadığında Alt Satıra Geçirerek Dizer.
                spacing: 16, // Kartlar Arasında Yatayda 16 Boşluk Bırakır.
                runSpacing: 16, // Satırlar Arasında Dikeyde 16 Boşluk Bırakır.
                children: [ // Wrap İçindeki Kartların Listesidir.
                  for (final book in filteredBooks) // Collection for İle Her Filtrelenmiş Kitap İçin Kart Üretir.
                    SizedBox( // Kartı Hesaplanan Genişlikte Tutar.
                      width: width, // SizedBox Genişliğini width Yapar.
                      child: Card( // Gölgeli ve Yuvarlak Köşeli Bir Card Oluşturur.
                        margin: EdgeInsets.zero, // Card'ın Varsayılan Margin'ini Sıfırlar.
                        child: Padding( // Card İçeriğine Boşluk Ekler.
                          padding: const EdgeInsets.all(20), // Her Yönden 20 Padding Verir.
                          child: Column( // Kart İçeriğini Dikey Olarak Dizer.
                            crossAxisAlignment: CrossAxisAlignment.start, // child'ları Sola Hizalar.
                            children: [ // Column İçindeki Widget Listesidir.
                              Row( // Avatar ve Kategoriyi Yatay Olarak Dizer.
                                children: [ // Row İçindeki Widget Listesidir.
                                  CircleAvatar( // Yuvarlak Bir Avatar Oluşturur.
                                    backgroundColor: Theme.of(context) // Theme'e Erişir.
                                        .colorScheme // ColorScheme'i Alır.
                                        .primaryContainer, // primaryContainer Rengini Arka Plan Yapar.
                                    child: Icon( // Kitap Durumuna Göre İkon Gösterir.
                                      book.isCompleted // Kitap Tamamlandı Mı Kontrol Eder.
                                          ? Icons.task_alt // Tamamlandıysa Onay İkonunu Gösterir.
                                          : Icons.auto_stories, // Tamamlanmadıysa Kitap İkonunu Gösterir.
                                    ),
                                  ),
                                  const SizedBox(width: 12), // Yatayda 12 Birim Boşluk Bırakır.
                                  Expanded( // Row'daki Kalan Tüm Alanı Kaplar.
                                    child: Text( // Kategori Adını Gösteren Text'tir.
                                      book.category, // Kitabın Kategorisini Yazar.
                                      style: TextStyle( // Text'in Stilini Tanımlar.
                                        color: Theme.of(context) // Theme'e Erişir.
                                            .colorScheme // ColorScheme'i Alır.
                                            .primary, // primary Rengini Text Rengi Yapar.
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16), // Dikeyde 16 Birim Boşluk Bırakır.
                              Text( // Kitap Adını Gösteren Text'tir.
                                book.title, // Kitabın title Değerini Yazar.
                                style: Theme.of(context).textTheme.titleMedium, // Theme'deki titleMedium Stilini Uygular.
                              ),
                              const SizedBox(height: 4), // Dikeyde 4 Birim Boşluk Bırakır.
                              Text(book.author), // Kitabın Yazarını Gösterir.
                              const SizedBox(height: 20), // Dikeyde 20 Birim Boşluk Bırakır.
                              LinearProgressIndicator( // Okuma İlerlemesini Çubuk Olarak Gösterir.
                                value: book.progress, // Çubuğun Doluluk Oranını Belirler.
                                minHeight: 6, // Çubuğun Yüksekliğini 6 Yapar.
                              ),
                              const SizedBox(height: 8), // Dikeyde 8 Birim Boşluk Bırakır.
                              Text( // Sayfa Bilgisini Gösteren Text'tir.
                                '${book.readPages} / ${book.totalPages} sayfa', // Okunan ve Toplam Sayfayı Yazar.
                              ),
                              const SizedBox(height: 8), // Dikeyde 8 Birim Boşluk Bırakır.
                              Text( // Okuma Durumunu Gösteren Text'tir.
                                book.isCompleted // Kitap Tamamlandı Mı Kontrol Eder.
                                    ? 'Tamamlandı' // Tamamlandıysa Bu Metni Gösterir.
                                    : book.readPages == 0 // Hiç Okunmadı Mı Kontrol Eder.
                                    ? 'Okunacak' // Hiç Okunmadıysa Bu Metni Gösterir.
                                    : 'Okunuyor', // Okunmaya Devam Ediyorsa Bu Metni Gösterir.
                                style: const TextStyle( // Text'in Stilini Tanımlar.
                                  fontWeight: FontWeight.bold, // Text'i Bold Yapar.
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
