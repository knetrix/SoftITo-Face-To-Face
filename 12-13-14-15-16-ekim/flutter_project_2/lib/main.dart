import 'package:flutter/material.dart'; // Flutter'ın Material Widget'larını import Eder.

import 'models/book_model.dart'; // Book Model Class'ını ve initialBooks Listesini import Eder.
import 'models/reading_session_model.dart'; // ReadingSession Model Class'ını import Eder.
import 'screens/01_reading_summary_screen.dart'; // ReadingSummaryScreen Class'ını import Eder.
import 'screens/02_library_screen.dart'; // LibraryScreen Class'ını import Eder.
import 'screens/03_reading_log_screen.dart'; // ReadingLogScreen Class'ını import Eder.

void main() => runApp(const BookRouteApp()); // Uygulamanın Entry Point'idir, BookRouteApp'i Root Widget Olarak Çalıştırır.

class BookRouteApp extends StatefulWidget { // ThemeMode'u State Olarak Tutan Root StatefulWidget'tır.
  const BookRouteApp({super.key}); // key Parametresini Superclass'a İleten const Constructor'dır.

  @override // Superclass'taki createState Metodunun Override Edildiğini Belirtir.
  State<BookRouteApp> createState() => _BookRouteAppState(); // Bu Widget'a Ait State Nesnesini Oluşturur.
}

class _BookRouteAppState extends State<BookRouteApp> { // BookRouteApp'in State'ini Yöneten Private Class'tır.
  ThemeMode _themeMode = ThemeMode.system; // Başlangıçta Sistemin Theme Ayarını Kullanır.

  @override // Superclass'taki build Metodunun Override Edildiğini Belirtir.
  Widget build(BuildContext context) { // Uygulamanın Widget Tree'sini Oluşturur.
    return MaterialApp( // Material Design Tabanlı Uygulama İskeletini Döndürür.
      debugShowCheckedModeBanner: false, // Sağ Üstteki Debug Banner'ını Gizler.
      title: 'Kitap Rotası', // İşletim Sisteminin Görev Yöneticisinde Görünen Uygulama title'ıdır.
      theme: ThemeData( // Light Mode İçin Theme Ayarlarını Tanımlar.
        useMaterial3: true, // Material 3 Tasarım Sistemini Aktif Eder.
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF356859)), // Seed Color'dan Light ColorScheme Üretir.
        scaffoldBackgroundColor: const Color(0xFFFAF7F0), // Tüm Scaffold'ların Arka Plan Rengini Belirler.
        inputDecorationTheme: const InputDecorationTheme( // Tüm Input Alanları İçin Ortak Dekorasyonu Tanımlar.
          border: OutlineInputBorder(), // Input Alanlarına Çerçeve Çizer.
        ),
      ),
      darkTheme: ThemeData( // Dark Mode İçin Theme Ayarlarını Tanımlar.
        useMaterial3: true, // Material 3 Tasarım Sistemini Aktif Eder.
        colorScheme: ColorScheme.fromSeed( // Seed Color'dan ColorScheme Üretir.
          seedColor: const Color(0xFF356859), // ColorScheme'in Üretileceği Ana Renktir.
          brightness: Brightness.dark, // Dark Mode Renk Paletini Kullanır.
        ),
        inputDecorationTheme: const InputDecorationTheme( // Tüm Input Alanları İçin Ortak Dekorasyonu Tanımlar.
          border: OutlineInputBorder(), // Input Alanlarına Çerçeve Çizer.
        ),
      ),
      themeMode: _themeMode, // Aktif Theme Modunu _themeMode'a Göre Belirler.
      home: ReadingHomeScreen( // Uygulama Açıldığında Gösterilecek İlk Ekrandır.
        onThemeToggle: (isDark) => setState(() { // Theme Değiştirme Callback'ini Tanımlar ve build() Metodunu Tetikler.
          _themeMode = isDark ? ThemeMode.light : ThemeMode.dark; // Mevcut Tema Koyuysa Açığa, Açıksa Koyuya Geçer.
        }),
      ),
    );
  }
}

class ReadingHomeScreen extends StatefulWidget { // Sekmeleri ve Ortak Veriyi Yöneten Ana Ekran StatefulWidget'ıdır.
  const ReadingHomeScreen({super.key, required this.onThemeToggle}); // onThemeToggle'ı required Parametre Olarak Alan const Constructor'dır.

  final ValueChanged<bool> onThemeToggle; // Theme Değiştirmek İçin Parent'tan Gelen Callback'tir.

