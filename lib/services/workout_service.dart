import 'package:uuid/uuid.dart';
import '../models/workout.dart';
import '../models/workout_set.dart';
import 'database_service.dart';

class WorkoutService {
  static const _uuid = Uuid();

  // Yeni antrenman başlat
  static Future<Workout> createWorkout({
    required String exerciseId,
    required String exerciseName,
    DateTime? workoutDate,
  }) async {
    final workout = Workout(
      id: _uuid.v4(),
      exerciseId: exerciseId,
      exerciseName: exerciseName,
      setIds: [],
      workoutDate: workoutDate ?? DateTime.now(),
    );

    await DatabaseService.workoutsBox.add(workout);
    return workout;
  }

  // Antrenman'a set ekle
  static Future<WorkoutSet> addSetToWorkout({
    required Workout workout,
    required double weightKg,
    required int reps,
    String? notes,
  }) async {
    final setNumber = workout.setIds.length + 1;
    final workoutSet = WorkoutSet(
      id: _uuid.v4(),
      setNumber: setNumber,
      weightKg: weightKg,
      reps: reps,
      notes: notes,
    );

    await DatabaseService.workoutSetsBox.add(workoutSet);

    // Workout'u güncelle
    final updatedSetIds = List<String>.from(workout.setIds)..add(workoutSet.id);
    final updatedWorkout = workout.copyWith(setIds: updatedSetIds);
    
    await workout.delete();
    await DatabaseService.workoutsBox.add(updatedWorkout);

    return workoutSet;
  }

  // Workout'u tamamla
  static Future<void> completeWorkout(Workout workout, int durationMinutes) async {
    final updatedWorkout = workout.copyWith(
      isCompleted: true,
      durationMinutes: durationMinutes,
    );

    await workout.delete();
    await DatabaseService.workoutsBox.add(updatedWorkout);
  }

  // Tüm workoutları al
  static List<Workout> getAllWorkouts() {
    final workouts = DatabaseService.workoutsBox.values.toList();
    workouts.sort((a, b) => b.workoutDate.compareTo(a.workoutDate));
    return workouts;
  }

  // Bugünün workoutlarını al
  static List<Workout> getTodaysWorkouts() {
    final today = DateTime.now();
    return getAllWorkouts().where((w) {
      return w.workoutDate.year == today.year &&
          w.workoutDate.month == today.month &&
          w.workoutDate.day == today.day;
    }).toList();
  }

  // Belirli bir egzersizin geçmişini al
  static List<Workout> getWorkoutsByExercise(String exerciseId) {
    return getAllWorkouts()
        .where((w) => w.exerciseId == exerciseId)
        .toList();
  }

  // Workout için tüm setleri al
  static List<WorkoutSet> getSetsForWorkout(Workout workout) {
    return workout.setIds
        .map((id) => DatabaseService.workoutSetsBox.values
            .firstWhere((set) => set.id == id))
        .toList();
  }

  // Set'i güncelle
  static Future<void> updateSet(
    WorkoutSet set, {
    double? weightKg,
    int? reps,
    bool? isCompleted,
    String? notes,
  }) async {
    final updatedSet = set.copyWith(
      weightKg: weightKg,
      reps: reps,
      isCompleted: isCompleted,
      notes: notes,
    );

    await set.delete();
    await DatabaseService.workoutSetsBox.add(updatedSet);
  }

  // Workout sil
  static Future<void> deleteWorkout(Workout workout) async {
    // Önce tüm setleri sil
    for (final setId in workout.setIds) {
      final set = DatabaseService.workoutSetsBox.values
          .firstWhere((s) => s.id == setId);
      await set.delete();
    }
    // Sonra workout'u sil
    await workout.delete();
  }

  // İstatistikler
  static Map<String, dynamic> getWorkoutStatistics() {
    final workouts = getAllWorkouts();
    final completedWorkouts = workouts.where((w) => w.isCompleted).toList();

    if (completedWorkouts.isEmpty) {
      return {
        'totalWorkouts': 0,
        'totalSets': 0,
        'averageDuration': 0.0,
        'thisWeekWorkouts': 0,
      };
    }

    final totalSets = completedWorkouts.fold<int>(
      0,
      (sum, w) => sum + w.totalSets,
    );

    final totalDuration = completedWorkouts.fold<int>(
      0,
      (sum, w) => sum + w.durationMinutes,
    );

    final thisWeek = DateTime.now().subtract(const Duration(days: 7));
    final thisWeekWorkouts = completedWorkouts
        .where((w) => w.workoutDate.isAfter(thisWeek))
        .length;

    return {
      'totalWorkouts': completedWorkouts.length,
      'totalSets': totalSets,
      'averageDuration': totalDuration / completedWorkouts.length,
      'thisWeekWorkouts': thisWeekWorkouts,
    };
  }
}
