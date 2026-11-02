import 'package:flutter/material.dart'; // Flutter'ın Material Widget'larını import Eder.

void main() { // Uygulamanın Entry Point'idir.
  runApp(const CounterApp()); // CounterApp'i Root Widget Olarak Çalıştırıp Uygulamayı Başlatır.
}

class CounterApp extends StatelessWidget { // Uygulamanın Root Widget'ıdır, State Tutmayan Bir StatelessWidget'tır.
  const CounterApp({super.key}); // key Parametresini Superclass'a İleten const Constructor'dır.

  @override // Superclass'taki build Metodunun Override Edildiğini Belirtir.
  Widget build(BuildContext context) { // Uygulamanın Widget Tree'sini Oluşturur.
    return MaterialApp( // Material Tasarımlı Uygulama Çatısını Oluşturur.
      title: 'Counter App', // Uygulamanın Başlığını Belirler.
      debugShowCheckedModeBanner: false, // Sağ Üstteki Debug Banner'ını Gizler.
      theme: ThemeData( // Uygulamanın Genel Theme Ayarlarını Tanımlar.
        useMaterial3: true, // Material 3 Tasarım Sistemini Aktif Eder.
        colorScheme: ColorScheme.fromSeed( // Seed Renkten Otomatik Bir ColorScheme Üretir.
          seedColor: Colors.indigo, // ColorScheme İçin Ana Rengi Indigo Olarak Belirler.
          brightness: Brightness.light, // Açık Renk Temayı Seçer.
        ),
      ),
      home: const FirstScreen(), // Uygulamanın Açılış Sayfası Olarak FirstScreen'i Gösterir.
    );
  }
}

class FirstScreen extends StatefulWidget { // Sayaç Ana Ekranıdır, State Tutan Bir StatefulWidget'tır.
  const FirstScreen({super.key}); // key Parametresini Superclass'a İleten const Constructor'dır.

  @override // Superclass'taki createState Metodunun Override Edildiğini Belirtir.
  State<FirstScreen> createState() => _FirstScreenState(); // Bu Widget'ın State Nesnesini Oluşturur.
}

class _FirstScreenState extends State<FirstScreen> { // FirstScreen'in Değişken State'ini Yöneten Class'tır.
  int _counter = 0; // Sayaç Değerini Tutan Private Değişkendir.

  void _increment() { // Sayacı Bir Artıran Metottur.
    setState(() { // State Değişikliğini Bildirip Arayüzü Yeniden Çizdirir.
      _counter++; // _counter Değerini Bir Artırır.
    });
  }

  void _decrement() { // Sayacı Bir Azaltan Metottur.
    setState(() { // State Değişikliğini Bildirip Arayüzü Yeniden Çizdirir.
      if (_counter > 0) _counter--; // Sayaç Sıfırdan Büyükse Bir Azaltır.
    });
  }

  void _reset() { // Sayacı Sıfırlayan Metottur.
    setState(() { // State Değişikliğini Bildirip Arayüzü Yeniden Çizdirir.
      _counter = 0; // _counter Değerini Sıfıra Eşitler.
    });
  }

  void _goToSecondScreen() async { // İkinci Ekrana Gidip Dönen Değeri Bekleyen async Metottur.
    final updatedCounter = await Navigator.push<int>( // Yeni Route Push Eder ve Geri Dönen int Değeri await İle Bekler.
      context, // Navigator İçin Mevcut BuildContext'i Verir.
      MaterialPageRoute( // Material Geçiş Animasyonlu Bir Route Oluşturur.
        builder: (context) => SecondScreen(counterValue: _counter), // Mevcut Sayaç Değeriyle SecondScreen'i Oluşturur.
      ),
    );

    if (updatedCounter != null && mounted) { // Dönen Değer null Değilse ve Widget Hâlâ Ağaçtaysa Devam Eder.
      setState(() { // State Değişikliğini Bildirip Arayüzü Yeniden Çizdirir.
        _counter = updatedCounter; // Sayacı İkinci Ekrandan Dönen Değerle Günceller.
      });
    }
  }

