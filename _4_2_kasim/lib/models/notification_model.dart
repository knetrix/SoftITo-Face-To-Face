class NotificationModel { // Bir Bildirimi Temsil Eden Model Class'tır.
  final String id; // Bildirimin Benzersiz id'sini Tutan Field'dır.
  final String title; // Bildirimin Başlığını Tutan Field'dır.
  final String body; // Bildirimin İçerik Metnini Tutan Field'dır.
  final DateTime date; // Bildirimin Geldiği Tarihi Tutan Field'dır.
  final bool isRead; // Bildirimin Okunup Okunmadığını Tutan Field'dır.

  const NotificationModel({ // Tüm Field'ları Named Parameter Olarak Alan const Constructor'dır.
    required this.id, // id Parametresini Zorunlu Yapar.
    required this.title, // title Parametresini Zorunlu Yapar.
    required this.body, // body Parametresini Zorunlu Yapar.
    required this.date, // date Parametresini Zorunlu Yapar.
    this.isRead = false, // isRead Opsiyoneldir; Verilmezse false Atanır.
  });

  NotificationModel copyWith({ // Seçilen Field'ları Değiştirilmiş Yeni Bir Kopya Üreten copyWith Metodudur.
    String? id, // Yeni id Değerini Alan Nullable Parametredir.
    String? title, // Yeni title Değerini Alan Nullable Parametredir.
    String? body, // Yeni body Değerini Alan Nullable Parametredir.
    DateTime? date, // Yeni date Değerini Alan Nullable Parametredir.
    bool? isRead, // Yeni isRead Değerini Alan Nullable Parametredir.
  }) {
    return NotificationModel( // Güncellenmiş Değerlerle Yeni Bir NotificationModel Döndürür.
      id: id ?? this.id, // Yeni id Verildiyse Onu, Yoksa Mevcut id'yi Atar.
      title: title ?? this.title, // Yeni title Verildiyse Onu, Yoksa Mevcut title'ı Atar.
      body: body ?? this.body, // Yeni body Verildiyse Onu, Yoksa Mevcut body'yi Atar.
      date: date ?? this.date, // Yeni date Verildiyse Onu, Yoksa Mevcut date'i Atar.
      isRead: isRead ?? this.isRead, // Yeni isRead Verildiyse Onu, Yoksa Mevcut isRead'i Atar.
    );
  }
}
