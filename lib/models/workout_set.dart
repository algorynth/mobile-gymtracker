import 'package:hive/hive.dart';

part 'workout_set.g.dart';

@HiveType(typeId: 3)
class WorkoutSet extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final int setNumber;

  @HiveField(2)
  final double weightKg;

  @HiveField(3)
  final int reps;

  @HiveField(4)
  final bool isCompleted;

  @HiveField(5)
  final String? notes;

  WorkoutSet({
    required this.id,
    required this.setNumber,
    required this.weightKg,
    required this.reps,
    this.isCompleted = false,
    this.notes,
  });

  WorkoutSet copyWith({
    int? setNumber,
    double? weightKg,
    int? reps,
    bool? isCompleted,
    String? notes,
  }) {
    return WorkoutSet(
      id: id,
      setNumber: setNumber ?? this.setNumber,
      weightKg: weightKg ?? this.weightKg,
      reps: reps ?? this.reps,
      isCompleted: isCompleted ?? this.isCompleted,
      notes: notes ?? this.notes,
    );
  }

  // 1RM hesaplama (Epley formülü)
  double get estimatedOneRepMax {
    return weightKg * (1 + reps / 30);
  }

  // Toplam hacim hesaplama (set x tekrar x ağırlık)
  double get volume {
    return weightKg * reps;
  }
}
