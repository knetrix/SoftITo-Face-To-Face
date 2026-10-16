class Book {
  const Book({
    required this.id,
    required this.title,
    required this.author,
    required this.category,
    required this.totalPages,
    this.readPages = 0,
  });

  final String id;
  final String title;
  final String author;
  final String category;
  final int totalPages;
  final int readPages;

  double get progress => readPages / totalPages;
  bool get isCompleted => readPages == totalPages;

  Book withReadPages(int pages) => Book(
    id: id,
    title: title,
    author: author,
    category: category,
    totalPages: totalPages,
    readPages: pages,
  );
}

const initialBooks = [
  Book(
    id: 'b1',
    title: 'Küçük Prens',
    author: 'Antoine de Saint-Exupéry',
    category: 'Öykü',
    totalPages: 112,
    readPages: 42,
  ),
  Book(
    id: 'b2',
    title: 'Saatleri Ayarlama Enstitüsü',
    author: 'Ahmet Hamdi Tanpınar',
    category: 'Roman',
    totalPages: 382,
    readPages: 96,
  ),
  Book(
    id: 'b3',
    title: 'İnsan Ne ile Yaşar?',
    author: 'Lev Tolstoy',
    category: 'Öykü',
    totalPages: 104,
  ),
  Book(
    id: 'b4',
    title: 'Dönüşüm',
    author: 'Franz Kafka',
    category: 'Roman',
    totalPages: 80,
    readPages: 80,
  ),
  Book(
    id: 'b5',
    title: 'Bilim ve Teknik Seçkisi',
    author: 'Örnek yayın',
    category: 'Bilim',
    totalPages: 160,
    readPages: 24,
  ),
  Book(
    id: 'b6',
    title: 'Bir Bilim İnsanın Gezileri',
    author: 'Örnek yazar',
    category: 'Bilim',
    totalPages: 240,
  ),
];
