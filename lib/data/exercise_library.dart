import '../models/exercise.dart';
import 'package:uuid/uuid.dart';

class ExerciseLibrary {
  static const _uuid = Uuid();

  // Önceden tanımlı egzersizler
  static final List<Exercise> predefinedExercises = [
    // GÖĞÜS EGZERSİZLERİ
    Exercise(
      id: _uuid.v4(),
      name: 'Bench Press (Düz Bank Press)',
      category: 'strength',
      muscleGroup: 'chest',
      description: 'Göğüs kaslarının genel gelişimi için temel egzersiz',
      isCustom: false,
    ),
    Exercise(
      id: _uuid.v4(),
      name: 'Incline Bench Press (Eğimli Bank Press)',
      category: 'strength',
      muscleGroup: 'chest',
      description: 'Üst göğüs kaslarını hedefler',
      isCustom: false,
    ),
    Exercise(
      id: _uuid.v4(),
      name: 'Dumbbell Fly (Dambıl Flye)',
      category: 'strength',
      muscleGroup: 'chest',
      description: 'Göğüs kaslarını izole eden hareket',
      isCustom: false,
    ),
    Exercise(
      id: _uuid.v4(),
      name: 'Push-ups (Şınav)',
      category: 'strength',
      muscleGroup: 'chest',
      description: 'Vücut ağırlığı ile yapılan temel göğüs egzersizi',
      isCustom: false,
    ),

    // SIRT EGZERSİZLERİ
    Exercise(
      id: _uuid.v4(),
      name: 'Barbell Row (Barfiks Kürek)',
      category: 'strength',
      muscleGroup: 'back',
      description: 'Sırt kasları için compound hareket',
      isCustom: false,
    ),
    Exercise(
      id: _uuid.v4(),
      name: 'Pull-ups (Barfiks)',
      category: 'strength',
      muscleGroup: 'back',
      description: 'Sırt genişliği  için klasik egzersiz',
      isCustom: false,
    ),
    Exercise(
      id: _uuid.v4(),
      name: 'Lat Pulldown (Ön Çekiş)',
      category: 'strength',
      muscleGroup: 'back',
      description: 'Latissimus dorsi kaslarını hedefler',
      isCustom: false,
    ),
    Exercise(
      id: _uuid.v4(),
      name: 'Deadlift (Ölü Kaldırış)',
      category: 'strength',
      muscleGroup: 'back',
      description: 'Tüm vücudu çalıştıran compound hareket',
      isCustom: false,
    ),

    // BACAK EGZERSİZLERİ
    Exercise(
      id: _uuid.v4(),
      name: 'Squat (Çömelme)',
      category: 'strength',
      muscleGroup: 'legs',
      description: 'Bacak kasları için en temel egzersiz',
      isCustom: false,
    ),
    Exercise(
      id: _uuid.v4(),
      name: 'Leg Press (Bacak Presi)',
      category: 'strength',
      muscleGroup: 'legs',
      description: 'Quadriceps ve gluteusları hedefler',
      isCustom: false,
    ),
    Exercise(
      id: _uuid.v4(),
      name: 'Lunges (Hamle)',
      category: 'strength',
      muscleGroup: 'legs',
      description: 'Tek bacak çalışması, denge ve kuvvet',
      isCustom: false,
    ),
    Exercise(
      id: _uuid.v4(),
      name: 'Leg Curl (Bacak Curl)',
      category: 'strength',
      muscleGroup: 'legs',
      description: 'Hamstring kaslarını izole eder',
      isCustom: false,
    ),

    // OMUZ EGZERSİZLERİ
    Exercise(
      id: _uuid.v4(),
      name: 'Overhead Press (Omuz Presi)',
      category: 'strength',
      muscleGroup: 'shoulders',
      description: 'Deltoid kaslarının genel gelişimi',
      isCustom: false,
    ),
    Exercise(
      id: _uuid.v4(),
      name: 'Lateral Raises (Yanal Açılış)',
      category: 'strength',
      muscleGroup: 'shoulders',
      description: 'Orta deltoid kaslarını hedefler',
      isCustom: false,
    ),
    Exercise(
      id: _uuid.v4(),
      name: 'Front Raises (Ön Açılış)',
      category: 'strength',
      muscleGroup: 'shoulders',
      description: 'Ön deltoid kaslarını izole eder',
      isCustom: false,
    ),

    // KOL EGZERSİZLERİ
    Exercise(
      id: _uuid.v4(),
      name: 'Bicep Curl (Pazı Curl)',
      category: 'strength',
      muscleGroup: 'arms',
      description: 'Biceps kaslarını hedefler',
      isCustom: false,
    ),
    Exercise(
      id: _uuid.v4(),
      name: 'Tricep Dips (Triceps Dips)',
      category: 'strength',
      muscleGroup: 'arms',
      description: 'Triceps kasları için compound hareket',
      isCustom: false,
    ),
    Exercise(
      id: _uuid.v4(),
      name: 'Hammer Curl (Çekiç Curl)',
      category: 'strength',
      muscleGroup: 'arms',
      description: 'Biceps ve ön kol kasları',
      isCustom: false,
    ),

    // KARIN EGZERSİZLERİ
    Exercise(
      id: _uuid.v4(),
      name: 'Crunches (Mekik)',
      category: 'strength',
      muscleGroup: 'core',
      description: 'Üst karın kaslarını hedefler',
      isCustom: false,
    ),
    Exercise(
      id: _uuid.v4(),
      name: 'Plank (Plank)',
      category: 'strength',
      muscleGroup: 'core',
      description: 'Core stabilizasyonu için izometrik egzersiz',
      isCustom: false,
    ),
    Exercise(
      id: _uuid.v4(),
      name: 'Leg Raises (Bacak Kaldırma)',
      category: 'strength',
      muscleGroup: 'core',
      description: 'Alt karın kaslarını hedefler',
      isCustom: false,
    ),

    // KARDİYO
    Exercise(
      id: _uuid.v4(),
      name: 'Koşu (Treadmill)',
      category: 'cardio',
      muscleGroup: 'full_body',
      description: 'Kardiyovasküler dayanıklılık',
      isCustom: false,
    ),
    Exercise(
      id: _uuid.v4(),
      name: 'Bisiklet (Stationary Bike)',
      category: 'cardio',
      muscleGroup: 'full_body',
      description: 'Düşük etkili kardiyovasküler çalışma',
      isCustom: false,
    ),
    Exercise(
      id: _uuid.v4(),
      name: 'Rowing (Kürek Çekme)',
      category: 'cardio',
      muscleGroup: 'full_body',
      description: 'Tüm vücut kardiyosu',
      isCustom: false,
    ),
  ];

  // Kas grubuna göre egzersizleri filtrele
  static List<Exercise> getExercisesByMuscleGroup(String muscleGroup) {
    return predefinedExercises
        .where((e) => e.muscleGroup == muscleGroup)
        .toList();
  }

  // Kategoriye göre egzersizleri filtrele
  static List<Exercise> getExercisesByCategory(String category) {
    return predefinedExercises
        .where((e) => e.category == category)
        .toList();
  }

  // Egzersiz ara
  static List<Exercise> searchExercises(String query) {
    final lowerQuery = query.toLowerCase();
    return predefinedExercises
        .where((e) => e.name.toLowerCase().contains(lowerQuery))
        .toList();
  }
}
