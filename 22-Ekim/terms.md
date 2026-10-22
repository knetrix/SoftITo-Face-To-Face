## Const

* **1) Ne İşe Yarar:** İçine Girilen Değerleri Derleme Zamanında Tek Bir Kere Yazılarak Değişmez Olarak Üretir.
* **2) Neden Kullanılır:** Bir Widget Const Olarak Tanımlanırsa SetState Olduğunda Flutter Bu Widget'ı Yeniden Üretmez, CPU ve Pil Tasarrufu Sağlar.

## Final

* **1) Ne İşe Yarar:** Çalışma Zamanında Değeri Bir Kez Atanan ve Sonrasında Referansı Asla Değiştirilmeyen Değişkenler
* ***Const ve Final Farkı:** Const Derlenirken Bilinmek Zorunda (Const Pi = 3.14), Final İse Çalışma Anında Belirlenebilir (Final Saat = DateTime.now()) --- **Model Sınıflarında Alanlar Her Zaman Final Olmalıdır.** ---*

## Late

* **1) Ne İşe Yarar:** Değişken Tanımlandığı Anda Değil, İlk Kullanıldığında veya InitState Anında Başlatılacağı Zaman Kullanılır.

## Required

* **1) Ne İşe Yarar:** İsimlendirilmiş Parametrelerde O Parametrenin (Değişkenin) Zorunlu Olduğunu Belirtir.

## @Override

* **1) Ne İşe Yarar:** Alt Sınıfın, Üst Sınıftan Devraldığı Metodu Ezdiğini Belirtir.
* **2) Faydası:** Eğer Üst Metot Adını Yanlış Yazarsanız (Örnek Builds Yazarsanız) Derleyici @Override Sayesinde Bunu Anında Hata Olarak Yakalar.

## Null-Aware Operatörleri (? ?? !)

* **?.** - Place?.title -> Eğer Place Null İse Hata Vermez, Direkt Null Olarak Döner.
* **??** - **If Null:** Final Id = State.userId ?? 10; -> Sol Taraf Null İse Sağdaki (Hardcode Olan Değer) Otomatik Olarak Atanır.
* **! (Null / Force):** Final Id = State.userId! -> Bu Kod Derleyiciye "Bana Güven Bu Değer O Anda Kesinlikle Null Değil" Der. Eğer Null Gelir İse Uygulama Anında Çöker. **(Çok Dikkatli Kullanılmalı)**

## Spread Operatörü (...)

* **1) Ne İşe Yarar:** Bir Listenin Elemanlarını Tek Tek Çıkartıp Bulunduğu Üst Listenin İçine Ekler. Column ve ListView İçinde Dinamik Kart Dizini Kullanmak İçin En Temiz Yöntemdir.
  ...listeAdi.map((p) => _buildCard(p))

## InitState()

* **Ne Zaman Çalışır:** Widget Ağaca Fiziksel Olarak İlk Başladığında Yalnızca 1 Kere Çalışır
* **Ne Yapar:** ScrollController Başlatmaları ve İlk API İstekleri Burada Kurulur.
* **Kural:** İçinde Doğrudan BuildContext ile Navigator Çağrılmaz Çünkü Widget Ağaca Tam Oturmamıştır.

## DidChangeDependencies()

* **Ne Zaman Çalışır:** InitState()'ten Hemen Sonra ve Widget Dinlediği Bir (Örnek: Theme.of(context)) Değiştiğinde Otomatik Tetikler.
* **Ne Yapar:** BuildContext'e Güvenli Bir Şekilde Erişerek Tema veya Ekran Boyutu Bağımlılıkları ile İlgili İlk Yüklemeler Burada Yapılır.

## Build(BuildContext Context)

* **Ne Zaman Çalışır:** Sayfa İlk Açıldığında, SetState() Çağrıldığında veya Üst Widget Yeni Bir İnşa Ağaç Boyama Geldiğinde Saniyesinde Defalarca Çalışır
* **Kural:** Build() Metodu Tamamen Saf Olmalıdır. Asla İçinde SetState(), API İsteği Ya Da Controller Başlatma Yapılmamalıdır. Sadece UI Döndürülmelidir.

## Dispose()

* **Ne Zaman Çalışır:** Widget Hafızadan Atılmadan Hemen Önce Son Bir Kez Çalışır

## SetState((){})

* **1) Arka Planda Ne Yapar:** State'in Bağlı Olduğu StatefulElement Nesnesine "Ben Değiştim, Build Et" Sinyali Yollar
* **2) Nerede Kullanılır:** Sayfa Genelini Çizdirmez. Sadece Onu Dinleyen Küçük ValueListenableBuilder'a Sinyal Gönderilir.

