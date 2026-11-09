import 'package:firebase_remote_config/firebase_remote_config.dart';

class RemoteConfigServisi {
  final FirebaseRemoteConfig _rc = FirebaseRemoteConfig.instance;

  Future<void> baslat() async {
    await _rc.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: Duration.zero,
      ),
    );

    await _rc.setDefaults(const {
      'kampanya_aktif': true,
      'kampanya_metni': 'Mobil Mezuniyet indirimi',
      'kampanya_indirim_orani': 30,
      'zorunlu_guncelleme': false,
      'en_dusuk_surum': '1.0.0',
    });

    try {
      await _rc.fetchAndActivate();
    } catch (_) {}
  }

  bool get kampanyaAktifMi => _rc.getBool('kampanya_aktif');
  String get kampanyaMetni => _rc.getString('kampanya_metni');
  int get indirimOrani => _rc.getInt('kampanya_indirim_orani');
  bool get zorunluGuncellemeMi => _rc.getBool('zorunlu_guncelleme');
  String get enDusukSurum => _rc.getString('en_dusuk_surum');
}
