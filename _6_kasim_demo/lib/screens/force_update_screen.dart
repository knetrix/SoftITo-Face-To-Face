import 'package:flutter/material.dart';

import '../main.dart';

class ForceUpdateScreen extends StatefulWidget {
  const ForceUpdateScreen({super.key, required this.enDusukSurum});

  final String enDusukSurum;

  @override
  State<ForceUpdateScreen> createState() => _ForceUpdateScreenState();
}

class _ForceUpdateScreenState extends State<ForceUpdateScreen> {
  @override
  void initState() {
    super.initState();
    analytics.ekranGoruntulendi('force_update');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.system_update, size: 72),
              const SizedBox(height: 16),
              Text(
                'Güncelleme gerekli',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text('En düşük desteklenen sürüm: ${widget.enDusukSurum}'),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () => analytics.olayGonder(
                  olayAdi: 'guncelle_tiklandi',
                  parametreler: {'en_dusuk_surum': widget.enDusukSurum},
                ),
                child: const Text('Güncelle'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
