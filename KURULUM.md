# 🚀 Muktar Marangoz - Hızlı Kurulum Rehberi

## 📱 Kullanıcılar İçin (APK Kurulumu)

### Adım 1: APK Dosyasını İndirin
1. En son sürümü [Releases](releases) sayfasından indirin
2. `muktar-marangoz-v1.0.0.apk` dosyasını telefonunuza indirin

### Adım 2: Bilinmeyen Kaynaklara İzin Verin
1. **Ayarlar** > **Güvenlik** > **Bilinmeyen Kaynaklar**'ı açın
2. Tarayıcınıza (Chrome/Firefox) izin verin

### Adım 3: APK'yı Kurun
1. İndirilen APK dosyasına tıklayın
2. **Yükle** butonuna basın
3. Kurulum tamamlanana kadar bekleyin
4. **Aç** butonuna tıklayın

### Adım 4: İzinleri Verin
Uygulama şu izinleri isteyecek:
- 🎤 **Mikrofon**: Sesli giriş için
- 📁 **Depolama**: PDF kaydetme için

Her ikisine de **İzin Ver** deyin.

### ✅ Hazırsınız!
Uygulama kullanıma hazır. İyi kullanımlar!

---

## 👨‍💻 Geliştiriciler İçin (Kaynak Koddan)

### Ön Gereksinimler

#### 1. Flutter SDK Kurulumu
```bash
# Windows
# Flutter SDK'yı indirin: https://docs.flutter.dev/get-started/install/windows
# ZIP'i çıkarın ve PATH'e ekleyin

# Kurulumu kontrol edin
flutter doctor
```

