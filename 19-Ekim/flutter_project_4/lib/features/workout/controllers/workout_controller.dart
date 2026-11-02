import 'package:flutter/foundation.dart'; // ValueNotifier İçin Flutter'ın foundation Library'sini import Eder.
import '../models/workout_model.dart'; // WorkoutModel ve WorkoutItem Class'larını import Eder.

class WorkoutController { // Antrenman Verisini Yöneten Controller Class'ıdır.
  final ValueNotifier<WorkoutModel> state = ValueNotifier<WorkoutModel>( // Antrenman State'ini Tutan ValueNotifier'dır, Değer Değişince Listener'ları Bilgilendirir.
    const WorkoutModel( // Başlangıç State'i Olarak const Bir WorkoutModel Oluşturur.
      dailyCalorieGoal: 600, // Günlük Kalori Hedefini 600 Olarak Belirler.
      workouts: [ // Varsayılan Antrenman Listesini Tanımlar.
        WorkoutItem( // İlk Varsayılan Antrenmanı Oluşturur.
          id: 'w1', // Antrenmanın Benzersiz id'sini Belirler.
          title: 'HIIT Kardiyo & Isınma', // Antrenmanın Başlığını Belirler.
          category: 'Kardiyo', // Antrenmanın Kategorisini Belirler.
          durationMinutes: 20, // Antrenman Süresini Dakika Olarak Belirler.
          caloriesBurned: 180, // Yakılacak Kalori Miktarını Belirler.
          isCompleted: false, // Antrenmanı Tamamlanmamış Olarak Başlatır.
        ),
        WorkoutItem( // İkinci Varsayılan Antrenmanı Oluşturur.
          id: 'w2', // Antrenmanın Benzersiz id'sini Belirler.
          title: 'Üst Vücut Güç Antrenmanı', // Antrenmanın Başlığını Belirler.
          category: 'Ağırlık', // Antrenmanın Kategorisini Belirler.
          durationMinutes: 35, // Antrenman Süresini Dakika Olarak Belirler.
          caloriesBurned: 240, // Yakılacak Kalori Miktarını Belirler.
          isCompleted: false, // Antrenmanı Tamamlanmamış Olarak Başlatır.
        ),
        WorkoutItem( // Üçüncü Varsayılan Antrenmanı Oluşturur.
          id: 'w3', // Antrenmanın Benzersiz id'sini Belirler.
          title: 'Karın & Core Sıkılaştırma', // Antrenmanın Başlığını Belirler.
          category: 'Core', // Antrenmanın Kategorisini Belirler.
          durationMinutes: 15, // Antrenman Süresini Dakika Olarak Belirler.
          caloriesBurned: 110, // Yakılacak Kalori Miktarını Belirler.
          isCompleted: false, // Antrenmanı Tamamlanmamış Olarak Başlatır.
        ),
        WorkoutItem( // Dördüncü Varsayılan Antrenmanı Oluşturur.
          id: 'w4', // Antrenmanın Benzersiz id'sini Belirler.
          title: 'Koşu Bandı & Soğuma', // Antrenmanın Başlığını Belirler.
          category: 'Kardiyo', // Antrenmanın Kategorisini Belirler.
          durationMinutes: 25, // Antrenman Süresini Dakika Olarak Belirler.
          caloriesBurned: 200, // Yakılacak Kalori Miktarını Belirler.
          isCompleted: false, // Antrenmanı Tamamlanmamış Olarak Başlatır.
        ),
      ],
    ),
  );

  void toggleWorkoutCompletion(String id) { // Verilen id'ye Sahip Antrenmanın Tamamlanma Durumunu Tersine Çevirir.
    final updatedList = state.value.workouts.map((workout) { // Antrenman Listesini Dolaşarak Yeni Bir Liste Üretir.
      if (workout.id == id) { // Antrenmanın id'si Aranan id İle Eşleşiyor mu Kontrol Eder.
        return workout.copyWith(isCompleted: !workout.isCompleted); // isCompleted Değeri Tersine Çevrilmiş Bir Kopya Döndürür.
      }
      return workout; // Eşleşmeyen Antrenmanı Değiştirmeden Döndürür.
    }).toList(); // Map Sonucunu List'e Dönüştürür.

    state.value = state.value.copyWith(workouts: updatedList); // Güncellenmiş Listeyle Yeni State Atayarak Listener'ları Tetikler.
  }

  void addCustomWorkout(String title, String category, int duration, int calories) { // Kullanıcının Girdiği Bilgilerle Yeni Bir Antrenman Ekler.
    final newWorkout = WorkoutItem( // Yeni Bir WorkoutItem Oluşturur.
      id: 'custom_${DateTime.now().millisecondsSinceEpoch}', // Zaman Damgasıyla Benzersiz Bir id Üretir.
      title: title, // Antrenman Başlığını Parametreden Alır.
      category: category, // Antrenman Kategorisini Parametreden Alır.
      durationMinutes: duration, // Antrenman Süresini Parametreden Alır.
      caloriesBurned: calories, // Yakılan Kaloriyi Parametreden Alır.
      isCompleted: true, // Eklenen Antrenmanı Tamamlanmış Olarak İşaretler.
    );

    final updated = List<WorkoutItem>.from(state.value.workouts)..add(newWorkout); // Mevcut Listenin Kopyasını Alıp Yeni Antrenmanı Ekler.
    state.value = state.value.copyWith(workouts: updated); // Yeni Listeyle State'i Günceller.
  }

  void resetAll() { // Tüm Antrenmanları Tamamlanmamış Duruma Sıfırlar.
    final resetWorkouts = state.value.workouts // Mevcut Antrenman Listesini Alır.
        .map((w) => w.copyWith(isCompleted: false)) // Her Antrenmanın isCompleted Değerini false Yapar.
        .toList(); // Sonucu List'e Dönüştürür.
    state.value = state.value.copyWith(workouts: resetWorkouts); // Sıfırlanmış Listeyle State'i Günceller.
  }

  void dispose() { // Controller Kaynaklarını Serbest Bırakır.
    state.dispose(); // ValueNotifier'ı dispose Ederek Listener'ları Temizler.
  }
}
