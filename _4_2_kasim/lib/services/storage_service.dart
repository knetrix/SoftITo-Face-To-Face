import 'dart:io'; // File Class'ını Kullanmak için dart:io Library'sini import Eder.

import 'package:image_picker/image_picker.dart'; // Galeriden veya Kameradan Görsel Seçmek için image_picker Package'ını import Eder.
import 'package:supabase_flutter/supabase_flutter.dart'; // Supabase Storage İşlemleri için supabase_flutter Package'ını import Eder.

import '../config/supabase_config.dart'; // Bucket Adını Almak için SupabaseConfig'i import Eder.

class StorageService { // Görsel Seçme ve Supabase Storage İşlemlerini Yapan Service Class'tır.
  final StorageFileApi _bucket = Supabase.instance.client.storage.from(SupabaseConfig.bucket); // Bucket'a Erişen Storage API Nesnesini Tutan Private Field'dır.
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

  Future<String> uploadFile({ // Dosyayı Storage'a Yükleyip Public URL Döndüren async Metottur.
    required File file, // Yüklenecek Dosyayı Alan Zorunlu Parametredir.
    required String fileName, // Storage'daki Dosya Adını Alan Zorunlu Parametredir.
    required String path, // Storage'daki Klasör Yolunu Alan Zorunlu Parametredir.
  }) async {
    final String fullPath = '$path/$fileName'; // Bucket İçindeki Tam Dosya Yolunu Oluşturur.
    await _bucket.upload( // Dosyayı Bucket'a Yükler ve Bitmesini Bekler.
      fullPath, // Bucket İçindeki Hedef Yolu Verir.
      file, // Yüklenecek Dosyayı Verir.
      fileOptions: const FileOptions(contentType: 'image/jpeg'), // Dosyanın contentType'ını image/jpeg Olarak Belirler.
    );
    return _bucket.getPublicUrl(fullPath); // Public Bucket'taki Dosyanın Herkese Açık URL'ini Döndürür.
  }

  Future<void> deleteFile({required String path}) async { // Verilen path'teki Dosyayı Storage'dan Silen async Metottur.
    await _bucket.remove([path]); // Dosyayı Bucket'tan Siler (DELETE Policy Gerektirir).
  }
}
