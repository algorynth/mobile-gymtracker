import 'package:flutter/material.dart';

class AppColors {
  // Ana Renk Paleti - Mavi Tonları (Sade ve Tutarlı)
  static const primary = Color(0xFF3B82F6);       // Ana mavi
  static const primaryLight = Color(0xFF60A5FA);  // Açık mavi
  static const primaryDark = Color(0xFF1D4ED8);   // Koyu mavi
  
  // Nötr Renkler
  static const success = Color(0xFF22C55E);       // Yeşil (başarı)
  static const warning = Color(0xFFF59E0B);       // Turuncu (uyarı)
  static const error = Color(0xFFEF4444);         // Kırmızı (hata)

  // Dark Theme Arkaplan
  static const darkBackground = Color(0xFF0F172A);  // Çok koyu mavi-gri
  static const darkSurface = Color(0xFF1E293B);     // Koyu mavi-gri
  static const darkCard = Color(0xFF334155);        // Kart rengi
  static const darkBorder = Color(0xFF475569);      // Kenar rengi

  // Text Renkleri
  static const textPrimary = Color(0xFFF8FAFC);     // Beyaz
  static const textSecondary = Color(0xFF94A3B8);   // Gri
  static const textDisabled = Color(0xFF64748B);    // Koyu gri

  // Eski isimleri koruyalım (geriye uyumluluk)
  static const primaryColor = primary;
  static const primaryGradientStart = primary;
  static const primaryGradientEnd = primaryDark;
  static const accentOrange = warning;
  static const accentGreen = success;
  static const accentYellow = warning;
  static const accentPurple = primaryLight;
  static const info = primaryLight;
  
  // Light Theme (kullanılmıyor ama tutuyoruz)
  static const lightBackground = Color(0xFFF8FAFC);
  static const lightSurface = Color(0xFFFFFFFF);
  static const lightCard = Color(0xFFFFFFFF);
  static const lightBorder = Color(0xFFE2E8F0);
  static const textLight = Color(0xFF1E293B);
  
  // Chart Colors - Mavi tonları
  static const chartBlue = primary;
  static const chartGreen = success;
  static const chartOrange = warning;
  static const chartPurple = primaryLight;
  static const chartRed = error;
  static const chartPink = primaryLight;

  // Tek Gradient - Mavi tonları
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [darkCard, darkSurface],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient successGradient = LinearGradient(
    colors: [success, Color(0xFF16A34A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient warningGradient = LinearGradient(
    colors: [warning, Color(0xFFD97706)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Tüm diğer gradientler de ana renge bağlı
  static const LinearGradient chartGradient = primaryGradient;
  static const LinearGradient photoGradient = primaryGradient;
}
