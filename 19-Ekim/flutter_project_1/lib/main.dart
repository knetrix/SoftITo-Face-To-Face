import 'package:flutter/material.dart';

void main() {
  runApp(const CounterApp());
}

class CounterApp extends StatelessWidget {
  const CounterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Counter App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.light,
        ),
      ),
      home: const FirstScreen(),
    );
  }
}

class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  int _counter = 0;

  void _increment() {
    setState(() {
      _counter++;
    });
  }

  void _decrement() {
    setState(() {
      if (_counter > 0) _counter--;
    });
  }

  void _reset() {
    setState(() {
      _counter = 0;
    });
  }

  void _goToSecondScreen() async {
    final updatedCounter = await Navigator.push<int>(
      context,
      MaterialPageRoute(
        builder: (context) => SecondScreen(counterValue: _counter),
      ),
    );

    if (updatedCounter != null && mounted) {
      setState(() {
        _counter = updatedCounter;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sayaç - Ana Ekran'),
        centerTitle: true,
        backgroundColor: theme.colorScheme.inversePrimary,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 48,
                    vertical: 32,
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Sayaç Değeri',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.secondary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '$_counter',
                        style: theme.textTheme.displayMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FilledButton.tonalIcon(
                    onPressed: _decrement,
                    icon: const Icon(Icons.remove),
                    label: const Text('Azalt'),
                  ),
                  const SizedBox(width: 12),
                  IconButton.filledTonal(
                    onPressed: _reset,
                    icon: const Icon(Icons.refresh),
                    tooltip: 'Sıfırla',
                  ),
                  const SizedBox(width: 12),
                  FilledButton.icon(
                    onPressed: _increment,
                    icon: const Icon(Icons.add),
                    label: const Text('Artır'),
                  ),
                ],
              ),
              const SizedBox(height: 48),
              FilledButton.tonal(
                onPressed: _goToSecondScreen,
                child: const Text('Detay Ekranına Git ->'),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _increment,
        tooltip: 'Hızlı Artır',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class SecondScreen extends StatefulWidget {
  final int counterValue;

  const SecondScreen({super.key, required this.counterValue});

  @override
  State<SecondScreen> createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  late int _currentCounter;

  @override
  void initState() {
    super.initState();
    _currentCounter = widget.counterValue;
  }

  void _addTen() {
    setState(() {
      _currentCounter += 10;
    });
  }

  void _multiplyByTwo() {
    setState(() {
      _currentCounter *= 2;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sayaç - Detay Ekranı'),
        centerTitle: true,
        backgroundColor: theme.colorScheme.inversePrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context, _currentCounter),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Birinci ekrandan aktarılan değer:',
                style: theme.textTheme.bodyLarge,
              ),
              const SizedBox(height: 8),
              Text(
                '${widget.counterValue}',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.outline,
                ),
              ),
              const SizedBox(height: 24),
              Card(
                color: theme.colorScheme.surfaceContainerHighest,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 28,
                  ),
                  child: Column(
                    children: [
                      Text(
                        'İkinci Ekran Güncel Değer',
                        style: theme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '$_currentCounter',
                        style: theme.textTheme.displayMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.tertiary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                alignment: WrapAlignment.center,
                children: [
                  OutlinedButton.icon(
                    onPressed: _addTen,
                    icon: const Icon(Icons.exposure_plus_1),
                    label: const Text('+10 Ekle'),
                  ),
                  OutlinedButton.icon(
                    onPressed: _multiplyByTwo,
                    icon: const Icon(Icons.close),
                    label: const Text('2 ile Çarp'),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              FilledButton.icon(
                onPressed: () => Navigator.pop(context, _currentCounter),
                icon: const Icon(Icons.check),
                label: const Text('Değeri Kaydet ve Geri Dön'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
