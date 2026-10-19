# State Yönetim ve Veri Akışı Kılavuzu (State Flow)

Bu kılavuz, **Susadım** projesinde durum yönetimi (State Management), katmanlar arası veri akışı ve reaktif güncelleme prensiplerini tanımlar.

---

## 1. Temel Prensipler

1. **Harici Ağır Paket Yasağı:**  
   Bloc, Riverpod, MobX veya Redux gibi harici ağır paketler kullanılmaz. Flutter çekirdek API'si olan `ValueNotifier` ve `ValueListenableBuilder` esastır.
2. **Ağır setState Yasağı:**  
   Sayfa düzeyinde ve iş mantığı yönetiminde `setState` kullanılmaz. Sadece salt UI animasyon veya mikro-durumlar için yerel `StatefulWidget` kabul edilir.
3. **Tek Yönlü Veri Akışı (Unidirectional Data Flow):**  
   Kullanıcı eylemi -> Controller metodu -> State mutasyonu (`ValueNotifier.value`) -> `ValueListenableBuilder` tetiklenmesi -> Yalnızca ilgili widget ağacının yeniden çizilmesi.
4. **İmmutable Modeller:**  
   State nesneleri değiştirilemez (`@immutable`) olmalı; güncellemeler `copyWith` üzerinden yeni nesne referansı üreterek tetiklenmelidir.

---

## 2. Mimari Katmanlar ve Sorumluluklar

```text
[ View / Widget ]  ---(1. Kullanıcı Aksiyonu: controller.addWater())---> [ Controller ]
       ^                                                                        |
       |                                                                        | (2. State Güncelleme)
       |                                                                        v
       +---(3. Bildirim: ValueListenableBuilder dinler)--- [ ValueNotifier<Model> ]
```

### A. Model Katmanı (`models/<feature>_model.dart`)
- `@immutable` anotasyonu taşır.
- Tüm alanlar `final` tanımlanır.
- `copyWith`, `fromJson` ve `toJson` metotları eksiksiz uygulanır.

### B. Controller Katmanı (`controllers/<feature>_controller.dart`)
- İş mantığını (business logic) ve hesaplamaları içerir.
- Durumu `ValueNotifier<T>` ile dışa açar.
- View katmanına doğrudan Flutter UI bağımlılığı sokmaz (yalnızca `foundation.dart`).
- Yaşam döngüsü bitiminde bellek sızıntısını önlemek için `dispose()` metodu sunar.

### C. View Katmanı (`views/<feature>_view.dart`)
- Controller'ı başlatır ve `dispose()` çağrısını garanti eder.
- Tüm sayfayı `setState` ile yeniden çizmek yerine hedef widget alanlarını `ValueListenableBuilder` ile sarar.
- 40 satırı aşan build parçalarını `widgets/` altındaki alt widget'lara böler.

### D. Widget Katmanı (`widgets/<feature>_widget.dart`)
- Mümkün olan her yerde `StatelessWidget` ve `const` constructor kullanır.
- Tema değerlerini (`Theme.of(context)`) ve sabit renkleri kullanır.

---

## 3. Yaşam Döngüsü (Lifecycle) Standardı

```dart
class _WaterTrackerViewState extends State<WaterTrackerView> {
  late final WaterTrackerController _controller;

  @override
  void initState() {
    super.initState();
    // 1. Controller başlatma
    _controller = WaterTrackerController();
  }

  @override
  void dispose() {
    // 2. Bellek sızıntısını önlemek için notifier dispose edilir
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<WaterTrackerModel>(
      valueListenable: _controller.state,
      builder: (context, state, child) {
        // 3. Yalnızca bu blok reaktif olarak yeniden çizilir
        return Text('${state.currentWaterMl} ml');
      },
    );
  }
}
```

---

## 4. Hata ve Yan Etki Yönetimi

- Asenkron veri çekme işlemlerinde durum modeli (Status: `initial`, `loading`, `success`, `failure`) barındırabilir.
- UI katmanında doğrudan try-catch blokları ile karmaşık logic yazılmaz; hata durumu controller state'ine yansıtılır.
- SnackBar veya Dialog gösterimleri için listenable listener kancaları kullanılır.
