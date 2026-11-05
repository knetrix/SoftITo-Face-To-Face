import 'dart:io'; // File Class'ını Kullanmak için dart:io Library'sini import Eder.

import 'package:firebase_storage/firebase_storage.dart'; // TaskSnapshot için firebase_storage Package'ını import Eder.
import 'package:flutter/material.dart'; // Material Widget'larını Kullanmak için flutter/material Library'sini import Eder.

import '../models/notification_model.dart'; // NotificationModel Class'ını import Eder.
import '../services/fcm_notification_service.dart'; // FCM İşlemlerini Yapan Service Class'ını import Eder.
import '../services/storage_service.dart'; // Storage İşlemlerini Yapan Service Class'ını import Eder.
import '../widgets/image_upload_card.dart'; // Görsel Yükleme Kartı Widget'ını import Eder.
import '../widgets/notification_list_card.dart'; // Bildirim Listesi Kartı Widget'ını import Eder.

class StorageAndFcmScreen extends StatefulWidget {
  // Storage ve FCM Özelliklerini Bir Arada Gösteren StatefulWidget'tır.
  const StorageAndFcmScreen({
    super.key,
  }); // key'i Üst Class'a İleten const Constructor'dır.

  @override // Üst Class'taki createState Metodunu Override Eder.
  State<StorageAndFcmScreen> createState() => _StorageAndFcmScreenState(); // Bu Widget'ın State Nesnesini Oluşturur.
}

class _StorageAndFcmScreenState extends State<StorageAndFcmScreen> {
  // Ekranın Değişken Durumunu Yöneten State Class'ıdır.
  static const String _topic =
      'softito'; // Abone Olunacak FCM Topic Adını Tutan static const Field'dır.

  final StorageService _storageService = StorageService(); // Storage İşlemleri için Service Nesnesini Tutan Field'dır.
  final FcmNotificationService _fcmNotificationService = // FCM İşlemleri için Service Nesnesini Tutan Field'dır.
      FcmNotificationService(); // Yeni Bir FcmNotificationService Oluşturur.

  File?
  _selectedFile; // Kullanıcının Seçtiği Yerel Dosyayı Tutan Nullable Field'dır.
  String?
  _uploadUrl; // Yüklenen Görselin Download URL'ini Tutan Nullable Field'dır.
  double _loadingProgress =
      0.0; // Yükleme İlerlemesini 0-1 Arasında Tutan Field'dır.
  bool _isLoading =
      false; // Yükleme İşleminin Sürüp Sürmediğini Tutan Flag'dir.

  String? _fcmToken; // Cihazın FCM Token'ını Tutan Nullable Field'dır.
  bool _isSubscribedToTopic =
      false; // Topic'e Abone Olunup Olunmadığını Tutan Flag'dir.
  final List<NotificationModel> _notifications =
      []; // Gelen Bildirimleri Tutan List Field'ıdır.

  @override // Üst Class'taki initState Metodunu Override Eder.
  void initState() {
    // Widget İlk Oluşturulduğunda Bir Kez Çalışan Metottur.
    super.initState(); // Üst Class'ın initState Metodunu Çağırır.
    _fcmInit(); // FCM Kurulumunu Başlatır.
  }

  Future<void> _fcmInit() async {
    // FCM Service'ini Başlatıp Token'ı Alan async Metottur.
    await _fcmNotificationService.start(
      // FCM Service'ini Başlatır ve Bitmesini Bekler.
      onMessageReceived: (message) {
        // Foreground'da Mesaj Geldiğinde Çalışan Callback'tir.
        if (!mounted) return; // Widget Ağaçtan Kaldırıldıysa setState Çağırmadan Çıkar.
        setState(() {
          // Bildirim Listesi Değiştiği için UI'ı Yeniler.
          _notifications.insert(
            // Yeni Bildirimi List'e Ekler.
            0, // Bildirimi List'in En Başına Koyar.
            NotificationModel(
              // Gelen RemoteMessage'dan Yeni Bir NotificationModel Oluşturur.
              id: // id Alanına Değer Atar.
                  message.messageId ?? // messageId Varsa Onu Kullanır.
                  DateTime.now().millisecondsSinceEpoch.toString(), // messageId Yoksa Şu Anki Zamanın Milisaniyesini id Yapar.
              title:
                  message.notification?.title ??
                  'New Notification', // Başlık Yoksa Varsayılan Başlığı Atar.
              body:
                  message.notification?.body ??
                  '', // body Yoksa Boş String Atar.
              date:
                  DateTime.now(), // Bildirim Tarihi Olarak Şu Anki Zamanı Atar.
            ),
          );
        });
      },
    );
    final token = await _fcmNotificationService
        .getToken(); // Service Üzerinden Cihazın FCM Token'ını Alır.
    if (!mounted) return; // Widget Ağaçtan Kaldırıldıysa Metottan Çıkar.
    setState(() => _fcmToken = token); // Token'ı State'e Yazıp UI'ı Yeniler.
  }

