import 'package:flutter/foundation.dart'; // ChangeNotifier İçin Flutter'ın foundation Library'sini import Eder.
import '../models/workout_item.dart'; // WorkoutItem Model'ini import Eder.

class WorkoutController extends ChangeNotifier { // Antrenman State'ini Yöneten ve Değişiklikleri Bildiren Controller'dır.
  final List<WorkoutItem> _workouts = [ // Antrenmanları Tutan Private Listeyi Başlangıç Verileriyle Oluşturur.
    const WorkoutItem( // İlk Örnek Antrenmanı Oluşturur.
      id: '1', // Antrenmanın id'sini Belirler.
      title: 'Gece Koşusu', // Antrenmanın Başlığını Belirler.
      durationMinutes: 30, // Süreyi 30 Dakika Olarak Belirler.
      caloriesBurned: 280, // Yakılan Kaloriyi 280 Olarak Belirler.
      category: WorkoutCategory.cardio, // Kategoriyi Kardiyo Olarak Belirler.
    ),
    const WorkoutItem( // İkinci Örnek Antrenmanı Oluşturur.
      id: '2', // Antrenmanın id'sini Belirler.
      title: 'Bench Press & Göğüs', // Antrenmanın Başlığını Belirler.
      durationMinutes: 45, // Süreyi 45 Dakika Olarak Belirler.
      caloriesBurned: 320, // Yakılan Kaloriyi 320 Olarak Belirler.
      category: WorkoutCategory.strength, // Kategoriyi Kuvvet Olarak Belirler.
    ),
  ];

  List<WorkoutItem> get workouts => List.unmodifiable(_workouts); // Antrenmanların Değiştirilemez Bir Kopyasını Döndürür.

  int get totalCalories => // Toplam Yakılan Kaloriyi Döndüren Getter'dır.
      _workouts.fold(0, (sum, item) => sum + item.caloriesBurned); // Tüm Antrenmanların caloriesBurned Değerlerini Toplar.

  int get totalMinutes => // Toplam Antrenman Süresini Döndüren Getter'dır.
      _workouts.fold(0, (sum, item) => sum + item.durationMinutes); // Tüm Antrenmanların durationMinutes Değerlerini Toplar.

  void addWorkout(WorkoutItem item) { // Yeni Antrenman Ekleyen Metottur.
    _workouts.insert(0, item); // Antrenmanı Listenin Başına Ekler.
    notifyListeners(); // Listener'ları Değişiklikten Haberdar Eder.
  }

  void removeWorkout(String id) { // Verilen id'ye Sahip Antrenmanı Silen Metottur.
    _workouts.removeWhere((item) => item.id == id); // id'si Eşleşen Antrenmanı Listeden Kaldırır.
    notifyListeners(); // Listener'ları Değişiklikten Haberdar Eder.
  }
}
