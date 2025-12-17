import 'package:hive/hive.dart';

part 'exercise.g.dart';

@HiveType(typeId: 2)
class Exercise extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String category; // 'strength', 'cardio', 'flexibility'

  @HiveField(3)
  final String muscleGroup; // 'chest', 'back', 'legs', 'shoulders', 'arms', 'core', 'full_body'

  @HiveField(4)
  final String? description;

  @HiveField(5)
  final String? imageUrl;

  @HiveField(6)
  final bool isCustom; // Kullanıcının eklediği egzersiz mi?

  Exercise({
    required this.id,
    required this.name,
    required this.category,
    required this.muscleGroup,
    this.description,
    this.imageUrl,
    this.isCustom = false,
  });
}
