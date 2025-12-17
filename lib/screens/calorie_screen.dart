import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_colors.dart';
import '../providers/calorie_provider.dart';
import '../providers/user_profile_provider.dart';
import '../providers/body_measurements_provider.dart';

class CalorieScreen extends ConsumerWidget {
  const CalorieScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dailyCalories = ref.watch(dailyCaloriesProvider);
    final profile = ref.watch(userProfileProvider);
    final latestMeasurement = ref.watch(latestMeasurementProvider);

    if (profile == null || latestMeasurement == null) {
      return Scaffold(
        backgroundColor: AppColors.darkBackground,
        appBar: AppBar(title: const Text('Kalori Hesaplama')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.person_outline_rounded,
                  size: 100,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(height: 24),
                Text(
                  'Kalori hesaplama için önce profil oluşturun ve vücut ölçümü yapın',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        title: const Text('Kalori Hesaplama'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Main Calorie Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: AppColors.warningGradient,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.accentYellow.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.local_fire_department_rounded,
                    size: 64,
                    color: AppColors.textPrimary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Günlük Hedef Kalori',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColors.textPrimary,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${dailyCalories?.targetCalories.toStringAsFixed(0) ?? '--'} kcal',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _getGoalDescription(profile.goal),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textPrimary.withOpacity(0.9),
                        ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Metabolic Info
            Text(
              'Metabolizma Bilgileri',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.darkCard,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  _buildInfoRow(
                    context,
                    'BMR (Bazal Metabolizma)',
                    '${dailyCalories?.bmr.toStringAsFixed(0) ?? '--'} kcal',
                    Icons.nightlight_round,
                    'Dinlenme halinde yaktığınız kalori',
                  ),
                  const Divider(color: AppColors.darkBorder, height: 32),
                  _buildInfoRow(
                    context,
                    'TDEE (Toplam Harcama)',
                    '${dailyCalories?.tdee.toStringAsFixed(0) ?? '--'} kcal',
                    Icons.directions_run_rounded,
                    'Günlük toplam yaktığınız kalori',
                  ),
                  const Divider(color: AppColors.darkBorder, height: 32),
                  _buildInfoRow(
                    context,
                    'Aktivite Seviyesi',
                    _getActivityLevelName(profile.activityLevel),
                    Icons.fitness_center_rounded,
                    'Haftada ${_getActivityDays(profile.activityLevel)} gün antrenman',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Macros
            Text(
              'Makro Besinler',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: AppColors.cardGradient,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  _buildMacroRow(
                    context,
                    'Protein',
                    '${dailyCalories?.proteinGrams.toStringAsFixed(0) ?? '--'}g',
                    AppColors.accentOrange,
                    (dailyCalories?.proteinGrams ?? 0) * 4 /
                        (dailyCalories?.targetCalories ?? 1),
                  ),
                  const SizedBox(height: 16),
                  _buildMacroRow(
                    context,
                    'Karbonhidrat',
                    '${dailyCalories?.carbsGrams.toStringAsFixed(0) ?? '--'}g',
                    AppColors.accentGreen,
                    (dailyCalories?.carbsGrams ?? 0) * 4 /
                        (dailyCalories?.targetCalories ?? 1),
                  ),
                  const SizedBox(height: 16),
                  _buildMacroRow(
                    context,
                    'Yağ',
                    '${dailyCalories?.fatGrams.toStringAsFixed(0) ?? '--'}g',
                    AppColors.accentYellow,
                    (dailyCalories?.fatGrams ?? 0) * 9 /
                        (dailyCalories?.targetCalories ?? 1),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Estimated Weight Change
            if (dailyCalories != null) ...[
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.darkCard,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.primaryColor.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.trending_up_rounded,
                        color: AppColors.primaryColor,
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tahmini Haftalık Değişim',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${dailyCalories.estimatedWeeklyWeightChange >= 0 ? '+' : ''}${dailyCalories.estimatedWeeklyWeightChange.toStringAsFixed(2)} kg',
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryColor,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    String subtitle,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.primaryColor.withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppColors.primaryColor, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
            ],
          ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }

  Widget _buildMacroRow(
    BuildContext context,
    String name,
    String amount,
    Color color,
    double percentage,
  ) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  name,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            Text(
              amount,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: percentage.clamp(0.0, 1.0),
            backgroundColor: AppColors.darkBorder,
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 8,
          ),
        ),
      ],
    );
  }

  String _getGoalDescription(String goal) {
    switch (goal) {
      case 'lose_weight':
        return 'Kilo kaybı hedefi için günlük 500 kalori açığı';
      case 'gain_muscle':
        return 'Kas kazanımı için günlük 300 kalori fazlası';
      case 'maintain':
        return 'Mevcut kiloyu korumak için kalori dengesi';
      default:
        return '';
    }
  }

  String _getActivityLevelName(String level) {
    switch (level) {
      case 'sedentary':
        return 'Az Hareketli';
      case 'light':
        return 'Hafif Aktif';
      case 'moderate':
        return 'Orta Aktif';
      case 'active':
        return 'Çok Aktif';
      case 'very_active':
        return 'Ekstra Aktif';
      default:
        return '';
    }
  }

  String _getActivityDays(String level) {
    switch (level) {
      case 'sedentary':
        return '0-1';
      case 'light':
        return '1-3';
      case 'moderate':
        return '3-5';
      case 'active':
        return '6-7';
      case 'very_active':
        return '7+ (2x)';
      default:
        return '';
    }
  }
}
