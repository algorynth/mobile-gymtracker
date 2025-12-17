import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_colors.dart';
import '../providers/workout_provider.dart';
import '../providers/user_profile_provider.dart';
import '../utils/validators.dart';
import '../data/exercise_library.dart';
import '../models/workout.dart';
import 'workout_templates_screen.dart';

class WorkoutScreen extends ConsumerStatefulWidget {
  const WorkoutScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends ConsumerState<WorkoutScreen> {
  @override
  Widget build(BuildContext context) {
    final workouts = ref.watch(workoutsProvider);
    final stats = ref.watch(workoutStatsProvider);

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        title: const Text('Antrenmanlarım'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stats Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: AppColors.successGradient,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatColumn(
                        'Toplam',
                        '${stats['totalWorkouts'] ?? 0}',
                        'antrenman',
                      ),
                      Container(
                        width: 1,
                        height: 50,
                        color: AppColors.textPrimary.withOpacity(0.3),
                      ),
                      _buildStatColumn(
                        'Bu Hafta',
                        '${stats['thisWeekWorkouts'] ?? 0}',
                        'antrenman',
                      ),
                      Container(
                        width: 1,
                        height: 50,
                        color: AppColors.textPrimary.withOpacity(0.3),
                      ),
                      _buildStatColumn(
                        'Toplam',
                        '${stats['totalSets'] ?? 0}',
                        'set',
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Start Workout Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  _showExerciseSelector(context);
                },
                icon: const Icon(Icons.play_circle_outline_rounded, size: 28),
                label: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text('Yeni Antrenman Başlat'),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Templates Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const WorkoutTemplatesScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.library_books_rounded, size: 24),
                label: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text('Hazır Antrenman Şablonları'),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.textPrimary,
                  side: const BorderSide(color: AppColors.primaryColor),
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Workout History
            Text(
              'Antrenman Geçmişi',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),

            if (workouts.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(40),
                  child: Column(
                    children: [
                      Icon(
                        Icons.fitness_center_rounded,
                        size: 80,
                        color: AppColors.textSecondary.withOpacity(0.5),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Henüz antrenman yok',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'İlk antrenmanına başla!',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.textDisabled,
                            ),
                      ),
                    ],
                  ),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: workouts.length,
                itemBuilder: (context, index) {
                  final workout = workouts[index];
                  return _buildWorkoutCard(workout);
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(String label, String value, String unit) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          '$label\n$unit',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textPrimary.withOpacity(0.8),
              ),
        ),
      ],
    );
  }

  Widget _buildWorkoutCard(Workout workout) {
    final sets = ref.read(workoutsProvider.notifier).getSets(workout);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.fitness_center_rounded,
                color: AppColors.primaryColor,
              ),
            ),
            title: Text(
              workout.exerciseName,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            subtitle: Text(
              '${sets.length} set • ${workout.durationMinutes} dk',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline, color: AppColors.error),
              onPressed: () async {
                await ref.read(workoutsProvider.notifier).deleteWorkout(workout);
              },
            ),
          ),
          if (sets.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                children: [
                  const Divider(color: AppColors.darkBorder),
                  const SizedBox(height: 8),
                  ...sets.map((set) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Set ${set.setNumber}',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            Text(
                              '${set.weightKg}kg × ${set.reps} tekrar',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            ),
        ],
      ),
    );
  }

  void _showExerciseSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.darkSurface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) {
          return Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.textSecondary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Egzersiz Seç',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: ExerciseLibrary.predefinedExercises.length,
                  itemBuilder: (context, index) {
                    final exercise = ExerciseLibrary.predefinedExercises[index];
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      tileColor: AppColors.darkCard,
                      title: Text(exercise.name),
                      subtitle: Text(
                        _getMuscleGroupName(exercise.muscleGroup),
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: AppColors.textSecondary,
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        _startWorkout(exercise.id, exercise.name);
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _startWorkout(String exerciseId, String exerciseName) async {
    final workout = await ref.read(workoutsProvider.notifier).createWorkout(
          exerciseId: exerciseId,
          exerciseName: exerciseName,
        );

    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => WorkoutSessionScreen(workout: workout),
        ),
      );
    }
  }

  String _getMuscleGroupName(String muscleGroup) {
    const map = {
      'chest': 'Göğüs',
      'back': 'Sırt',
      'legs': 'Bacak',
      'shoulders': 'Omuz',
      'arms': 'Kol',
      'core': 'Karın',
      'full_body': 'Tüm Vücut',
    };
    return map[muscleGroup] ?? muscleGroup;
  }
}

// Workout Session Screen
class WorkoutSessionScreen extends ConsumerStatefulWidget {
  final Workout workout;

  const WorkoutSessionScreen({Key? key, required this.workout}) : super(key: key);

  @override
  ConsumerState<WorkoutSessionScreen> createState() => _WorkoutSessionScreenState();
}

class _WorkoutSessionScreenState extends ConsumerState<WorkoutSessionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _weightController = TextEditingController();
  final _repsController = TextEditingController();
  late DateTime _startTime;

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now();
  }

  @override
  void dispose() {
    _weightController.dispose();
    _repsController.dispose();
    super.dispose();
  }

  Future<void> _addSet() async {
    if (_formKey.currentState!.validate()) {
      await ref.read(workoutsProvider.notifier).addSet(
            workout: widget.workout,
            weightKg: double.parse(_weightController.text),
            reps: int.parse(_repsController.text),
          );

      _weightController.clear();
      _repsController.clear();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Set eklendi!'),
            backgroundColor: AppColors.success,
            duration: Duration(seconds: 1),
          ),
        );
      }
    }
  }

  Future<void> _finishWorkout() async {
    final duration = DateTime.now().difference(_startTime).inMinutes;
    await ref.read(workoutsProvider.notifier).completeWorkout(
          widget.workout,
          duration > 0 ? duration : 1,
        );

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Antrenman tamamlandı! 💪'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final sets = ref.watch(workoutsProvider.notifier).getSets(widget.workout);

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        title: Text(widget.workout.exerciseName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Set Entry Form
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.darkCard,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Set ${sets.length + 1}',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _weightController,
                            keyboardType: TextInputType.number,
                            validator: Validators.isPositive,
                            decoration: const InputDecoration(
                              labelText: 'Ağırlık (kg)',
                              hintText: '75',
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: _repsController,
                            keyboardType: TextInputType.number,
                            validator: Validators.isValidReps,
                            decoration: const InputDecoration(
                              labelText: 'Tekrar',
                              hintText: '10',
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _addSet,
                        child: const Text('Set Ekle'),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Sets List
            Text(
              'Tamamlanan Setler',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),

            Expanded(
              child: sets.isEmpty
                  ? Center(
                      child: Text(
                        'Henüz set eklemedin',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: sets.length,
                      itemBuilder: (context, index) {
                        final set = sets[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.darkCard,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: AppColors.primaryColor.withOpacity(0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    '${set.setNumber}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          color: AppColors.primaryColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  '${set.weightKg}kg × ${set.reps} tekrar',
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                              ),
                              Text(
                                '${set.volume.toStringAsFixed(0)} kg',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: sets.isNotEmpty
          ? SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: ElevatedButton(
                  onPressed: _finishWorkout,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.success,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Antrenmanı Tamamla'),
                ),
              ),
            )
          : null,
    );
  }
}
