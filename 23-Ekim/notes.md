## 1. Sözleşmeler, SOLID Prensipleri ve OOP Mimarisi

### 1.1. Interface (Arayüz / Sözleşme)
**Sözlük Anlamı:** İki bağımsız sistemin veya sınıfın birbiriyle nasıl iletişim kuracağını belirleyen, içi boş metot imzalarından oluşan kurallar bütünüdür.

**Neden Kullanılır:** Bir sınıfa doğrudan bağımlı kalmamak (örneğin gerçek şarj istasyonu cihazı olmadan sahte/mock şarj seviyesiyle testleri çalıştırabilmek) için kullanılır.

```dart
abstract interface class StationContract {
  Future<void> startCharging(String socketId);
  Stream<double> watchLivePower();
}
```

---

### 1.2. Implements ve Extends ile With

#### 1.2.1. Implements (Arayüz Sözleşmesi)
**Sözlük Anlamı:** Bir sınıfın, bir şablonun belirlediği kuralları kabul edip **içini sıfırdan kendisinin doldurması** zorunluluğudur. 

**Neden Kullanılır:** Farklı sınıflara ortak bir standart/sözleşme dayatmak, çoklu arayüz desteği sağlamak ve koddaki bağımlılıkları azaltmak için kullanılır.

#### 1.2.2. Extends (Kalıtım / Miras)
**Sözlük Anlamı:** Bir sınıfın, başka bir sınıfın özelliklerini ve metotlarını doğrudan devralmasıdır.

**Neden Kullanılır:** Kod tekrarını önlemek (DRY) ve mantıksal bir sınıf hiyerarşisi oluşturmak için kullanılır.

#### 1.2.3. With (Mixin / Yetenek Aşılama)
**Sözlük Anlamı:** Sınıf hiyerarşisini bozmadan, bağımsız bir sınıfa hazır kod bloklarını (metotlar ve değişkenler) enjekte etme mekanizmasıdır. 

**Neden Kullanılır:** Akraba olmayan sınıflara ortak yetenekler kazandırmak, çoklu kalıtım sorunlarını önlemek ve modülerliği artırmak için kullanılır.

---

### 1.3. SOLID Prensipleri (Mobil ve Dart Odaklı)

#### 1.3.1. S – Single Responsibility Principle (Tek Sorumluluk Prensibi)
**Kural:** Bir sınıfın veya dosyanın değişmesi için **yalnızca tek bir sebebi** olmalıdır.

#### 1.3.2. O – Open / Closed Principle (Açık / Kapalı Prensibi)
**Kural:** Yazılım varlıkları (sınıflar, modüller) **genişletilmeye AÇIK, ancak değiştirilmeye KAPALI** olmalıdır.

#### 1.3.3. L – Liskov Substitution Principle (Liskov'un Yerine Geçme Prensibi)
**Kural:** Bir üst sınıfın yerine, onun alt sınıflarından herhangi biri geçirildiğinde sistemin davranışı bozulmamalı ve sistem hata fırlatmamalıdır.

#### 1.3.4. I – Interface Segregation Principle (Arayüz Ayrıştırma Prensibi)
**Kural:** İstemciler, **kullanmadıkları arayüzleri ve metotları implemente etmeye zorlanmamalıdır**. Tek ve devasa bir arayüz yerine amaca odaklı, küçük ve parçalanmış arayüzler (`abstract interface class`) tercih edilmelidir. Böylece bir sınıf, işine yaramayan içi boş metotları barındırmak zorunda kalmaz.

#### 1.3.5. D – Dependency Inversion Principle (Bağımlılıkların Tersine Çevrilmesi Prensibi)
**Kural:** Yüksek seviyeli modüller (UI, iş mantığı), düşük seviyeli modüllere (veritabanı, HTTP istemcisi) doğrudan bağlı olmamalıdır. Her ikisi de soyutlamalara (`interface`) bağlı olmalıdır.

---

## 2. Stream Temelleri, Cubit ve Enterprise BLoC

