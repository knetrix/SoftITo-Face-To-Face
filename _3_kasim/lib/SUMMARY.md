# _3_kasim — Proje Özeti

**Flutter** ile Yazılmış, **Firebase Cloud Firestore** Kullanan Basit Bir **Öğrenci Yönetim** Uygulaması.
Öğrenciler (Ad Soyad, Email, Proje Adı, Puan) Bulutta Saklanır; Uygulama Bunları Listeler, Ekler, Günceller ve Siler.

> Önerilen Okuma Sırası: `pubspec.yaml` → `student.dart` → `firestore_student_service.dart` → `firebase_options.dart` → `main.dart` → `firestore_management_screen.dart` → `widget_test.dart`.
> Projeyi Sıfırdan Kuracaksan Önce **12. Bölüme** Bak; Firebase Yapılandırması Olmadan Uygulama Boş Beyaz Ekranda Kalır.

## 1. Temel Kavramlar

| Kavram | Kısa Açıklama |
|---|---|
| **Widget** | Ekrandaki Her Şey (Yazı, Buton, Sayfa) Bir Widget'tır. |
| **StatelessWidget / StatefulWidget** | Değişen Veri Tutmayan / Tutan Widget. Değişiklik `setState()` ile Ekrana Yansır. |
| **build() / BuildContext** | Widget'ı Çizen Metot / Widget'ın Ağaçtaki Konumu (`Navigator`, `ScaffoldMessenger`'a Ulaşmak için). |
| **Future / Stream** | Bir Kez Gelen Sonuç / Zamanla Sürekli Yeni Değer Yayan Akış. |
| **Firestore / CRUD** | Google'ın Bulut NoSQL Veritabanı (**Collection → Document → Field**) / Create, Read, Update, Delete. |

### 1.1 Firestore Veri Yapısı

```text
students (Collection)
 └── <Otomatik Id> (Document)
      ├── nameSurname      : String
      ├── email            : String
      ├── projectName      : String
      ├── point            : int (Console'da Tip Olarak int64 Seçilir)
      ├── registrationDate : Timestamp
      └── updateDate       : Timestamp (Güncellemede Eklenir)
```

- Firestore'da **Şema Yoktur**; Bir Dokümanda Olan Alan Diğerinde Olmayabilir. Bu Yüzden Model'de `??` ile Varsayılan Değer Verilir.

### 1.2 SQL ve Firestore (`images/1.png`, `images/2.png`)

| Kavram | Klasik SQL | Firestore (NoSQL) |
|---|---|---|
| Veriler / Tek Veri / Alan | Tablo / Satır / Sütun | Koleksiyon / Doküman / Alan |
| İlişkiler | `JOIN`, `FOREIGN KEY` | Alt Koleksiyon veya Gömülü Map (`kullanicilar/USER12/siparisler/ORD99`) |
| Sorgu Hızı | Tablo Büyüdükçe Yavaşlar | Sadece Çekilen Sonuç Sayısına Bağlı |
| Veri Sınırı | Disk Kapasitesi | Tek Doküman En Fazla 1 MB (Alt Koleksiyonlar Bu Sınıra Dahil Değil) |
| Veri Tipleri | Sütun Tipleri | String, Number, Boolean, Array, Map, Timestamp (**Bu Projede** String, Number, Timestamp) |

### 1.3 Future ve Stream

| Özellik | Future | Stream |
|---|---|---|
| Kaç Değer? | Bir Kez (Fotoğraf) | Sürekli (Canlı Yayın) |
| UI'da | `FutureBuilder` | `StreamBuilder` |
| Bu Projede | `getStudents()` → `FirebaseHomePage` (Açılışta Kullanılmıyor) | `watchStudents()` → `FirestoreManagementScreen` (Açılış Ekranı) |

## 2. Klasör Yapısı ve Mimari

```text
_3_kasim/
├── pubspec.yaml, README.md, firebase.json (*)
├── lib/
│   ├── main.dart                                → Başlangıç Noktası
│   ├── firebase_options.dart (*)                → Platforma Göre Firebase Ayarları
│   ├── models/student.dart                      → Veri Modeli
│   ├── services/firestore_student_service.dart  → Firestore CRUD İşlemleri
│   ├── screens/firestore_management_screen.dart → Canlı Yönetim Ekranı (Açılış Ekranı)
│   ├── images/1.png, 2.png                      → Ders Notu Görselleri
│   └── SUMMARY.md                               → Bu Doküman
├── docs/screenshots/                            → README Ekran Görüntüleri
├── test/widget_test.dart                        → Basit Test
├── android/app/google-services.json (*)         → Android Firebase Ayarları
└── ios/Runner/GoogleService-Info.plist (*)      → iOS Firebase Ayarları
```

> (*) Bu Dosyaları `dart run flutterfire_cli:flutterfire configure` Üretir. Komut Ayrıca Android Gradle Dosyalarına
> Google Services Eklentisini, `ios/Runner.xcodeproj/project.pbxproj`'a da Plist Referansını Ekler.

**Katmanlı Mimari: Model → Service → Screen.** UI Firestore'a Sadece Service Üzerinden Erişir; Veritabanı Değişirse Sadece Service Değişir.

## 3. `pubspec.yaml` — Paketler

- `name: _3_kasim` (Import'larda `package:_3_kasim/...`), `publish_to: 'none'`, `version: 1.0.0+1`, `sdk: ^3.13.5`.

| Paket | Sürüm | Görevi |
|---|---|---|
| `firebase_core` | `^5.1.0` | Firebase'i Başlatmak için Zorunlu Temel Paket. |
| `cloud_firestore` | `^7.1.0` | Firestore Erişimi. |
| `cupertino_icons` | `^1.0.8` | iOS Tarzı İkonlar. |
| `flutter_lints` (Dev) | `^6.0.0` | Kod Kalitesi Kuralları. |
| `flutterfire_cli` (Dev) | `^1.4.1` | Firebase Yapılandırma Dosyalarını Üreten Araç; Uygulamanın İçine Girmez. |

- **Global Kurulum** (`dart pub global activate flutterfire_cli`): `~/.pub-cache`'e Kurulur, `~/.pub-cache/bin` PATH'e Eklenmeli, Komut `flutterfire`.
- **Proje Bazlı Kurulum** (`flutter pub add --dev flutterfire_cli`): Sürüm `pubspec.lock`'a Sabitlenir, Komut `dart run flutterfire_cli:flutterfire`. **Bu Projede Bu Yol Kullanılıyor.**
- Kurulu Paketler: `dart pub global list` (Global), `flutter pub deps --style=compact` (Proje), `npm list -g --depth=0` (npm).
- `assets:` Bölümü Yorum Satırında; `lib/images/` Görselleri Kodda Kullanılmıyor.

## 4. `lib/models/student.dart` — Veri Modeli

`class Student`: `id`, `nameSurname`, `email`, `projectName` (`String`), `point` (`int`), `registrationDate` (`DateTime`).
Hepsi `final` (**Immutable**); Constructor `required` İsimli Parametreler Alır. `updateDate` Model'de Yok.

**`factory Student.fromFireStore(DocumentSnapshot snapshot)`** → Firestore Dokümanını `Student`'a Çevirir:

| Satır | Ne Yapar? |
|---|---|
| `snapshot.data() as Map<String, dynamic>? ?? {}` | Veriyi Map Olarak Alır; Boşsa Boş Map. |
| `id: snapshot.id` | Id Verinin İçinde Değil, Dokümanın Kendisinde Durur. |
| `data['email'] as String? ?? ''` | Alan Yoksa Boş String; Uygulama Çökmez. |
| `(data['point'] as num?)?.toInt() ?? 0` | `num` Okur, `int`'e Çevirir (int64 ve double İkisi de Çalışır). |
| `(data['registrationDate'] as Timestamp?)?.toDate() ?? DateTime.now()` | `Timestamp` → `DateTime`. |

> **Neden `factory`?** Önce Veriyi İşleyip Sonra `return Student(...)` ile Nesne Döndürebilir.
> `serverTimestamp()` ile Yazılan Kayıt Sunucu Onaylayana Kadar Yerelde `null` Görünür; O An `?? DateTime.now()` Devreye Girer.

## 5. `lib/services/firestore_student_service.dart` — Veritabanı Katmanı

`_studenCollection = FirebaseFirestore.instance.collection('students')` → Private (`_`) Collection Referansı; `instance` Singleton'dır.

| Metot | Dönüş | CRUD | Ne Yapar? |
|---|---|---|---|
| `addStudent({student})` | `Future<String>` | Create | `.add()` ile Otomatik Id'li Doküman Ekler, Id'yi Döndürür. |
| `saveStudentWithId({student})` | `Future<void>` | Create/Update | `.doc(id).set(..., SetOptions(merge: true))`. *(Kullanılmıyor.)* |
| `getStudents()` | `Future<List<Student>>` | Read | `orderBy('point', descending: true).get()` ile Bir Kez Çeker. |
| `watchStudents()` | `Stream<List<Student>>` | Read | `.snapshots()` ile Canlı Dinler. |
| `pointUpdate({id, newPoint})` | `Future<void>` | Update | `.update()` ile Puanı ve `updateDate`'i Yazar. |
| `deleteStudent({id})` | `Future<void>` | Delete | `.delete()` ile Dokümanı Siler. |

- **`addStudent`:** Tarih için `FieldValue.serverTimestamp()` Yazılır (Cihaz Saati Yanlış Olabilir); `catch` İçindeki `rethrow` Hatayı Ekrana İletir.
- **`set` + `merge` vs `update`:** `set` Doküman Yoksa Oluşturur; `update` Doküman Yoksa Hata Verir. `saveStudentWithId` Her Çağrıda `registrationDate`'i de Yeniden Yazar.
- **`getStudents`:** Hata Olursa Boş Liste Döner (Hata Yutulur); Ekran "Hata" ile "Öğrenci Yok"u Ayırt Edemez.
- **`watchStudents`:** `.map((s) => s.docs.map(Student.fromFireStore).toList())` → `Student.fromFireStore` **Tear-Off** Kullanımıdır.
- `pointUpdate` ve `deleteStudent`'ta `try/catch` Yok; Hata Doğrudan Ekrana Ulaşır.

> `orderBy('point')` Kullanan Sorgular, `point` Alanı **Olmayan** Dokümanları Sonuçlara Dahil Etmez.

## 6. `lib/main.dart` ve `lib/firebase_options.dart`

### 6.1 `void main() async`

1. `WidgetsFlutterBinding.ensureInitialized()` → `runApp`'ten Önce Native Kod Çağrılacağı için Flutter Motorunu Hazırlar.
2. `await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)` → Firebase'i Platformun Ayarlarıyla Başlatır.
3. `runApp(const FirebaseApp())` → Kök Widget'ı Çizer.

> **Boş Beyaz Ekran Sorunu:** `initializeApp` Hata Fırlatırsa `runApp` Hiç Çalışmaz, Sadece Beyaz LaunchScreen Kalır ve Terminalde
> `[core/not-initialized] Firebase has not been correctly initialized.` Görülür. Sebep: Yapılandırma Dosyaları Yoktu (Çözüm: 12. Bölüm).

### 6.2 `FirebaseApp` (Kök Widget) → `MaterialApp`

| Özellik | Değer | Anlamı |
|---|---|---|
| `debugShowCheckedModeBanner` | `false` | "DEBUG" Etiketini Gizler. |
| `title` | `'Firebase'` | Android'de Son Uygulamalar Listesindeki Ad (iOS'ta Ad `Info.plist`'ten Gelir). |
| `theme` | `ColorScheme.fromSeed(deepOrange)`, `useMaterial3: true` | Tek Renkten Palet Üretir, Material 3'ü Açar. |
| `home` | `FirestoreManagementScreen()` | Açılış Sayfası (Bkz. 7. Bölüm). |

### 6.3 `FirebaseHomePage` (Açılışta Kullanılmıyor)

`FutureBuilder` ile Öğrencileri **Tek Seferlik** Listeler: Bekleniyorsa Çark, Boşsa "No students found.", Doluysa `ListView.builder` + `ListTile`.
Canlı Değildir ve `future:` `build` İçinde Yazıldığı için Her Rebuild'de Yeni Sorgu Atar. Future/Stream Farkını Görmek için Örnek Olarak
Duruyor; Denemek için `home:` Değerini Geçici Olarak `const FirebaseHomePage()` Yap.

### 6.4 `firebase_options.dart` (FlutterFire CLI Üretir, **Elle Düzenlenmez**)

- `DefaultFirebaseOptions.currentPlatform` → `defaultTargetPlatform`'a Bakıp `android` veya `ios` Ayarını Döndürür.
- Ayarlar: `apiKey`, `appId`, `messagingSenderId`, `projectId: 'so-3-kasim'`, `storageBucket`; iOS'ta Ek Olarak `iosBundleId`.
- Kayıtlı Uygulamalar: Android `com.example.u_3_kasim`, iOS `com.example.3Kasim`. Web/macOS/Windows/Linux'ta `UnsupportedError`.
- `apiKey` Tek Başına Gizli Şifre Değildir, Ama GitHub Uyardığı için (*) İşaretli Dosyalar **`.gitignore`'da**; Klonlayan Kişi `configure` ile Üretir.

## 7. `lib/screens/firestore_management_screen.dart` — Canlı Yönetim Ekranı

Uygulamanın **Açılış Ekranı**. Üstte Ekleme Formu, Altta Canlı Liste. Ekran Görüntüleri: `docs/screenshots/01-management.png`, `02-update.png`, `03-delete.png`.

### 7.1 State Field'ları ve `_validatePoint`

| Field | Görevi |
|---|---|
| `_firestoreStudentService` | Service Nesnesi. |
| `late final _studentsStream` | **Bir Kez** Oluşturulan Canlı Stream. |
| `_formKey` (`GlobalKey<FormState>`) | Formu Doğrulamak / Sıfırlamak. |
| 4 × `TextEditingController` | Alanların Metnini Okumak / Temizlemek; `dispose()`'da Serbest Bırakılır. |
| `_isSaving` | Kayıt Sürerken Butonu Kilitlemek. |

> **Neden `late final` Stream?** `build()` Defalarca Çalışır; Stream Orada Oluşturulsaydı Her Seferinde Yeni Abonelik Açılır, Liste Titrerdi.

- `_validatePoint` (Sınıf Dışında): `int.tryParse` ile Çevirir; `null`, `< 0`, `> 100` İse Hata, Geçerliyse `null`. Form ve Dialog Ortak Kullanır.

### 7.2 Metotlar

**`_newStudentSave()`**
1. `validate()` Başarısızsa Çıkar → `setState(() => _isSaving = true)`.
2. `addStudent(student: Student(id: '', ...))` (Id'yi Firestore Üretir).
3. `if (!mounted) return;` → Form `reset()`, Controller'lar `clear()`, Klavye Kapanır, "Student saved." Gösterilir.
4. `catch` → Hata SnackBar'ı; `finally` → `_isSaving = false`.

- **`_deleteStudent(student)`** → `Future<bool>`: Başarılıysa `true` (Satır Kalkar), Hatada `false` (Satır Geri Gelir).
- **`_pointUpdateDialog(student)`** → `showDialog<int>` ile Yeni Puanı Bekler; İptal (`null`) veya Aynı Puansa Yazmaz, Değilse `pointUpdate`.
- **`_pointColor(point)`** → 80–100 Yeşil, 51–79 Turuncu, 0–50 Kırmızı. **`_showMessage`** → SnackBar Gösterir.

> **`mounted` Neden Önemli?** `await` Sırasında Ekran Kapanmış Olabilir; Kapanmış Ekranda `context` / `setState` Kullanmak Hata Verir.

### 7.3 `build()` ve Widget'lar

- `AppBar` ("Live Firestore Management Screen", `Colors.amber.shade600`) + `CustomScrollView` (`keyboardDismissBehavior: onDrag`).
- Sliver'lar: `SliverToBoxAdapter(_buildForm())`, `Divider`, `StreamBuilder` → Hata: "Cloud Error: ...", Veri Yok: Çark,
  Boş: "No Students Found In Cloud.", Dolu: `SliverList.builder` (Boş Durumlarda `SliverFillRemaining(hasScrollBody: false)`).

> **Neden Sliver?** `Column` İçinde `ListView` Yükseklik Hatası Verir; `CustomScrollView` ile Form ve Liste Aynı Kaydırma Alanını Paylaşır.

**`_buildForm()`** → 4 `TextFormField` + Buton:

| Alan | İkon | Klavye | Doğrulama |
|---|---|---|---|
| Name Surname | `person` | Varsayılan | Boş Olamaz |
| Email | `email` | `emailAddress` | `RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')` (`ali@mail.com` ✓, `ali@mail` ✗) |
| Project Name | `work` | Varsayılan | Boş Olamaz |
| Point (0-100) | `grade` | `number` | `_validatePoint` |

- Buton: `onPressed: _isSaving ? null : _newStudentSave` (`null` → Devre Dışı); Kayıtta Çark + "Saving...", Değilse "Save Cloud.".

**`_buildStudentTile(student)`**
- `Dismissible`: `key: ValueKey(student.id)`, Sadece Sağdan Sola, Kırmızı Arka Plan + Çöp İkonu, `confirmDismiss` Silme Bitene Kadar Bekler.
- `ListTile`: Solda Renkli `CircleAvatar` (Puan), Kalın Ad Soyad, `'email - Project: projectName'`, Sağda `edit` Butonu.

**`_PointUpdateDialog`** (Ayrı StatefulWidget, Çünkü Kendi Controller'ı Var ve `dispose` Edilmeli)
- `late final _controller` Mevcut Puanla Başlar (`widget`'a Field Tanımında Erişilemez). `_submit()` → `Navigator.pop(context, yeniPuan)`; "Cancel" → `null`.

## 8. `test/widget_test.dart`

Tek Test: `expect(const FirebaseApp(), isA<StatelessWidget>())`. `pumpWidget` Kullanılmaz, Çünkü Testte Gerçek Firebase Başlatılamaz. Çalıştır: `flutter test`.

## 9. Veri Akışları

```text
Ekleme:  "Save Cloud." → _newStudentSave() → validate() ✓ → addStudent() → students.add()
         → watchStudents() Yeni Listeyi Yayar → StreamBuilder Ekranı Yeniler → "Student saved."
Güncelle: Edit → showDialog<int> → "Update" → pop(context, 85) → pointUpdate(id, 85) → doc(id).update()
         → Stream Yeni Sıralı Listeyi Yayar
Silme:   Sağdan Sola Kaydır → confirmDismiss → deleteStudent(id) → doc(id).delete()
         → true: Satır Kaybolur + SnackBar | false: Satır Geri Gelir + Hata SnackBar
```

## 10. Dart Söz Dizimi

| Söz Dizimi | Örnek | Anlamı |
|---|---|---|
| `?` / `??` / `?.` | `String?`, `x ?? ''`, `value?.trim()` | Nullable Tip / `null` İse Sağı Kullan / `null` Değilse Çağır |
| `!` | `currentState!` | "Kesinlikle `null` Değil" Garantisi |
| `late` / `const` | `late final`, `const Text(...)` | İlk Kullanımda Başlat / Derleme Zamanı Sabiti |
| `factory` / Tear-Off | `Student.fromFireStore`, `map(Student.fromFireStore)` | Nesne Döndüren Constructor / Fonksiyonu Referans Olarak Geçme |
| `_` Ön Eki / `rethrow` | `_formKey`, `catch { rethrow; }` | Dosyaya Özel (Private) / Yakalanan Hatayı Tekrar Fırlat |

## 11. Bilinen Eksikler

1. ~~Açılış Ekranı `FirebaseHomePage`'di; Firebase Yapılandırması Yoktu.~~ **Çözüldü:** `FirestoreManagementScreen` + `flutterfire configure`.
2. **Kullanılmayan Metot:** `saveStudentWithId` Hiçbir Yerde Çağrılmıyor.
3. **Yazım Hatası:** `_studenCollection` → `_studentCollection` Olmalı.
4. **Hata Yutma / Tekrarlanan Sorgu:** `FirebaseHomePage` Hataları Gösteremez ve Her Rebuild'de Yeni Sorgu Atar.
5. **Gösterilmeyen Alanlar:** `registrationDate` ve `updateDate` Ekranda Yok; `updateDate` Model'de de Yok.
6. **Test Mode Süresi:** Kural **30 Gün** Sonra Tüm İstekleri Reddeder (`permission-denied`); Firestore → Rules'tan Tarihi Uzat.
   Auth Olmadığı için Bu Sürede Veritabanı Herkese Açık; Gerçek Kişisel Veri Girme.
7. **Silme Geri Alınamaz:** Kaydırarak Silmede Onay Penceresi Yok.
8. **Platform Desteği:** Sadece Android ve iOS Yapılandırıldı; Web/macOS'ta `UnsupportedError`.

## 12. Kurulum ve Çalıştırma

```bash
node -v                                             # 1. Node.js Kurulu mu? (npm için)
npm install -g firebase-tools                       # 2. Firebase CLI
firebase login                                      # 3. Google ile Giriş (Gemini / Kullanım Verisi Soruları İsteğe Bağlı)
firebase projects:list                              #    Girişi Doğrula
gem install xcodeproj                               # 4. FlutterFire'ın iOS Projesini Düzenlemesi için
flutter pub get                                     # 5. Paketler (flutterfire_cli Dahil)
dart run flutterfire_cli:flutterfire configure      # 6. Projeyi Seç, android + ios; Sonra lib/firebase_options.dart'ı Kontrol Et
flutter clean && flutter pub get                    # 7. Native Dosyalar Değişti; Hot Reload Yetmez
flutter run                                         # 8. Çalıştır (flutter test ile Testler)
```

**Firebase Console → Firestore Database → Create Database:**
- **Standard Edition**, Database ID **`(default)`** (`FirebaseFirestore.instance` Sadece Buna Bağlanır), Yakın Bir **Location** (Sonradan Değişmez).
- **Start in Test Mode** (Production'daki `allow read, write: if false;` Tüm İstekleri Reddeder).
- **Scheduled Backups** Ücretli Blaze Planı İster; Boş Bırakıp **Create**. Ücretsiz Spark Planı Yeterli.
- **+ Start Collection** → `students` → **Auto-ID** → `nameSurname`, `email`, `projectName`: string; `point`: **int64** ("number" Yok); `registrationDate`: timestamp.

### 12.1 Sık Karşılaşılan Hatalar

| Hata | Sebep | Çözüm |
|---|---|---|
| Boş Beyaz Ekran / `[core/not-initialized]` | Yapılandırma Dosyaları Yok | `configure` Çalıştır, `options:` Ekle. |
| `zsh: command not found: flutterfire` | PATH'te Yok veya Proje Bazlı Kurulu | `dart run flutterfire_cli:flutterfire ...` veya `~/.pub-cache/bin`'i PATH'e Ekle. |
| `project_id contains invalid characters` | ID Rakamla Başlıyor (`3-kasim`) | Harfle Başlat (`so-3-kasim`); Ayrıntı `firebase-debug.log`'da (`.gitignore`'da). |
| `cannot load such file -- xcodeproj` | Ruby Paketi Eksik | `gem install xcodeproj`, `configure`'ı Tekrarla. |
| `Target of URI doesn't exist: 'firebase_options.dart'` | `configure` Yarıda Kaldı | Tekrar Çalıştır, Mevcut Projeyi Seç. |
| `permission-denied` / Liste Hep Boş | Production Kuralı veya Test Süresi Doldu | Firestore → Rules'u Düzenle. |
| Console'da Var, Listede Yok | `point` Eksik veya Alan Adı Yanlış (Büyük/Küçük Harf) | Alanı Düzelt; `orderBy('point')` Getirmez. |

## 13. Kendini Test Et

1. `watchStudents()` Neden `Stream`? → Veritabanı Her Değiştiğinde Yeni Liste Yaymalı.
2. `_studentsStream` Neden `late final`? → Her `build`'de Yeni Abonelik Açılmasın.
3. `set` + `merge` ile `update()` Farkı? → `set` Yoksa Oluşturur; `update` Yoksa Hata Verir.
4. `confirmDismiss` `false` Döndürürse? → Satır Kaldırılmaz, Geri Döner.
5. `Navigator.pop(context, value)` Nerede Karşılanır? → `final newPoint = await showDialog<int>(...)`.
6. Firebase Yapılandırılmadan Neden Beyaz Ekran? → `initializeApp` Hata Fırlatır, `runApp` Çağrılmaz.
7. Database ID Neden `(default)`? → `FirebaseFirestore.instance` Sadece `(default)`'a Bağlanır.