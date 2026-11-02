class ReadingSession { // Tek Bir Okuma Oturumunun Verisini Tutan Model Class'ıdır.
  const ReadingSession({ // Field'ları Named Parametre Olarak Alan const Constructor'dır.
    required this.bookId, // bookId Field'ını required Yapar.
    required this.pages, // pages Field'ını required Yapar.
    required this.minutes, // minutes Field'ını required Yapar.
    required this.date, // date Field'ını required Yapar.
    this.note = '', // note Verilmezse Default Olarak Boş String Kullanır.
  });

  final String bookId; // Oturumun Ait Olduğu Kitabın id'sidir.
  final int pages; // Bu Oturumda Okunan Sayfa Sayısıdır.
  final int minutes; // Bu Oturumda Harcanan Dakikadır.
  final DateTime date; // Oturumun Kaydedildiği Tarih ve Saattir.
  final String note; // Oturuma Ait İsteğe Bağlı Nottur.
}
