import 'package:hive/hive.dart';

part 'workout_template.g.dart';

@HiveType(typeId: 8)
class WorkoutTemplate {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String? description;

  @HiveField(3)
  final List<TemplateExercise> exercises;

  @HiveField(4)
  final String category; // 'push', 'pull', 'legs', 'upper', 'lower', 'full_body', 'custom'

  @HiveField(5)
  final int estimatedDuration; // dakika

  @HiveField(6)
  final DateTime createdAt;

  WorkoutTemplate({
    required this.id,
    required this.name,
    this.description,
    required this.exercises,
    this.category = 'custom',
    this.estimatedDuration = 60,
    required this.createdAt,
  });

  WorkoutTemplate copyWith({
    String? id,
    String? name,
    String? description,
    List<TemplateExercise>? exercises,
    String? category,
    int? estimatedDuration,
    DateTime? createdAt,
  }) {
    return WorkoutTemplate(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      exercises: exercises ?? this.exercises,
      category: category ?? this.category,
      estimatedDuration: estimatedDuration ?? this.estimatedDuration,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

@HiveType(typeId: 9)
class TemplateExercise {
  @HiveField(0)
  final String exerciseId;

  @HiveField(1)
  final String exerciseName;

  @HiveField(2)
  final int targetSets;

  @HiveField(3)
  final int targetReps;

  @HiveField(4)
  final double? targetWeight;

  @HiveField(5)
  final int restSeconds;

  TemplateExercise({
    required this.exerciseId,
    required this.exerciseName,
    this.targetSets = 3,
    this.targetReps = 10,
    this.targetWeight,
    this.restSeconds = 90,
  });
}
