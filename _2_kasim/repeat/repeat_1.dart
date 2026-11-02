// ignore_for_file: avoid_print
// Sealed Sınıflar Dışarıdan Extend Edilmez, Switch İçinde Tüm Alt Sınıflar Tüketilmek Zorundadır
sealed class PaymentStatus {} // Ödeme Sonucunu Temsil Eden sealed Base Class'tır.

class PaymentSuccess extends PaymentStatus { // Başarılı Ödemeyi Temsil Eden Subclass'tır.
  final ({String referenceCode, double amount}) data; // referenceCode ve amount Field'larını Tutan Named Record'dur.

  PaymentSuccess(this.data); // data Record'unu Alan Constructor'dır.
}

class PaymentFailure extends PaymentStatus { // Başarısız Ödemeyi Temsil Eden Subclass'tır.
  final String failureReason; // Ödemenin Neden Başarısız Olduğunu Tutar.

  PaymentFailure(this.failureReason); // failureReason'ı Alan Constructor'dır.
}

// ---

abstract class IBankService { // Banka Servislerinin Uyması Gereken abstract Interface'tir.
  Future<PaymentStatus> pay({required double amount}); // amount Alıp Future<PaymentStatus> Döndüren pay Metodunu Tanımlar.
}

mixin SecurityCheckMixin { // Token Kontrolü Sağlayan Mixin'dir.
  bool isTokenValid(String token) { // Token'ın Geçerli Olup Olmadığını bool Olarak Döndürür.
    return token.isNotEmpty && token.length >= 32; // Token Boş Değilse ve En Az 32 Karakterse true Döndürür.
  }
}

mixin AuditLogMixin { // İşlem Log'u Yazma Yeteneği Sağlayan Mixin'dir.
  void logTransaction(String message) { // Verilen message'ı Timestamp İle Log'lar.
    final timestamp = DateTime.now().toIso8601String(); // Şu Anki Zamanı ISO 8601 Formatında String'e Çevirir.
    print('Log - $timestamp: $message'); // Timestamp ve message'ı Console'a Yazdırır.
  }
}

class GarantiBankService // Garanti Bankası İçin Ödeme Servisi Class'ıdır.
    with SecurityCheckMixin, AuditLogMixin // SecurityCheckMixin ve AuditLogMixin'in Metotlarını Class'a Katar.
    implements IBankService { // IBankService Interface'ini implement Eder.
  final String apiKey; // Banka API'si İçin Kullanılan apiKey'dir.

  GarantiBankService({required this.apiKey}); // apiKey'i required Named Parametre Olarak Alan Constructor'dır.

  @override // Interface'teki pay Metodunun Override Edildiğini Belirtir.
  Future<PaymentStatus> pay({required double amount}) async { // Ödemeyi async Olarak Gerçekleştirir.
    if (!isTokenValid(apiKey)) { // apiKey Geçersizse Bu Bloğa Girer.
      logTransaction('Ödeme Reddedildi. Geçersiz API Anahtarı.'); // Reddedilen Ödemeyi Log'lar.
      return PaymentFailure('Yetkilendirme Hatası: Geçersiz Token!'); // Hata Mesajıyla PaymentFailure Döndürür.
    }

    await Future.delayed(const Duration(milliseconds: 1000)); // Banka Cevabını Simüle Etmek İçin 1 Saniye Bekler.

    logTransaction( // Onaylanan Ödemeyi Log'lar.
      '$amount Tutarındaki Ödeme Garanti Bankası Tarafından Onaylandı!', // Log'a Yazılacak Onay Mesajıdır.
    );

    return PaymentSuccess(( // Record İle Bir PaymentSuccess Döndürür.
      referenceCode: 'GRNT-${DateTime.now().millisecondsSinceEpoch}', // Epoch Milisaniyesinden Benzersiz Bir referenceCode Üretir.
      amount: amount, // Ödenen amount'u Record'a Yazar.
    ));
  }
}

void printPaymentResult(PaymentStatus status) { // Ödeme Sonucunu Console'a Yazdırır.
  final message = switch (status) { // status'un Tipine Göre message Üreten Switch Expression'dır.
    PaymentSuccess s => // status PaymentSuccess İse s Değişkenine Bağlar.
      'Ödeme Başarılı! Referans: ${s.data.referenceCode}, Tutar: ${s.data.amount} TL', // Başarılı Ödeme Mesajını Oluşturur.
    PaymentFailure f => 'Ödeme Başarısız! Neden: ${f.failureReason}', // status PaymentFailure İse Hata Mesajını Oluşturur.
  };
  print(message); // Oluşan message'ı Console'a Yazdırır.
}

void main() async { // Programın async Entry Point'idir.
  // Geçersiz Token.
  final invalidService = GarantiBankService(apiKey: 'kisa_token'); // 32 Karakterden Kısa apiKey İle Servis Oluşturur.
  final result1 = await invalidService.pay(amount: 150.0); // 150.0 Tutarında Ödeme Dener ve Sonucu Bekler.
  printPaymentResult(result1); // İlk Sonucu Yazdırır.

  print('---'); // Çıktıları Ayırmak İçin Ayraç Yazdırır.

  // Geçerli Token (32 Karakter).
  final validService = GarantiBankService( // Geçerli apiKey İle Servis Oluşturur.
    apiKey: '1234567890abcdef1234567890abcdef', // 32 Karakterlik apiKey'dir.
  );

  // Birinci Ödeme Denemesi.
  final result2 = await validService.pay(amount: 250.75); // 250.75 Tutarında Ödeme Dener ve Sonucu Bekler.
  printPaymentResult(result2); // İkinci Sonucu Yazdırır.

  print('---'); // Çıktıları Ayırmak İçin Ayraç Yazdırır.

  // İkinci Ödeme Denemesi.
  final result3 = await validService.pay(amount: 500.0); // 500.0 Tutarında Ödeme Dener ve Sonucu Bekler.
  printPaymentResult(result3); // Üçüncü Sonucu Yazdırır.
}
