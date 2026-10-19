# Fitness Su Takip Uygulaması

Bu Döküman Flutter Projesinde Geliştirme Yapacak Olan Ajan Yapay Zeka ve Yazılım Geliştiriler için Bağlayıcı Bir Kılavuzdur. Projede Üretilen Her Kod Satırı Buradaki Kurallara UYMAK ZORUNDADIR.

## 1. Proje Özeti ve Teknolojiler

- **Uygulama Adı:** Susadım (Akıllı Su Egzersiz ve Kalori Takibi Uygulaması)
- Hedef Platformlar: Android ve iOS Öncelikli, Ardırdan Web ve Masaüstü Platformları
- **Flutter SDK**: 3.29.0
- **Dart SDK**: 3.0.0
- **Tasarım Dili:** Material 3, Çift Tema Desteği (Karanlık Mod: Dark Obsidian & Neon Cyan; Aydınlık Mod: Temiz Beyaz/Buzul Mavisi & Elektrik Mavisi)
- **Tema Yönetimi:** Harici paket olmadan Flutter yerel API'si `ValueNotifier<ThemeMode>` ile reaktif tema geçişi.

## 2. Mimari Yapı: Özellik Bazlı

- Kodlar Kesinlikle Tek Bir Yerde Toplanmayacaktır. Her Modül Kendi Feature Klasörübde Kodlanacaktır.

```text
lib/
core/
    constants/app_colors.dart
    theme/
        app_theme.dart
        theme_controller.dart

    features/
        water_tracker/
            controller/
            models/
            view/
        workout/
            controller/
            models/
            view/
            widget/
    main.dart
```

#### Sadece Uygulama Başlatma ve Tema Bölümleri

## 3. Kırmızı Çizgiler -> Kod Kalite Standartları

1. State Yönetim Standartları

- Sayfa Düzeyinde Ağır `setState`KULLANILMAYACAKTIR.
- Sadece Yerel Arayüz Durumunu Yöneten (Örneğin Buton Animasyonları, vb.) StatefulWidget Kabul Edilir.

2. UI ve Performance Standartları

- Statik Tüm Widget'larda `const`Zorunludur.
- Renk ve Metin Stilleri Kesinlikle Tema Dosyalarına Yazılacaktır.
- Büyük build Metotları Yasaktır, 40 Satırı Geçen build Metotları Özel Widget'lara Yazılacaktır.

3. Yasaklı Paketler

- Projeye Onay Almadan Harici Ağır State Paketleri EKLENMEYECEKTİR.
- Dart'ın ve Flutter'ın Yerel Çekirdek Api'lerini Kullanmak Esastır.

## 4. Geliştirme Analiz ve Test Komutları

Ajan Yaptığı Herhangi Bir Kod Değişikliklerinden Sonra Mutlaka Alttaki Komutların Çalıştığını Doğrulamalıdır.

- **Statik Kod Analizi (0 Uyarı ve 0 Hata Şart)**

```bash
flutter analyze
```

- **Birim ve Widget Testleri**

```bash
flutter test
```

- **Projeyi Çalıştırma**

```bash
flutter run
```

## 5. Ajanın Çıktı ve Yanıt Verme Standartları

- **Açıklamalar:** Türkçe Teknik Terimlerin Özünü Bozmadan Net ve Doğrudan Olacaktır.

- **Değişiklik Sunumları:** Örnek 500 Satırlık Bir Dosyada 3 Satır Değiştiyse Tüm Dosyayı Baştan Sona Basma; Hedef Satırları ve Diff Yapısı Göster.

- **Dosya Yolları:** Bahsedilen ve Üretilen Her Dosya için Mutlaka Projeye Göre Tıklanabilir Link Ver.

- **Doğrulama:** Kod Yazdıktan Sonra Kullanıcıya "Şimdi flutter analyze ile Kontrol Edebilirsin" Şeklinde Doğrulama Yönergeleri Ver.