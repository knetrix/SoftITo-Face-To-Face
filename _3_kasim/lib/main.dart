// flutter pub add firebase_core cloud_firestore  [firebase_auth firebase_storage]
import 'package:flutter/material.dart'; // Material Widget'larını Kullanmak için flutter/material Library'sini import Eder.
import 'package:firebase_core/firebase_core.dart'; // Firebase'i Başlatmak için firebase_core Package'ını import Eder.
import 'models/student.dart'; // Student Model Class'ını import Eder.
import 'services/firestore_student_service.dart'; // Firestore İşlemlerini Yapan Service Class'ını import Eder.

void main() async { // Uygulamanın async Entry Point'idir.
  WidgetsFlutterBinding.ensureInitialized(); // runApp'ten Önce Native Kod Çağrılabilsin Diye Flutter Binding'i Hazırlar.
  await Firebase.initializeApp(); // Firebase'i Başlatır ve Bitmesini Bekler.
  runApp(const FirebaseApp()); // FirebaseApp Widget'ını Root Olarak Çalıştırır.
}

class FirebaseApp extends StatelessWidget { // Uygulamanın Root Widget'ı Olan StatelessWidget'tır.
  const FirebaseApp({super.key}); // key'i Üst Class'a İleten const Constructor'dır.

  @override // Üst Class'taki build Metodunu Override Eder.
  Widget build(BuildContext context) { // Widget Ağacını Oluşturan build Metodudur.
    return MaterialApp( // Material Design Ayarlarını Taşıyan MaterialApp Döndürür.
      debugShowCheckedModeBanner: false, // Sağ Üstteki Debug Banner'ını Gizler.
      title: 'Firebase', // Uygulamanın Başlığını Belirler.
      theme: ThemeData( // Uygulamanın Temasını Tanımlar.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange), // deepOrange Seed Color'dan ColorScheme Üretir.
        useMaterial3: true, // Material 3 Tasarımını Açar.
      ),
      home: const FirebaseHomePage(), // Açılışta Gösterilecek Sayfayı Belirler.
    );
  }
}

class FirebaseHomePage extends StatelessWidget { // Öğrenci Listesini Gösteren StatelessWidget'tır.
  const FirebaseHomePage({super.key}); // key'i Üst Class'a İleten const Constructor'dır.

  @override // Üst Class'taki build Metodunu Override Eder.
  Widget build(BuildContext context) { // Sayfanın Widget Ağacını Oluşturan build Metodudur.
    return Scaffold( // Sayfa İskeletini Sağlayan Scaffold Döndürür.
      appBar: AppBar(title: const Text('Students')), // Başlığı Students Olan AppBar Ekler.
      body: FutureBuilder<List<Student>>( // Future Sonucuna Göre UI Çizen FutureBuilder'dır.
        future: FirestoreStudentService().getStudents(), // Firestore'dan Öğrenci Listesini Getiren Future'dır.
        builder: (context, snapshot) { // Future'ın Durumuna Göre Widget Döndüren Builder Callback'idir.
          if (snapshot.connectionState != ConnectionState.done) { // Future Henüz Tamamlanmadıysa Bu Bloğa Girer.
            return const Center(child: CircularProgressIndicator()); // Ortada Yükleniyor Göstergesi Gösterir.
          }
          final students = snapshot.data ?? []; // Gelen Veriyi Alır, null İse Boş List Kullanır.
          if (students.isEmpty) { // Liste Boşsa Bu Bloğa Girer.
            return const Center(child: Text('No students found.')); // Öğrenci Bulunamadı Mesajını Gösterir.
          }
          return ListView.builder( // Öğrencileri Lazy Olarak Çizen ListView Döndürür.
            itemCount: students.length, // Liste Eleman Sayısını Belirler.
            itemBuilder: (context, index) { // Her index için Bir Satır Üreten Callback'tir.
              final student = students[index]; // index'teki Student Nesnesini Alır.
              return ListTile( // Öğrenci Bilgilerini Gösteren ListTile Döndürür.
                title: Text(student.nameSurname), // Başlıkta Ad Soyadı Gösterir.
                subtitle: Text('${student.email} - ${student.projectName}'), // Alt Satırda email ve Proje Adını Gösterir.
                trailing: Text('${student.point}'), // Sağ Tarafta Puanı Gösterir.
              );
            },
          );
        },
      ),
    );
  }
}
