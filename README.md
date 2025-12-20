# 💪 Gym Tracker

Modern, kapsamlı bir fitness takip uygulaması. Flutter ile geliştirildi.

![Flutter](https://img.shields.io/badge/Flutter-3.0+-02569B?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.0+-0175C2?logo=dart)
![Platform](https://img.shields.io/badge/Platform-Android%20|%20iOS%20|%20Web%20|%20Desktop-blue)
![License](https://img.shields.io/badge/License-MIT-green)
![Build](https://github.com/Mobile-Apps-Coop/mobile-gymtracker/actions/workflows/build-aab.yml/badge.svg)

## 📥 İndirme

[![Download AAB](https://img.shields.io/badge/Download-Latest%20AAB-green?style=for-the-badge&logo=android)](https://github.com/Mobile-Apps-Coop/mobile-gymtracker/releases/latest)

> **Not:** Her push işleminde otomatik olarak yeni bir AAB dosyası oluşturulur. En son sürümü yukarıdaki butona tıklayarak indirebilirsiniz.

## ✨ Özellikler

### 📊 Vücut Takibi
- Kilo, yağ oranı ve kas kütlesi takibi
- Trend grafikleri ile ilerleme görselleştirme
- Geçmiş ölçümleri listeleme

### 🔥 Kalori Hesaplama
- BMR (Bazal Metabolizma Hızı) hesaplama
- TDEE (Günlük Toplam Enerji Harcaması)
- Makro besin dağılımı (protein, karbonhidrat, yağ)
- Hedef bazlı kalori önerileri

### 🏋️ Antrenman Takibi
- Egzersiz ve set kayıt sistemi
- Hazır antrenman şablonları (Push/Pull/Legs, Full Body)
- Antrenman geçmişi ve istatistikler

### 📸 İlerleme Fotoğrafları
- Ön, yan ve arka açı kategorileri
- Kamera ve galeri entegrasyonu
- Tarih ve kilo ile eşleştirme

## 🛠️ Teknolojiler

| Teknoloji | Kullanım |
|-----------|----------|
| **Flutter** | Cross-platform UI framework |
| **Riverpod** | State management |
| **Hive** | Local database |
| **fl_chart** | Grafikler |
| **image_picker** | Fotoğraf seçimi |

## 🚀 Kurulum

```bash
# Repoyu klonla
git clone https://github.com/Mobile-Apps-Coop/mobile-gymtracker.git
cd mobile-gymtracker

# Bağımlılıkları yükle
flutter pub get

# Çalıştır
flutter run
```

## 📱 Platform Desteği

| Platform | Durum |
|----------|-------|
| Android | ✅ |
| iOS | ✅ |
| Web | ✅ |
| Linux | ✅ |
| macOS | ✅ |
| Windows | ✅ |

## 📁 Proje Yapısı

```
lib/
├── data/           # Egzersiz ve şablon verileri
├── models/         # Veri modelleri (Hive)
├── providers/      # Riverpod state yönetimi
├── screens/        # UI ekranları
├── services/       # İş mantığı servisleri
├── theme/          # Renk ve tema
├── utils/          # Yardımcı fonksiyonlar
├── widgets/        # Yeniden kullanılabilir widgetlar
└── main.dart       # Giriş noktası
```

## 🔄 CI/CD

Bu proje GitHub Actions kullanarak otomatik build yapar:

- Her `main` branch'e push yapıldığında AAB dosyası oluşturulur
- Oluşturulan AAB dosyaları [Releases](https://github.com/Mobile-Apps-Coop/mobile-gymtracker/releases) sayfasında yayınlanır

## 🤝 Katkıda Bulunma

1. Fork yapın
2. Feature branch oluşturun (`git checkout -b feature/yeni-ozellik`)
3. Commit yapın (`git commit -m 'Yeni özellik eklendi'`)
4. Push yapın (`git push origin feature/yeni-ozellik`)
5. Pull Request açın

## 📄 Lisans

MIT License - Detaylar için [LICENSE](LICENSE) dosyasına bakın.

---

⭐ Beğendiyseniz yıldız vermeyi unutmayın!
