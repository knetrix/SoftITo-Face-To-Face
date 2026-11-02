enum WorkoutCategory { // Antrenman Kategorilerini Tanımlayan Enum'dır.
  cardio('Kardiyo'), // Kardiyo Kategorisini Görünen Adıyla Tanımlar.
  strength('Kuvvet Antrenmanı'), // Kuvvet Kategorisini Görünen Adıyla Tanımlar.
  flexibility('Esneme & Yoga'); // Esneme Kategorisini Görünen Adıyla Tanımlar.

  const WorkoutCategory(this.displayName); // displayName Alan Enum'ın const Constructor'ıdır.
  final String displayName; // Kategorinin Arayüzde Gösterilen Adıdır.
}

class WorkoutItem { // Tek Bir Antrenmanı Temsil Eden Model Class'ıdır.
  const WorkoutItem({ // Named Parametreli const Constructor'dır.
    required this.id, // id Field'ını required Yapar.
    required this.title, // title Field'ını required Yapar.
    required this.durationMinutes, // durationMinutes Field'ını required Yapar.
    required this.caloriesBurned, // caloriesBurned Field'ını required Yapar.
    required this.category, // category Field'ını required Yapar.
  });

  final String id; // Antrenmanın Benzersiz Kimliğidir.
  final String title; // Antrenmanın Başlığıdır.
  final int durationMinutes; // Antrenman Süresini Dakika Cinsinden Tutar.
  final int caloriesBurned; // Yakılan Kaloriyi Tutar.
  final WorkoutCategory category; // Antrenmanın Kategorisini Tutar.
}
