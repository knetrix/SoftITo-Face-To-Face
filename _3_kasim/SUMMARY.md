# Proje Özeti: Firestore Öğrenci Yönetim Uygulaması

## 1. Amaç

Bu proje, **Flutter** ile yazılmış ve verilerini **Firebase Cloud Firestore**'da tutan küçük bir
öğrenci yönetim uygulamasıdır. SoftITo yüz yüze eğitiminde (3 Kasım dersi) Firestore ile
**CRUD** (Create / Read / Update / Delete) işlemlerini ve **gerçek zamanlı veri dinlemeyi**
öğretmek amacıyla hazırlanmıştır.

Uygulamada yeni öğrenci eklenebilir (ad soyad, e-posta, proje adı, puan), öğrenciler puana göre
sıralı **canlı** bir listede görülebilir, puan bir dialog ile güncellenebilir ve satır sağdan sola
kaydırılarak öğrenci silinebilir.

Firestore'da yapılan her değişiklik (başka bir cihazdan bile olsa) açık ekranlara anında yansır.

## 2. Teknoloji Yığını

| Katman | Teknoloji |
| --- | --- |
| UI | Flutter (Material 3, `deepOrange` seed rengi) |
| Dil | Dart (SDK `^3.13.5`) |
| Backend / Veritabanı | Firebase Cloud Firestore (`cloud_firestore ^7.1.0`) |
| Firebase başlatma | `firebase_core ^5.1.0` + FlutterFire CLI ile üretilmiş `firebase_options.dart` |
| Desteklenen platformlar | **Android** ve **iOS** (Web, macOS, Windows, Linux yapılandırılmamış) |
| Firebase projesi | `soft-3-kasim` |

## 3. Klasör Yapısı

```text
_3_kasim/
├── lib/
│   ├── main.dart                               # Giriş noktası, Firebase başlatma, root widget
│   ├── firebase_options.dart                   # FlutterFire CLI'ın ürettiği platform ayarları
│   ├── models/
│   │   └── student.dart                        # Student veri modeli + tarih formatlama
│   ├── services/
│   │   └── firestore_student_service.dart      # Firestore CRUD işlemleri
│   ├── screens/
│   │   └── firestore_management_screen.dart    # Ana ekran: form + canlı liste + dialog
│   └── images/                                 # 1.png, 2.png (şu an kodda kullanılmıyor)
├── test/widget_test.dart                       # Basit birim testi
├── docs/screenshots/                           # README ekran görüntüleri
├── android/  ios/                              # Platform projeleri (google-services dosyaları dahil)
├── firebase.json                               # FlutterFire CLI yapılandırması
└── pubspec.yaml                                # Bağımlılıklar
```

## 4. Mimari

Proje basit bir **katmanlı mimari** kullanır. Her katmanın tek bir sorumluluğu vardır:

```text
┌──────────────────────────────────────────┐
│  UI Katmanı (screens/)                   │  Form, liste, dialog, SnackBar
│  FirestoreManagementScreen               │
└───────────────┬──────────────────────────┘
                │  metod çağrıları / Stream
┌───────────────▼──────────────────────────┐
│  Service Katmanı (services/)             │  Firestore ile konuşan tek yer
│  FirestoreStudentService                 │
└───────────────┬──────────────────────────┘
                │  Map <-> Student dönüşümü
┌───────────────▼──────────────────────────┐
│  Model Katmanı (models/)                 │  Student sınıfı
└───────────────┬──────────────────────────┘
                │
┌───────────────▼──────────────────────────┐
│  Cloud Firestore → "students" collection │
└──────────────────────────────────────────┘
```

- UI, Firestore'a **doğrudan erişmez**; her işlem servis üzerinden yapılır.
- Ayrı bir state management kütüphanesi (Provider, Bloc vb.) yoktur. Durum `StatefulWidget`
  + `setState` ile, veri akışı ise `StreamBuilder` ile yönetilir.

## 5. Dosyaların Görevleri

### `lib/main.dart`
- `main()` içinde `WidgetsFlutterBinding.ensureInitialized()` çağrılır, ardından
  `Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)` beklenir.
- Root widget `FirebaseApp`, `MaterialApp` döndürür ve açılış ekranı olarak
  `FirestoreManagementScreen`'i gösterir.
- Dosyada ayrıca `FirebaseHomePage` adında, öğrencileri **tek seferlik** (`FutureBuilder` +
  `getStudents()`) listeleyen alternatif bir sayfa var. Şu an hiçbir yerden açılmıyor; Future ile
  Stream farkını göstermek için örnek olarak duruyor.

### `lib/models/student.dart`
`Student` sınıfının alanları:

| Alan | Tip | Açıklama |
| --- | --- | --- |
| `id` | `String` | Firestore document id'si |
| `nameSurname` | `String` | Ad soyad |
| `email` | `String` | E-posta |
| `projectName` | `String` | Proje adı |
| `point` | `int` | Puan (0–100) |
| `registrationDate` | `DateTime` | Kayıt tarihi |
| `updateDate` | `DateTime?` | Son güncelleme tarihi (hiç güncellenmediyse `null`) |

- `Student.fromFireStore(DocumentSnapshot)`: Firestore document'ını güvenli şekilde `Student`'a
  çevirir. Eksik alanlara varsayılan değer verir, `Timestamp`'leri `DateTime`'a dönüştürür.