### 2.1. Stream Nedir? (BLoC'un Kalbindeki Motor)
* **Sözlük Anlamı:** Zaman içinde parça parça gelen, akıp giden asenkron veri dizisidir.
* **BLoC Sırrı:** BLoC kütüphanesi sihirli bir şey yapmaz; BLoC'un içinde gizli bir `StreamController` bulunur. Event'ler borunun bir ucundan girer (`sink.add`), BLoC onları işler ve diğer ucundan ekrana State akıtır (`stream.listen`).

---

### 2.2. BLoC'un Üç Temel Elemanı: Event, State ve Emitter

* **Event (Olay):** Kullanıcının BLoC'a gönderdiği emir fişidir.  
  *Mini Sözdizimi:* `class StartChargingRequested extends ChargingEvent { final String socketId; }`

* **State (Durum):** Ekranın o milisaniyedeki anlık fotoğrafıdır (snapshot).  
  *Mini Sözdizimi:* `class ChargingActiveState extends ChargingState { final double kwh; }`  
  *Özel Durumlar:* `Initial`, `Loading`, `Loaded`, `Error`

* **Emitter:** BLoC'un ürettiği yeni State'i ekrana fırlattığı aktarım kanalıdır.  
  *Kural:* Senkron çalışır; `emit(NewState())` dendiği anda UI'daki builder yapıları tetiklenir.

---

## 3. Yan Etki Yönetimi ve Performans

### 3.1. Side Effect (Yan Etki) Neden BlocBuilder İçine Yazılamaz?
* `BlocBuilder` bileşeninin tek görevi **Widget döndürmektir**.
* Flutter motoru ekranı saniyede 60 kez yeniden çizebilir (Rebuild). `BlocBuilder` içine `ScaffoldMessenger.showSnackBar` veya `Navigator.push` yazılırsa; cihaz yan çevrildiğinde veya klavye açıldığında kullanıcıya **üst üste 10 defa SnackBar gösterilir veya 10 kez yeni sayfa açılır!**
* **Kural:** Yan etkiler YALNIZCA `BlocListener` içine yazılır; çünkü `listener`, sayfa rebuild olduğunda değil, **yalnızca State değiştiğinde 1 kez** tetiklenir.

### 3.2. BlocSelector (Mikro Performans ve Pil Tasarrufu)
* **Kavram:** State'in içindeki onlarca alandan sadece **1 tanesini süzüp izleme** mekanizmasıdır. Yalnızca hedeflenen alan değiştiğinde ilgili Widget'ı günceller.

---

## 4. Eşitlik, Değişmezlik ve BlocObserver

### 4.1. Referential Equality ve Value Equality
* **Dart Varsayılanı (Referans Eşitliği):** İki nesnenin bellekteki (RAM) adresi aynı mıdır?
  > `Soket('A') == Soket('A')` -> **`false` döner!** İçerikleri aynı olsa da bellekteki adresleri farklıdır.

* **Değer Eşitliği (Value Equality):** Nesnelerin içindeki veriler aynı mıdır?
  > `Equatable` paketi tam olarak bunu çözer: Nesneleri bellek adresine göre değil, `props` listesindeki alanların değerine göre karşılaştırır.

### 4.2. Props Listesi Yazılmazsa Ne Olur?
* BLoC gereksiz render işlemlerini engellemek için şu denetimi yapar: `if (yeniState == eskiState) ekraniCizme();`.
* `StationLoaded` state'ine yeni bir `filterType` alanı eklenir ancak `props` listesine yazılmazsa, BLoC iki state'i birbirine eşit zanneder; **ekranı güncellemez ve arayüz donuk kalır!**

### 4.3. Immutability (Değişmezlik) ve copyWith
* **Kural:** State sınıflarının tüm alanları `final` olmalıdır (Değişmezlik).
* **`copyWith` Mantığı:** Eski nesnenin alanlarını koruyup, sadece değişen alanları güncelleyerek yeni bir nesne üretme yöntemidir.
  ```dart
  final guncel = state.copyWith(isCharging: true); // Diğer alanlar bozulmadan kopyalanır
  ```

### 4.4. BlocObserver (Tüm Uygulamayı İzleme)
* **Kavram:** Uygulamadaki tüm BLoC ve Cubit'lerin arkasında çalışan merkezi bir telemetri ve olay kaydedicidir.
* **Ne İşe Yarar?:** Hangi ekranda hangi Event'in fırlatıldığı, State'in nereden nereye geçtiği (`onTransition`) ve nerede hata oluştuğu (`onError`) tek merkezden loglanır. Kurumsal projelerde analitik ve çökme takibi için zorunludur.