  Future<void> _pickImage({required bool withCamera}) async {
    // Kameradan veya Galeriden Görsel Seçen async Metottur.
    final file = await _storageService.pickImage(
      withCamera: withCamera,
    ); // Service Üzerinden Görsel Seçer ve File Alır.
    if (file == null) return; // Kullanıcı Seçimi İptal Ettiyse Metottan Çıkar.
    setState(() {
      // Seçim Sonrası State'i Güncelleyip UI'ı Yeniler.
      _selectedFile = file; // Seçilen Dosyayı _selectedFile'a Atar.
      _uploadUrl = null; // Önceki Yükleme URL'ini Temizler.
      _loadingProgress = 0.0; // Yükleme İlerlemesini Sıfırlar.
    });
  }

  Future<void> _uploadImage() async {
    // Seçilen Görseli Storage'a Yükleyen async Metottur.
    final file = _selectedFile; // Nullable Field'ı Yerel Değişkene Alır.
    if (file == null) return; // Dosya Seçilmediyse Metottan Çıkar.

    setState(() {
      // Yükleme Başladığı için State'i Güncelleyip UI'ı Yeniler.
      _isLoading = true; // _isLoading'i true Yapar.
      _loadingProgress = 0.0; // Yükleme İlerlemesini Sıfırlar.
    });

    try {
      // Hata Oluşabilecek Yükleme İşlemini try Bloğuna Alır.
      final task = _storageService.uploadFile(
        // Service Üzerinden Yüklemeyi Başlatır ve UploadTask Alır.
        file: file, // Yüklenecek Dosyayı Verir.
        fileName: '${DateTime.now().millisecondsSinceEpoch}.jpg', // Benzersiz Olması için Zaman Damgasını Dosya Adı Yapar.
        path: 'uploads', // Dosyanın Storage'daki Klasörünü uploads Olarak Belirler.
      );
      task.snapshotEvents.listen((TaskSnapshot snapshot) {
        // Yükleme İlerlemesini TaskSnapshot Stream'i ile Dinler.
        if (snapshot.totalBytes == 0 || !mounted) {
          return; // Toplam Boyut 0 İse veya Widget Kaldırıldıysa İşlem Yapmaz.
        }
        setState(() {
          // İlerleme Değiştiği için UI'ı Yeniler.
          _loadingProgress = snapshot.bytesTransferred / snapshot.totalBytes; // Aktarılan Byte'ı Toplama Bölerek İlerlemeyi Hesaplar.
        });
      });
      final snapshot = await task; // Yüklemenin Tamamlanmasını Bekler ve Son TaskSnapshot'ı Alır.
      final url = await _storageService.downloadUrl(
        reference: snapshot.ref,
      ); // Yüklenen Dosyanın Download URL'ini Alır.
      if (!mounted) return; // Widget Ağaçtan Kaldırıldıysa Metottan Çıkar.
      setState(() {
        // Yükleme Sonucunu State'e Yazıp UI'ı Yeniler.
        _uploadUrl = url; // Download URL'ini _uploadUrl'e Atar.
        _selectedFile = null; // Yerel Dosya Seçimini Temizler.
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          // Context'teki ScaffoldMessenger Üzerinden SnackBar Gösterir.
          const SnackBar(
            // Başarı Mesajını İçeren SnackBar'dır.
            content: Text('Upload Success'), // SnackBar Metnini Belirler.
            backgroundColor: Color.fromARGB(
              255,
              253,
              1,
              186,
            ), // SnackBar Arka Plan Rengini Belirler.
          ),
        );
      }
    } catch (e) {
      // Oluşan Hatayı Yakalar.
      if (mounted) {
        ScaffoldMessenger.of(context) // Context'teki ScaffoldMessenger'ı Bulur.
            .showSnackBar(
              SnackBar(content: Text('Upload Failed: $e')),
            ); // Hata Mesajını SnackBar ile Gösterir.
      }
    } finally {
      // Hata Olsa da Olmasa da Bu Bloğu Çalıştırır.
      if (mounted) {
        setState(() => _isLoading = false); // Yükleme Bittiği için _isLoading'i false Yapar.
      }
    }
  }

