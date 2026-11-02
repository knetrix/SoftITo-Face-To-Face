import 'package:flutter/foundation.dart'; // immutable Annotation'ı İçin Flutter'ın foundation Library'sini import Eder.

@immutable // Class'ın Değiştirilemez Olduğunu Belirtir.
class WaterTrackerModel { // Su Takibi Verilerini Tutan Model Class'ıdır.
  final int currentWaterMl; // Şu Ana Kadar İçilen Su Miktarını Tutar.
  final int dailyGoalMl; // Günlük Su Hedefini Tutar.
  final List<int> intakeHistory; // Eklenen Su Miktarlarının Geçmişini Tutar.

  const WaterTrackerModel({ // Model'in const Constructor'ıdır.
    required this.currentWaterMl, // currentWaterMl Field'ını required Yapar.
    required this.dailyGoalMl, // dailyGoalMl Field'ını required Yapar.
    this.intakeHistory = const [], // intakeHistory İçin Varsayılan Olarak Boş Liste Atar.
  });

  double get progress => // Hedefe Göre İlerleme Oranını Döndüren Getter'dır.
      dailyGoalMl > 0 ? (currentWaterMl / dailyGoalMl).clamp(0.0, 1.0) : 0.0; // Oranı 0 İle 1 Arasında Sınırlayarak Hesaplar.

  bool get isGoalReached => currentWaterMl >= dailyGoalMl; // Günlük Hedefe Ulaşılıp Ulaşılmadığını Döndürür.

  WaterTrackerModel copyWith({ // Seçilen Alanları Değiştirerek Yeni Model Kopyası Oluşturur.
    int? currentWaterMl, // Opsiyonel Yeni Su Miktarıdır.
    int? dailyGoalMl, // Opsiyonel Yeni Günlük Hedeftir.
    List<int>? intakeHistory, // Opsiyonel Yeni Geçmiş Listesidir.
  }) {
    return WaterTrackerModel( // Güncellenmiş Değerlerle Yeni Model Döndürür.
      currentWaterMl: currentWaterMl ?? this.currentWaterMl, // Yeni Değer null İse Mevcut Değeri Kullanır.
      dailyGoalMl: dailyGoalMl ?? this.dailyGoalMl, // Yeni Değer null İse Mevcut Değeri Kullanır.
      intakeHistory: intakeHistory ?? this.intakeHistory, // Yeni Değer null İse Mevcut Değeri Kullanır.
    );
  }

  factory WaterTrackerModel.fromJson(Map<String, dynamic> json) { // JSON Verisinden Model Oluşturan factory Constructor'dır.
    return WaterTrackerModel( // JSON Değerleriyle Yeni Model Döndürür.
      currentWaterMl: json['currentWaterMl'] as int? ?? 0, // Su Miktarını Okur, Yoksa 0 Kullanır.
      dailyGoalMl: json['dailyGoalMl'] as int? ?? 2500, // Günlük Hedefi Okur, Yoksa 2500 Kullanır.
      intakeHistory: (json['intakeHistory'] as List<dynamic>?) // Geçmiş Listesini Nullable List Olarak Okur.
              ?.map((e) => e as int) // Her Elemanı int'e Çevirir.
              .toList() ?? // Sonucu List'e Dönüştürür.
          const [], // Liste Yoksa Boş Liste Kullanır.
    );
  }

  Map<String, dynamic> toJson() { // Model'i JSON Map'ine Çeviren Metottur.
    return { // Model Alanlarını İçeren Map'i Döndürür.
      'currentWaterMl': currentWaterMl, // Su Miktarını Map'e Ekler.
      'dailyGoalMl': dailyGoalMl, // Günlük Hedefi Map'e Ekler.
      'intakeHistory': intakeHistory, // Geçmiş Listesini Map'e Ekler.
    };
  }
}
