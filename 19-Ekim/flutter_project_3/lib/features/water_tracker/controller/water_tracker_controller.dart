import 'package:flutter/foundation.dart'; // ValueNotifier İçin Flutter'ın foundation Library'sini import Eder.
import '../models/water_log.dart'; // WaterLog Model'ini import Eder.

class WaterTrackerController { // Su Takibi İş Mantığını Yöneten Controller Class'ıdır.
  final ValueNotifier<int> currentWater = ValueNotifier<int>(0); // İçilen Toplam Su Miktarını Tutan ValueNotifier'dır.
  final ValueNotifier<List<WaterLog>> logs = ValueNotifier<List<WaterLog>>([]); // Su Kayıtlarının Listesini Tutan ValueNotifier'dır.
  final int dailyGoalWater = 2500; // Günlük Su Hedefini Ml Cinsinden Tutar.

  void addWater(int amountMl) { // Verilen Miktarda Su Ekleyip Kayıt Oluşturur.
    if (amountMl <= 0) return; // Geçersiz Miktarda İşlem Yapmadan Çıkar.
    currentWater.value += amountMl; // Toplam Su Miktarını Artırır.
    final newLog = WaterLog( // Yeni Bir WaterLog Kaydı Oluşturur.
      id: DateTime.now().millisecondsSinceEpoch.toString(), // Zaman Damgasından Benzersiz id Üretir.
      amountMl: amountMl, // Eklenen Su Miktarını Atar.
      timestamp: DateTime.now(), // Kaydın Oluşturulma Zamanını Atar.
    );
    logs.value = [newLog, ...logs.value]; // Yeni Kaydı Listenin Başına Ekleyerek Listener'ları Bilgilendirir.
  }

  void resetWater() { // Su Miktarını ve Kayıtları Sıfırlar.
    currentWater.value = 0; // Toplam Su Miktarını Sıfırlar.
    logs.value = []; // Kayıt Listesini Boşaltır.
  }

  void dispose() { // ValueNotifier'ları Dispose Ederek Kaynakları Serbest Bırakır.
    currentWater.dispose(); // currentWater ValueNotifier'ını Dispose Eder.
    logs.dispose(); // logs ValueNotifier'ını Dispose Eder.
  }
}
