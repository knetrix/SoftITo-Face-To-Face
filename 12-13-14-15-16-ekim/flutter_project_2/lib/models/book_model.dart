class Book { // Tek Bir Kitabın Verisini Tutan Model Class'ıdır.
  const Book({ // Field'ları Named Parametre Olarak Alan const Constructor'dır.
    required this.id, // id Field'ını required Yapar.
    required this.title, // title Field'ını required Yapar.
    required this.author, // author Field'ını required Yapar.
    required this.category, // category Field'ını required Yapar.
    required this.totalPages, // totalPages Field'ını required Yapar.
    this.readPages = 0, // readPages Verilmezse Default Olarak 0 Kullanır.
  });

  final String id; // Kitabın Benzersiz id'sidir.
  final String title; // Kitabın Adıdır.
  final String author; // Kitabın Yazarıdır.
  final String category; // Kitabın Kategorisidir.
  final int totalPages; // Kitabın Toplam Sayfa Sayısıdır.
  final int readPages; // Okunan Sayfa Sayısıdır.

  double get progress => readPages / totalPages; // Okuma İlerlemesini 0-1 Arası Oran Olarak Döndüren Getter'dır.
  bool get isCompleted => readPages == totalPages; // Kitabın Bitip Bitmediğini Döndüren Getter'dır.

  Book withReadPages(int pages) => Book( // Sadece readPages'i Değiştirilmiş Yeni Bir Book Kopyası Döndürür.
    id: id, // Mevcut id'yi Korur.
    title: title, // Mevcut title'ı Korur.
    author: author, // Mevcut author'ı Korur.
    category: category, // Mevcut category'yi Korur.
    totalPages: totalPages, // Mevcut totalPages'i Korur.
    readPages: pages, // readPages'e Yeni Değeri Atar.
  );
}

const initialBooks = [ // Uygulama Açılışında Kullanılan Örnek Kitapların const Listesidir.
  Book( // Birinci Örnek Kitabı Oluşturur.
    id: 'b1', // Kitabın id'sidir.
    title: 'Küçük Prens', // Kitabın Adıdır.
    author: 'Antoine de Saint-Exupéry', // Kitabın Yazarıdır.
    category: 'Öykü', // Kitabın Kategorisidir.
    totalPages: 112, // Toplam Sayfa Sayısıdır.
    readPages: 42, // Okunan Sayfa Sayısıdır.
  ),
  Book( // İkinci Örnek Kitabı Oluşturur.
    id: 'b2', // Kitabın id'sidir.
    title: 'Saatleri Ayarlama Enstitüsü', // Kitabın Adıdır.
    author: 'Ahmet Hamdi Tanpınar', // Kitabın Yazarıdır.
    category: 'Roman', // Kitabın Kategorisidir.
    totalPages: 382, // Toplam Sayfa Sayısıdır.
    readPages: 96, // Okunan Sayfa Sayısıdır.
  ),
  Book( // Üçüncü Örnek Kitabı Oluşturur.
    id: 'b3', // Kitabın id'sidir.
    title: 'İnsan Ne ile Yaşar?', // Kitabın Adıdır.
    author: 'Lev Tolstoy', // Kitabın Yazarıdır.
    category: 'Öykü', // Kitabın Kategorisidir.
    totalPages: 104, // Toplam Sayfa Sayısıdır.
  ),
  Book( // Dördüncü Örnek Kitabı Oluşturur.
    id: 'b4', // Kitabın id'sidir.
    title: 'Dönüşüm', // Kitabın Adıdır.
    author: 'Franz Kafka', // Kitabın Yazarıdır.
    category: 'Roman', // Kitabın Kategorisidir.
    totalPages: 80, // Toplam Sayfa Sayısıdır.
    readPages: 80, // Okunan Sayfa Sayısıdır.
  ),
  Book( // Beşinci Örnek Kitabı Oluşturur.
    id: 'b5', // Kitabın id'sidir.
    title: 'Bilim ve Teknik Seçkisi', // Kitabın Adıdır.
    author: 'Örnek yayın', // Kitabın Yazarıdır.
    category: 'Bilim', // Kitabın Kategorisidir.
    totalPages: 160, // Toplam Sayfa Sayısıdır.
    readPages: 24, // Okunan Sayfa Sayısıdır.
  ),
  Book( // Altıncı Örnek Kitabı Oluşturur.
    id: 'b6', // Kitabın id'sidir.
    title: 'Bir Bilim İnsanın Gezileri', // Kitabın Adıdır.
    author: 'Örnek yazar', // Kitabın Yazarıdır.
    category: 'Bilim', // Kitabın Kategorisidir.
    totalPages: 240, // Toplam Sayfa Sayısıdır.
  ),
];