  @override // Superclass'taki createState Metodunun Override Edildiğini Belirtir.
  State<ReadingHomeScreen> createState() => _ReadingHomeScreenState(); // Bu Widget'a Ait State Nesnesini Oluşturur.
}

class _ReadingHomeScreenState extends State<ReadingHomeScreen> { // ReadingHomeScreen'in State'ini Yöneten Private Class'tır.
  int _selectedIndex = 0; // NavigationBar'da Seçili Olan Sekmenin Index'ini Tutar.
  bool _hasUnreadNotification = true; // Okunmamış Bildirim Olup Olmadığını Tutar.
  final List<Book> _books = List.of(initialBooks); // initialBooks'un Değiştirilebilir Bir Kopyasını Tutar.
  final List<ReadingSession> _sessions = []; // Kaydedilen Okuma Oturumlarını Tutan List'tir.

  void _saveSession(ReadingSession session) { // Yeni Okuma Oturumunu Kaydedip İlgili Kitabın İlerlemesini Günceller.
    final index = _books.indexWhere((book) => book.id == session.bookId); // Oturumun Ait Olduğu Kitabın Index'ini Bulur.
    if (index == -1) return; // Kitap Bulunamazsa Metottan Çıkar.

    setState(() { // State'i Güncelleyip build() Metodunu Tetikler.
      _books[index] = _books[index].withReadPages( // Kitabı Güncel Okunan Sayfa Sayısıyla Yeni Bir Nesneyle Değiştirir.
        _books[index].readPages + session.pages, // Mevcut Okunan Sayfalara Oturumdaki Sayfaları Ekler.
      );
      _sessions.insert(0, session); // Yeni Oturumu Listenin Başına Ekler.
    });
    ScaffoldMessenger.of(context).showSnackBar( // Ekranın Altında Bir SnackBar Gösterir.
      const SnackBar(content: Text('Okuma kaydın eklendi. Harika gidiyorsun!')), // SnackBar'ın İçerik Metnidir.
    );
  }