  Future<void> _onSubscribeChange(bool value) async {
    // Switch Değerine Göre Topic Aboneliğini Değiştiren async Metottur.
    setState(() => _isSubscribedToTopic = value); // Yeni Abonelik Durumunu State'e Yazıp UI'ı Yeniler.
    try {
      // Hata Oluşabilecek Abonelik İşlemini try Bloğuna Alır.
      if (value) {
        // Switch Açıldıysa Bu Bloğa Girer.
        await _fcmNotificationService.subscribeToTopic(
          _topic,
        ); // Cihazı _topic'e Abone Eder.
      } else {
        // Switch Kapatıldıysa Bu Bloğa Girer.
        await _fcmNotificationService.unsubscribeFromTopic(
          _topic,
        ); // Cihazın _topic Aboneliğini İptal Eder.
      }
      if (!mounted) return; // Widget Ağaçtan Kaldırıldıysa Metottan Çıkar.
      ScaffoldMessenger.of(context).showSnackBar(
        // Context'teki ScaffoldMessenger Üzerinden SnackBar Gösterir.
        SnackBar(
          content: Text(
            value
                ? "Subscribed To '$_topic' Topic"
                : "Unsubscribed From '$_topic' Topic",
          ), // Abonelik Durumuna Göre Mesaj Gösterir.
        ),
      );
    } catch (e) {
      // Oluşan Hatayı Yakalar.
      if (!mounted) return; // Widget Ağaçtan Kaldırıldıysa Metottan Çıkar.
      setState(() => _isSubscribedToTopic = !value); // İşlem Başarısız Olduğu için Switch'i Eski Haline Döndürür.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Subscription Failed: $e')),
      ); // Hata Mesajını SnackBar ile Gösterir.
    }
  }

  @override // Üst Class'taki build Metodunu Override Eder.
  Widget build(BuildContext context) {
    // Ekranın Widget Ağacını Oluşturan build Metodudur.
    return Scaffold(
      // Sayfa İskeletini Sağlayan Scaffold Döndürür.
      backgroundColor: const Color(0xFFF8FAFC), // Sayfa Arka Plan Rengini Belirler.
      appBar: AppBar(
        // Sayfanın Üst Çubuğu Olan AppBar'dır.
        title: const Column(
          // Başlık ve Alt Başlığı Alt Alta Dizen Column'dur.
          crossAxisAlignment: CrossAxisAlignment.start, // Metinleri Sola Hizalar.
          children: [
            Text(
              'Softito Storage ve FCM', // Ana Başlık Metnidir.
              style: TextStyle(
                fontSize: 17, // Yazı Boyutunu 17 Yapar.
                fontWeight: FontWeight.bold, // Yazıyı Kalın Yapar.
              ),
            ), // Text
            Text(
              'Bulut Yükleme ve Push Bildirimleri', // Alt Başlık Metnidir.
              style: TextStyle(
                fontSize: 11, // Yazı Boyutunu 11 Yapar.
                color: Colors.white70, // Yazı Rengini Yarı Saydam Beyaz Yapar.
              ),
            ), // Text
          ],
        ), // Column
        backgroundColor: const Color(0xff0F172A), // AppBar Arka Plan Rengini Belirler.
        foregroundColor: Colors.white, // AppBar Yazı ve İkon Rengini Beyaz Yapar.
      ), // AppBar
      body: SingleChildScrollView(
        // İçeriği Kaydırılabilir Yapan SingleChildScrollView'dır.
        padding: const EdgeInsets.all(16), // Her Yönden 16 Birim İç Boşluk Verir.
        child: Column(
          // Kartları Alt Alta Dizen Column'dur.
          children: [
            ImageUploadCard(
              // Görsel Seçme ve Yükleme Kartını Gösterir.
              selectedFile: _selectedFile, // Seçilen Dosyayı Karta İletir.
              uploadUrl: _uploadUrl, // Download URL'ini Karta İletir.
              loadingProgress: _loadingProgress, // Yükleme İlerlemesini Karta İletir.
              isLoading: _isLoading, // Yükleme Durumunu Karta İletir.
              onGallerySelect: () => _pickImage(withCamera: false), // Galeriden Görsel Seçer.
              onTakePhoto: () => _pickImage(withCamera: true), // Kameradan Fotoğraf Çeker.
              onCloudUpload: _uploadImage, // Yükle Butonunda _uploadImage'ı Çağırır.
            ), // ImageUploadCard
            const SizedBox(height: 16), // İki Kart Arasına 16 Birim Boşluk Koyar.
            NotificationListCard(
              // FCM Bildirim Kartını Gösterir.
              notifications: _notifications, // Bildirim List'ini Karta İletir.
              token: _fcmToken ?? '', // Token null İse Boş String İletir.
              isSubscribedToTopic: _isSubscribedToTopic, // Abonelik Durumunu Karta İletir.
              onSubscribeChange: _onSubscribeChange, // Switch Değişince _onSubscribeChange'i Çağırır.
            ), // NotificationListCard
          ],
        ), // Column
      ), // SingleChildScrollView
    ); // Scaffold
  }
}
