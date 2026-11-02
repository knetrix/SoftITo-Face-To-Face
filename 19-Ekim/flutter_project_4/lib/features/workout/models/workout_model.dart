import 'package:flutter/foundation.dart'; // immutable Annotation'ı İçin Flutter'ın foundation Library'sini import Eder.

@immutable // Class'ın Değiştirilemez Olduğunu Belirtir.
class WorkoutItem { // Tek Bir Antrenmanı Temsil Eden Model Class'ıdır.
  final String id; // Antrenmanın Benzersiz Kimliğini Tutar.
  final String title; // Antrenmanın Başlığını Tutar.
  final String category; // Antrenmanın Kategorisini Tutar.
  final int durationMinutes; // Antrenman Süresini Dakika Olarak Tutar.
  final int caloriesBurned; // Yakılan Kalori Miktarını Tutar.
  final bool isCompleted; // Antrenmanın Tamamlanıp Tamamlanmadığını Tutar.

  const WorkoutItem({ // Named Parametreler Alan const Constructor'dır.
    required this.id, // id Field'ını required Yapar.
    required this.title, // title Field'ını required Yapar.
    required this.category, // category Field'ını required Yapar.
    required this.durationMinutes, // durationMinutes Field'ını required Yapar.
    required this.caloriesBurned, // caloriesBurned Field'ını required Yapar.
    this.isCompleted = false, // isCompleted Field'ına Varsayılan Olarak false Atar.
  });

  WorkoutItem copyWith({ // Belirtilen Alanları Değiştirilmiş Yeni Bir Kopya Oluşturan Metottur.
    String? id, // Opsiyonel Yeni id Değeridir.
    String? title, // Opsiyonel Yeni title Değeridir.
    String? category, // Opsiyonel Yeni category Değeridir.
    int? durationMinutes, // Opsiyonel Yeni durationMinutes Değeridir.
    int? caloriesBurned, // Opsiyonel Yeni caloriesBurned Değeridir.
    bool? isCompleted, // Opsiyonel Yeni isCompleted Değeridir.
  }) {
    return WorkoutItem( // Güncellenmiş Değerlerle Yeni Bir WorkoutItem Döndürür.
      id: id ?? this.id, // Yeni id null İse Mevcut id'yi Kullanır.
      title: title ?? this.title, // Yeni title null İse Mevcut title'ı Kullanır.
      category: category ?? this.category, // Yeni category null İse Mevcut category'yi Kullanır.
      durationMinutes: durationMinutes ?? this.durationMinutes, // Yeni Süre null İse Mevcut Süreyi Kullanır.
      caloriesBurned: caloriesBurned ?? this.caloriesBurned, // Yeni Kalori null İse Mevcut Kaloriyi Kullanır.
      isCompleted: isCompleted ?? this.isCompleted, // Yeni Durum null İse Mevcut Durumu Kullanır.
    );
  }

  factory WorkoutItem.fromJson(Map<String, dynamic> json) { // JSON Map'inden WorkoutItem Oluşturan factory Constructor'dır.
    return WorkoutItem( // JSON Verileriyle Yeni Bir WorkoutItem Döndürür.
      id: json['id'] as String? ?? '', // JSON'dan id'yi Okur, Yoksa Boş String Kullanır.
      title: json['title'] as String? ?? '', // JSON'dan title'ı Okur, Yoksa Boş String Kullanır.
      category: json['category'] as String? ?? 'Genel', // JSON'dan category'yi Okur, Yoksa 'Genel' Kullanır.
      durationMinutes: json['durationMinutes'] as int? ?? 0, // JSON'dan Süreyi Okur, Yoksa 0 Kullanır.
      caloriesBurned: json['caloriesBurned'] as int? ?? 0, // JSON'dan Kaloriyi Okur, Yoksa 0 Kullanır.
      isCompleted: json['isCompleted'] as bool? ?? false, // JSON'dan Tamamlanma Durumunu Okur, Yoksa false Kullanır.
    );
  }

