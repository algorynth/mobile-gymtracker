import 'package:hive/hive.dart';
import 'workout_set.dart';

part 'workout.g.dart';

@HiveType(typeId: 4)
class Workout extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String exerciseId;

  @HiveField(2)
  final String exerciseName;

  @HiveField(3)
  final List<String> setIds; // WorkoutSet ID'leri

  @HiveField(4)
  final DateTime workoutDate;

  @HiveField(5)
  final int durationMinutes;

  @HiveField(6)
  final String? notes;

  @HiveField(7)
  final bool isCompleted;

  Workout({
    required this.id,
    required this.exerciseId,
    required this.exerciseName,
    required this.setIds,
    required this.workoutDate,
    this.durationMinutes = 0,
    this.notes,
    this.isCompleted = false,
  });

  // Toplam set sayısı
  int get totalSets => setIds.length;

  Workout copyWith({
    String? exerciseId,
    String? exerciseName,
    List<String>? setIds,
    DateTime? workoutDate,
    int? durationMinutes,
    String? notes,
    bool? isCompleted,
  }) {
    return Workout(
      id: id,
      exerciseId: exerciseId ?? this.exerciseId,
      exerciseName: exerciseName ?? this.exerciseName,
      setIds: setIds ?? this.setIds,
      workoutDate: workoutDate ?? this.workoutDate,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      notes: notes ?? this.notes,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
