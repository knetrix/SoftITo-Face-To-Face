// flutter pub add firebase_core cloud_firestore  [firebase_auth firebase_storage]
import 'package:flutter/material.dart'; // Material Widget'larını Kullanmak için flutter/material Library'sini import Eder.
import 'package:firebase_core/firebase_core.dart'; // Firebase'i Başlatmak için firebase_core Package'ını import Eder.
import 'models/student.dart'; // Student Model Class'ını import Eder.
import 'services/firestore_student_service.dart'; // Firestore İşlemlerini Yapan Service Class'ını import Eder.
import 'screens/firestore_management_screen.dart'; // Ekleme, Güncelleme ve Silme Yapan Yönetim Ekranını import Eder.

import 'firebase_options.dart';

void main() async { // Uygulamanın async Entry Point'idir.
  WidgetsFlutterBinding.ensureInitialized(); // runApp'ten Önce Native Kod Çağrılabilsin Diye Flutter Binding'i Hazırlar.
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform); // Firebase'i Çalışılan Platformun Ayarlarıyla Başlatır ve Bitmesini Bekler.
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
      home: const FirestoreManagementScreen(), // Açılışta Canlı Yönetim Ekranını Gösterir.
    );
  }
}

class FirebaseHomePage extends StatefulWidget { // Öğrenci Listesini Tek Seferlik Gösteren StatefulWidget'tır.
  const FirebaseHomePage({super.key}); // key'i Üst Class'a İleten const Constructor'dır.

  @override // Üst Class'taki createState Metodunu Override Eder.
  State<FirebaseHomePage> createState() => _FirebaseHomePageState(); // Bu Widget'ın State Nesnesini Oluşturur.
}

class _FirebaseHomePageState extends State<FirebaseHomePage> { // Sayfanın Future'ını Tutan State Class'ıdır.
  late final Future<List<Student>> _studentsFuture = FirestoreStudentService().getStudents(); // Sorguyu Bir Kez Başlatır; Her build'de Tekrar Atılmaz.

  @override // Üst Class'taki build Metodunu Override Eder.
  Widget build(BuildContext context) { // Sayfanın Widget Ağacını Oluşturan build Metodudur.
    return Scaffold( // Sayfa İskeletini Sağlayan Scaffold Döndürür.
      appBar: AppBar(title: const Text('Students')), // Başlığı Students Olan AppBar Ekler.
      body: FutureBuilder<List<Student>>( // Future Sonucuna Göre UI Çizen FutureBuilder'dır.
        future: _studentsFuture, // State'te Bir Kez Oluşturulan Future'ı Kullanır.
        builder: (context, snapshot) { // Future'ın Durumuna Göre Widget Döndüren Builder Callback'idir.
          if (snapshot.connectionState != ConnectionState.done) { // Future Henüz Tamamlanmadıysa Bu Bloğa Girer.
            return const Center(child: CircularProgressIndicator()); // Ortada Yükleniyor Göstergesi Gösterir.
          }
          if (snapshot.hasError) { // Sorgu Hata Verdiyse Bu Bloğa Girer.
            return Center(child: Text('Error: ${snapshot.error}')); // Hata Mesajını Ortada Gösterir.
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
                subtitle: Text('${student.email} - ${student.projectName}\n${formatStudentDates(student)}'), // Alt Satırda email, Proje Adı ve Tarihleri Gösterir.
                isThreeLine: true, // Tarih Satırı için ListTile'ı Üç Satırlık Yapar.
                trailing: Text('${student.point}'), // Sağ Tarafta Puanı Gösterir.
              );
            },
          );
        },
      ),
    );
  }
}