- `formatStudentDates(student)`: Tarihleri `gg.aa.yyyy ss:dd` biçiminde
  `Registered: ... · Updated: ...` metnine çevirir.

### `lib/services/firestore_student_service.dart`
`students` collection'ı üzerinde çalışan servis:

| Metot | İşlem | Firestore çağrısı |
| --- | --- | --- |
| `addStudent(student)` | Create | `add({...})`; `registrationDate` = `serverTimestamp()` |
| `getStudents()` | Read (tek sefer) | `orderBy('point', descending: true).get()` |
| `watchStudents()` | Read (canlı) | `orderBy('point', descending: true).snapshots()` → `Stream<List<Student>>` |
| `pointUpdate(id, newPoint)` | Update | `doc(id).update({point, updateDate: serverTimestamp()})` |
| `deleteStudent(id)` | Delete | `doc(id).delete()` |

Tarihler istemci saatiyle değil **sunucu zamanıyla** (`FieldValue.serverTimestamp()`) yazılır.
Hatalar `debugPrint` ile loglanır ve `rethrow` ile UI'a iletilir; böylece ekran hatayı kullanıcıya
gösterebilir.

### `lib/screens/firestore_management_screen.dart`
Uygulamanın tek aktif ekranıdır. `CustomScrollView` içinde iki bölüm vardır:

1. **Ekleme formu** (`_buildForm`)
   - Doğrulamalar: ad soyad ve proje adı boş olamaz, e-posta RegExp ile kontrol edilir, puan
     0–100 arasında olmalıdır (`_validatePoint`).
   - "Save Cloud." butonu kayıt sürerken devre dışı kalır ve yükleniyor göstergesi gösterir
     (`_isSaving`).
   - Kayıt başarılı olunca form temizlenir, klavye kapanır, SnackBar gösterilir.
2. **Canlı öğrenci listesi** (`StreamBuilder` + `SliverList`)
   - Yükleniyor, hata ve boş liste durumlarını ayrı ayrı gösterir.
   - Stream `late final` alanda tutulur, böylece her `build`'de yeniden oluşturulmaz.
   - Her satır (`_buildStudentTile`):
     - Solda puana göre renklenen avatar: **≥80 yeşil**, **51–79 turuncu**, **≤50 kırmızı**
     - Ortada ad soyad, e-posta, proje adı ve tarihler
     - Sağda düzenle butonu → `_PointUpdateDialog`
     - `Dismissible` ile sağdan sola kaydırınca silme. `confirmDismiss` silme işleminin sonucunu
       bekler; silme başarısız olursa satır listede kalır.

`_PointUpdateDialog`, mevcut puanla açılan ve aynı validator'ı kullanan bir `AlertDialog`'dur.
Yeni puanı `Navigator.pop` ile geri döndürür. Puan değişmemişse Firestore'a istek gönderilmez.

## 6. Veri Akışı Örnekleri

**Öğrenci ekleme:**
```text
Form → validate() → Student nesnesi → FirestoreStudentService.addStudent()
     → Firestore "students".add() → snapshots() yeni veri yayınlar
     → StreamBuilder listeyi yeniden çizer
```

**Puan güncelleme:**
```text
Düzenle ikonu → _PointUpdateDialog → yeni puan → pointUpdate()
     → doc(id).update() → Stream günceller → liste yeniden sıralanır
```

**Silme:**
```text
Kaydırma → confirmDismiss → deleteStudent() → başarılıysa true → satır kaldırılır
```

## 7. Firestore Veri Şeması

Collection: `students`  (document id'leri otomatik üretilir)

```json
{
  "nameSurname": "Ali Yılmaz",
  "email": "ali@example.com",
  "projectName": "Flutter App",
  "point": 85,
  "registrationDate": "<Timestamp>",
  "updateDate": "<Timestamp>"
}
```

`updateDate` alanı sadece puan en az bir kez güncellendiyse bulunur.

## 8. Çalıştırma

```bash
flutter pub get
flutter run          # Android emülatörü / iOS simülatörü veya gerçek cihaz
flutter test         # test/widget_test.dart
```

Kendi Firebase projenizi bağlamak için `flutterfire configure` çalıştırın; bu komut
`firebase_options.dart`, `google-services.json` ve `GoogleService-Info.plist` dosyalarını yeniden üretir.
Firestore'da `students` collection'ının okunup yazılabilmesi için Firebase Console'daki
güvenlik kurallarının buna izin vermesi gerekir.

## 9. Bilinmesi Gerekenler

- Proje eğitim amaçlı olduğu için kodda hemen her satırın yanında Türkçe açıklama yorumu var.
- `FirebaseHomePage` ve `lib/images/` klasörü şu an kullanılmıyor (görseller `pubspec.yaml`'da
  asset olarak da tanımlı değil).
- Kimlik doğrulama (Auth) ve dosya depolama (Storage) yok; `main.dart`'ın ilk satırındaki yorumda
  bunlar ileride eklenebilecek paketler olarak geçiyor.
- Test kapsamı çok sınırlı: tek test, `FirebaseApp`'in `StatelessWidget` olduğunu kontrol ediyor.
