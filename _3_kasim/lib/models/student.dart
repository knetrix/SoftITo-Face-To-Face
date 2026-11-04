import 'package:cloud_firestore/cloud_firestore.dart'; // DocumentSnapshot ve Timestamp için cloud_firestore Package'ını import Eder.

class Student { // Bir Öğrenciyi Temsil Eden Model Class'tır.
  final String id; // Firestore Document id'sini Tutan Field'dır.
  final String nameSurname; // Öğrencinin Ad Soyadını Tutan Field'dır.
  final String email; // Öğrencinin email Adresini Tutan Field'dır.
  final String projectName; // Öğrencinin Proje Adını Tutan Field'dır.
  final int point; // Öğrencinin Puanını Tutan Field'dır.
  final DateTime registrationDate; // Kayıt Tarihini Tutan Field'dır.

  const Student({ // Tüm Field'ları Named Parameter Olarak Alan const Constructor'dır.
    required this.id, // id Parametresini Zorunlu Yapar.
    required this.nameSurname, // nameSurname Parametresini Zorunlu Yapar.
    required this.email, // email Parametresini Zorunlu Yapar.
    required this.projectName, // projectName Parametresini Zorunlu Yapar.
    required this.point, // point Parametresini Zorunlu Yapar.
    required this.registrationDate, // registrationDate Parametresini Zorunlu Yapar.
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
    );
  }
}
