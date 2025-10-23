# 🪵 Muktar Marangoz - MDF Kesim Hesaplama Uygulaması

Modern ve kullanıcı dostu bir Android uygulaması ile MDF plakalarının kesim ölçülerini kolayca hesaplayın, planlayın ve WhatsApp üzerinden paylaşın.

## 📱 Özellikler

### ✨ Ana Özellikler
- **Kolay Parça Girişi**: En, boy, adet ve bant bilgileri ile hızlıca parça ekleyin
- **Otomatik Hesaplama**: Gerekli tabaka sayısı ve artık miktarını anında hesaplama
- **PDF Oluşturma**: Profesyonel görünümlü kesim planı PDF'leri
- **WhatsApp Entegrasyonu**: Hesaplamaları doğrudan WhatsApp ile paylaşın
- **Geçmiş Kayıtları**: Tüm kesim planlarınızı saklayın ve yeniden görüntüleyin
- **Sesli Giriş**: Mikrofonla ölçüleri söyleyerek hızlı giriş yapın

### 🎨 Kullanıcı Arayüzü
- Ahşap tonlarında modern ve şık tasarım
- Büyük butonlar ve yazılar (yaşlı kullanıcı dostu)
- Bantlı/Bantsız parçalar için renkli gösterimler
- Responsive ve kullanımı kolay arayüz

### 📊 Hesaplama Detayları
- Toplam gerekli tabaka sayısı
- Toplam parça sayısı ve alanı
- Artık alan miktarı (m² ve %)
- Parça bazlı detaylı liste
- Görsel kesim planı temsili

## 🚀 Kurulum

### Gereksinimler
- Flutter SDK (3.0.0 veya üzeri)
- Android Studio veya VS Code
- Android SDK (API 26+)
- Dart SDK

### Adımlar

1. **Projeyi klonlayın:**
```bash
git clone <repo-url>
cd muktar_marangoz
```

2. **Bağımlılıkları yükleyin:**
```bash
flutter pub get
```

3. **Android cihaz veya emülatör bağlayın**

4. **Uygulamayı çalıştırın:**
```bash
flutter run
```

### APK Oluşturma

**Release APK oluşturmak için:**
```bash
flutter build apk --release
```

APK dosyası: `build/app/outputs/flutter-apk/app-release.apk`

**App Bundle (Play Store için):**
```bash
flutter build appbundle --release
```

## 📖 Kullanım

### 1. Yeni Kesim Planı Oluşturma
1. Ana ekrandan "Yeni Kesim Planı" butonuna tıklayın
2. Müşteri adını girin
3. Parça bilgilerini ekleyin:
   - En (mm)
   - Boy (mm)
   - Adet
   - Bantlı mı? (Evet/Hayır)
4. "Parça Ekle" ile listeye ekleyin
5. Tüm parçalar eklendikten sonra "Hesapla" butonuna basın

### 2. Sesli Giriş Kullanma
- Her ölçü alanının yanındaki mikrofon ikonuna tıklayın
- Sayıyı söyleyin (örn: "iki bin sekiz yüz")
- Sistem otomatik olarak sayıyı alana yazacak

### 3. Sonuçları Paylaşma
- Hesaplama sonrası "PDF Paylaş" ile doğrudan PDF oluşturun
- "WhatsApp" butonu ile WhatsApp'ta paylaşın
- Özet bilgiler otomatik olarak mesaja eklenir

### 4. Geçmiş Kayıtlar
- Ana ekrandan "Geçmiş Faturalar" bölümüne gidin
- Kaydedilmiş planları görüntüleyin
- Planları tekrar açın veya silin

## 🏗️ Proje Yapısı

```
lib/
├── main.dart                 # Uygulama giriş noktası
├── models/                   # Veri modelleri
│   ├── piece.dart           # Parça modeli
│   └── cutting_plan.dart    # Kesim planı modeli
├── providers/               # State management
│   └── cutting_plan_provider.dart
├── screens/                 # Ekranlar
│   ├── home_screen.dart    # Ana ekran
│   ├── cutting_plan_screen.dart  # Kesim planı ekranı
│   ├── result_screen.dart  # Sonuç ekranı
│   └── history_screen.dart # Geçmiş ekranı
├── services/               # Servisler
│   ├── database_service.dart  # SQLite veritabanı
│   └── pdf_service.dart      # PDF oluşturma
├── utils/                  # Yardımcı araçlar
│   └── app_theme.dart     # Tema ve renkler
└── widgets/               # Özel widget'lar
    └── cutting_layout_widget.dart
```

## 🛠️ Kullanılan Teknolojiler

### Flutter Paketleri
- **provider**: State management
- **sqflite**: Yerel veritabanı
- **pdf**: PDF oluşturma
- **share_plus**: Dosya paylaşımı
- **speech_to_text**: Sesli giriş
- **google_fonts**: Özel yazı tipleri
- **intl**: Tarih ve dil desteği

### Özellikler
- Material Design 3
- SQLite veritabanı
- Responsive tasarım
- Türkçe dil desteği

## 🎨 Tasarım Renk Paleti

- **Primary Wood**: `#8B4513` (Koyu Kahve)
- **Secondary Wood**: `#D2691E` (Orta Kahve)
- **Light Wood**: `#F5E6D3` (Açık Krem)
- **Accent Wood**: `#CD853F` (Peru)
- **Banded Color**: `#4CAF50` (Yeşil)
- **Unbanded Color**: `#FF9800` (Turuncu)

## 📋 Özellik Listesi

- [x] Giriş ekranı ve navigasyon
- [x] Parça ekleme/düzenleme/silme
- [x] Otomatik hesaplama
- [x] PDF oluşturma
- [x] WhatsApp paylaşımı
- [x] Geçmiş kayıtlar
- [x] Sesli giriş
- [x] Parça sıralama (büyükten küçüğe)
- [x] Yerel veri saklama
- [x] Bantlı/Bantsız gösterimi
- [x] Kesim planı görselleştirmesi
- [x] Dark mode desteği (hazır)

## 🔒 İzinler

Uygulama aşağıdaki izinleri gerektirir:
- **RECORD_AUDIO**: Sesli giriş için
- **WRITE_EXTERNAL_STORAGE**: PDF kaydetme için
- **READ_EXTERNAL_STORAGE**: PDF okuma için

## 📱 Sistem Gereksinimleri

- **Minimum**: Android 8.0 (API 26)
- **Hedef**: Android 14 (API 34)
- **Yönlendirme**: Sadece dikey mod

## 🤝 Katkıda Bulunma

1. Fork yapın
2. Feature branch oluşturun (`git checkout -b feature/amazing-feature`)
3. Commit yapın (`git commit -m 'Add some amazing feature'`)
4. Push edin (`git push origin feature/amazing-feature`)
5. Pull Request açın

## 📄 Lisans

Bu proje özel kullanım içindir.

## 📞 İletişim

**Muktar Marangoz**

---

⭐ Bu uygulamayı beğendiyseniz yıldız vermeyi unutmayın!

