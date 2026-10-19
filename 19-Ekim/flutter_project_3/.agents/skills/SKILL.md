name:flutter-feature-scaffold
description: Flutter Projelerinde Feature Bazlı Kod Yazmak için Gerekli Klasör Yapısını Oluşturur. ValueNotifier State Mimarisini, UI Ayrımını ve Birim Test İskeletini Standartlara Uygun Olarak Üretir.

# Flutter Feature Scaffold (Modüler Ekran İskeleti)
Bu Yetenek, Projede Yeni Bir Ekran yada İşlev Modülü Açarken Clean UI ve Reaktif State Kurallarına Tam Uyulmasını Garanti Altına Alır.

## Temel Kurallar

### Asla Tek Dosyada Toplama

UI (`_view.dart`) State Controller, (_controller.dart) ve (`model.dart`) Dosyaları Ayrı Açılmalıdır.

### State Management

Basit ve Reaktif Durumlar için ValueNotifier Kullanılmalıdır.
Doğrudan Devasa StatefulWidgets Yazarak İşi Karmaşıklaştırma.

### Const Zorunluluğu

Mümkün Olan Tüm Widget'larda const Olmalıdır.

## Adım Adım Uygulama Akışı

### Adım 1: Klasör Yapısı Oluşturma
Hedeflenen Modül Adlarını (Örn: `water_tracker`), 'lib/features/<feature_name> Altına Yapıyı Kur.

```text
lib/features/<feature_name>
    controllers/
        <feature_name>_controller.dart
    models/
        <feature_name>_model.dart
    views/
        <feature_name>_view.dart
    widgets/
        <feature_name>_widget.dart
```

### Adım 2: Controller Dosyasını Yaz
`controllers/<feature_name>_controller.dart` İçinde Mantığı `ValueNotifier`Tanımlarını Oluştur.

```dart
import 'package:flutter/foundation.dart';

class WaterTrackerController {
    final ValueNotifier<int> currentWater = ValueNotifier<int>(0);
    final int dailyGoalWater = 2000; // 2000 ml

    void addWater() {
        currentWater.value += 250;
    }

    void resetWater() {
        currentWater.value = 0;
    }

    void dispose() {
        currentWater.dispose();
    }
}
```

### Adım 3: Model Dosyasını Oluşturma
`models/<feature_name>_model.dart` Dosyasını `copyWith`, `fromJson`, `toJson` Metotlarını İçerecek Şekilde 'immutable` Olarak Tanımla:

```dart
class UserProfile {
    final String name;
    final String email;
    final String profileImage;
    final int level;
    finat int coins;

    const UserProfile({
        required this.name,
        required this.email,
        required this.profileImage,
        required this.level,
        required this.coins,
    });

    UserProfile copyWith({
        String? name,
        String? email,
        String? profileImage,
        int? level,
        int? coins,
    }) {
        return UserProfile(
            name: name ?? this.name,
            email: email ?? this.email,
            profileImage: profileImage ?? this.profileImage,
            level: level ?? this.level,
            coins: coins ?? this.coins,
        );
    }

    factory UserProfile.fromJson(Map<String, dynamic> json) {
        return UserProfile(
            name: json['name'] ?? '',
            email: json['email'] ?? '',
            profileImage: json['profileImage'] ?? '',
            level: json['level'] ?? 0,
            coins: json['coins'] ?? 0,
        );
    }

    Map<String, dynamic> toJson() {
        return {
            'name': name,
            'email': email,
            'profileImage': profileImage,
            'level': level,
            'coins': coins,
        };
    }
}
```

### Adım 4: View Dosyasını Oluşturma

`views/<feature_name>_view.dart` Dosyasında `StatefulWidget` Kullanılarak UI Katmanını Oluştur:

```dart
import 'package:flutter/material.dart';
import '../controllers/<feature_name>_controller.dart';

class <feature_name>View extends StatelessWidget {
  final <feature_name>Controller _controller = <feature_name>Controller();

  <feature_name>View({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Feature Scaffold'),
      ),
      body: ValueListenableBuilder<int>(
        valueListenable: _controller.currentWater,
        builder: (context, currentWater, _) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Current Water: $currentWater ml',
                  style: const TextStyle(fontSize: 24),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _controller.addWater,
                  child: const Text('Add 250 ml'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _controller.resetWater,
                  child: const Text('Reset'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
```

### Adım 5: Widget Dosyasını Oluşturma
`widgets/<feature_name>_card.dart` Dosyasında `StatelessWidget` Kullanılarak UI Katmanını Oluştur:

```dart
import 'package:flutter/material.dart';

class <Feature_name>Card extends StatelessWidget {
  final String title;
  final String subtitle;
  final String image;
  final int level;
  final int coins;

  const <Feature_name>Card({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.image,
    required this.level,
    required this.coins,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Image.network(image),
          Text(title),
          Text(subtitle),
          Text('Level: $level'),
          Text('Coins: $coins'),
        ],
      ),
    );
  }
}
```

### Adım 6: Clean Architecture Kurallarına Uyum

- **Separation of Concerns:** Her dosyanın belirli bir sorumluluğu olduğundan emin ol.
- **Reusability:** Widgetları ve controller'ı diğer ekranlarda da kullanabilecek şekilde tasarla.
- **Testability:** Her katman için ayrı testler yazabileceğinden emin ol.

## Kullanım Örnekleri

### Örnek 1: Basit Bir Ekran Oluşturma
```dart
import 'package:flutter/material.dart';
import 'package:flutter_feature_scaffold/features/water_tracker/view/water_tracker_view.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WaterTrackerView();
  }
}
```

### Örnek 2: Modüler Widget Kullanımı
```dart
import 'package:flutter/material.dart';
import 'package:flutter_feature_scaffold/features/water_tracker/widgets/water_tracker_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WaterTrackerCard(
      title: 'Water Tracker',
      subtitle: 'Track Your Water Intake',
      image: 'https://example.com/water_tracker.jpg',
      level: 1,
      coins: 0,
    );
  }
}
```

## Ekstra İpuçları
- **Dependency Injection:** Controller'ları Widgetlara Inject Etmek için GetIt veya Provider Kullanabilirsin.
- **Navigation:** Navigasyonu Sağlamak için Navigator 2.0 veya go_router Kullanılarabilirsin.
- **Testing:** Her katman için Ayrı Testler Yazarak Uygulamanın Stabilitesini Sağlayabilirsin.

## SSS

### Soru: Hangi durumlarda bu yeteneği kullanmalıyım?
**Cevap:** Yeni Bir Ekran veya İşlev Modülü Oluştururken Bu Yeteneği Kullanımalısın.

### Soru: Bu yetenek hangi durumlarda kullanmamalıyım?
**Cevap:** Mevcut Bir Ekran Güncellerken veya küçük bir hata düzeltmesi yaparken Bu Yeteneği Kullanısmamalısın.