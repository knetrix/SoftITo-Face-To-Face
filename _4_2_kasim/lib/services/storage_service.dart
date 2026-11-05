import 'dart:io'; // File Class'ını Kullanmak için dart:io Library'sini import Eder.

import 'package:firebase_storage/firebase_storage.dart'; // Firebase Storage İşlemleri için firebase_storage Package'ını import Eder.

import 'package:image_picker/image_picker.dart'; // Galeriden veya Kameradan Görsel Seçmek için image_picker Package'ını import Eder.

class StorageService { // Görsel Seçme ve Firebase Storage İşlemlerini Yapan Service Class'tır.
  final FirebaseStorage _storage = FirebaseStorage.instance; // FirebaseStorage Singleton Instance'ını Tutan Private Field'dır.
  final ImagePicker _picker = ImagePicker(); // Görsel Seçimi için ImagePicker Nesnesini Tutan Private Field'dır.

  Future<File?> pickImage({bool withCamera = false}) async { // Kameradan veya Galeriden Görsel Seçip File Döndüren async Metottur.
    final XFile? xFile = await _picker.pickImage( // Kullanıcıdan Görsel Seçmesini Bekler ve XFile Alır.
      source: withCamera ? ImageSource.camera : ImageSource.gallery, // withCamera true İse Kamerayı, Değilse Galeriyi Kaynak Yapar.
      imageQuality: 70, // Görsel Kalitesini %70'e Sıkıştırır.
      maxWidth: 800, // Görselin Maksimum Genişliğini 800px ile Sınırlar.
    );
    if (xFile == null) return null; // Kullanıcı Seçimi İptal Ettiyse null Döndürür.
    return File(xFile.path); // XFile'ın path'inden File Oluşturup Döndürür.
  }

  UploadTask uploadFile({ // Dosyayı Storage'a Yükleyen ve UploadTask Döndüren Metottur.
    required File file, // Yüklenecek Dosyayı Alan Zorunlu Parametredir.
    required String fileName, // Storage'daki Dosya Adını Alan Zorunlu Parametredir.
    required String path, // Storage'daki Klasör Yolunu Alan Zorunlu Parametredir.
  }) {
    final Reference reference = _storage.ref().child('$path/$fileName'); // Root'tan Başlayarak Dosyanın Storage Reference'ını Oluşturur.
    final metadata = SettableMetadata( // Dosyaya Eklenecek Metadata'yı Oluşturur.
      contentType: 'image/jpeg', // Dosyanın contentType'ını image/jpeg Olarak Belirler.
      customMetadata: {'Uploader': 'Mustafa'}, // Yükleyen Bilgisini customMetadata Olarak Ekler.
    );
    return reference.putFile(file, metadata); // Dosyayı Metadata ile Yükler ve UploadTask'ı Döndürür.
  }

  Future<String> downloadUrl({required Reference reference}) async { // Verilen Reference'ın Download URL'ini Döndüren async Metottur.
    return await reference.getDownloadURL(); // Storage'dan Dosyanın Public Download URL'ini Alıp Döndürür.
  }

  Future<void> deleteFile({required String path}) async { // Verilen path'teki Dosyayı Storage'dan Silen async Metottur.
    final Reference reference = _storage.ref().child(path); // Silinecek Dosyanın Storage Reference'ını Oluşturur.
    await reference.delete(); // Dosyayı Storage'dan Siler.
  }
}
