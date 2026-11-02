class WaterLog { // Tek Bir Su İçme Kaydını Temsil Eden Model Class'ıdır.
  final String id; // Kaydın Benzersiz id'sini Tutar.
  final int amountMl; // Eklenen Su Miktarını Ml Cinsinden Tutar.
  final DateTime timestamp; // Kaydın Oluşturulma Zamanını Tutar.

  const WaterLog({ // Tüm Field'ları Alan const Constructor'dır.
    required this.id, // id Field'ını required Yapar.
    required this.amountMl, // amountMl Field'ını required Yapar.
    required this.timestamp, // timestamp Field'ını required Yapar.
  });

  WaterLog copyWith({String? id, int? amountMl, DateTime? timestamp}) { // Seçili Field'ları Değiştirilmiş Yeni Bir Kopya Döndürür.
    return WaterLog( // Yeni WaterLog Instance'ı Oluşturur.
      id: id ?? this.id, // Yeni id Verilmediyse Mevcut id'yi Kullanır.
      amountMl: amountMl ?? this.amountMl, // Yeni Miktar Verilmediyse Mevcut Miktarı Kullanır.
      timestamp: timestamp ?? this.timestamp, // Yeni Zaman Verilmediyse Mevcut Zamanı Kullanır.
    );
  }

  factory WaterLog.fromJson(Map<String, dynamic> json) { // JSON Map'ten WaterLog Oluşturan factory Constructor'dır.
    return WaterLog( // JSON Verisiyle Yeni WaterLog Instance'ı Oluşturur.
      id: json['id'] as String? ?? '', // id'yi Okur, null İse Boş String Atar.
      amountMl: json['amountMl'] as int? ?? 0, // amountMl'i Okur, null İse 0 Atar.
      timestamp: json['timestamp'] != null // timestamp Alanının null Olup Olmadığını Kontrol Eder.
          ? DateTime.parse(json['timestamp'] as String) // Varsa String'i DateTime'a Parse Eder.
          : DateTime.now(), // Yoksa Şimdiki Zamanı Kullanır.
    );
  }

  Map<String, dynamic> toJson() { // WaterLog'u JSON Map'e Dönüştürür.
    return { // Field'ları İçeren Map'i Döndürür.
      'id': id, // id Değerini Map'e Ekler.
      'amountMl': amountMl, // amountMl Değerini Map'e Ekler.
      'timestamp': timestamp.toIso8601String(), // timestamp'i ISO 8601 String Olarak Map'e Ekler.
    };
  }
}