## ValueNotifier<T>

* **1) Arka Planda Ne İş Yapar:** ChangeNotifier Sınıfından Türer. Belleğinde Tek Bir Nesne Referansı Tutar (T _value)
* **2) Tetikleme:** Değer Atandığında (Set Value(T Value)), Eğer Yeni Değer Eski Değere Eşit Değilse (_value != NewValue), Kayıtlı Olan Fonksiyon Çağrılır. (AddListener(() {}))

## InheritedWidget

* **1) Ne Yapar:** Widget Ağacında Alttaki Child'ların, Aradaki Onlarca Widget'ı Baypas Ederek, Üst Widget'ın Verisine (State'ine) Doğrudan Erişmesini Sağlayan Soyut Bir Widget'tır.

# Material 3 Tasarım Dili Renk Algoritması ve Temalar

* **Primary:** Ana Marka Rengi
* **OnPrimary:** Ana Rengin Üstüne Yazılacak Yazı Rengi (Okunabilirlik Açısından)
* **PrimaryContainer:** Ana Rengin Yumuşak Pastel Arka Plan Tonu
* **OnPrimaryContainer:** Ana Rengin Yumuşak Pastel Arka Plan Tonunun Üstüne Yazılacak Yazı (Okunabilirlik Açısından)
* **Surface:** Sayfa Arka Plan Tuvali
* **OnSurface:** Sayfa Üstündeki Ana Metin Rengi
* **OutlineVariant:** İnce Sınır ve Ayrım Çizgilerinin Rengi

### ThemeMode.System

* **Color:** Colors.black.withOpacity(186) // Kesinlikle 1 İla 255 Sayıları Arasında Tam Sayı Olarak Girilmelidir **Bu Kullanım Güncelde İstenmiyor**
* **Color:** Colors.black.withValues(alpha: 186/255) // Double Sayı Olarak Girilmelidir **Güncel ve Doğru Yöntemdir**

# Arayüz Düzen ve Liste Bileşenleri

## Expanded ve Flexible

* **Expanded:** Kalan Bol Alanın Tamamını Kaplamaya Zorlar.
* **Flexible:** Kalan Bol Alanı Paylaştırır. (Flex: 1, Flex: 2)
* **Flex:** Yan Yana İki Expanded Varsa Birine Flex 2 Diğerine Flex 1 Verir, Bu Sayede Ekran Boyutuna Göre Otomatik Olarak Ayarlar.

## Stack ve Positioned

* **Ne Yapar:** Widget'ları Z Ekseninde Üst Üste Bindirir.
* **Positioned:** Yalnızca Bir Stack İçinde Çalışır.
* **Top: 10, Right: 10** Vererek Bir Resmin Sağ Üst Köşesine Bildirim Rozeti Eklemenizi Sağlar.

## ListView.Builder

* **Klasik ListView(children: [...]):** İçindeki Örnek Vermek Gerekirse 10.000 Elemanın Tamamını Daha Sayfa Açılmadan Belleğe Yükler ve Doğal Olarak Telefon Donar.
* **ListView.builder:** Geri Dönüşümlü Görünüm Alanı Mantığını Kullanarak Ekranda Sadece O An Eğer 5 Kart Görünecek İse Sadece 5 Kartı RAM Belleğe Yükler. Kullanıcı Aşağıya Kaydıkça Yukarıda Kalanlar Bellekten Düşürülüp Altta Kalanlar Belleğe Taze Olarak Yeni Olarak Üretilir.

### ShrinkWrap: True

* Bir ListView Başka Bir Dikey Kaydırıcının (SingleChildScrollView) İçine Konursa Vertical Viewport Hatası Verir.
* ShrinkWrap True Verilerek Bu Çözülebilir Ancak: ListView'un Sonsuza Kayma (Sonsuz Scroll) Özelliği Kaybolur.
* **Sadece 3-5 Elemanınız Varsa Bunu Kullanmalısınız**

## InkWell ve GestureDetector

* **GestureDetector:** Tıklama, Çift Tıklama, Sürükleme Olaylarını Yakalar Ama **Görsel Hiçbir Tepki Vermez.**
* **InkWell:** Tıklandığı An Parmağın Altından Dışa Doğru Yayılan Bir Su Dalgası Efekti Verir.
* **Önemli Kural:** InkWell'in Arkasında Mutlaka Bir Material Widget Olmak Zorundadır. Aksi Takdirde Su Dalgası Arkadaki Tuvali Göremediği İçin Hiçbir Şekilde Görünmez.