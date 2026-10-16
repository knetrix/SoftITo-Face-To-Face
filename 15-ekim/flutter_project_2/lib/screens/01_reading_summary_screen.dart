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
                const SizedBox(height: 12),
                Text(
                  todayPages >= _dailyGoal
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
                onPressed: () =>
                    setState(() => _dailyGoal = _dailyGoal == 30 ? 50 : 30),
                icon: const Icon(Icons.flag_outlined),
                label: Text('Hedef: $_dailyGoal sayfa'),
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
          const Text(
            'Örnek kitaplık verileri kullanılır. Eklediğin kayıtlar yalnızca uygulama açıkken saklanır.',
            style: TextStyle(color: Colors.black54),
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