### 4.5. Sayfa Kapanması ve isClosed Kontrolü
Kullanıcı ekrandayken asenkron bir işlem başlar (`await api.fetchSockets()`). Kullanıcı cevap gelmeden geri tuşuna basıp sayfayı kapatırsa, BLoC/Cubit kapatıldığı (`closed`) için hemen ardından gelen `emit()` çağrısı:

> 💥 `StateError: Cannot emit new states after calling close`

hatasını fırlatır ve uygulama çöker.

**Çözüm:** Asenkron `await` satırından sonraki her `emit` mutlaka `isClosed` kontrolü ile korunmalıdır:

```dart
final data = await repository.getData();
if (!isClosed) {
  emit(DataLoaded(data));
}
```

---

## 5. Clean Architecture Katmanları ve Sorumluluk Duvarları

### 5.1. Entity ile Model / DTO Karşılaştırması

* **`Entity` (Varlık):** Saf iş nesnesidir. Bir şarj soketinin gerçek hayattaki özelliklerini (`id`, `kw`, `durum`) tutar. `fromJson` veya `toJson` **içermez**.
* **`Model / DTO` (Data Transfer Object):** API'den gelen ham JSON verisini karşılayan taşıyıcıdır. `Entity` sınıfından türer; `fromJson` ve `toJson` metotlarını barındırır.
* **Soru:** *"Neden `Entity` içine `fromJson` yazmıyoruz?"*
  * **Cevap:** Yarın backend JSON yerine XML veya Protobuf formatına geçerse; Domain katmanındaki iş kurallarımız ve UI sayfalarımız zerre kadar etkilenmesin, yalnızca DATA katmanındaki Model etkilensin diye!

---

### 5.2. UseCase (Kullanım Senaryosu)

* **Kavram:** Kullanıcının veya sistemin gerçekleştirebileceği **tek ve atomik bir iş kuralıdır**.
* **Örnekler:** `StartChargingSessionUseCase`, `GetStationSocketsUseCase`, `RefundWalletBalanceUseCase`.
* **Kural:** Her `UseCase` sınıfının içinde sadece tek bir `call()` veya `execute()` fonksiyonu bulunur. Dart'taki `call()` metodu sayesinde nesne doğrudan bir fonksiyon gibi (`useCase()`) çağrılabilir.

---

### 5.3. Clean Architecture Katman Hiyerarşisi ve Akış Yönü

#### 5.3.1. Domain Katmanı (Çekirdek / Bağımsız Katman)
* **Özellik:** Sistemin kalbidir; Flutter SDK'sı dahil hiçbir dış pakete veya katmana bağımlı olmamalıdır (`pure Dart`).
* **İçerik:** `Entity`, `UseCase` (İş Mantığı) ve Repository Sözleşmeleri (`abstract interface class`).

#### 5.3.2. Data Katmanı (Veri Sağlayıcı Katman)
* **Özellik:** Dış dünya ile konuşan katmandır.
* **İçerik:** `Model / DTO`, `Data Source` (Remote / Local veri kaynakları: Dio, Retrofit, Hive, SQLite) ve Domain katmanındaki sözleşmeleri uygulayan `Repository Impl` sınıfları.

#### 5.3.3. Presentation Katmanı (Arayüz ve Durum Yönetimi)
* **Özellik:** Kullanıcının gördüğü ve etkileşime girdiği katmandır.
* **İçerik:** `UI / Widget`, `BLoC / Cubit`, `Event` ve `State` sınıfları. Yalnızca Domain katmanındaki Use Case'leri tetikler; Data katmanını doğrudan tanımaz.

---

### 5.4. Repository Mimarisi: Contract ve Implementation Ayrımı

* **`Contract` (Domain Katmanında):** Sadece kuralı tanımlayan sözleşmedir (`abstract interface class StationRepository`). Verinin nereden, nasıl geleceğini bilmez ve ilgilenmez.
* **`Implementation` (Data Katmanında):** Sözleşmeyi uygulayan somut sınıftır (`class StationRepositoryImpl implements StationRepository`). Verinin önce yerel diskten (Cache/Local) mi yoksa internetten (Remote API) mi çekileceği mantığına ve akışına burada karar verilir.

