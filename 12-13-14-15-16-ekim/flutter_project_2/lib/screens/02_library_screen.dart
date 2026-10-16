import 'package:flutter/material.dart';

import '../models/book_model.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({
    super.key,
    required this.books,
    required this.onAddBook,
  });

  final List<Book> books;
  final ValueChanged<Book> onAddBook;

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  String _query = '';
  String _category = 'Tümü';
  bool _onlyUnread = false;
  final Set<String> _addedCategories = {};

  List<String> get _categories => {
    'Roman',
    'Öykü',
    'Bilim',
    ...widget.books.map((book) => book.category),
    ..._addedCategories,
  }.toList();

  Future<void> _addCategory() async {
    final formKey = GlobalKey<FormState>();
    var name = '';
    final category = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Kategori ekle'),
        content: Form(
          key: formKey,
          child: TextFormField(
            autofocus: true,
            decoration: const InputDecoration(labelText: 'Kategori adı'),
            onSaved: (value) => name = value!.trim(),
            validator: (value) {
              final text = value?.trim() ?? '';
              if (text.isEmpty) return 'Kategori adı girin.';
              if ([
                'Tümü',
                ..._categories,
              ].any((category) => _normalize(category) == _normalize(text))) {
                return 'Bu kategori zaten var.';
              }
              return null;
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Vazgeç'),
          ),
          FilledButton(
            onPressed: () {
              if (!formKey.currentState!.validate()) return;
              formKey.currentState!.save();
              Navigator.pop(context, name);
            },
            child: const Text('Ekle'),
          ),
        ],
      ),
    );
    if (!mounted || category == null) return;
    setState(() => _addedCategories.add(category));
  }

  Future<void> _addBook() async {
    final formKey = GlobalKey<FormState>();
    var title = '';
    var author = '';
    var totalPages = 0;
    var category = _category == 'Tümü' ? _categories.first : _category;
    final book = await showDialog<Book>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Kitap ekle'),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Kitap adı'),
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'Kitap adı girin.'
                      : null,
                  onSaved: (value) => title = value!.trim(),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Yazar'),
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'Yazar girin.'
                      : null,
                  onSaved: (value) => author = value!.trim(),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: category,
                  isExpanded: true,
                  decoration: const InputDecoration(labelText: 'Kategori'),
                  items: [
                    for (final name in _categories)
                      DropdownMenuItem(value: name, child: Text(name)),
                  ],
                  onChanged: (value) => category = value!,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Toplam sayfa'),
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      (int.tryParse(value?.trim() ?? '') ?? 0) <= 0
                      ? 'Pozitif bir tam sayı girin.'
                      : null,
                  onSaved: (value) => totalPages = int.parse(value!.trim()),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Vazgeç'),
          ),
          FilledButton(
            onPressed: () {
              if (!formKey.currentState!.validate()) return;
              formKey.currentState!.save();
              Navigator.pop(
                context,
                Book(
                  id: DateTime.now().microsecondsSinceEpoch.toString(),
                  title: title,
                  author: author,
                  category: category,
                  totalPages: totalPages,
                ),
              );
            },
            child: const Text('Ekle'),
          ),
        ],
      ),
    );
    if (!mounted || book == null) return;
    widget.onAddBook(book);
  }

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
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              FilledButton.icon(
                onPressed: _addBook,
                icon: const Icon(Icons.add),
                label: const Text('Kitap ekle'),
              ),
              OutlinedButton.icon(
                onPressed: _addCategory,
                icon: const Icon(Icons.create_new_folder_outlined),
                label: const Text('Kategori ekle'),
              ),
            ],
          ),
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
              for (final category in ['Tümü', ..._categories])
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
