# Değişiklik Günlüğü

Muktar Marangoz uygulamasının tüm önemli değişiklikleri bu dosyada belgelenir.

## [1.0.0] - 2025-10-23

### ✨ Yeni Özellikler

#### Ana Özellikler
- 🏠 **Ana Ekran**: Kullanıcı dostu giriş ekranı ve navigasyon
- ➕ **Parça Yönetimi**: Parça ekleme, düzenleme ve silme
- 🔢 **Otomatik Hesaplama**: Gereken tabaka sayısı ve artık hesaplama
- 📄 **PDF Oluşturma**: Profesyonel görünümlü kesim planı PDF'leri
- 📱 **WhatsApp Entegrasyonu**: Doğrudan WhatsApp paylaşımı
- 📚 **Geçmiş Kayıtlar**: Tüm planları saklama ve görüntüleme
- 🎤 **Sesli Giriş**: Mikrofon ile ölçü girişi
- 🔄 **Otomatik Sıralama**: Parçaları büyükten küçüğe sıralama

#### Kullanıcı Arayüzü
- 🎨 Ahşap tonlarında modern tema
- 📱 Büyük butonlar ve yazılar (yaşlı kullanıcı dostu)
- 🟢 Bantlı parçalar için yeşil renk
- 🟠 Bantsız parçalar için turuncu renk
- 🌙 Dark mode desteği
- 📊 Görsel kesim planı temsili

#### Veri Yönetimi
- 💾 SQLite ile yerel veri saklama
- 🔄 Otomatik kaydetme
- 🗑️ Plan silme ve güncelleme
- 📈 İstatistik görüntüleme

#### PDF ve Paylaşım
- 📄 A4 format PDF oluşturma
- 📊 Detaylı parça listesi
- 📱 Özet bilgiler
- 🔗 Doğrudan paylaşım
- 💬 WhatsApp mesaj şablonu

### 🛠️ Teknik Özellikler
- Flutter 3.0+ desteği
- Material Design 3
- Provider state management
- SQLite veritabanı
- PDF generation
- Speech to text (Türkçe)
- Share functionality
- Permission handling

### 📦 Bağımlılıklar
- `provider: ^6.1.1` - State management
- `sqflite: ^2.3.0` - Yerel veritabanı
- `pdf: ^3.10.7` - PDF oluşturma
- `printing: ^5.11.1` - PDF yazdırma
- `share_plus: ^7.2.1` - Dosya paylaşımı
- `speech_to_text: ^6.6.0` - Sesli giriş
- `google_fonts: ^6.1.0` - Özel yazı tipleri
- `intl: ^0.18.1` - Dil ve tarih formatı
- `path_provider: ^2.1.1` - Dosya yolları
- `permission_handler: ^11.1.0` - İzin yönetimi
- `uuid: ^4.2.2` - Benzersiz ID'ler

### 📱 Platform Desteği
- Android 8.0+ (API 26)
- Target: Android 14 (API 34)

### 🎨 Tasarım
- Renk Paleti:
  - Primary Wood: `#8B4513`
  - Secondary Wood: `#D2691E`
  - Light Wood: `#F5E6D3`
  - Accent Wood: `#CD853F`
  - Banded: `#4CAF50`
  - Unbanded: `#FF9800`

### 📚 Dokümantasyon
- ✅ README.md
- ✅ GELISTIRME_REHBERI.md
- ✅ KULLANIM_KILAVUZU.md
- ✅ CHANGELOG.md
- ✅ Kod içi yorumlar

### 🔒 Güvenlik ve İzinler
- `RECORD_AUDIO` - Sesli giriş için
- `WRITE_EXTERNAL_STORAGE` - PDF kaydetme için
- `READ_EXTERNAL_STORAGE` - PDF okuma için
- WhatsApp intent desteği

### 🧪 Test
- Unit test yapısı hazır
- Widget test şablonları
- Integration test desteği

### 📊 Performans
- Const widget kullanımı
- Lazy loading
- ListView.builder optimizasyonu
- Minimal rebuild

## [Gelecek] - Planlanan Özellikler

### v1.1.0 (Yakında)
- [ ] Özel tabaka ölçüleri girişi
- [ ] Fiyat hesaplama modülü
- [ ] Maliyet analizi
- [ ] Daha gelişmiş kesim algoritması
- [ ] 2D kesim planı görselleştirmesi

### v1.2.0
- [ ] Bulut yedekleme (Firebase)
- [ ] Müşteri yönetim sistemi
- [ ] Excel export
- [ ] Email ile gönderme
- [ ] QR kod ile plan paylaşımı

### v1.3.0
- [ ] Çoklu dil desteği (İngilizce, Almanca)
- [ ] Farklı malzeme tipleri (LDF, Kontrplak vb.)
- [ ] Kenar bantı renk seçimi
- [ ] Stok takibi
- [ ] İstatistik ve raporlar

### v2.0.0
- [ ] iOS desteği
- [ ] Web versiyonu
- [ ] Kullanıcı hesapları
- [ ] Multi-tenancy
- [ ] API entegrasyonu
- [ ] Makine entegrasyonu

## Versiyon Notları

### Semantik Versiyonlama
Bu proje [Semantic Versioning](https://semver.org/) kullanır:
- **MAJOR**: Uyumsuz API değişiklikleri
- **MINOR**: Geriye dönük uyumlu yeni özellikler
- **PATCH**: Geriye dönük uyumlu hata düzeltmeleri

### Değişiklik Kategorileri
- **✨ Yeni Özellikler**: Yeni fonksiyonlar
- **🔧 Geliştirmeler**: Mevcut özelliklerin iyileştirilmesi
- **🐛 Hata Düzeltmeleri**: Bug fix'ler
- **📚 Dokümantasyon**: Doküman güncellemeleri
- **🎨 Stil**: UI/UX değişiklikleri
- **⚡ Performans**: Performans iyileştirmeleri
- **🔒 Güvenlik**: Güvenlik güncellemeleri
- **🗑️ Kaldırılan**: Kaldırılan özellikler

---

**Geliştiriciler:** Muktar Marangoz Ekibi
**İletişim:** [İletişim bilgisi]


