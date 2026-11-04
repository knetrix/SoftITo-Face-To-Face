import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore Erişimi için cloud_firestore Package'ını import Eder.
import 'package:flutter/foundation.dart'; // debugPrint için flutter/foundation Library'sini import Eder.
import '../models/student.dart'; // Student Model Class'ını import Eder.

class FirestoreStudentService { // Öğrenci Verileri için Firestore CRUD İşlemlerini Yapan Service Class'tır.
  final CollectionReference _studentCollection = FirebaseFirestore.instance.collection('students'); // students Collection'ına Referans Tutan Private Field'dır.

  Future<String> addStudent({required Student student}) async { // Yeni Öğrenci Ekleyip Oluşan Document id'sini Döndüren async Metottur.
    try { // Hata Oluşabilecek Firestore İşlemini try Bloğuna Alır.
      final docRef = await _studentCollection.add({ // Otomatik id ile Yeni Document Ekler ve DocumentReference'ı Alır.
        'nameSurname': student.nameSurname, // nameSurname Alanını Yazar.
        'email': student.email, // email Alanını Yazar.
        'projectName': student.projectName, // projectName Alanını Yazar.
        'point': student.point, // point Alanını Yazar.
        'registrationDate': FieldValue.serverTimestamp(), // Kayıt Tarihini Sunucu Zamanı Olarak Yazar.
      });
      debugPrint('Student Added'); // Ekleme Başarılı Mesajını Console'a Yazdırır.
      return docRef.id; // Yeni Document'ın id'sini Döndürür.
    } catch (e) { // Oluşan Hatayı Yakalar.
      debugPrint('Error Adding Student: $e'); // Hata Mesajını Console'a Yazdırır.
      rethrow; // Hatayı Çağıran Tarafa Tekrar Fırlatır.
    }
  }

  Future<List<Student>> getStudents() async { // Tüm Öğrencileri Tek Seferlik Getiren async Metottur.
    try { // Hata Oluşabilecek Sorguyu try Bloğuna Alır.
      final QuerySnapshot snapshot = await _studentCollection.orderBy('point', descending: true).get(); // Öğrencileri point'e Göre Azalan Sırada Çeker.
      return snapshot.docs.map((doc) => Student.fromFireStore(doc)).toList(); // Her Document'ı Student'a Çevirip List Olarak Döndürür.
    } catch (e) { // Oluşan Hatayı Yakalar.
      debugPrint('Error Getting Students: $e'); // Hata Mesajını Console'a Yazdırır.
      rethrow; // Hatayı Yutmak Yerine Çağırana İletir; Ekran "Hata" ile "Öğrenci Yok"u Ayırt Edebilsin.
    }
  }

  Stream<List<Student>> watchStudents() { // Öğrenci Listesini Canlı Dinleyen Stream Döndüren Metottur.
    return _studentCollection // students Collection'ı Üzerinden Sorgu Başlatır.
        .orderBy('point', descending: true) // Sonuçları point'e Göre Azalan Sıralar.
        .snapshots() // Her Değişiklikte Yeni QuerySnapshot Yayan Stream Alır.
        .map((snapshot) => snapshot.docs.map(Student.fromFireStore).toList()); // Her Snapshot'ı Student List'ine Çevirir.
  }

  Future<void> pointUpdate({required String id, required int newPoint}) async { // Verilen id'deki Öğrencinin Puanını Güncelleyen async Metottur.
    await _studentCollection.doc(id).update({ // Document'ta Sadece Verilen Alanları Günceller.
      'point': newPoint, // point Alanına Yeni Puanı Yazar.
      'updateDate': FieldValue.serverTimestamp(), // Güncelleme Tarihini Sunucu Zamanı Olarak Yazar.
    });
  }

  Future<void> deleteStudent({required String id}) async { // Verilen id'deki Öğrenciyi Silen async Metottur.
    await _studentCollection.doc(id).delete(); // id'ye Ait Document'ı Firestore'dan Siler.
    debugPrint('Data With $id was Deleted.'); // Silme Mesajını Console'a Yazdırır.
  }
}
