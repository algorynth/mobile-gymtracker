import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/daily_calories.dart';
import '../services/calorie_calculator_service.dart';
import 'user_profile_provider.dart';
import 'body_measurements_provider.dart';

// Daily Calories Provider
final dailyCaloriesProvider = Provider<DailyCalories?>((ref) {
  final profile = ref.watch(userProfileProvider);
  final latestMeasurement = ref.watch(latestMeasurementProvider);

  if (profile == null || latestMeasurement == null) {
    return null;
  }

  return CalorieCalculatorService.calculateDailyCalories(
    profile: profile,
    currentWeightKg: latestMeasurement.weightKg,
  );
});

// BMR Provider
final bmrProvider = Provider<double?>((ref) {
  final calories = ref.watch(dailyCaloriesProvider);
  return calories?.bmr;
});

// TDEE Provider
final tdeeProvider = Provider<double?>((ref) {
  final calories = ref.watch(dailyCaloriesProvider);
  return calories?.tdee;
});

// Target Calories Provider
final targetCaloriesProvider = Provider<double?>((ref) {
  final calories = ref.watch(dailyCaloriesProvider);
  return calories?.targetCalories;
});
