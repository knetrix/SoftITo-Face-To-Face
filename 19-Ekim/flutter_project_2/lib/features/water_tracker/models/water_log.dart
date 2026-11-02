class WaterLog { // Tek Bir Su Tüketim Kaydını Temsil Eden Model Class'ıdır.
  const WaterLog({ // Named Parametreli const Constructor'dır.
    required this.id, // id Field'ını required Yapar.
    required this.amountMl, // amountMl Field'ını required Yapar.
    required this.timestamp, // timestamp Field'ını required Yapar.
  });

  final String id; // Kaydın Benzersiz Kimliğidir.
  final int amountMl; // İçilen Su Miktarını ml Cinsinden Tutar.
  final DateTime timestamp; // Kaydın Oluşturulma Zamanını Tutar.
}
