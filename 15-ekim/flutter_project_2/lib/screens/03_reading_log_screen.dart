import 'package:flutter/material.dart';

import '../models/book_model.dart';
import '../models/reading_session_model.dart';

class ReadingLogScreen extends StatefulWidget {
  const ReadingLogScreen({
    super.key,
    required this.books,
    required this.sessions,
    required this.onSave,
  });

  final List<Book> books;
  final List<ReadingSession> sessions;
  final ValueChanged<ReadingSession> onSave;

  @override
  State<ReadingLogScreen> createState() => _ReadingLogScreenState();
}

class _ReadingLogScreenState extends State<ReadingLogScreen> {
  final _formKey = GlobalKey<FormState>();
  final _pagesController = TextEditingController();
  final _minutesController = TextEditingController();
  final _noteController = TextEditingController();
  String? _selectedBookId;

  @override
  void dispose() {
    _pagesController.dispose();
    _minutesController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final session = ReadingSession(
      bookId: _selectedBookId!,
      pages: int.parse(_pagesController.text.trim()),
      minutes: int.parse(_minutesController.text.trim()),
      date: DateTime.now(),
      note: _noteController.text.trim(),
    );
    widget.onSave(session);
    _formKey.currentState!.reset();
    setState(() => _selectedBookId = null);
    _pagesController.clear();
    _minutesController.clear();
    _noteController.clear();
    FocusScope.of(context).unfocus();
  }

  String _formatDate(DateTime date) =>
      '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year} '
      '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Bugün neler okudun?',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          const Text('Okuduğun yeni sayfaları kaydet, ilerlemeni takip et.'),
          const SizedBox(height: 20),
          Card(
            margin: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    DropdownButtonFormField<String>(
                      isExpanded: true,
                      decoration: const InputDecoration(labelText: 'Kitap seç'),
                      items: [
                        for (final book in widget.books)
                          DropdownMenuItem(
                            value: book.id,
                            enabled: !book.isCompleted,
                            child: Text(
                              '${book.title}${book.isCompleted ? ' (bitti)' : ''}',
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                      ],
                      onChanged: (value) =>
                          setState(() => _selectedBookId = value),
                      validator: (value) =>
                          value == null ? 'Bir kitap seçin.' : null,
                    ),
                    if (_selectedBookId != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        'Kalan: ${widget.books.firstWhere((book) => book.id == _selectedBookId).totalPages - widget.books.firstWhere((book) => book.id == _selectedBookId).readPages} sayfa',
                      ),
                    ],
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _pagesController,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Yeni okunan sayfa sayısı',
                        prefixIcon: Icon(Icons.menu_book),
                      ),
                      validator: (value) {
                        final pages = int.tryParse((value ?? '').trim());
                        if (pages == null || pages <= 0) {
                          return 'Pozitif bir tam sayı girin.';
                        }
                        if (_selectedBookId != null) {
                          final book = widget.books.firstWhere(
                            (book) => book.id == _selectedBookId,
                          );
                          if (pages > book.totalPages - book.readPages) {
                            return 'Kalan sayfa sayısını aşamazsınız.';
                          }
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _minutesController,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Okuma süresi (dakika)',
                        prefixIcon: Icon(Icons.timer_outlined),
                      ),
                      validator: (value) {
                        final minutes = int.tryParse((value ?? '').trim());
                        return minutes == null || minutes <= 0
                            ? 'Pozitif bir tam sayı girin.'
                            : null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _noteController,
                      maxLines: 3,
                      maxLength: 300,
                      decoration: const InputDecoration(
                        labelText: 'Aklında kalanlar (isteğe bağlı)',
                        alignLabelWithHint: true,
                      ),
                    ),
                    const SizedBox(height: 12),
                    FilledButton.icon(
                      onPressed: _submit,
                      icon: const Icon(Icons.check),
                      label: const Text('Okumayı Kaydet'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 28),
          Text('Okuma günlüğün', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          if (widget.sessions.isEmpty)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'Henüz kayıt yok. İlk okuma kaydını yukarıdan ekle.',
                ),
              ),
            ),
          for (final session in widget.sessions)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.books
                          .firstWhere(
                            (book) => book.id == session.bookId,
                            orElse: () => const Book(
                              id: '',
                              title: 'Bilinmeyen kitap',
                              author: '',
                              category: '',
                              totalPages: 1,
                            ),
                          )
                          .title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text('${session.pages} sayfa • ${session.minutes} dakika'),
                    Text(_formatDate(session.date)),
                    if (session.note.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(session.note),
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
