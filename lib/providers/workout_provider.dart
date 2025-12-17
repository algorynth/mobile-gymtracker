import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/workout.dart';
import '../models/workout_set.dart';
import '../services/workout_service.dart';

// Workouts List Provider
final workoutsProvider = StateNotifierProvider<WorkoutsNotifier, List<Workout>>((ref) {
  return WorkoutsNotifier();
});

class WorkoutsNotifier extends StateNotifier<List<Workout>> {
  WorkoutsNotifier() : super([]) {
    _loadWorkouts();
  }

  void _loadWorkouts() {
    state = WorkoutService.getAllWorkouts();
  }

  Future<Workout> createWorkout({
    required String exerciseId,
    required String exerciseName,
    DateTime? workoutDate,
  }) async {
    final workout = await WorkoutService.createWorkout(
      exerciseId: exerciseId,
      exerciseName: exerciseName,
      workoutDate: workoutDate,
    );
    _loadWorkouts();
    return workout;
  }

  Future<WorkoutSet> addSet({
    required Workout workout,
    required double weightKg,
    required int reps,
    String? notes,
  }) async {
    final set = await WorkoutService.addSetToWorkout(
      workout: workout,
      weightKg: weightKg,
      reps: reps,
      notes: notes,
    );
    _loadWorkouts();
    return set;
  }

  Future<void> completeWorkout(Workout workout, int durationMinutes) async {
    await WorkoutService.completeWorkout(workout, durationMinutes);
    _loadWorkouts();
  }

  Future<void> deleteWorkout(Workout workout) async {
    await WorkoutService.deleteWorkout(workout);
    _loadWorkouts();
  }

  List<Workout> getTodaysWorkouts() {
    return WorkoutService.getTodaysWorkouts();
  }

  List<WorkoutSet> getSets(Workout workout) {
    return WorkoutService.getSetsForWorkout(workout);
  }

  void refresh() {
    _loadWorkouts();
  }
}

// Today's Workouts Provider
final todaysWorkoutsProvider = Provider<List<Workout>>((ref) {
  final workouts = ref.watch(workoutsProvider);
  final today = DateTime.now();
  return workouts.where((w) {
    return w.workoutDate.year == today.year &&
        w.workoutDate.month == today.month &&
        w.workoutDate.day == today.day;
  }).toList();
});

// Workout Statistics Provider
final workoutStatsProvider = Provider<Map<String, dynamic>>((ref) {
  ref.watch(workoutsProvider); // Watch to trigger rebuild
  return WorkoutService.getWorkoutStatistics();
});
