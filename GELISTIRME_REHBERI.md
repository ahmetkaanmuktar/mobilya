# 🛠️ Muktar Marangoz - Geliştirme Rehberi

Bu doküman, Muktar Marangoz uygulamasının geliştirilmesi, test edilmesi ve dağıtımı için gerekli bilgileri içerir.

## 📋 İçindekiler
- [Geliştirme Ortamı Kurulumu](#geliştirme-ortamı-kurulumu)
- [Proje Yapısı](#proje-yapısı)
- [Çalıştırma ve Test](#çalıştırma-ve-test)
- [Build ve Dağıtım](#build-ve-dağıtım)
- [Özellik Ekleme](#özellik-ekleme)
- [Sorun Giderme](#sorun-giderme)

## 🚀 Geliştirme Ortamı Kurulumu

### Gereksinimler
1. **Flutter SDK** (3.0.0+)
   - [Flutter Kurulum Rehberi](https://docs.flutter.dev/get-started/install)
   
2. **Android Studio** veya **VS Code**
   - Android SDK (API 26-34)
   - Kotlin Plugin
   
3. **Git** (versiyon kontrolü için)

### Kurulum Adımları

```bash
# 1. Flutter doktor kontrolü
flutter doctor

# 2. Projeyi klonlayın
git clone <repo-url>
cd muktar_marangoz

# 3. Bağımlılıkları yükleyin
flutter pub get

# 4. Flutter analiz
flutter analyze

# 5. Test edin
flutter test
```

## 📁 Proje Yapısı

```
muktar_marangoz/
├── lib/
│   ├── main.dart                    # Ana giriş noktası
│   ├── models/                      # Veri modelleri
│   │   ├── piece.dart              # Parça modeli
│   │   └── cutting_plan.dart       # Plan modeli
│   ├── providers/                   # State management
│   │   └── cutting_plan_provider.dart
│   ├── screens/                     # UI Ekranları
│   │   ├── home_screen.dart
│   │   ├── cutting_plan_screen.dart
│   │   ├── result_screen.dart
│   │   └── history_screen.dart
│   ├── services/                    # İş mantığı servisleri
│   │   ├── database_service.dart
│   │   └── pdf_service.dart
│   ├── utils/                       # Yardımcı fonksiyonlar
│   │   ├── app_theme.dart
│   │   ├── constants.dart
│   │   ├── validators.dart
│   │   └── formatters.dart
│   └── widgets/                     # Özel widget'lar
│       ├── cutting_layout_widget.dart
│       ├── empty_state_widget.dart
│       └── loading_dialog.dart
├── android/                         # Android yapılandırması
├── assets/                          # Görseller ve ikonlar
├── test/                           # Test dosyaları
└── pubspec.yaml                    # Bağımlılıklar
```

## 🎯 Çalıştırma ve Test

### Debug Modda Çalıştırma

```bash
# Bağlı cihazları listele
flutter devices

# Uygulamayı çalıştır
flutter run

# Hot reload için: r
# Hot restart için: R
# Quit için: q
```

### Release Modda Test

```bash
flutter run --release
```

### Unit Test

```bash
# Tüm testleri çalıştır
flutter test

# Belirli bir test dosyasını çalıştır
flutter test test/models/piece_test.dart

# Coverage raporu
flutter test --coverage
```

## 📦 Build ve Dağıtım

### APK Oluşturma

#### Debug APK
```bash
flutter build apk --debug
# Çıktı: build/app/outputs/flutter-apk/app-debug.apk
```

#### Release APK (Tüm ABI'ler)
```bash
flutter build apk --release
# Çıktı: build/app/outputs/flutter-apk/app-release.apk
```

#### Split APK (Her ABI için ayrı)
```bash
flutter build apk --split-per-abi --release
# Çıktılar:
# - app-armeabi-v7a-release.apk
# - app-arm64-v8a-release.apk
# - app-x86_64-release.apk
```

### App Bundle (Google Play için)
```bash
flutter build appbundle --release
# Çıktı: build/app/outputs/bundle/release/app-release.aab
```

### İmzalama (Production için)

1. **Keystore oluşturun:**
```bash
keytool -genkey -v -keystore ~/muktar-marangoz-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias muktar-marangoz
```

2. **key.properties oluşturun** (`android/key.properties`):
```properties
storePassword=<şifre>
keyPassword=<şifre>
keyAlias=muktar-marangoz
storeFile=<keystore-dosya-yolu>
```

3. **android/app/build.gradle** dosyasını güncelleyin:
```gradle
// key.properties'i yükle
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

android {
    ...
    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }
    buildTypes {
        release {
            signingConfig signingConfigs.release
        }
    }
}
```

## ✨ Özellik Ekleme

### Yeni Ekran Ekleme

1. `lib/screens/` altında yeni dosya oluşturun
2. StatefulWidget veya StatelessWidget oluşturun
3. Navigasyon ekleyin
4. Provider'a bağlayın (gerekiyorsa)

Örnek:
```dart
// lib/screens/settings_screen.dart
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ayarlar')),
      body: ListView(
        children: [
          // Ayar itemleri
        ],
      ),
    );
  }
}
```

### Yeni Model Ekleme

1. `lib/models/` altında yeni dosya oluşturun
2. Sınıf tanımlayın
3. `toMap()` ve `fromMap()` metodları ekleyin
4. `copyWith()` metodu ekleyin (immutability için)

### Veritabanı Güncelleme

1. `lib/services/database_service.dart` açın
2. `_createDB` metodunda yeni tablo ekleyin
3. Version numarasını artırın
4. Migration ekleyin (gerekiyorsa)

## 🐛 Sorun Giderme

### Yaygın Hatalar

#### 1. "flutter: command not found"
```bash
export PATH="$PATH:`pwd`/flutter/bin"
```

#### 2. "Android SDK not found"
- Android Studio'yu açın
- Tools > SDK Manager
- Android SDK'yı kurun

#### 3. Gradle Build Hatası
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
```

#### 4. "Execution failed for task ':app:lintVitalRelease'"
`android/app/build.gradle` içine ekleyin:
```gradle
android {
    lintOptions {
        checkReleaseBuilds false
    }
}
```

#### 5. SQLite Hatası
```bash
flutter clean
flutter pub get
flutter run
```

### Debug İpuçları

1. **Flutter DevTools kullanın:**
```bash
flutter pub global activate devtools
flutter pub global run devtools
```

2. **Logları takip edin:**
```bash
flutter logs
```

3. **Widget Inspector:**
- DevTools açın
- Flutter Inspector sekmesine gidin
- Widget tree'yi inceleyin

## 🧪 Test Yazma

### Unit Test Örneği
```dart
// test/models/piece_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:muktar_marangoz/models/piece.dart';

void main() {
  group('Piece Model Tests', () {
    test('Area calculation should be correct', () {
      final piece = Piece(
        id: '1',
        width: 1000,
        height: 2000,
        isBanded: false,
      );
      
      expect(piece.area, 2.0); // 2 m²
    });
  });
}
```

### Widget Test Örneği
```dart
// test/screens/home_screen_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:muktar_marangoz/screens/home_screen.dart';

void main() {
  testWidgets('Home screen shows app title', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: HomeScreen()),
    );
    
    expect(find.text('MUKTAR MARANGOZ'), findsOneWidget);
  });
}
```

## 📱 Cihaz Testleri

### Emülatör
```bash
# Emülatörleri listele
flutter emulators

# Emülatör başlat
flutter emulators --launch <emulator-id>
```

### Fiziksel Cihaz
1. USB Debugging'i açın
2. Cihazı bağlayın
3. `flutter devices` ile kontrol edin
4. `flutter run` ile çalıştırın

## 🔧 Performans Optimizasyonu

### 1. Build Context Kullanımı
```dart
// ❌ Kötü
onPressed: () {
  Provider.of<MyProvider>(context).method();
}

// ✅ İyi
onPressed: () {
  Provider.of<MyProvider>(context, listen: false).method();
}
```

### 2. Const Kullanımı
```dart
// ✅ Mümkün olduğunca const kullanın
const SizedBox(height: 16)
const Text('Sabit metin')
```

### 3. ListView.builder Kullanın
```dart
// ✅ Büyük listeler için builder kullanın
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) => ItemWidget(items[index]),
)
```

## 📚 Kaynaklar

- [Flutter Dokümantasyonu](https://docs.flutter.dev/)
- [Dart Dokümantasyonu](https://dart.dev/guides)
- [Provider Package](https://pub.dev/packages/provider)
- [SQLite Package](https://pub.dev/packages/sqflite)
- [PDF Package](https://pub.dev/packages/pdf)

## 🤝 Katkıda Bulunma

1. Branch oluşturun: `git checkout -b feature/yeni-ozellik`
2. Değişiklikleri commit edin: `git commit -am 'Yeni özellik eklendi'`
3. Branch'i push edin: `git push origin feature/yeni-ozellik`
4. Pull Request açın

## 📝 Notlar

- Her commit öncesi `flutter analyze` çalıştırın
- Büyük değişikliklerde test ekleyin
- Kod formatını koruyun: `flutter format .`
- Commit mesajları açıklayıcı olsun

---

**Son Güncelleme:** 2025
**Geliştirici:** Muktar Marangoz Team

