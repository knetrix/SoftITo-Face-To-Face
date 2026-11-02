import 'package:flutter/material.dart'; // Flutter'ın Material Widget'larını import Eder.

import 'screens/01_layout_screen.dart'; // LayoutStylingScreen Class'ını import Eder.
import 'screens/02_markets_list_screen.dart'; // MarketsGridListScreen Class'ını import Eder.
import 'screens/03_transfer_form_screen.dart'; // TransferFormScreen Class'ını import Eder.

void main() { // Uygulamanın Entry Point'idir.
  runApp(const DtmMasterApp()); // DtmMasterApp'i Root Widget Olarak Çalıştırıp Uygulamayı Başlatır.
}

class DtmMasterApp extends StatelessWidget { // Uygulamanın Root Widget'ıdır, State Tutmayan Bir StatelessWidget'tır.
  const DtmMasterApp({ // const Constructor'dır.
    super.key, // key Parametresini Superclass Olan StatelessWidget'a İletir.
  });

  @override // Superclass'taki build Metodunun Override Edildiğini Belirtir.
  Widget build(BuildContext context) { // Uygulamanın Widget Tree'sini Oluşturur.
    return MaterialApp( // Material Design Tabanlı Uygulama İskeletini Döndürür.
      debugShowCheckedModeBanner: false, // Sağ Üstteki Debug Banner'ını Gizler.
      title: "DTM Flutter Sınıfı", // İşletim Sisteminin Görev Yöneticisinde Görünen Uygulama title'ıdır.
      theme: ThemeData( // Uygulamanın Genel Theme Ayarlarını Tanımlar.
        useMaterial3: true, // Material 3 Tasarım Sistemini Aktif Eder.
        colorScheme: ColorScheme.fromSeed( // Tek Bir Seed Color'dan Tüm ColorScheme'i Üretir.
          seedColor: const Color(0xFF6366F1), // ColorScheme'in Üretileceği Ana Renktir.
          brightness: Brightness.light, // Light Mode Renk Paletini Kullanır.
        ),
      ),
      home: const LiveCanvasScreen(), // Uygulama Açıldığında Gösterilecek İlk Ekranı Belirler.
    );
  }
}

class LiveCanvasScreen extends StatefulWidget { // Seçili Sekmeyi State Olarak Tutan Ana Ekran StatefulWidget'ıdır.
  const LiveCanvasScreen({super.key}); // key Parametresini Superclass'a İleten const Constructor'dır.

  @override // Superclass'taki createState Metodunun Override Edildiğini Belirtir.
  State<LiveCanvasScreen> createState() => _LiveCanvasScreenState(); // Bu Widget'a Ait State Nesnesini Oluşturur.
}

class _LiveCanvasScreenState extends State<LiveCanvasScreen> { // LiveCanvasScreen'in State'ini ve UI'ını Yöneten Private Class'tır.
  int _selectedIndex = 0; // NavigationBar'da Seçili Olan Sekmenin Index'ini Tutar.

  @override // Superclass'taki build Metodunun Override Edildiğini Belirtir.
  Widget build(BuildContext context) { // Ana Ekranın Widget Tree'sini Oluşturur.
    return Scaffold( // Sayfanın Temel Material Layout'unu Oluşturur.
      backgroundColor: const Color(0xFFF8FaFC), // Scaffold'un Arka Plan Rengini Belirler.
      appBar: AppBar( // Ekranın Üstüne Bir AppBar Ekler.
        title: const Text( // AppBar'ın title Text'ini Tanımlar.
          "DTM Canlı Arayüz", // AppBar'da Görünen Başlık Metnidir.
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18), // Başlığı Bold ve 18 Font Size Yapar.
        ),
        centerTitle: true, // title'ı AppBar'ın Ortasına Hizalar.
        backgroundColor: Colors.white, // AppBar'ın Arka Plan Rengini Beyaz Yapar.
        elevation: 0, // AppBar'ın Gölgesini Kaldırır.
        actions: [ // AppBar'ın Sağ Tarafındaki Action Widget'larının Listesidir.
          IconButton( // Tıklanabilir Bir İkon Butonu Oluşturur.
            icon: const Icon(Icons.notifications_active_outlined), // Bildirim İkonunu Gösterir.
            onPressed: () {}, // Şimdilik Boş Bir onPressed Callback'idir.
          ),
        ],
      ), // AppBar
      body: SafeArea( // İçeriği Çentik ve Status Bar Gibi Sistem Alanlarından Korur.
        child: IndexedStack( // Tüm Sayfaları Bellekte Tutup Yalnızca Seçili Index'tekini Gösterir.
          index: _selectedIndex, // Gösterilecek child'ın Index'ini Belirler.
          children: const [ // IndexedStack'teki Sayfaların Listesidir.
            LayoutStylingScreen(), // Index 0: Ana Sayfa Ekranıdır.
            MarketsGridListScreen(), // Index 1: Piyasalar Ekranıdır.
            TransferFormScreen(), // Index 2: Transfer Ekranıdır.
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar( // Ekranın Altına NavigationBar Ekler.
        selectedIndex: _selectedIndex, // Seçili Sekmenin Index'ini Belirler.
        onDestinationSelected: (index) { // Bir Destination Seçildiğinde Çalışan Callback'tir.
          setState(() => _selectedIndex = index); // Seçilen Index'i Kaydedip build() Metodunu Tetikler.
        },
        destinations: const [ // NavigationBar'daki Destination Listesidir.
          NavigationDestination( // Ana Sayfa Destination'ını Tanımlar.
            icon: Icon(Icons.home_outlined), // Seçili Değilken Görünen İkondur.
            selectedIcon: Icon(Icons.home), // Seçiliyken Görünen İkondur.
            label: 'Ana Sayfa', // Destination'ın Altında Görünen label'dır.
          ),
          NavigationDestination( // Piyasalar Destination'ını Tanımlar.
            icon: Icon(Icons.show_chart), // Grafik İkonunu Gösterir.
            label: 'Piyasalar', // Destination'ın Altında Görünen label'dır.
          ),
          NavigationDestination( // Transfer Destination'ını Tanımlar.
            icon: Icon(Icons.send_outlined), // Seçili Değilken Görünen İkondur.
            selectedIcon: Icon(Icons.send), // Seçiliyken Görünen İkondur.
            label: 'Transfer', // Destination'ın Altında Görünen label'dır.
          ),
        ],
      ),
    );
  }
}
