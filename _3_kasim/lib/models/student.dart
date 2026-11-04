import 'package:cloud_firestore/cloud_firestore.dart'; // DocumentSnapshot ve Timestamp için cloud_firestore Package'ını import Eder.

class Student { // Bir Öğrenciyi Temsil Eden Model Class'tır.
  final String id; // Firestore Document id'sini Tutan Field'dır.
  final String nameSurname; // Öğrencinin Ad Soyadını Tutan Field'dır.
  final String email; // Öğrencinin email Adresini Tutan Field'dır.
  final String projectName; // Öğrencinin Proje Adını Tutan Field'dır.
  final int point; // Öğrencinin Puanını Tutan Field'dır.
  final DateTime registrationDate; // Kayıt Tarihini Tutan Field'dır.
  final DateTime? updateDate; // Son Güncelleme Tarihini Tutan Field'dır; Hiç Güncellenmediyse null'dır.

  const Student({ // Tüm Field'ları Named Parameter Olarak Alan const Constructor'dır.
    required this.id, // id Parametresini Zorunlu Yapar.
    required this.nameSurname, // nameSurname Parametresini Zorunlu Yapar.
    required this.email, // email Parametresini Zorunlu Yapar.
    required this.projectName, // projectName Parametresini Zorunlu Yapar.
    required this.point, // point Parametresini Zorunlu Yapar.
    required this.registrationDate, // registrationDate Parametresini Zorunlu Yapar.
    this.updateDate, // updateDate Opsiyoneldir; Yeni Öğrencide Verilmez.
  });

  factory Student.fromFireStore(DocumentSnapshot snapshot) { // Firestore Document'ından Student Üreten factory Constructor'dır.
    final data = snapshot.data() as Map<String, dynamic>? ?? {}; // Document Verisini Map'e Çevirir, null İse Boş Map Kullanır.
    return Student( // Map'teki Değerlerle Yeni Bir Student Döndürür.
      id: snapshot.id, // Document id'sini id Olarak Atar.
      nameSurname: data['nameSurname'] as String? ?? '', // nameSurname'ü Okur, Yoksa Boş String Atar.
      email: data['email'] as String? ?? '', // email'i Okur, Yoksa Boş String Atar.
      projectName: data['projectName'] as String? ?? '', // projectName'i Okur, Yoksa Boş String Atar.
      point: (data['point'] as num?)?.toInt() ?? 0, // point'i num Olarak Okuyup int'e Çevirir, Yoksa 0 Atar.
      registrationDate: (data['registrationDate'] as Timestamp?)?.toDate() ?? DateTime.now(), // Timestamp'i DateTime'a Çevirir, Yoksa Şu Anki Zamanı Atar.
      updateDate: (data['updateDate'] as Timestamp?)?.toDate(), // Timestamp'i DateTime'a Çevirir, Alan Yoksa null Bırakır.
    );
  }
}

String _formatDate(DateTime date) { // DateTime'ı gg.aa.yyyy ss:dd Biçiminde Metne Çeviren Yardımcı Function'dır.
  String two(int n) => n.toString().padLeft(2, '0'); // Tek Haneli Sayının Başına 0 Ekler.
  return '${two(date.day)}.${two(date.month)}.${date.year} ${two(date.hour)}:${two(date.minute)}'; // Biçimlenmiş Tarihi Döndürür.
}

String formatStudentDates(Student student) { // Kayıt ve Güncelleme Tarihlerini Tek Satırda Birleştiren Function'dır.
  final registered = 'Registered: ${_formatDate(student.registrationDate)}'; // Kayıt Tarihi Metnini Hazırlar.
  final updateDate = student.updateDate; // Nullable Alanı Yerel Değişkene Alır.
  return updateDate == null ? registered : '$registered · Updated: ${_formatDate(updateDate)}'; // Güncelleme Varsa Ekler.
}
