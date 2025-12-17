import 'package:hive/hive.dart';

part 'user_profile.g.dart';

@HiveType(typeId: 0)
class UserProfile extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  int age;

  @HiveField(3)
  String gender; // 'male' or 'female'

  @HiveField(4)
  double heightCm;

  @HiveField(5)
  String activityLevel; // 'sedentary', 'light', 'moderate', 'active', 'very_active'

  @HiveField(6)
  String goal; // 'lose_weight', 'maintain', 'gain_muscle'

  @HiveField(7)
  DateTime createdAt;

  @HiveField(8)
  DateTime updatedAt;

  UserProfile({
    required this.id,
    required this.name,
    required this.age,
    required this.gender,
    required this.heightCm,
    required this.activityLevel,
    required this.goal,
    required this.createdAt,
    required this.updatedAt,
  });

  UserProfile copyWith({
    String? name,
    int? age,
    String? gender,
    double? heightCm,
    String? activityLevel,
    String? goal,
  }) {
    return UserProfile(
      id: id,
      name: name ?? this.name,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      heightCm: heightCm ?? this.heightCm,
      activityLevel: activityLevel ?? this.activityLevel,
      goal: goal ?? this.goal,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }
}
