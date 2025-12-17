import '../models/workout_template.dart';

class WorkoutTemplateLibrary {
  /// Hazır antrenman şablonları
  static List<WorkoutTemplate> get predefinedTemplates => [
    // Push Day (Göğüs, Omuz, Triceps)
    WorkoutTemplate(
      id: 'template_push_day',
      name: 'Push Day',
      description: 'Göğüs, omuz ve triceps için itme hareketleri',
      category: 'push',
      estimatedDuration: 60,
      createdAt: DateTime.now(),
      exercises: [
        TemplateExercise(
          exerciseId: 'bench_press',
          exerciseName: 'Bench Press',
          targetSets: 4,
          targetReps: 8,
          restSeconds: 120,
        ),
        TemplateExercise(
          exerciseId: 'incline_dumbbell_press',
          exerciseName: 'Incline Dumbbell Press',
          targetSets: 3,
          targetReps: 10,
          restSeconds: 90,
        ),
        TemplateExercise(
          exerciseId: 'overhead_press',
          exerciseName: 'Overhead Press',
          targetSets: 3,
          targetReps: 10,
          restSeconds: 90,
        ),
        TemplateExercise(
          exerciseId: 'lateral_raises',
          exerciseName: 'Lateral Raises',
          targetSets: 3,
          targetReps: 12,
          restSeconds: 60,
        ),
        TemplateExercise(
          exerciseId: 'tricep_dips',
          exerciseName: 'Tricep Dips',
          targetSets: 3,
          targetReps: 12,
          restSeconds: 60,
        ),
      ],
    ),

    // Pull Day (Sırt, Biceps)
    WorkoutTemplate(
      id: 'template_pull_day',
      name: 'Pull Day',
      description: 'Sırt ve biceps için çekme hareketleri',
      category: 'pull',
      estimatedDuration: 60,
      createdAt: DateTime.now(),
      exercises: [
        TemplateExercise(
          exerciseId: 'deadlift',
          exerciseName: 'Deadlift',
          targetSets: 4,
          targetReps: 6,
          restSeconds: 180,
        ),
        TemplateExercise(
          exerciseId: 'lat_pulldown',
          exerciseName: 'Lat Pulldown',
          targetSets: 3,
          targetReps: 10,
          restSeconds: 90,
        ),
        TemplateExercise(
          exerciseId: 'barbell_row',
          exerciseName: 'Barbell Row',
          targetSets: 3,
          targetReps: 10,
          restSeconds: 90,
        ),
        TemplateExercise(
          exerciseId: 'face_pulls',
          exerciseName: 'Face Pulls',
          targetSets: 3,
          targetReps: 15,
          restSeconds: 60,
        ),
        TemplateExercise(
          exerciseId: 'bicep_curls',
          exerciseName: 'Bicep Curls',
          targetSets: 3,
          targetReps: 12,
          restSeconds: 60,
        ),
      ],
    ),

    // Leg Day
    WorkoutTemplate(
      id: 'template_leg_day',
      name: 'Leg Day',
      description: 'Bacak ve kalça için kapsamlı antrenman',
      category: 'legs',
      estimatedDuration: 70,
      createdAt: DateTime.now(),
      exercises: [
        TemplateExercise(
          exerciseId: 'squat',
          exerciseName: 'Squat',
          targetSets: 4,
          targetReps: 8,
          restSeconds: 150,
        ),
        TemplateExercise(
          exerciseId: 'leg_press',
          exerciseName: 'Leg Press',
          targetSets: 3,
          targetReps: 12,
          restSeconds: 90,
        ),
        TemplateExercise(
          exerciseId: 'romanian_deadlift',
          exerciseName: 'Romanian Deadlift',
          targetSets: 3,
          targetReps: 10,
          restSeconds: 90,
        ),
        TemplateExercise(
          exerciseId: 'leg_curl',
          exerciseName: 'Leg Curl',
          targetSets: 3,
          targetReps: 12,
          restSeconds: 60,
        ),
        TemplateExercise(
          exerciseId: 'calf_raises',
          exerciseName: 'Calf Raises',
          targetSets: 4,
          targetReps: 15,
          restSeconds: 60,
        ),
      ],
    ),

    // Upper Body
    WorkoutTemplate(
      id: 'template_upper_body',
      name: 'Üst Vücut',
      description: 'Üst vücut için genel antrenman',
      category: 'upper',
      estimatedDuration: 55,
      createdAt: DateTime.now(),
      exercises: [
        TemplateExercise(
          exerciseId: 'bench_press',
          exerciseName: 'Bench Press',
          targetSets: 3,
          targetReps: 10,
          restSeconds: 90,
        ),
        TemplateExercise(
          exerciseId: 'barbell_row',
          exerciseName: 'Barbell Row',
          targetSets: 3,
          targetReps: 10,
          restSeconds: 90,
        ),
        TemplateExercise(
          exerciseId: 'overhead_press',
          exerciseName: 'Overhead Press',
          targetSets: 3,
          targetReps: 10,
          restSeconds: 90,
        ),
        TemplateExercise(
          exerciseId: 'lat_pulldown',
          exerciseName: 'Lat Pulldown',
          targetSets: 3,
          targetReps: 10,
          restSeconds: 90,
        ),
      ],
    ),

    // Full Body
    WorkoutTemplate(
      id: 'template_full_body',
      name: 'Full Body',
      description: 'Tüm vücut için temel bileşik hareketler',
      category: 'full_body',
      estimatedDuration: 60,
      createdAt: DateTime.now(),
      exercises: [
        TemplateExercise(
          exerciseId: 'squat',
          exerciseName: 'Squat',
          targetSets: 3,
          targetReps: 8,
          restSeconds: 120,
        ),
        TemplateExercise(
          exerciseId: 'bench_press',
          exerciseName: 'Bench Press',
          targetSets: 3,
          targetReps: 8,
          restSeconds: 90,
        ),
        TemplateExercise(
          exerciseId: 'barbell_row',
          exerciseName: 'Barbell Row',
          targetSets: 3,
          targetReps: 8,
          restSeconds: 90,
        ),
        TemplateExercise(
          exerciseId: 'overhead_press',
          exerciseName: 'Overhead Press',
          targetSets: 3,
          targetReps: 8,
          restSeconds: 90,
        ),
        TemplateExercise(
          exerciseId: 'deadlift',
          exerciseName: 'Deadlift',
          targetSets: 3,
          targetReps: 6,
          restSeconds: 150,
        ),
      ],
    ),

    // Başlangıç Programı
    WorkoutTemplate(
      id: 'template_beginner',
      name: 'Başlangıç Programı',
      description: 'Yeni başlayanlar için temel hareketler',
      category: 'full_body',
      estimatedDuration: 45,
      createdAt: DateTime.now(),
      exercises: [
        TemplateExercise(
          exerciseId: 'squat',
          exerciseName: 'Squat',
          targetSets: 3,
          targetReps: 10,
          restSeconds: 90,
        ),
        TemplateExercise(
          exerciseId: 'bench_press',
          exerciseName: 'Bench Press',
          targetSets: 3,
          targetReps: 10,
          restSeconds: 90,
        ),
        TemplateExercise(
          exerciseId: 'lat_pulldown',
          exerciseName: 'Lat Pulldown',
          targetSets: 3,
          targetReps: 10,
          restSeconds: 90,
        ),
        TemplateExercise(
          exerciseId: 'plank',
          exerciseName: 'Plank',
          targetSets: 3,
          targetReps: 30, // saniye olarak düşünülebilir
          restSeconds: 60,
        ),
      ],
    ),
  ];

  /// Kategoriye göre şablonları getir
  static List<WorkoutTemplate> getByCategory(String category) {
    return predefinedTemplates.where((t) => t.category == category).toList();
  }

  /// Kategori isimlerini Türkçe'ye çevir
  static String getCategoryName(String category) {
    const map = {
      'push': 'Push (İtme)',
      'pull': 'Pull (Çekme)',
      'legs': 'Bacak',
      'upper': 'Üst Vücut',
      'lower': 'Alt Vücut',
      'full_body': 'Full Body',
      'custom': 'Özel',
    };
    return map[category] ?? category;
  }

  /// Kategori ikonlarını getir
  static String getCategoryIcon(String category) {
    const map = {
      'push': '💪',
      'pull': '🏋️',
      'legs': '🦵',
      'upper': '👆',
      'lower': '👇',
      'full_body': '🔥',
      'custom': '⚡',
    };
    return map[category] ?? '💪';
  }
}