---

## 6. Bağımlılık Yönetimi: Dependency Injection ve get_it

### 6.1. Neden Doğrudan "new Dio()" Yazmak Yasaktır?

Eğer 5 ayrı sayfada doğrudan `final dio = Dio();` derseniz:

1. **Soket Tüketimi:** Bellekte 5 ayrı bağlantı havuzu açılır ve telefonun ağ/soket sınırını zorlar.
2. **Bakım Zorluğu:** `Base URL` veya `Timeout` süresi değiştiğinde, 5 ayrı dosyayı tek tek elle değiştirmek zorunda kalırsınız.
3. **Test Zorluğu:** Sınıflar `Dio`'ya sıkı sıkıya bağlı kalacağı için test yazarken araya sahte (`mock`) veri enjekte edemezsiniz.

---

### 6.2. GetIt Kayıt Tipleri: Singleton, LazySingleton ve Factory

* **`Singleton`:** Uygulama açıldığı milisaniyede nesneyi üretir ve belleğe çiviler (sabitler).
* **`LazySingleton`:** Uygulama açıldığında üretmez! Ne zaman ilk kez birisi `sl<Dio>()` derse o an üretir ve sonrasında hep aynı nesneyi verir (bellek ve açılış hızı dostudur).
* **`Factory`:** Her çağrıldığında **yepyeni, sıfır bir kopya** üretir.

---

## 7. Kurumsal Ağ Mimarisi: Dio, Interceptor ve HTTP Status Kodları

### 7.1. Interceptor Nedir?
* **Sözlük Anlamı:** Ağ isteği telefondan çıkıp internete gitmeden önce veya sunucudan cevap gelip koda düşmeden önce araya girip paketi inceleyen ya da değiştiren güvenlik/kontrol noktasıdır.

---

### 7.2. Bearer Token ve Payload

* **`Bearer Token`:** "Bu anahtarı taşıyan kişi işlem yapmaya yetkilidir" anlamına gelen şifrelenmiş kimlik kartı metnidir (`Authorization: Bearer eyJhbGci...`).
* **`Payload`:** Bir API isteğiyle sunucuya gönderilen ya da sunucudan bize dönen asıl veri gövdesidir (Body).

---

### 7.3. HTTP Durum Kodları Sözlüğü (Sınıfta Tahtada Sorulacak)

* **`200 OK`:** İstek başarılı, talep edilen veri yanıt gövdesindedir (Body).
* **`201 Created`:** Yeni kayıt (örneğin yeni şarj oturumu) başarıyla oluşturuldu.
* **`400 Bad Request`:** İstemci hatası; eksik veya hatalı parametre gönderildi.
* **`401 Unauthorized`:** Token yok veya süresi dolmuş; oturum geçersiz, hemen Login ekranına yönlendir!
* **`403 Forbidden`:** Giriş yapıldı ancak bu veriyi görmeye yetki yok (örneğin Admin rolü gerekli).
* **`404 Not Found`:** Aranan soket veya istasyon sunucuda bulunamadı.
* **`500 Internal Server Error`:** Sunucu tarafında beklenmeyen bir hata oluştu (backend çöktü); istemci kaynaklı bir problem yok.

---

## 8. Veri Dayanıklılığı: Cache-First ve Savunmacı Kodlama

### 8.1. Cache-First (Önce Önbellek) Stratejisi

* **Mantık:** Kullanıcı şarj istasyonu listesini açtığında 1 saniye bile beyaz ekranda spinner (yükleme ikonu) bekletme! Diskteki dünkü veriyi **0.01 milisaniyede** ekrana bas. Arka planda sunucudan taze veriyi çek; gelince ekranı ve diski sessizce güncelle.

---

### 8.2. Defensive Programming (Savunmacı Programlama)

* **Mantık:** Sunucudan gelen veriye asla %100 güvenmeme prensibidir.
* **Kural:** Hiçbir API isteği `try-catch` bloğu olmadan (hata yakalama mekanizması kurulmadan) çağrılmamalıdır.

# Sorular