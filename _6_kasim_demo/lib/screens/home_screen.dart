import 'package:flutter/material.dart';

import '../main.dart';
import 'debug_screen.dart';

class _Urun {
  const _Urun(this.id, this.ad, this.fiyat);
  final String id;
  final String ad;
  final double fiyat;
}

const _urunler = [
  _Urun('u1', 'Flutter Kitabı', 250),
  _Urun('u2', 'Mekanik Klavye', 1200),
  _Urun('u3', 'Kulaklık', 800),
  _Urun('u4', 'Laptop Standı', 450),
];

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.surum});

  final String surum;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _sepet = 0;

  @override
  void initState() {
    super.initState();
    analytics.ekranGoruntulendi('ana_ekran');
    crashlytics.logEkle('ana ekran açıldı');
  }

  void _sepeteEkle(_Urun urun) {
    setState(() => _sepet++);
    analytics.sepeteEklendi(urunId: urun.id, fiyat: urun.fiyat);
    crashlytics.logEkle('sepete eklendi: ${urun.id}');
  }

  @override
  Widget build(BuildContext context) {
    final kampanya = remoteConfig.kampanyaAktifMi;
    final oran = remoteConfig.indirimOrani;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Mini Mağaza'),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Badge(
                label: Text('$_sepet'),
                child: const Icon(Icons.shopping_cart),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.bug_report),
            tooltip: 'Debug',
            onPressed: () {
              analytics.olayGonder(olayAdi: 'debug_acildi');
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => DebugScreen(surum: widget.surum),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          if (kampanya)
            Container(
              width: double.infinity,
              color: Colors.amber.shade200,
              padding: const EdgeInsets.all(12),
              child: Text(
                '${remoteConfig.kampanyaMetni} (%$oran indirim)',
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          Expanded(
            child: ListView.builder(
              itemCount: _urunler.length,
              itemBuilder: (context, i) {
                final u = _urunler[i];
                final indirimli = kampanya ? u.fiyat * (100 - oran) / 100 : null;
                return ListTile(
                  title: Text(u.ad),
                  subtitle: indirimli == null
                      ? Text('${u.fiyat.toStringAsFixed(0)} TL')
                      : Text(
                          '${indirimli.toStringAsFixed(0)} TL (eski: ${u.fiyat.toStringAsFixed(0)} TL)',
                        ),
                  trailing: FilledButton(
                    onPressed: () => _sepeteEkle(u),
                    child: const Text('Sepete Ekle'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
