import 'package:flutter/foundation.dart'; // ValueNotifier İçin Flutter'ın foundation Library'sini import Eder.
import '../models/water_tracker_model.dart'; // Su Takibi Model'ini import Eder.

class WaterTrackerController { // Su Takibi İş Mantığını Yöneten Controller Class'ıdır.
  final ValueNotifier<WaterTrackerModel> state = // Su Takibi State'ini Tutan ValueNotifier'dır, Değer Değişince Listener'ları Bilgilendirir.
      ValueNotifier<WaterTrackerModel>( // Başlangıç Değeriyle ValueNotifier Oluşturur.
    const WaterTrackerModel(currentWaterMl: 0, dailyGoalMl: 2500), // Başlangıç State'ini 0 ml ve 2500 ml Hedefle Tanımlar.
  );

  void addWater(int amountMl) { // Verilen Miktarda Su Ekleyen Metottur.
    if (amountMl <= 0) return; // Miktar Geçersizse Metottan Çıkar.
    final current = state.value; // Mevcut State'i Alır.
    final newAmount = current.currentWaterMl + amountMl; // Yeni Toplam Su Miktarını Hesaplar.
    final updatedHistory = List<int>.from(current.intakeHistory)..add(amountMl); // Geçmişin Kopyasını Alıp Yeni Miktarı Ekler.

    state.value = current.copyWith( // State'i Güncellenmiş Değerlerle Değiştirir.
      currentWaterMl: newAmount, // Yeni Toplam Su Miktarını Atar.
      intakeHistory: updatedHistory, // Güncellenmiş Geçmişi Atar.
    );
  }

  void resetWater() { // Günlük Su Verilerini Sıfırlayan Metottur.
    state.value = state.value.copyWith( // State'i Sıfırlanmış Değerlerle Günceller.
      currentWaterMl: 0, // Su Miktarını Sıfırlar.
      intakeHistory: [], // Geçmiş Listesini Boşaltır.
    );
  }

  void updateDailyGoal(int newGoalMl) { // Günlük Su Hedefini Güncelleyen Metottur.
    if (newGoalMl < 500) return; // Hedef 500 ml'den Küçükse Metottan Çıkar.
    state.value = state.value.copyWith(dailyGoalMl: newGoalMl); // Yeni Hedefi State'e Atar.
  }

  void dispose() { // Controller Kaynaklarını Serbest Bırakan Metottur.
    state.dispose(); // ValueNotifier'ı dispose Eder.
  }
}
