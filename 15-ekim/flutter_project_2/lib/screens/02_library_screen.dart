import 'package:flutter/material.dart';

import '../models/book_model.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key, required this.books});

  final List<Book> books;

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  String _query = '';
  String _category = 'Tümü';
  bool _onlyUnread = false;

  String _normalize(String text) =>
      text.replaceAll('İ', 'i').replaceAll('I', 'ı').toLowerCase();

  @override
  Widget build(BuildContext context) {
    final filteredBooks = widget.books
        .where(
          (book) =>
              (_category == 'Tümü' || book.category == _category) &&
              (!_onlyUnread || !book.isCompleted) &&
              _normalize('${book.title} ${book.author}')
                  .contains(_normalize(_query.trim())),
        )
        .toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Kendi dünyanı keşfet',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          const Text('Bir sonraki yolculuğun kitaplığında seni bekliyor.'),
          const SizedBox(height: 20),
          TextField(
            onChanged: (value) => setState(() => _query = value),
            decoration: const InputDecoration(
              labelText: 'Kitap veya yazar ara',
              prefixIcon: Icon(Icons.search),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: [
              for (final category in ['Tümü', 'Roman', 'Öykü', 'Bilim'])
                ChoiceChip(
                  label: Text(category),
                  selected: _category == category,
                  onSelected: (_) => setState(() => _category = category),
                ),
            ],
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Yalnızca bitirmediklerim'),
            value: _onlyUnread,
            onChanged: (value) => setState(() => _onlyUnread = value),
          ),
          Text('${filteredBooks.length} kitap bulundu'),
          const SizedBox(height: 16),
          if (filteredBooks.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 40),
              child: Center(child: Text('Aramana uygun kitap bulunamadı.')),
            ),
          LayoutBuilder(
            builder: (context, constraints) {
              final columns = constraints.maxWidth >= 850
                  ? 3
                  : constraints.maxWidth >= 550
                  ? 2
                  : 1;
              final width =
                  (constraints.maxWidth - (columns - 1) * 16) / columns;
              return Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  for (final book in filteredBooks)
                    SizedBox(
                      width: width,
                      child: Card(
                        margin: EdgeInsets.zero,
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Theme.of(context)
                                        .colorScheme
                                        .primaryContainer,
                                    child: Icon(
                                      book.isCompleted
                                          ? Icons.task_alt
                                          : Icons.auto_stories,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      book.category,
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                book.title,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 4),
                              Text(book.author),
                              const SizedBox(height: 20),
                              LinearProgressIndicator(
                                value: book.progress,
                                minHeight: 6,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '${book.readPages} / ${book.totalPages} sayfa',
                              ),
                              const SizedBox(height: 8),
                              Text(
                                book.isCompleted
                                    ? 'Tamamlandı'
                                    : book.readPages == 0
                                    ? 'Okunacak'
                                    : 'Okunuyor',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
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
