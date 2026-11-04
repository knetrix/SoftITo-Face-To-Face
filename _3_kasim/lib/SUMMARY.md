# _3_kasim — Proje Özeti

Bu Proje, **Flutter** ile Yazılmış ve **Firebase Cloud Firestore** Kullanan Basit Bir **Öğrenci Yönetim** Uygulamasıdır.
Öğrenciler (Ad Soyad, Email, Proje Adı, Puan) Bulutta (Firestore) Saklanır; Uygulama Bu Verileri Listeler, Ekler, Günceller ve Siler.

> Bu Doküman, Flutter'a Yeni Başlayan Birinin Projeyi Baştan Sona Anlayabilmesi için **Okuma Sırasına Göre** Yazılmıştır.
> Önerilen Okuma Sırası: `pubspec.yaml` → `student.dart` → `firestore_student_service.dart` → `main.dart` → `firestore_management_screen.dart` → `widget_test.dart`.

## 1. Temel Kavramlar (Önce Bunları Bil)

| Kavram | Kısa Açıklama |
|---|---|
| **Widget** | Flutter'da Ekrandaki Her Şey (Yazı, Buton, Sayfa) Bir Widget'tır. |
| **StatelessWidget** | İçinde Değişen Veri Tutmayan Widget. |
| **StatefulWidget** | İçinde Değişen Veri (State) Tutan Widget. Değişiklik `setState()` ile Ekrana Yansır. |
| **State** | StatefulWidget'ın Değişken Verisini ve `build()` Metodunu Taşıyan Ayrı Sınıf. |
| **build()** | Widget'ın Ekranda Nasıl Görüneceğini Döndüren Metot. |
| **BuildContext** | Widget'ın Ağaçtaki Konumu. `Navigator`, `ScaffoldMessenger` Gibi Üst Widget'lara Ulaşmak için Kullanılır. |
| **Future** | İleride Bir Kez Gelecek Sonuç (Ör: İnternetten Tek Seferlik Veri). `async/await` ile Beklenir. |
| **Stream** | Zamanla Sürekli Yeni Değerler Yayan Veri Akışı (Ör: Canlı Veritabanı). |
| **Firestore** | Google'ın Bulut NoSQL Veritabanı. Veriler **Collection → Document → Field** Yapısında Tutulur. |
| **CRUD** | Create (Ekle), Read (Oku), Update (Güncelle), Delete (Sil) İşlemlerinin Kısaltması. |

### 1.1 Firestore Veri Yapısı

```text
students (Collection)
 └── <Otomatik Id> (Document)
      ├── nameSurname      : String
      ├── email            : String
      ├── projectName      : String
      ├── point            : int
      ├── registrationDate : Timestamp
      └── updateDate       : Timestamp (Güncellemede Eklenir)
```

- Firestore'da **Şema Yoktur**: Bir Document'ta Olan Alan Diğerinde Olmayabilir. Bu Yüzden Model'de `??` ile Varsayılan Değer Verilir.

### 1.2 Klasik SQL ve Firestore Karşılaştırması (`images/1.png`)

| Kavram | Klasik SQL | Firestore (NoSQL) | Mobil Dünyadaki Karşılığı |
|---|---|---|---|
| Veriler | Tablo (Table) | Koleksiyon (Collection) | `kullanicilar`, `siparisler`, `mesajlar` |
| Tek Veri | Satır (Row) | Doküman (Document) | Tek Bir Kullanıcının JSON Nesnesi |
| Veri Alanı | Sütun (Column) | Alan (Field) | `ad: "Ahmet"`, `bakiye: 450.50` |
| İlişkiler | `JOIN`, `FOREIGN KEY` | Alt Koleksiyon (Subcollection) veya Gömülü Veri (Map) | `kullanicilar/USER12/siparisler/ORD99` |
| Sorgu Hızı | Tablo Büyüdükçe Yavaşlar: O(N), İndeksle O(log N) | Veritabanı Büyüklüğünden Bağımsız; Sadece Çekilen Sonuç Sayısına Bağlı | Milyonlarca Kayıt Olsa da 20 Kayıt ~15 ms'de Çekilebilir |
| Veri Sınırı | Disk Kapasitesi Kadar | Tek Bir Doküman En Fazla 1 MB | Dokümana Büyük İkili (Binary) Dosyalar Konmaz |

> **Bu Projede:** `students` = Tablo, Her Öğrenci = Satır, `nameSurname` / `point` Gibi Alanlar = Sütun.

