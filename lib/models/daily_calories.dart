class DailyCalories {
  final double bmr; // Basal Metabolic Rate
  final double tdee; // Total Daily Energy Expenditure
  final double targetCalories; // Hedef kalori (kilo verme/alma/koruma için)
  final double proteinGrams;
  final double carbsGrams;
  final double fatGrams;
  final DateTime calculatedDate;

  DailyCalories({
    required this.bmr,
    required this.tdee,
    required this.targetCalories,
    required this.proteinGrams,
    required this.carbsGrams,
    required this.fatGrams,
    required this.calculatedDate,
  });

  // Kalori açığı/fazlası
  double get calorieDeficitOrSurplus {
    return targetCalories - tdee;
  }

  // Tahmini haftalık kilo değişimi (kg)
  double get estimatedWeeklyWeightChange {
    // 7700 kalori = 1 kg yağ
    return (calorieDeficitOrSurplus * 7) / 7700;
  }
}