  @override // Superclass'taki build Metodunun Override Edildiğini Belirtir.
  Widget build(BuildContext context) { // Ana Ekranın Widget Tree'sini Oluşturur.
    return Scaffold( // Sayfanın Temel Material Layout'unu Oluşturur.
      appBar: AppBar( // Ekranın Üstüne Bir AppBar Ekler.
        title: const Text( // AppBar'ın title Text'ini Tanımlar.
          'Kitap Rotası', // AppBar'da Görünen Başlık Metnidir.
          style: TextStyle(fontWeight: FontWeight.bold), // Başlığı Bold Yapar.
        ),
        centerTitle: true, // title'ı AppBar'ın Ortasına Hizalar.
        leading: const Icon(Icons.auto_stories_outlined), // AppBar'ın Sol Tarafında Kitap İkonu Gösterir.
        actions: [ // AppBar'ın Sağ Tarafındaki Action Widget'larının Listesidir.
          IconButton( // Theme Değiştirme Butonunu Oluşturur.
            tooltip: Theme.of(context).brightness == Brightness.dark // Mevcut Tema Koyu Mu Kontrol Eder.
                ? 'Açık temaya geç' // Koyu Temadaysa Bu tooltip'i Gösterir.
                : 'Koyu temaya geç', // Açık Temadaysa Bu tooltip'i Gösterir.
            icon: Icon( // Tema Durumuna Göre İkon Gösterir.
              Theme.of(context).brightness == Brightness.dark // Mevcut Tema Koyu Mu Kontrol Eder.
                  ? Icons.light_mode_outlined // Koyu Temadaysa Güneş İkonunu Gösterir.
                  : Icons.dark_mode_outlined, // Açık Temadaysa Ay İkonunu Gösterir.
            ),
            onPressed: () => widget.onThemeToggle( // Tıklanınca Parent'taki onThemeToggle Callback'ini Çağırır.
              Theme.of(context).brightness == Brightness.dark, // Mevcut Temanın Koyu Olup Olmadığını Parametre Olarak Gönderir.
            ),
          ),
          IconButton( // Bildirim Butonunu Oluşturur.
            tooltip: _hasUnreadNotification // Okunmamış Bildirim Var Mı Kontrol Eder.
                ? 'Bildirimler: 1 okunmamış bildirim' // Okunmamış Bildirim Varsa Bu tooltip'i Gösterir.
                : 'Bildirimler', // Yoksa Bu tooltip'i Gösterir.
            icon: Badge( // İkonun Üzerine Bir Badge Ekler.
              isLabelVisible: _hasUnreadNotification, // Okunmamış Bildirim Yoksa Badge'i Gizler.
              label: const Text('1'), // Badge Üzerinde '1' Yazar.
              child: const Icon(Icons.notifications_outlined), // Badge'in child'ı Olan Bildirim İkonudur.
            ),
            onPressed: () { // Butona Tıklanınca Çalışan Callback'tir.
              setState(() => _hasUnreadNotification = false); // Bildirimi Okundu Olarak İşaretleyip build() Metodunu Tetikler.
              showDialog<void>( // Ekranda Bir Dialog Açar.
                context: context, // Dialog'un Açılacağı BuildContext'tir.
                builder: (context) => AlertDialog( // Bir AlertDialog Build Eder.
                  title: const Text('Okuma hatırlatması'), // Dialog'un title'ıdır.
                  content: const Text( // Dialog'un İçerik Metnidir.
                    'Bugün kendine bir okuma molası ver. ' // Metnin İlk Kısmıdır.
                    'Okuduğun sayfaları kaydetmeyi unutma!', // Bitişik String Literal Olarak Metnin İkinci Kısmıdır.
                  ),
                  actions: [ // Dialog'un Alt Kısmındaki Butonlardır.
                    TextButton( // Düz Bir Metin Butonu Oluşturur.
                      onPressed: () => Navigator.of(context).pop(), // Tıklanınca Dialog'u Kapatır.
                      child: const Text('Kapat'), // Butonun Metnidir.
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea( // İçeriği Çentik ve Status Bar Gibi Sistem Alanlarından Korur.
        child: Center( // İçeriği Yatayda Ortalar.
          child: ConstrainedBox( // child'ın Boyutuna Sınır Koyar.
            constraints: const BoxConstraints(maxWidth: 1100), // Maksimum Genişliği 1100 İle Sınırlar.
            child: IndexedStack( // Tüm Sayfaları Bellekte Tutup Yalnızca Seçili Index'tekini Gösterir.
              index: _selectedIndex, // Gösterilecek child'ın Index'ini Belirler.
              children: [ // IndexedStack'teki Sayfaların Listesidir.
                ReadingSummaryScreen( // Index 0: Özet Ekranıdır.
                  books: _books, // Kitap Listesini Gönderir.
                  sessions: _sessions, // Okuma Oturumlarını Gönderir.
                  onStartReading: () => setState(() => _selectedIndex = 2), // Okuma Kaydı Sekmesine Geçiş Yapar.
                ),
                LibraryScreen( // Index 1: Kitaplık Ekranıdır.
                  books: _books, // Kitap Listesini Gönderir.
                  onAddBook: (book) => setState(() => _books.add(book)), // Yeni Kitabı Listeye Ekleyip build() Metodunu Tetikler.
                ),
                ReadingLogScreen( // Index 2: Okuma Kaydı Ekranıdır.
                  books: _books, // Kitap Listesini Gönderir.
                  sessions: _sessions, // Okuma Oturumlarını Gönderir.
                  onSave: _saveSession, // Kaydetme Callback'i Olarak _saveSession'ı Gönderir.
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: NavigationBar( // Ekranın Altına NavigationBar Ekler.
        selectedIndex: _selectedIndex, // Seçili Sekmenin Index'ini Belirler.
        onDestinationSelected: (index) => // Bir Destination Seçildiğinde Çalışan Callback'tir.
            setState(() => _selectedIndex = index), // Seçilen Index'i Kaydedip build() Metodunu Tetikler.
        destinations: const [ // NavigationBar'daki Destination Listesidir.
          NavigationDestination( // Özet Destination'ını Tanımlar.
            icon: Icon(Icons.dashboard_outlined), // Seçili Değilken Görünen İkondur.
            selectedIcon: Icon(Icons.dashboard), // Seçiliyken Görünen İkondur.
            label: 'Özet', // Destination'ın Altında Görünen label'dır.
          ),
          NavigationDestination( // Kitaplık Destination'ını Tanımlar.
            icon: Icon(Icons.local_library_outlined), // Seçili Değilken Görünen İkondur.
            selectedIcon: Icon(Icons.local_library), // Seçiliyken Görünen İkondur.
            label: 'Kitaplık', // Destination'ın Altında Görünen label'dır.
          ),
          NavigationDestination( // Okuma Kaydı Destination'ını Tanımlar.
            icon: Icon(Icons.edit_note_outlined), // Seçili Değilken Görünen İkondur.
            selectedIcon: Icon(Icons.edit_note), // Seçiliyken Görünen İkondur.
            label: 'Okuma Kaydı', // Destination'ın Altında Görünen label'dır.
          ),
        ],
      ),
    );
  }
}
