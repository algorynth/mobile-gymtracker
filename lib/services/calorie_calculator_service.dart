import '../models/user_profile.dart';
import '../models/daily_calories.dart';

class CalorieCalculatorService {
  // BMR Hesaplama - Mifflin-St Jeor Formülü
  static double calculateBMR({
    required double weightKg,
    required double heightCm,
    required int age,
    required String gender,
  }) {
    if (gender.toLowerCase() == 'male') {
      return (10 * weightKg) + (6.25 * heightCm) - (5 * age) + 5;
    } else {
      return (10 * weightKg) + (6.25 * heightCm) - (5 * age) - 161;
    }
  }

  // TDEE Hesaplama (Aktivite seviyesi ile)
  static double calculateTDEE({
    required double bmr,
    required String activityLevel,
  }) {
    final multipliers = {
      'sedentary': 1.2, // Az hareketli (günde 0-1 gün antrenman)
      'light': 1.375, // Hafif aktif (günde 1-3 gün antrenman)
      'moderate': 1.55, // Orta aktif (günde 3-5 gün antrenman)
      'active': 1.725, // Çok aktif (günde 6-7 gün antrenman)
      'very_active': 1.9, // Ekstra aktif (günde 2x antrenman veya fiziksel iş)
    };

    final multiplier = multipliers[activityLevel] ?? 1.2;
    return bmr * multiplier;
  }

  // Hedef kaloriye göre ayarlama
  static double calculateTargetCalories({
    required double tdee,
    required String goal,
  }) {
    switch (goal) {
      case 'lose_weight':
        return tdee - 500; // Günlük 500 kalori açığı (~0.5kg/hafta)
      case 'gain_muscle':
        return tdee + 300; // Günlük 300 kalori fazlası
      case 'maintain':
      default:
        return tdee;
    }
  }

  // Makro besin hesaplama (protein, karbonhidrat, yağ)
  static Map<String, double> calculateMacros({
    required double targetCalories,
    required double weightKg,
    required String goal,
  }) {
    double proteinGrams;
    double fatGrams;
    double carbsGrams;

    if (goal == 'lose_weight') {
      // Kilo verirken: Yüksek protein, orta yağ, düşük karb
      proteinGrams = weightKg * 2.2; // 2.2g/kg
      fatGrams = (targetCalories * 0.25) / 9; // Kalorilerin %25'i yağdan
      final remainingCalories = targetCalories - (proteinGrams * 4) - (fatGrams * 9);
      carbsGrams = remainingCalories / 4;
    } else if (goal == 'gain_muscle') {
      // Kas kazanırken: Yüksek protein, orta-yüksek karb
      proteinGrams = weightKg * 2.0; // 2.0g/kg
      fatGrams = (targetCalories * 0.25) / 9;
      final remainingCalories = targetCalories - (proteinGrams * 4) - (fatGrams * 9);
      carbsGrams = remainingCalories / 4;
    } else {
      // Korurken: Dengeli
      proteinGrams = weightKg * 1.8; // 1.8g/kg
      fatGrams = (targetCalories * 0.30) / 9;
      final remainingCalories = targetCalories - (proteinGrams * 4) - (fatGrams * 9);
      carbsGrams = remainingCalories / 4;
    }

    return {
      'protein': proteinGrams,
      'carbs': carbsGrams,
      'fat': fatGrams,
    };
  }

  // Tüm hesaplamaları birleştir
  static DailyCalories calculateDailyCalories({
    required UserProfile profile,
    required double currentWeightKg,
  }) {
    final bmr = calculateBMR(
      weightKg: currentWeightKg,
      heightCm: profile.heightCm,
      age: profile.age,
      gender: profile.gender,
    );

    final tdee = calculateTDEE(
      bmr: bmr,
      activityLevel: profile.activityLevel,
    );

    final targetCalories = calculateTargetCalories(
      tdee: tdee,
      goal: profile.goal,
    );

    final macros = calculateMacros(
      targetCalories: targetCalories,
      weightKg: currentWeightKg,
      goal: profile.goal,
    );

    return DailyCalories(
      bmr: bmr,
      tdee: tdee,
      targetCalories: targetCalories,
      proteinGrams: macros['protein']!,
      carbsGrams: macros['carbs']!,
      fatGrams: macros['fat']!,
      calculatedDate: DateTime.now(),
    );
  }
}