#### 2. Android Studio
- [Android Studio](https://developer.android.com/studio) indirin ve kurun
- Android SDK (API 26-34) kurun
- Android Virtual Device (AVD) oluşturun

#### 3. VS Code (Opsiyonel)
- [VS Code](https://code.visualstudio.com/) indirin
- Flutter ve Dart extension'larını kurun

### Proje Kurulumu

#### 1. Projeyi Klonlayın
```bash
git clone https://github.com/your-repo/muktar-marangoz.git
cd muktar-marangoz
```

#### 2. Bağımlılıkları Yükleyin
```bash
flutter pub get
```

#### 3. Cihaz/Emülatör Hazırlayın

**Android Emülatör:**
```bash
# Emülatör listesini görün
flutter emulators

# Emülatör başlatın
flutter emulators --launch <emulator-id>
```

**Fiziksel Cihaz:**
1. USB Debugging'i açın
2. Cihazı bilgisayara bağlayın
3. Bağlantıyı kontrol edin:
```bash
flutter devices
```

#### 4. Uygulamayı Çalıştırın

**Debug Mode:**
```bash
flutter run
```

**Release Mode:**
```bash
flutter run --release
```

### APK Oluşturma

#### Debug APK
```bash
flutter build apk --debug
```
Çıktı: `build/app/outputs/flutter-apk/app-debug.apk`

#### Release APK
```bash
flutter build apk --release
```
Çıktı: `build/app/outputs/flutter-apk/app-release.apk`

#### Split APK (Her ABI için ayrı - Daha küçük dosyalar)
```bash
flutter build apk --split-per-abi --release
```
Çıktılar:
- `app-armeabi-v7a-release.apk` (32-bit ARM)
- `app-arm64-v8a-release.apk` (64-bit ARM)
- `app-x86_64-release.apk` (Intel 64-bit)

#### App Bundle (Google Play için)
```bash
flutter build appbundle --release
```
Çıktı: `build/app/outputs/bundle/release/app-release.aab`

### 🔑 İmzalama (Production için)

#### 1. Keystore Oluşturun
```bash
keytool -genkey -v -keystore ~/muktar-marangoz-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias muktar-marangoz
```

Soruları cevaplayın:
- Şifre: (güçlü bir şifre)
- Ad Soyad: [İsminiz]
- Organizasyon: Muktar Marangoz
- vb.

#### 2. key.properties Oluşturun
`android/key.properties` dosyası oluşturun:
```properties
storePassword=<keystore-şifreniz>
keyPassword=<key-şifreniz>
keyAlias=muktar-marangoz
storeFile=<keystore-dosya-yolunuz>
```

**Örnek:**
```properties
storePassword=MyStr0ngP@ssw0rd
keyPassword=MyStr0ngP@ssw0rd
keyAlias=muktar-marangoz
storeFile=C:/Users/YourName/muktar-marangoz-key.jks
```

#### 3. build.gradle Güncelleyin
`android/app/build.gradle` dosyasında zaten yapılandırılmış.

#### 4. İmzalı APK Oluşturun
```bash
flutter build apk --release
```

---

## 🔧 Sorun Giderme

### "Flutter command not found"
```bash
# Windows'ta PATH'e ekleyin:
# Sistem Özellikleri > Gelişmiş > Ortam Değişkenleri > PATH
# Flutter SDK'nın bin klasörünü ekleyin
```

### "Android SDK not found"
1. Android Studio'yu açın
2. **Tools** > **SDK Manager**
3. Android SDK Platform 26-34 arası yükleyin
4. **Android SDK Build-Tools** yükleyin

### "Gradle build failed"
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
flutter run
```

### "Unable to locate Android SDK"
```bash
# Flutter'a Android SDK yolunu söyleyin
flutter config --android-sdk C:\Users\YourName\AppData\Local\Android\Sdk
```

### "License not accepted"
```bash
flutter doctor --android-licenses
# Tüm lisansları kabul edin (y)
```

### APK yüklenmiyor
1. Cihazda **Bilinmeyen Kaynaklar** iznini kontrol edin
2. Eski sürümü kaldırın ve tekrar deneyin
3. Yetersiz depolama alanı olup olmadığını kontrol edin

---

## 📦 Bağımlılık Güncellemeleri

### Tüm Paketleri Güncelleme
```bash
flutter pub upgrade
```

### Belirli Paketi Güncelleme
```bash
flutter pub upgrade provider
```

### Uyumluluk Kontrolü
```bash
flutter pub outdated
```

---

## 🧪 Test

### Unit Testler
```bash
flutter test
```

### Widget Testler
```bash
flutter test test/screens/
```

### Integration Testler
```bash
flutter test integration_test/
```

### Coverage Raporu
```bash
flutter test --coverage
```

---

## 🎯 Hızlı Başlangıç Kontrol Listesi

- [ ] Flutter SDK kuruldu
- [ ] Android Studio kuruldu
- [ ] Git kuruldu
- [ ] Proje klonlandı
- [ ] `flutter pub get` çalıştırıldı
- [ ] `flutter doctor` hatasız
- [ ] Emülatör/Cihaz hazır
- [ ] `flutter run` çalıştı
- [ ] Uygulama başarıyla açıldı

---

## 📱 Sistem Gereksinimleri

### Geliştirme İçin
- **OS**: Windows 10/11, macOS, Linux
- **RAM**: Minimum 8 GB (16 GB önerilir)
- **Disk**: 10 GB boş alan
- **İnternet**: Bağımlılıkları indirmek için

### Uygulama İçin
- **Android**: 8.0+ (API 26)
- **RAM**: 512 MB
- **Depolama**: 50 MB
- **İnternet**: Opsiyonel (sadece WhatsApp paylaşımı için)

---

## 📞 Yardım ve Destek

### Dokümantasyon
- [README.md](README.md) - Genel bakış
- [KULLANIM_KILAVUZU.md](KULLANIM_KILAVUZU.md) - Kullanıcı rehberi
- [GELISTIRME_REHBERI.md](GELISTIRME_REHBERI.md) - Geliştirici rehberi
- [CHANGELOG.md](CHANGELOG.md) - Değişiklik günlüğü

### Topluluk
- GitHub Issues: Hata bildirimi ve özellik isteği
- GitHub Discussions: Soru-cevap ve tartışmalar

### İletişim
- Email: [email@example.com]
- Telefon: [+90 XXX XXX XX XX]

---

## 🎉 Başarılı Kurulum!

Artık Muktar Marangoz uygulamasını kullanmaya veya geliştirmeye hazırsınız!

**İyi çalışmalar!** 🪵

---

*Son Güncelleme: 23 Ekim 2025*
*Versiyon: 1.0.0*

