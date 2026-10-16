import 'package:flutter/material.dart';

import '../models/book_model.dart';
import '../models/reading_session_model.dart';

class ReadingSummaryScreen extends StatefulWidget {
  const ReadingSummaryScreen({
    super.key,
    required this.books,
    required this.sessions,
    required this.onStartReading,
  });

  final List<Book> books;
  final List<ReadingSession> sessions;
  final VoidCallback onStartReading;

  @override
  State<ReadingSummaryScreen> createState() => _ReadingSummaryScreenState();
}

class _ReadingSummaryScreenState extends State<ReadingSummaryScreen> {
  int _dailyGoal = 30;
  int _dailyMinutesGoal = 20;

  Future<void> _editGoals() async {
    final formKey = GlobalKey<FormState>();
    var pages = _dailyGoal;
    var minutes = _dailyMinutesGoal;
    final result = await showDialog<(int, int)>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Günlük hedefler'),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final field in [
                  (pages, 'Sayfa hedefi'),
                  (minutes, 'Dakika hedefi'),
                ])
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: TextFormField(
                      initialValue: '${field.$1}',
                      onSaved: (value) {
                        if (field.$2 == 'Sayfa hedefi') {
                          pages = int.parse(value!.trim());
                        } else {
                          minutes = int.parse(value!.trim());
                        }
                      },
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: field.$2),
                      validator: (value) =>
                          (int.tryParse(value?.trim() ?? '') ?? 0) <= 0
                          ? 'Pozitif bir tam sayı girin.'
                          : null,
                    ),
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
              Navigator.pop(context, (pages, minutes));
            },
            child: const Text('Kaydet'),
          ),
        ],
      ),
    );
    if (!mounted || result == null) return;
    setState(() {
      _dailyGoal = result.$1;
      _dailyMinutesGoal = result.$2;
    });
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final todaySessions = widget.sessions.where(
      (session) =>
          session.date.year == now.year &&
          session.date.month == now.month &&
          session.date.day == now.day,
    );
    final todayPages = todaySessions.fold(
      0,
      (sum, session) => sum + session.pages,
    );
    final todayMinutes = todaySessions.fold(
      0,
      (sum, session) => sum + session.minutes,
    );
    final totalMinutes = widget.sessions.fold(
      0,
      (sum, session) => sum + session.minutes,
    );
    final completed = widget.books.where((book) => book.isCompleted).length;
    final readingBooks = widget.books.where(
      (book) => book.readPages > 0 && !book.isCompleted,
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const ListTile(
            contentPadding: EdgeInsets.zero,
            leading: CircleAvatar(child: Icon(Icons.person_outline)),
            title: Text(
              'Yeni bir hikâyeye hazır mısın?',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text('Her sayfa, yeni bir keşif.'),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF285447),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.menu_book_rounded,
                  color: Color(0xFFEACB94),
                  size: 40,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Bugünün okuma hedefi',
                  style: TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 8),
                Text(
                  '$todayPages / $_dailyGoal sayfa',
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                LinearProgressIndicator(
                  value: (todayPages / _dailyGoal).clamp(0.0, 1.0),
                  color: const Color(0xFFEACB94),
                  backgroundColor: Colors.white24,
                  minHeight: 8,
                  borderRadius: BorderRadius.circular(8),
                ),
                const SizedBox(height: 16),
                Text(
                  '$todayMinutes / $_dailyMinutesGoal dakika',
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: (todayMinutes / _dailyMinutesGoal).clamp(0.0, 1.0),
                  color: const Color(0xFFEACB94),
                  backgroundColor: Colors.white24,
                  minHeight: 8,
                  borderRadius: BorderRadius.circular(8),
                ),
                const SizedBox(height: 12),
                Text(
                  todayPages >= _dailyGoal && todayMinutes >= _dailyMinutesGoal
                      ? 'Tebrikler! Günlük hedefine ulaştın.'
                      : 'Küçük adımlar, büyük hikâyeler.',
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: [
              FilledButton.icon(
                onPressed: widget.onStartReading,
                icon: const Icon(Icons.add),
                label: const Text('Okuma Kaydı Ekle'),
              ),
              OutlinedButton.icon(
                onPressed: _editGoals,
                icon: const Icon(Icons.flag_outlined),
                label: const Text('Hedefleri düzenle'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _statCard(
                context,
                Icons.library_books_outlined,
                'Kitaplık',
                '${widget.books.length} kitap',
              ),
              _statCard(
                context,
                Icons.task_alt,
                'Tamamlanan',
                '$completed kitap',
              ),
              _statCard(
                context,
                Icons.timer_outlined,
                'Kaydedilen süre',
                '$totalMinutes dakika',
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            'Okumaya devam et',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          if (readingBooks.isEmpty)
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Kitaplıktan yeni bir kitap seçerek başlayabilirsin.',
              ),
            ),
          for (final book in readingBooks)
            Card(
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                leading: const CircleAvatar(child: Icon(Icons.book_outlined)),
                title: Text(book.title),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${book.readPages} / ${book.totalPages} sayfa'),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(value: book.progress),
                  ],
                ),
                onTap: widget.onStartReading,
              ),
            ),
          const SizedBox(height: 20),
          Text(
            'Örnek kitaplık verileri kullanılır. Eklediğin kayıtlar yalnızca uygulama açıkken saklanır.',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _statCard(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return SizedBox(
      width: 200,
      child: Card(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: Theme.of(context).colorScheme.primary),
              const SizedBox(height: 8),
              Text(label),
              Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}