### 1.3 Örnek Doküman Yapısı ve Veri Tipleri (`images/2.png`)

```text
kullanicilar (Koleksiyon / Klasör)
 └── fuat_01 (Doküman / JSON, En Fazla 1 MB)
      ├── ad          : "Fuat Fahri Furkan"                      (String)
      ├── bakiye      : 100000.75                                (Number)
      ├── aktifMi     : true                                     (Boolean)
      ├── roller      : ["ogrenci", "mentor"]                    (Array)
      ├── adres       : {sehir: "Çanakkale", ilce: "Bozcaada"}   (Map)
      ├── kayitTarihi : Timestamp                                (serverTimestamp)
      └── siparisler (Alt Koleksiyon / Subcollection)
           └── sip_99asda33qr34 (Doküman)
                ├── urun  : "Macbook Pro M6 32 GB Ram 2 TB SSD"
                └── tutar : 50000.00
```

- **Yol (Path) Mantığı:** Koleksiyon / Doküman / Koleksiyon / Doküman → `kullanicilar/fuat_01/siparisler/sip_99asda33qr34`.
- Alt Koleksiyon, Üst Dokümanın 1 MB Sınırına Dahil Değildir ve Üst Doküman Okunduğunda Otomatik Gelmez.
- **Bu Projede** Sadece String, Number (`point`) ve Timestamp Kullanılıyor; Boolean, Array, Map ve Alt Koleksiyon Kullanılmıyor.

### 1.4 Future ve Stream Karşılaştırması

| Özellik | Future | Stream |
|---|---|---|
| Kaç Değer Döner? | Bir Kez | Sıfır veya Daha Fazla, Sürekli |
| Benzetme | Fotoğraf Çekmek | Canlı Yayın |
| UI'da Kullanımı | `FutureBuilder` | `StreamBuilder` |
| Bu Projede | `getStudents()` | `watchStudents()` |

## 2. Klasör Yapısı ve Mimari

```text
_3_kasim/
├── pubspec.yaml                 → Proje Ayarları ve Paketler
├── analysis_options.yaml        → Lint (Kod Kalitesi) Ayarları
├── lib/
│   ├── main.dart                → Uygulamanın Başlangıç Noktası
│   ├── models/student.dart      → Öğrenci Veri Modeli
│   ├── services/firestore_student_service.dart → Firestore İşlemleri (CRUD)
│   ├── screens/firestore_management_screen.dart → Canlı Yönetim Ekranı
│   ├── images/1.png, 2.png      → Ders Notu Görselleri (Bkz. 1.2 ve 1.3)
│   └── SUMMARY.md               → Bu Doküman
├── test/widget_test.dart        → Basit Birim Testi
└── android/, ios/, ...          → Platforma Özel Dosyalar (Flutter Otomatik Üretir)
```

### 2.1 Katmanlı Mimari: **Model → Service → Screen (UI)**

```text
Screen (UI)  → Kullanıcıyı Dinler, Sonucu Ekrana Çizer   (main.dart, firestore_management_screen.dart)
   │ Çağırır
Service      → Firestore ile Konuşur                     (firestore_student_service.dart)
   │ Student Nesnesi Üretir / Kullanır
Model        → Verinin Şekli                             (student.dart)
```

- UI, Veritabanıyla **Doğrudan Konuşmaz**; Her Zaman Service Üzerinden Konuşur.
- Faydası: Yarın Firestore Yerine Başka Bir Veritabanı Kullanılırsa Sadece Service Değişir, Ekranlar Aynı Kalır.

## 3. `pubspec.yaml` — Proje Kimliği ve Paketler

