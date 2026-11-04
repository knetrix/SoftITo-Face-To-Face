# _3_kasim

Öğrencilerin ad soyad, e-posta, proje adı ve puan bilgilerini **Firebase Cloud Firestore**'da sakladığın; ekleme, puan güncelleme ve silme işlemlerini **canlı** olarak yaptığın basit bir öğrenci yönetim uygulaması. Flutter ile yazılmıştır; veriler bulutta `students` koleksiyonunda tutulur, değişiklikler tüm açık ekranlara anında yansır.

| Yönetim Ekranı | Puan Güncelleme | Silme |
| --- | --- | --- |
| ![Yönetim Ekranı](docs/screenshots/01-management.png) | ![Puan Güncelleme](docs/screenshots/02-update.png) | ![Silme](docs/screenshots/03-delete.png) |

## Özellikler

- Öğrenci ekleme formu (Ad Soyad, Email, Proje Adı, Puan) ve alan doğrulama: boş alan, geçersiz e-posta, 0–100 dışındaki puan uyarı verir
- Firestore'u `snapshots()` ile dinleyen canlı liste; Firebase Console'dan yapılan değişiklikler de yenilemeden görünür
- Öğrenciler puana göre azalan sırada listelenir; puan rozeti 80 ve üzeri yeşil, 51–79 turuncu, 50 ve altı kırmızı
- Kalem ikonuyla açılan dialog üzerinden puan güncelleme (`updateDate` sunucu zamanıyla yazılır)
- Satırı sağdan sola kaydırarak öğrenciyi Firestore'dan silme
- Kayıt, güncelleme ve silme sonuçları için SnackBar bildirimleri
- Kayıt tarihi cihaz saati yerine `FieldValue.serverTimestamp()` ile sunucu zamanı olarak yazılır

## Kurulum ve çalıştırma

Gereksinimler: Flutter SDK, Node.js, Xcode (iOS için), Android Studio (Android için).

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

> Not: `flutterfire_cli` projeye `dev_dependencies` olarak eklenmiştir, bu yüzden `flutterfire` yerine `dart run flutterfire_cli:flutterfire` ile çalıştırılır ve PATH ayarı gerekmez. Proje ID'si küçük harfle başlamalıdır (`3-kasim` geçersiz, `so-3-kasim` geçerli). iOS en düşük sürümü 15.0'dır.

`configure` şu dosyaları oluşturur: `lib/firebase_options.dart`, `ios/Runner/GoogleService-Info.plist`, `android/app/google-services.json`, `firebase.json`. Ayrıca Android Gradle dosyalarına Google Services eklentisini, Xcode projesine de plist dosyasını ekler.

Firebase Console'da yapılması gerekenler:

1. **Firestore Database → Create database** → Standard edition, Database ID `(default)`, **test mode**
2. `students` koleksiyonunu oluştur; alan tipleri: `nameSurname`, `email`, `projectName` → string, `point` → int64, `registrationDate` → timestamp

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

Katmanlı yapı: **Model → Service → Screen**. `models/student.dart` veri şeklini ve `fromFireStore` dönüşümünü, `services/firestore_student_service.dart` tüm Firestore CRUD işlemlerini (`addStudent`, `getStudents`, `watchStudents`, `pointUpdate`, `deleteStudent`, `saveStudentWithId`) içerir. Ekranlar Firestore'a doğrudan değil, her zaman service üzerinden erişir. State `StatefulWidget` + `setState`, canlı veri `StreamBuilder` ile çizilir; harici state/DI/router paketi yoktur. `main.dart` açılışta `FirestoreManagementScreen`'i gösterir; tek seferlik okuma yapan `FirebaseHomePage` (`FutureBuilder`) örnek olarak dosyada durur. Dosya dosya ayrıntılı ders notu: [lib/SUMMARY.md](lib/SUMMARY.md).

## Notlar

- Test mode kuralları **30 gün** sonra tüm okuma/yazmaları reddeder; bu durumda liste "No Students Found In Cloud." veya hata gösterir. Süreyi Firestore → Rules sekmesinden uzatabilirsin. Uygulamada kimlik doğrulama olmadığı için veritabanı bu sürede herkese açıktır; gerçek kişisel veri girme.
- `point` alanı tüm dokümanlarda aynı sayısal tipte (int64) olmalıdır; `orderBy('point')` sorgusu bu alanı olmayan dokümanları sonuçlara dahil etmez.
- Firebase yapılandırma dosyalarındaki API anahtarları gizli değildir; güvenliği Firestore Rules sağlar. Depo herkese açıksa yine de bu dosyaları `.gitignore`'a eklemeyi düşünebilirsin. `firebase-debug.log` zaten yok sayılır.
- Native yapılandırma değiştiğinde hot reload yetmez; `flutter clean && flutter pub get && flutter run` ile yeniden derle.
- `lib/images/` altındaki görseller SQL–Firestore karşılaştırması ve doküman yapısı ders notlarıdır (bkz. [SUMMARY.md](lib/SUMMARY.md) bölüm 1.2 ve 1.3).