  Map<String, dynamic> toJson() { // WorkoutItem'ı JSON Map'ine Dönüştürür.
    return { // Alanları İçeren Map'i Döndürür.
      'id': id, // id Değerini Map'e Ekler.
      'title': title, // title Değerini Map'e Ekler.
      'category': category, // category Değerini Map'e Ekler.
      'durationMinutes': durationMinutes, // durationMinutes Değerini Map'e Ekler.
      'caloriesBurned': caloriesBurned, // caloriesBurned Değerini Map'e Ekler.
      'isCompleted': isCompleted, // isCompleted Değerini Map'e Ekler.
    };
  }
}

@immutable // Class'ın Değiştirilemez Olduğunu Belirtir.
class WorkoutModel { // Antrenman Ekranının Tüm State'ini Temsil Eden Model Class'ıdır.
  final List<WorkoutItem> workouts; // Antrenman Listesini Tutar.
  final int dailyCalorieGoal; // Günlük Kalori Hedefini Tutar.

  const WorkoutModel({ // Named Parametreler Alan const Constructor'dır.
    required this.workouts, // workouts Field'ını required Yapar.
    required this.dailyCalorieGoal, // dailyCalorieGoal Field'ını required Yapar.
  });

  int get totalCaloriesBurned => workouts // Tamamlanan Antrenmanların Toplam Kalorisini Hesaplayan Getter'dır.
      .where((w) => w.isCompleted) // Sadece Tamamlanmış Antrenmanları Filtreler.
      .fold(0, (sum, w) => sum + w.caloriesBurned); // Kalorileri Toplayarak Tek Bir Değere İndirger.

  int get totalActiveMinutes => workouts // Tamamlanan Antrenmanların Toplam Süresini Hesaplayan Getter'dır.
      .where((w) => w.isCompleted) // Sadece Tamamlanmış Antrenmanları Filtreler.
      .fold(0, (sum, w) => sum + w.durationMinutes); // Süreleri Toplayarak Tek Bir Değere İndirger.

  double get calorieProgress => dailyCalorieGoal > 0 // Kalori Hedefine Ulaşma Oranını Hesaplayan Getter'dır.
      ? (totalCaloriesBurned / dailyCalorieGoal).clamp(0.0, 1.0) // Hedef Pozitifse Oranı 0 İle 1 Arasında Sınırlar.
      : 0.0; // Hedef 0 Veya Negatifse 0.0 Döndürür.

  WorkoutModel copyWith({ // Belirtilen Alanları Değiştirilmiş Yeni Bir Kopya Oluşturan Metottur.
    List<WorkoutItem>? workouts, // Opsiyonel Yeni workouts Listesidir.
    int? dailyCalorieGoal, // Opsiyonel Yeni dailyCalorieGoal Değeridir.
  }) {
    return WorkoutModel( // Güncellenmiş Değerlerle Yeni Bir WorkoutModel Döndürür.
      workouts: workouts ?? this.workouts, // Yeni Liste null İse Mevcut Listeyi Kullanır.
      dailyCalorieGoal: dailyCalorieGoal ?? this.dailyCalorieGoal, // Yeni Hedef null İse Mevcut Hedefi Kullanır.
    );
  }

  factory WorkoutModel.fromJson(Map<String, dynamic> json) { // JSON Map'inden WorkoutModel Oluşturan factory Constructor'dır.
    return WorkoutModel( // JSON Verileriyle Yeni Bir WorkoutModel Döndürür.
      workouts: (json['workouts'] as List<dynamic>?) // JSON'daki workouts Alanını Nullable List Olarak Okur.
              ?.map((e) => WorkoutItem.fromJson(e as Map<String, dynamic>)) // Her Elemanı WorkoutItem'a Dönüştürür.
              .toList() ?? // Sonucu List'e Çevirir, null İse Alternatif Değere Geçer.
          const [], // Liste Yoksa Boş const Liste Kullanır.
      dailyCalorieGoal: json['dailyCalorieGoal'] as int? ?? 500, // JSON'dan Günlük Hedefi Okur, Yoksa 500 Kullanır.
    );
  }

  Map<String, dynamic> toJson() { // WorkoutModel'i JSON Map'ine Dönüştürür.
    return { // Alanları İçeren Map'i Döndürür.
      'workouts': workouts.map((w) => w.toJson()).toList(), // Antrenmanları JSON Listesine Dönüştürüp Map'e Ekler.
      'dailyCalorieGoal': dailyCalorieGoal, // dailyCalorieGoal Değerini Map'e Ekler.
    };
  }
}