- `name: _3_kasim` → Paketin Adı (Import'larda `package:_3_kasim/...` Olarak Geçer).
- `publish_to: 'none'` → Paketin Yanlışlıkla pub.dev'e Yüklenmesini Engeller.
- `version: 1.0.0+1` → `1.0.0` Görünen Sürüm, `+1` Build Numarasıdır.
- `sdk: ^3.13.5` → Kullanılan Dart Sürümü (`^` = Bu Sürüm ve Uyumlu Üst Sürümler).

| Paket | Sürüm | Görevi |
|---|---|---|
| `firebase_core` | `^5.1.0` | Firebase'i Uygulamada Başlatmak için Zorunlu Temel Paket. |
| `cloud_firestore` | `^7.1.0` | Firestore Veritabanına Erişim Paketi. |
| `cupertino_icons` | `^1.0.8` | iOS Tarzı İkonlar. |
| `flutter_test` | SDK | Test Yazmak için (Dev). |
| `flutter_lints` | `^6.0.0` | Kod Kalitesi Kuralları (Dev). |

- `uses-material-design: true` → `Icons.person` Gibi Material İkonlarının Kullanılabilmesini Sağlar.
- `assets:` Bölümü Yorum Satırında; Yani Henüz Hiçbir Görsel Tanımlı Değil.

Paket Eklemek için: `flutter pub add firebase_core cloud_firestore` (`main.dart`'ın İlk Satırında da Not Olarak Yazılı).

## 4. `lib/models/student.dart` — Veri Modeli

Uygulamadaki "Öğrenci" Kavramını Temsil Eden Sınıftır. Önce Model Okunur, Çünkü Diğer Tüm Dosyalar Bunu Kullanır.

### 4.1 `class Student`

| Field | Tip | Açıklama |
|---|---|---|
| `id` | `String` | Firestore Document Id'si. |
| `nameSurname` | `String` | Ad Soyad. |
| `email` | `String` | Email Adresi. |
| `projectName` | `String` | Proje Adı. |
| `point` | `int` | Puan (0–100). |
| `registrationDate` | `DateTime` | Kayıt Tarihi. |

- Hepsi `final` → Nesne Oluşturulduktan Sonra Değiştirilemez (**Immutable**).
- `updateDate` Alanı Firestore'da Olsa da Model'de **Yoktur**; Yani Uygulama Bu Alanı Okumaz.

### 4.2 `const Student({required ...})`

Named (İsimli) ve Zorunlu Parametreli Constructor. Örnek: `Student(id: '', nameSurname: 'Ali', ..., point: 90, ...)`

- `required` → Bu Parametre Verilmezse Kod Derlenmez.

### 4.3 `factory Student.fromFireStore(DocumentSnapshot snapshot)`

Firestore'dan Gelen Ham Dokümanı `Student` Nesnesine Çevirir.

| Satır | Ne Yapar? |
|---|---|
| `snapshot.data() as Map<String, dynamic>? ?? {}` | Doküman Verisini Map Olarak Alır; Boşsa Boş Map Kullanır. |
| `id: snapshot.id` | Id, Verinin İçinde Değil, Dokümanın Kendisinde Durur. |
| `data['email'] as String? ?? ''` | Alan Yoksa Boş String Verir; Uygulama Çökmez. |
| `(data['point'] as num?)?.toInt() ?? 0` | `num` Olarak Okur, `int`'e Çevirir (Firestore Sayıları `double` da Gelebilir). |
| `(data['registrationDate'] as Timestamp?)?.toDate() ?? DateTime.now()` | Firestore `Timestamp`'ini Dart `DateTime`'a Çevirir. |

> **Neden `factory`?** Normal Constructor Gövdesinde Hesaplama Yapıp Farklı Bir Nesne Döndüremez.
> `factory` İse Önce Veriyi İşleyip Sonra `return Student(...)` ile Nesne Döndürebilir.

> **İpucu:** `serverTimestamp()` ile Yazılan Bir Kayıt, Sunucu Onaylayana Kadar Yerelde `null` Görünebilir.
> Bu Durumda `?? DateTime.now()` Devreye Girer; Bu Yüzden Bu Varsayılan Değer Önemlidir.

## 5. `lib/services/firestore_student_service.dart` — Veritabanı Katmanı

Firestore ile İlgili **Tüm** İşlemler Burada Toplanır (CRUD).

### 5.1 `class FirestoreStudentService`

- **`_studenCollection`**: `FirebaseFirestore.instance.collection('students')` → `students` Collection'ına Referans.
  - Başındaki `_` Onu **Private** Yapar (Sadece Bu Dosyadan Erişilir).
  - `FirebaseFirestore.instance` → Uygulama Genelinde Tek Olan (Singleton) Firestore Nesnesi.

### 5.2 Metotlar

| Metot | Dönüş | CRUD | Ne Yapar? |
|---|---|---|---|
| `addStudent({student})` | `Future<String>` | Create | Yeni Doküman Ekler, Id'yi Döndürür. |
| `saveStudentWithId({student})` | `Future<void>` | Create/Update | Belirli Id'ye Yazar (Merge). *(Kullanılmıyor.)* |
| `getStudents()` | `Future<List<Student>>` | Read | Listeyi **Bir Kez** Çeker. |
| `watchStudents()` | `Stream<List<Student>>` | Read | Listeyi **Canlı** Dinler. |
| `pointUpdate({id, newPoint})` | `Future<void>` | Update | Sadece Puanı Günceller. |
| `deleteStudent({id})` | `Future<void>` | Delete | Dokümanı Siler. |

### 5.3 `addStudent`

- `_studenCollection.add({...})` → Firestore **Otomatik Id** Üretir; `docRef.id` Geri Döndürülür.
- `registrationDate` için `student.registrationDate` Değil, `FieldValue.serverTimestamp()` Yazılır.
  Böylece Kullanıcının Telefon Saati Yanlış Olsa Bile Doğru (Sunucu) Saati Kaydedilir.
- `try/catch` → Hata `debugPrint` ile Konsola Yazılır ve `rethrow` ile **Çağırana İletilir**.
  Böylece Ekran Hatayı Yakalayıp Kullanıcıya SnackBar Gösterebilir.

### 5.4 `saveStudentWithId`

- `.doc(student.id).set(data, SetOptions(merge: true))`
- `set()` → Doküman Yoksa Oluşturur, Varsa Üzerine Yazar.
- `merge: true` → Sadece Gönderilen Alanları Değiştirir, Diğer Alanları Silmez.
- **Dikkat:** Her Çağrıda `registrationDate` da Yeniden Yazılır; Yani Kayıt Tarihi Değişir.

### 5.5 `getStudents`

- `.orderBy('point', descending: true).get()` → Puana Göre **Büyükten Küçüğe** Sıralı, Tek Seferlik Sorgu.
- `snapshot.docs.map((doc) => Student.fromFireStore(doc)).toList()` → Her Dokümanı `Student`'a Çevirir.
- Hata Olursa **Boş Liste** Döner (Hata Yutulur). Bu Yüzden Ekran "Hata" ile "Hiç Öğrenci Yok" Durumunu Ayırt Edemez.

### 5.6 `watchStudents`

```dart
return _studenCollection
    .orderBy('point', descending: true)
    .snapshots()
    .map((snapshot) => snapshot.docs.map(Student.fromFireStore).toList());
```

- `.snapshots()` → Veritabanı Her Değiştiğinde Yeni `QuerySnapshot` Yayar.
- `.map(...)` → Stream'deki Her Değeri `List<Student>`'a Dönüştürür.
- `map(Student.fromFireStore)` → **Tear-Off** Kullanımı: `(doc) => Student.fromFireStore(doc)` Yazmanın Kısa Hali.

### 5.7 `pointUpdate` ve `deleteStudent`

- `.update({...})` → Sadece Verilen Alanları Değiştirir. Doküman **Yoksa Hata Fırlatır** (`set`'ten Farkı).
- `pointUpdate` Aynı Zamanda `updateDate` Alanını Sunucu Saatiyle Ekler.
- `.delete()` → Dokümanı Tamamen Siler. Bu Metotlarda `try/catch` Yoktur; Hata Doğrudan Ekrana Ulaşır.

> **Not:** `orderBy('point')` Kullanan Sorgular, `point` Alanı **Olmayan** Dokümanları Sonuçlara Dahil Etmez.

## 6. `lib/main.dart` — Uygulamanın Giriş Noktası

### 6.1 `void main() async`

Her Flutter Uygulaması Buradan Başlar.

1. `WidgetsFlutterBinding.ensureInitialized()` → `runApp`'ten Önce Native (Android/iOS) Kod Çağrılacağı için Flutter Motorunu Hazırlar.
2. `await Firebase.initializeApp()` → Firebase Bağlantısını Kurar; Bitmeden Uygulama Açılmaz.
3. `runApp(const FirebaseApp())` → Kök Widget'ı Ekrana Çizer.

### 6.2 `class FirebaseApp extends StatelessWidget`

Uygulamanın Kök Widget'ı. `MaterialApp` Döndürür:

| Özellik | Değer | Anlamı |
|---|---|---|
| `debugShowCheckedModeBanner` | `false` | Sağ Üstteki "DEBUG" Etiketini Gizler. |
| `title` | `'Firebase'` | Görev Yöneticisinde Görünen Uygulama Adı. |
| `theme` | `ColorScheme.fromSeed(deepOrange)` | Tek Bir Renkten Tüm Renk Paletini Üretir. |
| `useMaterial3` | `true` | Material 3 Tasarım Dilini Açar. |
| `home` | `FirebaseHomePage()` | Açılış Sayfası. |

### 6.3 `class FirebaseHomePage extends StatelessWidget`

Öğrencileri **Tek Seferlik** Listeleyen Sayfa. `Scaffold` (AppBar + Body) İçinde `FutureBuilder<List<Student>>` Kullanır:

| Durum | Kontrol | Ekranda |
|---|---|---|
| Bekleniyor | `connectionState != done` | `CircularProgressIndicator` |
| Liste Boş | `students.isEmpty` | "No students found." |
| Veri Var | — | `ListView.builder` + `ListTile` |

- Her `ListTile`: `title` = Ad Soyad, `subtitle` = Email - Proje, `trailing` = Puan.

> **Not 1:** Bu Sayfa Canlı Değildir; Veritabanı Değişirse Ekran Kendiliğinden Güncellenmez.
> **Not 2:** `future: FirestoreStudentService().getStudents()` Doğrudan `build` İçinde Yazıldığı için
> Sayfa Her Yeniden Çizildiğinde Sorgu Tekrar Atılır. Yönetim Ekranında Bu Sorun `late final` ile Çözülmüştür.

## 7. `lib/screens/firestore_management_screen.dart` — Canlı Yönetim Ekranı

Projenin En Kapsamlı Dosyası. Üstte Öğrenci Ekleme Formu (`_buildForm`), Altta Canlı Öğrenci Listesi (`StreamBuilder` + `_buildStudentTile`) Bulunur.

### 7.1 `String? _validatePoint(String? value)` (Üst Seviye Fonksiyon)

- `int.tryParse(value?.trim() ?? '')` → Metni Sayıya Çevirmeyi Dener; Olmazsa `null` Verir (Çökmez).
- Puan `null`, `< 0` veya `> 100` İse → `'Point must be between 0 and 100.'`
- Geçerliyse → `null` (Flutter'da Validator'ın `null` Döndürmesi "Hata Yok" Demektir).
- Sınıfın Dışında Tanımlandığı için Hem Ana Formda Hem de Güncelleme Dialog'unda **Tekrar Kullanılır**.

### 7.2 `class FirestoreManagementScreen extends StatefulWidget`

Sadece `createState()` ile State Sınıfını Oluşturur. Asıl İş State Sınıfındadır.

### 7.3 `class _FirestoreManagementScreenState` — Field'lar

| Field | Tip | Görevi |
|---|---|---|
| `_firestoreStudentService` | `FirestoreStudentService` | Service Nesnesi. |
| `_studentsStream` | `late final Stream<List<Student>>` | **Bir Kez** Oluşturulan Canlı Stream. |
| `_formKey` | `GlobalKey<FormState>` | Formu Doğrulamak/Sıfırlamak için. |
| `_nameSurnameController`, `_emailController`, `_projectNameController`, `_pointController` | `TextEditingController` | Her Input Alanının Metnini Okumak/Temizlemek için. |
| `_isSaving` | `bool` | Kaydetme Sürüyor mu? (Butonu Kilitlemek için). |

> **Neden `late final` Stream?** `build()` Defalarca Çalışabilir. Stream `build` İçinde Oluşturulsaydı
> Her Seferinde Firestore'a Yeni Abonelik Açılır, Liste Titrer ve Gereksiz Okuma Maliyeti Oluşurdu.

### 7.4 Metotlar

**`dispose()`** → Ekran Kapanınca 4 Controller'ı Serbest Bırakır (Bellek Sızıntısını Önler). En Sonda `super.dispose()` Çağrılır.

**`_showMessage(String message)`** → `ScaffoldMessenger.of(context).showSnackBar(...)` ile Ekranın Altında Kısa Bir Mesaj Gösterir.

**`_newStudentSave()`** — Adım Adım:

1. `_formKey.currentState!.validate()` → Tüm Validator'ları Çalıştırır; Biri Bile Hatalıysa Çıkar.
2. `setState(() => _isSaving = true)` → Buton Kilitlenir, Çark Döner.
3. `addStudent(student: Student(id: '', ...))` → Id Boş Verilir, Çünkü Firestore Üretecek.
4. `if (!mounted) return;` → Ekran Kapandıysa Devam Etmez.
5. Form `reset()` Edilir, 4 Controller `clear()` Edilir.
6. `FocusScope.of(context).unfocus()` → Klavye Kapanır.
7. `'Student saved.'` Mesajı Gösterilir; `catch` Bloğunda İse Hata Mesajı Gösterilir.
8. `finally` → Başarılı da Olsa Hatalı da Olsa `_isSaving = false` Yapılır.

**`_deleteStudent(Student student)`** → `Future<bool>`
- Başarılıysa `true` → `Dismissible` Satırı Listeden Kaldırır.
- Hata Varsa `false` → Satır Yerine Geri Döner.

**`_pointUpdateDialog(Student student)`**
- `showDialog<int>(...)` → Dialog Açılır ve Kapanırken Dönecek `int` Değer Beklenir.
- `newPoint == null` (İptal) veya `newPoint == student.point` (Değişmemiş) İse Gereksiz Yazma Yapılmaz.
- Aksi Halde `pointUpdate` Çağrılır ve Sonuç Mesajı Gösterilir.

**`_pointColor(int point)`** → **80–100 Yeşil**, **51–79 Turuncu**, **0–50 Kırmızı**.

> **`mounted` Neden Önemli?** `await` Sırasında Kullanıcı Ekrandan Çıkmış Olabilir.
> Kapanmış Bir Ekranda `context` veya `setState` Kullanmak Hataya Yol Açar. `if (!mounted) return;` Bunu Önler.

### 7.5 `build()`

- `Scaffold` + `AppBar` (Başlık: "Live Firestore Management Screen", Renk: `Colors.amber.shade600`).
- `CustomScrollView` + **Sliver**'lar → Form ve Liste Tek Kaydırma Alanında Birleşir.
  - `keyboardDismissBehavior: onDrag` → Listeyi Kaydırınca Klavye Kapanır.
  - `SliverToBoxAdapter(_buildForm())` → Normal Bir Widget'ı Sliver'a Çevirir.
  - `SliverToBoxAdapter(Divider(thickness: 2))` → Ayırıcı Çizgi.
  - `StreamBuilder<List<Student>>` → `_studentsStream`'i Dinler:

| Durum | Dönen Sliver | Ekranda |
|---|---|---|
| `snapshot.hasError` | `SliverFillRemaining` | "Cloud Error: ..." |
| `!snapshot.hasData` | `SliverFillRemaining` | Yükleniyor Çarkı |
| Liste Boş | `SliverFillRemaining` | "No Students Found In Cloud." |
| Liste Dolu | `SliverList.builder` | Her Öğrenci için `_buildStudentTile` |

> **Neden Sliver?** `Column` İçine `ListView` Koymak Yükseklik Hatası Verir. `CustomScrollView` ile
> Form ve Liste Aynı Kaydırma Alanını Paylaşır; Liste Uzadıkça Form da Yukarı Kayar.
> `SliverFillRemaining(hasScrollBody: false)` → Kalan Boş Alanı Doldurur ve Mesajı Ortalar.

### 7.6 `_buildForm()`

`Padding(12)` → `Form(key: _formKey)` → `Column` İçinde 4 `TextFormField` + 1 Buton:

| Alan | İkon | Klavye | Doğrulama |
|---|---|---|---|
| Name Surname | `Icons.person` | Varsayılan | Boş Olamaz |
| Email | `Icons.email` | `emailAddress` | `RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')` |
| Project Name | `Icons.work` | Varsayılan | Boş Olamaz |
| Point (0-100) | `Icons.grade` | `number` | `_validatePoint` |

- `textInputAction: next` → Klavyedeki Tuş Sonraki Alana Geçer; Son Alanda `done` Kullanılır.
- `OutlineInputBorder()` → Çerçeveli Input Görünümü; `SizedBox(height: 8)` → Alanlar Arası Boşluk.
- **Email RegExp:** `[^@\s]+` = "@ ve Boşluk Dışında En Az Bir Karakter", Ardından `@`, Domain, `\.` (Nokta) ve Uzantı.
  Örn: `ali@mail.com` ✓, `ali@mail` ✗.

**`ElevatedButton.icon`**
- Arka Plan Pembe, Yazı Beyaz, `Size.fromHeight(44)` ile Tam Genişlik.
- `onPressed: _isSaving ? null : _newStudentSave` → `null` Verilen Buton Otomatik Olarak **Devre Dışı** Olur.
- `_isSaving` İse 18x18 Beyaz Çark ve "Saving..." Yazısı; Değilse `cloud_upload` İkonu ve "Save Cloud.".

### 7.7 `_buildStudentTile(Student student)`

- **`Dismissible`** → Satırı Kaydırarak Silmeyi Sağlar.
  - `key: ValueKey(student.id)` → Flutter Hangi Satırın Silindiğini Id ile Takip Eder.
  - `direction: endToStart` → Sadece **Sağdan Sola** Kaydırma.
  - `background` → Kırmızı Arka Plan + Beyaz `delete_forever` İkonu.
  - `confirmDismiss: (_) => _deleteStudent(student)` → Silme Bitip `true` Dönene Kadar Satır Kaldırılmaz.
- **`ListTile`**
  - `leading` → Puan Rengine Göre `CircleAvatar` İçinde Kalın Beyaz Puan.
  - `title` → Kalın Ad Soyad; `subtitle` → `'email - Project: projectName'`.
  - `trailing` → `amberAccent` Renkli `edit` `IconButton` → `_pointUpdateDialog` Açar.

### 7.8 `class _PointUpdateDialog` / `_PointUpdateDialogState`

Puan Güncelleme Penceresi (`AlertDialog`). Sınıf Adı `_` ile Başladığı için Sadece Bu Dosyada Kullanılır.

- `final Student student` → Dialog'a Dışarıdan Verilen Öğrenci; `_formKey` → Dialog'un Kendi Formu.
- `late final _controller` → Mevcut Puanla Başlar; `widget`'a Field Tanımında Erişilemediği için `late` ile İlk Kullanımda Oluşturulur.
- `dispose()` → Controller'ı Serbest Bırakır.
- `_submit()` → Doğrular ve `Navigator.pop(context, yeniPuan)` ile Değeri **Çağıran Yere Geri Gönderir**.
- `build()` →
  - `title`: "Ad Soyad - Update Point"
  - `content`: `autofocus: true` Olan Sayısal `TextFormField` (`onFieldSubmitted` ile Enter'a Basınca da Kaydeder).
  - `actions`: "Cancel" (`Navigator.pop(context)` → `null` Döner) ve "Update" (`_submit`).

> **Neden Dialog Ayrı Bir StatefulWidget?** Dialog'un Kendi Controller'ı Var ve Kapanınca `dispose` Edilmeli.
> Ayrı Bir State Sınıfı Bu Yaşam Döngüsünü Kendi Başına Yönetir.

## 8. `test/widget_test.dart` — Test

- Tek Test: `expect(const FirebaseApp(), isA<StatelessWidget>())` → `FirebaseApp`'in Bir `StatelessWidget` Olduğunu Doğrular.
- `testWidgets` + `pumpWidget` Kullanılmaz, Çünkü Gerçek Firebase Testte Başlatılamaz. Çalıştırmak için: `flutter test`

## 9. Veri Akışları (Uçtan Uca)

### 9.1 Öğrenci Ekleme

```text
Kullanıcı Formu Doldurur → "Save Cloud." Basar
  → _newStudentSave()  (Screen) → validate() ✓
  → addStudent()       (Service)
  → students.add({...}) (Firestore)
  → watchStudents() Yeni Listeyi Yayar
  → StreamBuilder Ekranı Otomatik Yeniler → SnackBar: "Student saved."
```

### 9.2 Puan Güncelleme

```text
Edit İkonuna Basılır → _pointUpdateDialog(student)
  → showDialog<int> → _PointUpdateDialog Açılır
  → "Update" → Navigator.pop(context, 85)
  → newPoint Farklı mı? ✓ → pointUpdate(id, 85) → doc(id).update({...})
  → Stream Yeni Sıralı Listeyi Yayar (Öğrenci Yeni Yerine Geçer)
```

### 9.3 Öğrenci Silme

```text
Satır Sağdan Sola Kaydırılır → confirmDismiss → _deleteStudent(student)
  → deleteStudent(id) → doc(id).delete()
  → true  → Satır Kaybolur + SnackBar
  → false → Satır Geri Gelir + Hata SnackBar
```

## 10. Dart Dil Özellikleri Sözlüğü

| Söz Dizimi | Örnek | Anlamı |
|---|---|---|
| `?` (Nullable Tip) | `String?` | Değer `null` Olabilir. |
| `??` | `x ?? ''` | Sol Taraf `null` İse Sağ Tarafı Kullan. |
| `?.` | `value?.trim()` | Nesne `null` Değilse Metodu Çağır. |
| `!` | `currentState!` | "Bu Kesinlikle `null` Değil" Garantisi. |
| `late` | `late final` | İlk Kullanımda Başlatılır. |
| `const` | `const Text(...)` | Derleme Zamanı Sabiti; Performans Sağlar. |
| `factory` | `Student.fromFireStore` | Hesaplama Yapıp Nesne Döndüren Constructor. |
| `_` Ön Eki | `_formKey` | Dosyaya Özel (Private). |
| `rethrow` | `catch { rethrow; }` | Yakalanan Hatayı Tekrar Fırlat. |
| Tear-Off | `map(Student.fromFireStore)` | Fonksiyonu Çağırmadan Referans Olarak Geçme. |

## 11. Dikkat Edilmesi Gerekenler ve Bilinen Eksikler

1. **Açılış Ekranı:** `main.dart` Şu An `FirebaseHomePage`'i Açıyor. Canlı Yönetim Ekranını Görmek için
   `import 'screens/firestore_management_screen.dart';` Eklenip `home: const FirestoreManagementScreen()` Yapılmalı.
2. **Firebase Yapılandırması:** `Firebase.initializeApp()` Parametresiz Çağrıldığı için
   Android'de `android/app/google-services.json`, iOS'ta `ios/Runner/GoogleService-Info.plist` Gerekir.
   Projede Bu Dosyalar Bulunmuyor. Önerilen Yol: `flutterfire configure` ile `firebase_options.dart` Üretip
   `Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)` Kullanmak.
3. **Görseller:** `lib/images/` Altındaki Ders Notu Görselleri (Bkz. 1.2, 1.3) `pubspec.yaml`'da `assets` Olarak Tanımlı Değil ve Kodda Kullanılmıyor.
4. **Kullanılmayan Metot:** `saveStudentWithId` Tanımlı Ama Hiçbir Yerde Çağrılmıyor.
5. **Yazım Hatası:** `_studenCollection` → `_studentCollection` Olmalı.
6. **Hata Yutma:** `getStudents()` Hata Olunca Boş Liste Döndürdüğü için `FirebaseHomePage` Hatayı Gösteremez.
7. **Tekrarlanan Sorgu:** `FirebaseHomePage`'de Future `build` İçinde Oluşturuluyor; Her Rebuild'de Yeni Sorgu Atılır.
8. **Gösterilmeyen Alanlar:** `registrationDate` ve `updateDate` Ekranda Hiç Gösterilmiyor; `updateDate` Model'de de Yok.
9. **Firestore Kuralları:** Güvenlik Kuralları Okuma/Yazmaya İzin Vermiyorsa `permission-denied` Hatası Alınır.
   Geliştirme Aşamasında "Test Mode" Kullanılabilir (Canlıda Kullanılmamalı).
10. **Silme Geri Alınamaz:** Kaydırarak Silmede Onay Penceresi Yok; Yanlışlıkla Kaydırılan Öğrenci Kalıcı Olarak Silinir.

## 12. Kurulum ve Çalıştırma

```bash
flutter pub get          # Paketleri İndir
flutterfire configure    # (Önerilen) Firebase Yapılandırmasını Üret
flutter run              # Uygulamayı Çalıştır
flutter test             # Testleri Çalıştır
```

**Firebase Console:** Proje Oluştur → Android/iOS Uygulaması Ekle (Paket Adı: `com.example.u_3_kasim`) → Firestore Database Oluştur.

### 12.1 Sık Karşılaşılan Hatalar

| Hata | Olası Sebep | Çözüm |
|---|---|---|
| `No Firebase App '[DEFAULT]' has been created` | `initializeApp` Çalışmadı | Yapılandırma Dosyalarını Ekle. |
| `permission-denied` | Firestore Kuralları | Kuralları Düzenle. |
| `Binding has not yet been initialized` | `ensureInitialized` Eksik | `main`'in Başına Ekle. |
| Liste Hep Boş | `getStudents` Hatayı Yuttu | Konsoldaki `debugPrint` Çıktısına Bak. |

## 13. Kendini Test Et

1. `watchStudents()` Neden `Future` Değil de `Stream` Döndürüyor? → Veritabanı Her Değiştiğinde Yeni Liste Yayması Gerektiği için.
2. `_studentsStream` Neden `late final` Field? → Her `build`'de Yeni Abonelik Açılmasını Önlemek için.
3. Neden `DateTime.now()` Yerine `FieldValue.serverTimestamp()`? → Cihaz Saati Yanlış Olabilir; Sunucu Saati Herkes için Aynıdır.
4. `set` + `merge` ile `update()` Farkı? → `set` Doküman Yoksa Oluşturur; `update` Doküman Yoksa Hata Verir.
5. `confirmDismiss` `false` Döndürürse? → Satır Listeden Kaldırılmaz, Yerine Geri Döner.
6. `Navigator.pop(context, value)` Değeri Nerede Karşılanır? → `final newPoint = await showDialog<int>(...)` Satırında.
