import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_colors.dart';
import '../providers/body_measurements_provider.dart';
import '../providers/calorie_provider.dart';
import '../providers/workout_provider.dart';
import '../widgets/metric_card.dart';
import 'body_tracking_screen.dart';
import 'calorie_screen.dart';
import 'workout_screen.dart';
import 'profile_screen.dart';
import 'progress_charts_screen.dart';
import 'progress_photos_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const BodyTrackingScreen(),
    const WorkoutScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppColors.darkSurface,
          selectedItemColor: AppColors.primaryColor,
          unselectedItemColor: AppColors.textSecondary,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_rounded),
              label: 'Ana Sayfa',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.monitor_weight_rounded),
              label: 'Vücut',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.fitness_center_rounded),
              label: 'Antrenman',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded),
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final latestMeasurement = ref.watch(latestMeasurementProvider);
    final dailyCalories = ref.watch(dailyCaloriesProvider);
    final workoutStats = ref.watch(workoutStatsProvider);

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        title: const Text('Gym Tracker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Section
            Text(
              'Hoş Geldin! 💪',
              style: Theme.of(context).textTheme.displaySmall,
            ),
            const SizedBox(height: 8),
            Text(
              'İşte bugünkü özetin',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
            const SizedBox(height: 24),

            // Metrics Grid
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.1,
              children: [
                MetricCard(
                  title: 'Mevcut Kilo',
                  value: latestMeasurement?.weightKg.toStringAsFixed(1) ?? '--',
                  unit: 'kg',
                  icon: Icons.monitor_weight_rounded,
                  color: AppColors.accentGreen,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const BodyTrackingScreen(),
                      ),
                    );
                  },
                ),
                MetricCard(
                  title: 'Yağ Oranı',
                  value: latestMeasurement?.bodyFatPercentage?.toStringAsFixed(1) ?? '--',
                  unit: '%',
                  icon: Icons.pie_chart_rounded,
                  color: AppColors.accentOrange,
                ),
                MetricCard(
                  title: 'Kas Oranı',
                  value: latestMeasurement?.muscleMassPercentage?.toStringAsFixed(1) ?? '--',
                  unit: '%',
                  icon: Icons.fitness_center_rounded,
                  color: AppColors.accentPurple,
                ),
                MetricCard(
                  title: 'Günlük Kalori',
                  value: dailyCalories?.targetCalories.toStringAsFixed(0) ?? '--',
                  unit: 'kcal',
                  icon: Icons.local_fire_department_rounded,
                  color: AppColors.accentYellow,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const CalorieScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Weekly Stats Section
            Text(
              'Bu Hafta',
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
                  _buildStatRow(
                    context,
                    'Tamamlanan Antrenman',
                    '${workoutStats['thisWeekWorkouts'] ?? 0}',
                    Icons.check_circle_outline,
                  ),
                  const Divider(color: AppColors.darkBorder, height: 32),
                  _buildStatRow(
                    context,
                    'Toplam Set',
                    '${workoutStats['totalSets'] ?? 0}',
                    Icons.fitness_center_rounded,
                  ),
                  const Divider(color: AppColors.darkBorder, height: 32),
                  _buildStatRow(
                    context,
                    'Ortalama Süre',
                    '${(workoutStats['averageDuration'] ?? 0).toStringAsFixed(0)} dk',
                    Icons.timer_outlined,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Quick Actions
            Text(
              'Hızlı İşlemler',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildQuickAction(
                    context,
                    'Ölçüm Ekle',
                    Icons.add_chart_rounded,
                    AppColors.primaryGradient,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const BodyTrackingScreen(),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildQuickAction(
                    context,
                    'Antrenman Başlat',
                    Icons.play_circle_outline_rounded,
                    AppColors.successGradient,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const WorkoutScreen(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildQuickAction(
                    context,
                    'İlerleme Grafikleri',
                    Icons.show_chart_rounded,
                    AppColors.chartGradient,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ProgressChartsScreen(),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildQuickAction(
                    context,
                    'Fotoğraf Galerisi',
                    Icons.photo_camera_rounded,
                    AppColors.photoGradient,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ProgressPhotosScreen(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(BuildContext context, String label, String value, IconData icon) {
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
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyLarge,
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

  Widget _buildQuickAction(
    BuildContext context,
    String label,
    IconData icon,
    Gradient gradient,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.textPrimary, size: 32),
            const SizedBox(height: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
