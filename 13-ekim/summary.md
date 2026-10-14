# Widget Tree

Widget Tree, Arayüzün Hangi Widget'lardan Oluştuğunu ve Bu Widget'ların Nasıl Yapılandırıldığını Tanımlar. Widget'lar Arayüzün Tarifidir; Çizimi Doğrudan Kendileri Yapmaz.

- **İskelet:** rayüzün Yapısal Tarifini Sunar.
- **Immutable (Değişmez):** Bir Widget Oluşturulduktan Sonra İçindeki Alanlar Değiştirilmez. Yeni Yapılandırma Gerektiğinde Yeni Widget Örneği Oluşturulur.
- **Hafif:** Widget Nesneleri Genellikle Küçük ve Oluşturulması Düşük Maliyetli Nesnelerdir.
- **Sık Yeniden Oluşturulabilir:** Animasyonlar ve Durum Güncellemeleri Sırasında Widget'lar Sıkça Yeniden Oluşturulur. "Saniyede 60-120 Kez" Her Widget İçin Garanti Edilen Bir Sayı Değildir; Bu Değer Ekran Yenileme Hızına Bağlı Örnek Bir Üst Sıklık Olarak Düşünülmelidir.
- **Ekranda Çizim Yapmaz, Şablon Sunar:** Widget, Arayüzün Nasıl Olması Gerektiğini Tarif Eder. Yerleşim Ve Çizim İşlemlerinde Element Ve RenderObject Katmanları Rol Alır.

# Element Tree

Widget Tariflerini Çalışma Zamanında Ekrana Bağlayan ve Ağaçtaki Nesnelerin Yaşam Döngüsünü Yöneten Yapıdır.

- **Yönetici ve Yaşayan Omurga:** Element, Widget Ağacının Çalışma Anındaki Karşılığıdır; Ağaç İçindeki Konumu ve İlişkileri Yönetir.
- **Mutable (Değişebilir):** Element, Ağaç Yaşamı Boyunca Güncellenebilir. `StatefulWidget` Kullanıldığında İlgili `State` Nesnesi de Element ile İlişkilendirilir ve Durum Burada Yaşamaya Devam Eder.
- **Widget ile RenderObject Arasındaki Koordinatör:** Element, Widget Yapılandırmasını Uygun RenderObject İle İlişkilendirir Ve Güncellemeleri Koordine Eder. Her Element'in Kendine Ait Bir RenderObject'i Olması Gerekmez.

## Flutter ve Oyun Geliştirme

***

# `canUpdate`

Flutter, Eski Widget'ın Element'inin Yeni Widget için Yeniden Kullanılabilir Olup Olmadığını Tür ve Anahtara Göre Kontrol Eder. Temel Mantık Şöyledir:

```dart
static bool canUpdate(Widget oldWidget, Widget newWidget) {
  return oldWidget.runtimeType == newWidget.runtimeType &&
      oldWidget.key == newWidget.key;
}
```

Widget'ların `runtimeType` Değerleri ve `key` Değerleri Eşleşirse Mevcut Element Yeni Widget ile Güncellenebilir. Kodda Karşılaştırma İçin `=` Değil `==` Kullanılmalıdır.

***

# State Yaşam Döngüsü

`StatefulWidget` Yapılandırması ile Ona Ait `State` Ayrı Nesnelerdir. Widget Yeniden Oluşturulsa Bile Türü ve Anahtarı Uygunsa Mevcut Element ve `State` Korunabilir; Bu Nedenle Kullanıcı Girdileri, Sayaçlar ve Controller'lar Her Rebuild'de Kendiliğinden Sıfırlanmaz.

Yaşam Döngüsünün Tipik Sırası:

1. `createState()` — `StatefulWidget` için `State` Nesnesini Oluşturur.
2. `mounted == true` — State Ağaca Bağlandığında True Olur; `initState()` Çağrılmadan Önce Geçerlidir.
3. `initState()` — State İlk Kez Oluşturulurken Bir Kez Çağrılır. Başlangıç İşlemleri Burada Yapılır.
4. `didChangeDependencies()` — İlk Kurulumda `initState()` Sonrasında Çağrılır; Bağımlı Olunan `InheritedWidget` Değerleri Değiştiğinde Tekrar Çağrılır. `Theme.of(context)` Gibi Bağımlılık Oluşturan Erişimler Burada Güvenlidir. Her Widget Değişikliğinde Çağrılmaz.
5. `build(BuildContext context)` — Arayüzü Tarif Eden Widget Ağacını Döndürür. Build Metodu Tekrar Çalışabileceğinden İçinde Doğrudan Asenkron İşlem Başlatılmamalıdır; İşlem Yaşam Döngüsüne Uygun Bir Yerde Yönetilmelidir.
6. `didUpdateWidget(oldWidget)` — Aynı Element Yeni Bir Widget Yapılandırmasıyla Güncellendiğinde Çağrılır; Eski Yapılandırmayı Parametre Olarak Alır. Ardından Genellikle `build()` Çalışır.
7. `deactivate()` — Element Ağaçtan Çıkarıldığında Çağrılır. Aynı Kare İçinde Başka Bir Yere Taşınırsa Yeniden Ağaçta Kullanılabilir.
8. `dispose()` — State Kalıcı Olarak Kaldırılırken Çağrılır. `controller.dispose()` Ve Stream Aboneliğini İptal Etme (`subscription.cancel()`) Gibi Temizlikler Burada Yapılır.
9. `mounted == false` — `dispose()` Sonrasında State Artık Ağaca Bağlı Değildir; Bu State Üzerinde `setState()` Çağrılmamalıdır.
