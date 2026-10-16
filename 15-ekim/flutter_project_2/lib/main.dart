import 'package:flutter/material.dart';

import 'models/book_model.dart';
import 'models/reading_session_model.dart';
import 'screens/01_reading_summary_screen.dart';
import 'screens/02_library_screen.dart';
import 'screens/03_reading_log_screen.dart';

void main() => runApp(const BookRouteApp());

class BookRouteApp extends StatelessWidget {
  const BookRouteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kitap Rotası',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF356859)),
        scaffoldBackgroundColor: const Color(0xFFFAF7F0),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
      ),
      home: const ReadingHomeScreen(),
    );
  }
}

class ReadingHomeScreen extends StatefulWidget {
  const ReadingHomeScreen({super.key});

  @override
  State<ReadingHomeScreen> createState() => _ReadingHomeScreenState();
}

class _ReadingHomeScreenState extends State<ReadingHomeScreen> {
  int _selectedIndex = 0;
  bool _hasUnreadNotification = true;
  final List<Book> _books = List.of(initialBooks);
  final List<ReadingSession> _sessions = [];

  void _saveSession(ReadingSession session) {
    final index = _books.indexWhere((book) => book.id == session.bookId);
    setState(() {
      _books[index] = _books[index].withReadPages(
        _books[index].readPages + session.pages,
      );
      _sessions.insert(0, session);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Okuma kaydın eklendi. Harika gidiyorsun!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Kitap Rotası',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: const Icon(Icons.auto_stories_outlined),
        actions: [
          IconButton(
            tooltip: _hasUnreadNotification
                ? 'Bildirimler: 1 okunmamış bildirim'
                : 'Bildirimler',
            icon: Badge(
              isLabelVisible: _hasUnreadNotification,
              label: const Text('1'),
              child: const Icon(Icons.notifications_outlined),
            ),
            onPressed: () {
              setState(() => _hasUnreadNotification = false);
              showDialog<void>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Okuma hatırlatması'),
                  content: const Text(
                    'Bugün kendine bir okuma molası ver. '
                    'Okuduğun sayfaları kaydetmeyi unutma!',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Kapat'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1100),
            child: IndexedStack(
              index: _selectedIndex,
              children: [
                ReadingSummaryScreen(
                  books: _books,
                  sessions: _sessions,
                  onStartReading: () => setState(() => _selectedIndex = 2),
                ),
                LibraryScreen(books: _books),
                ReadingLogScreen(
                  books: _books,
                  sessions: _sessions,
                  onSave: _saveSession,
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) =>
            setState(() => _selectedIndex = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Özet',
          ),
          NavigationDestination(
            icon: Icon(Icons.local_library_outlined),
            selectedIcon: Icon(Icons.local_library),
            label: 'Kitaplık',
          ),
          NavigationDestination(
            icon: Icon(Icons.edit_note_outlined),
            selectedIcon: Icon(Icons.edit_note),
            label: 'Okuma Kaydı',
          ),
        ],
      ),
    );
  }
}