  @override // Superclass'taki build Metodunun Override Edildiğini Belirtir.
  Widget build(BuildContext context) { // Ana Ekranın Widget Tree'sini Oluşturur.
    final theme = Theme.of(context); // Mevcut Theme Verisini Context'ten Alır.

    return Scaffold( // Sayfanın Temel Material Layout'unu Oluşturur.
      appBar: AppBar( // Sayfanın Üst Bar'ını Oluşturur.
        title: const Text('Sayaç - Ana Ekran'), // AppBar Başlık Metnini Gösterir.
        centerTitle: true, // Başlığı Ortalar.
        backgroundColor: theme.colorScheme.inversePrimary, // AppBar Arka Plan Rengini Theme'den Alır.
      ),
      body: Center( // İçeriği Ekranın Ortasına Yerleştirir.
        child: Padding( // İçeriğe Kenar Boşluğu Ekler.
          padding: const EdgeInsets.all(24.0), // Her Yönden 24 Birim Boşluk Verir.
          child: Column( // Child Widget'larını Dikey Olarak Dizer.
            mainAxisAlignment: MainAxisAlignment.center, // Child Widget'ları Dikey Eksende Ortalar.
            children: [ // Column'un Child Widget Listesini Başlatır.
              Card( // Sayaç Değerini Gösteren Kartı Oluşturur.
                elevation: 4, // Karta Gölge Yüksekliği Verir.
                shape: RoundedRectangleBorder( // Kartın Köşelerini Yuvarlatılmış Şekilde Tanımlar.
                  borderRadius: BorderRadius.circular(16), // Köşe Yarıçapını 16 Olarak Belirler.
                ),
                child: Padding( // Kart İçeriğine Boşluk Ekler.
                  padding: const EdgeInsets.symmetric( // Yatay ve Dikey Simetrik Boşluk Tanımlar.
                    horizontal: 48, // Yatay Boşluğu 48 Yapar.
                    vertical: 32, // Dikey Boşluğu 32 Yapar.
                  ),
                  child: Column( // Kart İçindeki Metinleri Dikey Dizer.
                    children: [ // Column'un Child Widget Listesini Başlatır.
                      Text( // Başlık Metnini Oluşturur.
                        'Sayaç Değeri', // Gösterilecek Başlık Metnidir.
                        style: theme.textTheme.titleMedium?.copyWith( // titleMedium Stilini Kopyalayıp Özelleştirir.
                          color: theme.colorScheme.secondary, // Metin Rengini Secondary Renk Yapar.
                        ),
                      ),
                      const SizedBox(height: 12), // Dikey 12 Birim Boşluk Bırakır.
                      Text( // Sayaç Değerini Gösteren Metni Oluşturur.
                        '$_counter', // _counter Değerini String Olarak Gösterir.
                        style: theme.textTheme.displayMedium?.copyWith( // displayMedium Stilini Kopyalayıp Özelleştirir.
                          fontWeight: FontWeight.bold, // Yazıyı Kalın Yapar.
                          color: theme.colorScheme.primary, // Metin Rengini Primary Renk Yapar.
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32), // Dikey 32 Birim Boşluk Bırakır.
              Row( // Butonları Yatay Olarak Dizer.
                mainAxisAlignment: MainAxisAlignment.center, // Butonları Yatay Eksende Ortalar.
                children: [ // Row'un Child Widget Listesini Başlatır.
                  FilledButton.tonalIcon( // İkonlu Tonal Dolgulu Buton Oluşturur.
                    onPressed: _decrement, // Basılınca Sayacı Azaltır.
                    icon: const Icon(Icons.remove), // Eksi İkonunu Gösterir.
                    label: const Text('Azalt'), // Buton Etiketini Gösterir.
                  ),
                  const SizedBox(width: 12), // Yatay 12 Birim Boşluk Bırakır.
                  IconButton.filledTonal( // Tonal Dolgulu İkon Buton Oluşturur.
                    onPressed: _reset, // Basılınca Sayacı Sıfırlar.
                    icon: const Icon(Icons.refresh), // Yenileme İkonunu Gösterir.
                    tooltip: 'Sıfırla', // Uzun Basınca Gösterilecek İpucu Metnidir.
                  ),
                  const SizedBox(width: 12), // Yatay 12 Birim Boşluk Bırakır.
                  FilledButton.icon( // İkonlu Dolgulu Buton Oluşturur.
                    onPressed: _increment, // Basılınca Sayacı Artırır.
                    icon: const Icon(Icons.add), // Artı İkonunu Gösterir.
                    label: const Text('Artır'), // Buton Etiketini Gösterir.
                  ),
                ],
              ),
              const SizedBox(height: 48), // Dikey 48 Birim Boşluk Bırakır.
              FilledButton.tonal( // Tonal Dolgulu Buton Oluşturur.
                onPressed: _goToSecondScreen, // Basılınca İkinci Ekrana Geçer.
                child: const Text('Detay Ekranına Git ->'), // Buton Metnini Gösterir.
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton( // Sağ Altta Yüzen Aksiyon Butonu Oluşturur.
        onPressed: _increment, // Basılınca Sayacı Artırır.
        tooltip: 'Hızlı Artır', // Uzun Basınca Gösterilecek İpucu Metnidir.
        child: const Icon(Icons.add), // Artı İkonunu Gösterir.
      ),
    );
  }
}

class SecondScreen extends StatefulWidget { // Sayaç Detay Ekranıdır, State Tutan Bir StatefulWidget'tır.
  final int counterValue; // Birinci Ekrandan Aktarılan Sayaç Değerini Tutar.

  const SecondScreen({super.key, required this.counterValue}); // key'i Superclass'a İleten ve counterValue'yu required Alan const Constructor'dır.

  @override // Superclass'taki createState Metodunun Override Edildiğini Belirtir.
  State<SecondScreen> createState() => _SecondScreenState(); // Bu Widget'ın State Nesnesini Oluşturur.
}

class _SecondScreenState extends State<SecondScreen> { // SecondScreen'in Değişken State'ini Yöneten Class'tır.
  late int _currentCounter; // Sonradan Atanacak Güncel Sayaç Değerini Tutar.

  @override // Superclass'taki initState Metodunun Override Edildiğini Belirtir.
  void initState() { // State İlk Oluşturulduğunda Bir Kez Çalışır.
    super.initState(); // Superclass'ın initState Metodunu Çağırır.
    _currentCounter = widget.counterValue; // Güncel Sayacı Aktarılan Değerle Başlatır.
  }

  void _addTen() { // Sayaca 10 Ekleyen Metottur.
    setState(() { // State Değişikliğini Bildirip Arayüzü Yeniden Çizdirir.
      _currentCounter += 10; // _currentCounter Değerini 10 Artırır.
    });
  }

  void _multiplyByTwo() { // Sayacı İkiyle Çarpan Metottur.
    setState(() { // State Değişikliğini Bildirip Arayüzü Yeniden Çizdirir.
      _currentCounter *= 2; // _currentCounter Değerini İkiyle Çarpar.
    });
  }

  @override // Superclass'taki build Metodunun Override Edildiğini Belirtir.
  Widget build(BuildContext context) { // Detay Ekranının Widget Tree'sini Oluşturur.
    final theme = Theme.of(context); // Mevcut Theme Verisini Context'ten Alır.

    return Scaffold( // Sayfanın Temel Material Layout'unu Oluşturur.
      appBar: AppBar( // Sayfanın Üst Bar'ını Oluşturur.
        title: const Text('Sayaç - Detay Ekranı'), // AppBar Başlık Metnini Gösterir.
        centerTitle: true, // Başlığı Ortalar.
        backgroundColor: theme.colorScheme.inversePrimary, // AppBar Arka Plan Rengini Theme'den Alır.
        leading: IconButton( // AppBar'ın Solundaki Geri Butonunu Özelleştirir.
          icon: const Icon(Icons.arrow_back), // Geri Ok İkonunu Gösterir.
          onPressed: () => Navigator.pop(context, _currentCounter), // Güncel Sayaç Değeriyle Önceki Route'a Döner.
        ),
      ),
      body: Center( // İçeriği Ekranın Ortasına Yerleştirir.
        child: Padding( // İçeriğe Kenar Boşluğu Ekler.
          padding: const EdgeInsets.all(24.0), // Her Yönden 24 Birim Boşluk Verir.
          child: Column( // Child Widget'larını Dikey Olarak Dizer.
            mainAxisAlignment: MainAxisAlignment.center, // Child Widget'ları Dikey Eksende Ortalar.
            children: [ // Column'un Child Widget Listesini Başlatır.
              Text( // Açıklama Metnini Oluşturur.
                'Birinci ekrandan aktarılan değer:', // Gösterilecek Açıklama Metnidir.
                style: theme.textTheme.bodyLarge, // bodyLarge Metin Stilini Uygular.
              ),
              const SizedBox(height: 8), // Dikey 8 Birim Boşluk Bırakır.
              Text( // Aktarılan Değeri Gösteren Metni Oluşturur.
                '${widget.counterValue}', // Widget'tan Gelen counterValue'yu String Olarak Gösterir.
                style: theme.textTheme.titleMedium?.copyWith( // titleMedium Stilini Kopyalayıp Özelleştirir.
                  color: theme.colorScheme.outline, // Metin Rengini Outline Renk Yapar.
                ),
              ),
              const SizedBox(height: 24), // Dikey 24 Birim Boşluk Bırakır.
              Card( // Güncel Değeri Gösteren Kartı Oluşturur.
                color: theme.colorScheme.surfaceContainerHighest, // Kartın Arka Plan Rengini Belirler.
                elevation: 2, // Karta Gölge Yüksekliği Verir.
                shape: RoundedRectangleBorder( // Kartın Köşelerini Yuvarlatılmış Şekilde Tanımlar.
                  borderRadius: BorderRadius.circular(16), // Köşe Yarıçapını 16 Olarak Belirler.
                ),
                child: Padding( // Kart İçeriğine Boşluk Ekler.
                  padding: const EdgeInsets.symmetric( // Yatay ve Dikey Simetrik Boşluk Tanımlar.
                    horizontal: 40, // Yatay Boşluğu 40 Yapar.
                    vertical: 28, // Dikey Boşluğu 28 Yapar.
                  ),
                  child: Column( // Kart İçindeki Metinleri Dikey Dizer.
                    children: [ // Column'un Child Widget Listesini Başlatır.
                      Text( // Başlık Metnini Oluşturur.
                        'İkinci Ekran Güncel Değer', // Gösterilecek Başlık Metnidir.
                        style: theme.textTheme.titleMedium, // titleMedium Metin Stilini Uygular.
                      ),
                      const SizedBox(height: 8), // Dikey 8 Birim Boşluk Bırakır.
                      Text( // Güncel Sayaç Değerini Gösteren Metni Oluşturur.
                        '$_currentCounter', // _currentCounter Değerini String Olarak Gösterir.
                        style: theme.textTheme.displayMedium?.copyWith( // displayMedium Stilini Kopyalayıp Özelleştirir.
                          fontWeight: FontWeight.bold, // Yazıyı Kalın Yapar.
                          color: theme.colorScheme.tertiary, // Metin Rengini Tertiary Renk Yapar.
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32), // Dikey 32 Birim Boşluk Bırakır.
              Wrap( // Butonları Sığmazsa Alt Satıra Geçecek Şekilde Dizer.
                spacing: 12, // Yatay Elemanlar Arası Boşluğu 12 Yapar.
                runSpacing: 12, // Satırlar Arası Boşluğu 12 Yapar.
                alignment: WrapAlignment.center, // Elemanları Ortalar.
                children: [ // Wrap'in Child Widget Listesini Başlatır.
                  OutlinedButton.icon( // İkonlu Çerçeveli Buton Oluşturur.
                    onPressed: _addTen, // Basılınca Sayaca 10 Ekler.
                    icon: const Icon(Icons.exposure_plus_1), // Artı Bir İkonunu Gösterir.
                    label: const Text('+10 Ekle'), // Buton Etiketini Gösterir.
                  ),
                  OutlinedButton.icon( // İkonlu Çerçeveli Buton Oluşturur.
                    onPressed: _multiplyByTwo, // Basılınca Sayacı İkiyle Çarpar.
                    icon: const Icon(Icons.close), // Çarpı İkonunu Gösterir.
                    label: const Text('2 ile Çarp'), // Buton Etiketini Gösterir.
                  ),
                ],
              ),
              const SizedBox(height: 40), // Dikey 40 Birim Boşluk Bırakır.
              FilledButton.icon( // İkonlu Dolgulu Buton Oluşturur.
                onPressed: () => Navigator.pop(context, _currentCounter), // Güncel Değeri Önceki Route'a Döndürerek Geri Gider.
                icon: const Icon(Icons.check), // Onay İkonunu Gösterir.
                label: const Text('Değeri Kaydet ve Geri Dön'), // Buton Etiketini Gösterir.
              ),
            ],
          ),
        ),
      ),
    );
  }
}
