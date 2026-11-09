import 'package:flutter/material.dart';

import '../main.dart';

class DebugScreen extends StatefulWidget {
  const DebugScreen({super.key, required this.surum});

  final String surum;

  @override
  State<DebugScreen> createState() => _DebugScreenState();
}

class _DebugScreenState extends State<DebugScreen> {
  @override
  void initState() {
    super.initState();
    analytics.ekranGoruntulendi('debug');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Debug')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Remote Config', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Text('uygulama sürümü: ${widget.surum}'),
          Text('kampanya_aktif: ${remoteConfig.kampanyaAktifMi}'),
          Text('kampanya_metni: ${remoteConfig.kampanyaMetni}'),
          Text('kampanya_indirim_orani: ${remoteConfig.indirimOrani}'),
          Text('zorunlu_guncelleme: ${remoteConfig.zorunluGuncellemeMi}'),
          Text('en_dusuk_surum: ${remoteConfig.enDusukSurum}'),
          const Divider(height: 32),
          Text('Crashlytics', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: () => crashlytics.logEkle('debug: manuel log'),
            child: const Text('Log ekle'),
          ),
          OutlinedButton(
            onPressed: () async {
              await crashlytics.sessizHataKaydet(
                Exception('Demo sessiz hata'),
                StackTrace.current,
              );
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Sessiz hata kaydedildi')),
              );
            },
            child: const Text('Sessiz hata kaydet'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: crashlytics.cokmeTesti,
            child: const Text('Çökme Testi Gönder'),
          ),
        ],
      ),
    );
  }
}
