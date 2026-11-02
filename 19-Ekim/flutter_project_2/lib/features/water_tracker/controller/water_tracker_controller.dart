import 'package:flutter/foundation.dart'; // ChangeNotifier İçin Flutter'ın foundation Library'sini import Eder.
import '../models/water_log.dart'; // WaterLog Model'ini import Eder.

class WaterTrackerController extends ChangeNotifier { // Su Takibi State'ini Yöneten ve Değişiklikleri Bildiren Controller'dır.
  WaterTrackerController({this.dailyGoalMl = 3000}); // Günlük Hedefi Varsayılan 3000 ml Olan Constructor'dır.

  final int dailyGoalMl; // Günlük Su Hedefini ml Cinsinden Tutar.
  final List<WaterLog> _logs = []; // Su Kayıtlarını Tutan Private Listedir.

  List<WaterLog> get logs => List.unmodifiable(_logs); // Kayıtların Değiştirilemez Bir Kopyasını Döndürür.

  int get totalConsumedMl => // Toplam İçilen Su Miktarını Döndüren Getter'dır.
      _logs.fold(0, (sum, item) => sum + item.amountMl); // Tüm Kayıtların amountMl Değerlerini Toplar.

  double get progressRatio => // Hedefe Ulaşma Oranını Döndüren Getter'dır.
      dailyGoalMl == 0 ? 0.0 : (totalConsumedMl / dailyGoalMl).clamp(0.0, 1.0); // Hedef Sıfırsa 0, Değilse 0-1 Arasına Sınırlanmış Oranı Hesaplar.

  void addWater(int amountMl) { // Yeni Su Kaydı Ekleyen Metottur.
    if (amountMl <= 0) return; // Geçersiz Miktarda Metottan Çıkar.
    _logs.insert( // Listeye Yeni Kayıt Ekler.
      0, // Kaydı Listenin Başına Yerleştirir.
      WaterLog( // Yeni Bir WaterLog Nesnesi Oluşturur.
        id: DateTime.now().microsecondsSinceEpoch.toString(), // Benzersiz id'yi Zaman Damgasından Üretir.
        amountMl: amountMl, // İçilen Miktarı Atar.
        timestamp: DateTime.now(), // Kayıt Zamanını Şu An Olarak Atar.
      ),
    );
    notifyListeners(); // Listener'ları Değişiklikten Haberdar Eder.
  }

  void reset() { // Tüm Kayıtları Sıfırlayan Metottur.
    _logs.clear(); // Kayıt Listesini Temizler.
    notifyListeners(); // Listener'ları Değişiklikten Haberdar Eder.
  }
}
