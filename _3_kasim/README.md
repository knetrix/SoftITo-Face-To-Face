# _3_kasim

Öğrencilerin ad soyad, e-posta, proje adı ve puanını Firebase Cloud Firestore'da tutan küçük bir öğrenci yönetim uygulaması. Flutter ile yazıldı. Öğrenci ekleyebilir, puanını güncelleyebilir ya da silebilirsin; veriler `students` koleksiyonunda durur ve yapılan her değişiklik açık ekranlarda hemen görünür.

| Yönetim Ekranı | Puan Güncelleme | Silme |
| --- | --- | --- |
| ![Yönetim Ekranı](docs/screenshots/01-management.png) | ![Puan Güncelleme](docs/screenshots/02-update.png) | ![Silme](docs/screenshots/03-delete.png) |

## Özellikler

- Ad Soyad, Email, Proje Adı ve Puan alanlarından oluşan ekleme formu. Boş alan, geçersiz e-posta ya da 0 ile 100 arasında olmayan puan girilirse form uyarı verir
- Firestore'u `snapshots()` ile dinleyen canlı liste. Firebase Console'dan yapılan değişiklikler de sayfayı yenilemeden gelir
- Liste puana göre büyükten küçüğe sıralanır. Puan rozeti 80 ve üzerinde yeşil, 51 ile 79 arasında turuncu, 50 ve altında kırmızıdır
- Kalem ikonu puan güncelleme dialog'unu açar; kayıt sırasında `updateDate` sunucu zamanıyla yazılır
- Satırı sağdan sola kaydırınca öğrenci Firestore'dan silinir
- Kayıt, güncelleme ve silme sonuçları SnackBar ile gösterilir
- Kayıt tarihi `FieldValue.serverTimestamp()` ile sunucu saatinden alınır

## Kurulum ve çalıştırma

Gerekenler: Flutter SDK, Node.js, iOS için Xcode, Android için Android Studio.

```bash
npm install -g firebase-tools                       # Firebase CLI
firebase login                                      # Google hesabıyla giriş
gem install xcodeproj                               # FlutterFire'ın iOS projesini düzenlemesi için
flutter pub get
dart run flutterfire_cli:flutterfire configure      # Firebase projesini seç, android + ios
flutter analyze
flutter test
flutter run                                         # bağlı cihaz / emülatör
```

> Not: `flutterfire_cli` projeye `dev_dependencies` olarak eklendi. Bu yüzden komut `flutterfire` yerine `dart run flutterfire_cli:flutterfire` ile çalışır ve PATH ayarına gerek kalmaz. Firebase proje ID'si küçük harfle başlamalı: `3-kasim` kabul edilmez, `kasim-3-students` gibi bir ID edilir. iOS için en düşük sürüm 15.0.

`configure` komutu `lib/firebase_options.dart`, `ios/Runner/GoogleService-Info.plist`, `android/app/google-services.json` ve `firebase.json` dosyalarını oluşturur. Android Gradle dosyalarına Google Services eklentisini, Xcode projesine de plist dosyasını kendisi ekler.

> Bu dört dosya API anahtarı içerdiği için `.gitignore`'da ve depoda yok. Projeyi klonladıysan uygulama bu dosyalar olmadan derlenmez; önce `configure` komutunu kendi Firebase projenle çalıştır.
>
> `configure` yeni oluşturulan bir projede "Failed to create iOS app" hatası verebilir. `firebase-debug.log` içinde `429 RESOURCE_EXHAUSTED` görüyorsan Firebase'in dakikalık kayıt sınırına takılmışsındır: bir iki dakika bekle, komutu tekrar çalıştır ve listeden aynı projeyi seç.

Firebase Console'da iki adım kalıyor:

1. Firestore Database sayfasında Create database'e bas. Standard edition'ı seç, Database ID'yi `(default)` bırak ve test mode ile başlat.
2. `students` koleksiyonunu oluştur. `nameSurname`, `email` ve `projectName` string, `point` int64, `registrationDate` timestamp olmalı.

## Firestore veri yapısı

```text
students (Collection)
 └── <Auto-ID> (Document)
      ├── nameSurname      : string
      ├── email            : string
      ├── projectName      : string
      ├── point            : int64
      ├── registrationDate : timestamp
      └── updateDate       : timestamp (güncellemede eklenir)
```

## Mimari

Kod üç katmana ayrılır: model, service ve ekran. `models/student.dart` verinin şeklini ve `fromFireStore` dönüşümünü tutar. `services/firestore_student_service.dart` Firestore işlemlerinin hepsini içerir: `addStudent`, `getStudents`, `watchStudents`, `pointUpdate` ve `deleteStudent`. Ekranlar Firestore'a yalnızca bu service üzerinden erişir.

State için `StatefulWidget` ve `setState` kullanılır, canlı liste `StreamBuilder` ile çizilir. Harici state, DI ya da router paketi yok. `main.dart` açılışta `FirestoreManagementScreen`'i gösterir. Veriyi bir kez okuyan `FirebaseHomePage` (`FutureBuilder`) örnek olarak dosyada duruyor. Dosyaların tek tek anlatıldığı ders notu: [lib/SUMMARY.md](lib/SUMMARY.md).

## Notlar

- Test mode kuralları 30 gün sonra bütün okuma ve yazmaları reddeder. O noktada liste "No Students Found In Cloud." ya da bir hata gösterir; süreyi Firestore'un Rules sekmesinden uzatabilirsin. Uygulamada giriş olmadığı için veritabanı bu süre boyunca herkese açık, gerçek kişisel veri girme.
- `point` alanı her dokümanda aynı tipte (int64) olmalı. `orderBy('point')` sorgusu bu alanı olmayan dokümanları sonuca almaz.
- Firebase istemci API anahtarları tek başına gizli şifre sayılmaz, erişimi Firestore Rules belirler. Yine de GitHub bu anahtarları uyarı olarak işaretlediği için yapılandırma dosyaları ve `firebase-debug.log` `.gitignore`'da tutuluyor. Anahtarları Google Cloud Console'da uygulama ID'sine ve Firebase API'lerine kısıtlaman önerilir.
- Native yapılandırma değişince hot reload yetmez. `flutter clean && flutter pub get && flutter run` ile baştan derle.
- `lib/images/` altındaki iki görsel ders notu: biri SQL ile Firestore'u karşılaştırıyor, diğeri doküman yapısını gösteriyor ([SUMMARY.md](lib/SUMMARY.md), bölüm 1.2 ve 1.3).
