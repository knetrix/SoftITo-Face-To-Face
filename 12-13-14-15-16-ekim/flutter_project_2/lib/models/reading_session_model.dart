class ReadingSession {
  const ReadingSession({
    required this.bookId,
    required this.pages,
    required this.minutes,
    required this.date,
    this.note = '',
  });

  final String bookId;
  final int pages;
  final int minutes;
  final DateTime date;
  final String note;
}
