# 🚀 GitHub'a Yükleme Rehberi (Adım Adım)

## 🎯 YÖNTEM 1: GitHub Desktop ile (EN KOLAY) ⭐

### Adım 1: GitHub Desktop İndirin
1. https://desktop.github.com/ adresine gidin
2. **"Download for Windows"** tıklayın
3. İndirilen dosyayı çalıştırın ve kurun

### Adım 2: GitHub Hesabı Açın (Henüz yoksa)
1. https://github.com/signup adresine gidin
2. Email adresinizi girin
3. Şifre oluşturun
4. Kullanıcı adı seçin
5. Email'inizi doğrulayın

### Adım 3: GitHub Desktop'ta Giriş Yapın
1. GitHub Desktop'ı açın
2. **"Sign in to GitHub.com"** tıklayın
3. Tarayıcı açılacak, giriş yapın
4. **"Authorize desktop"** tıklayın

### Adım 4: Projeyi Ekleyin
1. GitHub Desktop'ta **"Add a Local Repository"** tıklayın
2. **"Choose..."** butonuna tıklayın
3. Proje klasörünü seçin: `C:\Users\AHMET KAAN\Desktop\medefe`
4. Eğer "not a Git repository" hatası verirse:
   - **"create a repository"** tıklayın
   - **"Create Repository"** onaylayın

### Adım 5: İlk Commit
1. Sol altta **Summary** kutusuna yazın: `İlk commit - Muktar Marangoz uygulaması`
2. **"Commit to main"** butonuna tıklayın

### Adım 6: GitHub'a Yükleyin
1. Üstte **"Publish repository"** tıklayın
2. Repo adı: `muktar-marangoz`
3. Açıklama: `MDF Kesim Hesaplama Uygulaması`
4. ✅ **"Keep this code private"** işaretini kaldırın (public olsun ki Actions çalışsın)
5. **"Publish Repository"** tıklayın

### ✅ TAMAM! GitHub'a Yüklendi!

### Adım 7: APK'yı İndirin
1. Tarayıcıda GitHub'daki projenize gidin: `https://github.com/KULLANICI_ADINIZ/muktar-marangoz`
2. Üstte **"Actions"** sekmesine tıklayın
3. **"Build APK"** workflow'unu göreceksiniz
4. İlk build otomatik başlayacak (5-10 dakika sürer)
5. Build bitince yeşil ✓ işareti çıkacak
6. Tıklayın ve **"Artifacts"** bölümünden APK'yı indirin

---

## 🎯 YÖNTEM 2: Git Komut Satırı ile

### Adım 1: Git Kurun
1. https://git-scm.com/download/win
2. İndirin ve kurun (hep Next diyebilirsiniz)

### Adım 2: Git Yapılandırın
Terminalde (CMD veya PowerShell):
```bash
git config --global user.name "Adınız Soyadınız"
git config --global user.email "email@example.com"
```

### Adım 3: GitHub'da Repo Oluşturun
1. https://github.com/new adresine gidin
2. Repository name: `muktar-marangoz`
3. Description: `MDF Kesim Hesaplama Uygulaması`
4. **Public** seçin
5. **"Create repository"** tıklayın

### Adım 4: Projeyi Yükleyin
```bash
cd C:\Users\AHMET KAAN\Desktop\medefe

git init
git add .
git commit -m "İlk commit - Muktar Marangoz uygulaması"
git branch -M main
git remote add origin https://github.com/KULLANICI_ADINIZ/muktar-marangoz.git
git push -u origin main
```

GitHub kullanıcı adı ve şifrenizi soracak, girin.

### ✅ Yüklendi!

---

## 🎯 YÖNTEM 3: GitHub Web Arayüzü ile (Manuel)

### Adım 1: GitHub'da Repo Oluşturun
1. https://github.com/new
2. Repo adı: `muktar-marangoz`
3. Public seçin
4. **"Create repository"** tıklayın

### Adım 2: Dosyaları Yükleyin
1. **"uploading an existing file"** linkine tıklayın
2. Tüm proje klasörünü sürükleyip bırakın
   - VEYA **"choose your files"** ile tek tek seçin
3. **"Commit changes"** tıklayın

⚠️ **Not:** Bu yöntemle büyük projeler yüklenmeyebilir. GitHub Desktop önerilir.

---

## 📱 GitHub Actions APK Oluşturma (Otomatik)

Projeyi yükledikten sonra:

### 1. Actions Sekmesine Gidin
```
https://github.com/KULLANICI_ADINIZ/muktar-marangoz/actions
```

### 2. Workflow'u Etkinleştirin
- İlk kez görüyorsanız **"I understand my workflows, go ahead and enable them"** tıklayın

### 3. Build Başlayacak
- Otomatik olarak build başlar
- Veya **"Run workflow"** > **"Run workflow"** ile manuel başlatabilirsiniz

### 4. Build Takibi
- Build'e tıklayın
- Adımları göreceksiniz:
  - ✓ Checkout code
  - ✓ Setup Java
  - ✓ Setup Flutter
  - ✓ Install dependencies
  - ✓ Build APK
  - ✓ Upload APK

### 5. APK'yı İndirin
- Build bitince (yeşil ✓)
- Aşağı inin **"Artifacts"** bölümüne
- **"muktar-marangoz-release"** tıklayın
- ZIP inecek, açın
- İçinde `app-release.apk` var!

### ✅ APK HAZIR! 🎉

---

## ❓ Sık Sorulan Sorular

### Build başlamıyor?
- Actions sekmesinde workflow'u enable etmeyi unutmayın
- Repo **Public** olmalı (veya GitHub Pro hesabı)

### Build hata veriyor?
- `.github/workflows/build-apk.yml` dosyası doğru yüklenmiş mi kontrol edin
- Actions sekmesinde hata loglarını okuyun

### APK nerede?
```
Actions > Build tamamlanmış workflow > En altta Artifacts bölümü
```

### Her değişiklikte yeni APK?
- Evet! Her commit'te otomatik build olur
- Veya Actions sekmesinden manuel başlatabilirsiniz

### Private repo'da çalışır mı?
- Evet ama GitHub Pro veya GitHub Teams gerekir
- Ücretsiz hesapta Public repo olmalı

---

## 💡 İpuçları

### 1. İlk Build Uzun Sürer
- İlk build 10-15 dakika sürebilir
- Sonraki build'ler 5-7 dakika

### 2. Build Durumunu Kontrol Edin
```
https://github.com/KULLANICI_ADINIZ/muktar-marangoz/actions
```

### 3. APK Versiyonları
- Her build'in APK'sı 90 gün saklanır
- İstediğiniz build'in APK'sını indirebilirsiniz

### 4. Hata Durumunda
- Build'e tıklayın
- Hangi adımda hata aldığını görün
- Google'da arayın veya bana sorun

---

## 🎊 Özet

1. ✅ **GitHub Desktop** kurun (en kolay)
2. ✅ **GitHub hesabı** açın
3. ✅ Projeyi **Publish** edin
4. ✅ **Actions** sekmesinden APK indirin
5. ✅ **Telefona kurun**

**Toplam Süre:** 15-20 dakika

---

## 🆘 Yardım

Herhangi bir sorun yaşarsanız:

1. GitHub Desktop'tan screenshot alın
2. Hata mesajını kopyalayın
3. Bana gönderin

---

**🚀 Haydi başlayın! GitHub Desktop indirin ve projeyi yükleyin!**

*Son Güncelleme: 23 Ekim 2025*


