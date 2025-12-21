import 'package:flutter/material.dart';

class AppColors {
  // Ana Renk Paleti - Modern Mor-Mavi Gradient
  static const primary = Color(0xFF667EEA);         // Ana mor-mavi
  static const primaryLight = Color(0xFF9F7AEA);    // Açık mor
  static const primaryDark = Color(0xFF764BA2);     // Koyu mor
  
  // Accent Renkler - Canlı ve Modern
  static const accentOrange = Color(0xFFF97316);    // Turuncu vurgu
  static const accentGreen = Color(0xFF10B981);     // Yeşil (başarı)
  static const accentPurple = Color(0xFFA855F7);    // Parlak mor
  static const accentPink = Color(0xFFEC4899);      // Pembe
  static const accentCyan = Color(0xFF06B6D4);      // Cyan
  
  // Durum Renkleri
  static const success = Color(0xFF10B981);         // Yeşil
  static const warning = Color(0xFFF59E0B);         // Turuncu
  static const error = Color(0xFFEF4444);           // Kırmızı
  static const info = Color(0xFF3B82F6);            // Mavi

  // Dark Theme Arkaplan - Derin ve Premium
  static const darkBackground = Color(0xFF0D1117);  // Çok koyu
  static const darkSurface = Color(0xFF161B22);     // Koyu yüzey
  static const darkCard = Color(0xFF21262D);        // Kart rengi
  static const darkBorder = Color(0xFF30363D);      // Kenar rengi
  static const darkElevated = Color(0xFF2D333B);    // Yükseltilmiş yüzey

  // Text Renkleri
  static const textPrimary = Color(0xFFF0F6FC);     // Beyaz
  static const textSecondary = Color(0xFF8B949E);   // Gri
  static const textDisabled = Color(0xFF484F58);    // Koyu gri

  // Eski isimleri koruyalım (geriye uyumluluk)
  static const primaryColor = primary;
  static const primaryGradientStart = primary;
  static const primaryGradientEnd = primaryDark;
  static const accentYellow = warning;
  
  // Light Theme
  static const lightBackground = Color(0xFFF6F8FA);
  static const lightSurface = Color(0xFFFFFFFF);
  static const lightCard = Color(0xFFFFFFFF);
  static const lightBorder = Color(0xFFD0D7DE);
  static const textLight = Color(0xFF1F2328);
  
  // Chart Colors - Canlı ve Çeşitli
  static const chartBlue = Color(0xFF3B82F6);
  static const chartGreen = Color(0xFF10B981);
  static const chartOrange = Color(0xFFF97316);
  static const chartPurple = Color(0xFFA855F7);
  static const chartPink = Color(0xFFEC4899);
  static const chartCyan = Color(0xFF06B6D4);
  static const chartRed = Color(0xFFEF4444);

  // Modern Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient heroGradient = LinearGradient(
    colors: [Color(0xFF667EEA), Color(0xFFA855F7), Color(0xFFEC4899)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFF21262D), Color(0xFF161B22)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient successGradient = LinearGradient(
    colors: [Color(0xFF10B981), Color(0xFF059669)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient warningGradient = LinearGradient(
    colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient orangeGradient = LinearGradient(
    colors: [Color(0xFFF97316), Color(0xFFEA580C)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient pinkGradient = LinearGradient(
    colors: [Color(0xFFEC4899), Color(0xFFDB2777)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cyanGradient = LinearGradient(
    colors: [Color(0xFF06B6D4), Color(0xFF0891B2)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Chart ve Photo gradientleri
  static const LinearGradient chartGradient = primaryGradient;
  static const LinearGradient photoGradient = pinkGradient;

  // Glassmorphism için
  static Color glassWhite = Colors.white.withOpacity(0.1);
  static Color glassBorder = Colors.white.withOpacity(0.2);
}
