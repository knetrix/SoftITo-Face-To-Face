import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'firebase_options.dart';
import 'screens/force_update_screen.dart';
import 'screens/home_screen.dart';
import 'services/analytics_service.dart';
import 'services/crashlytics_service.dart';
import 'services/remote_config_service.dart';

final analytics = AnalyticsServisi();
final crashlytics = CrashlyticsServisi();
final remoteConfig = RemoteConfigServisi();

bool _surumDusukMu(String mevcut, String enDusuk) {
  final a = mevcut.split('.').map((e) => int.tryParse(e) ?? 0).toList();
  final b = enDusuk.split('.').map((e) => int.tryParse(e) ?? 0).toList();
  for (var i = 0; i < 3; i++) {
    final x = i < a.length ? a[i] : 0;
    final y = i < b.length ? b[i] : 0;
    if (x != y) return x < y;
  }
  return false;
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  await remoteConfig.baslat();
  final surum = (await PackageInfo.fromPlatform()).version;
  await crashlytics.kullaniciTanit(uid: 'demo-kullanici', rol: 'ogrenci');
  await analytics.kullaniciOzelligiBelirle(anahtar: 'rol', deger: 'ogrenci');

  final guncellemeGerekli = remoteConfig.zorunluGuncellemeMi &&
      _surumDusukMu(surum, remoteConfig.enDusukSurum);

  runApp(MiniMagazaApp(guncellemeGerekli: guncellemeGerekli, surum: surum));
}

class MiniMagazaApp extends StatelessWidget {
  const MiniMagazaApp({
    super.key,
    required this.guncellemeGerekli,
    required this.surum,
  });

  final bool guncellemeGerekli;
  final String surum;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mini Mağaza',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: guncellemeGerekli
          ? ForceUpdateScreen(enDusukSurum: remoteConfig.enDusukSurum)
          : HomeScreen(surum: surum),
    );
  }
}
