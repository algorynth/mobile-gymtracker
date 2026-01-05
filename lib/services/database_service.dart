import 'package:hive_flutter/hive_flutter.dart';
import '../models/user_profile.dart';
import '../models/body_measurement.dart';
import '../models/exercise.dart';
import '../models/workout.dart';
import '../models/workout_set.dart';
import '../models/progress_photo.dart';
import '../models/workout_template.dart';

class DatabaseService {
  static const String userProfileBoxName = 'user_profile';
  static const String bodyMeasurementsBoxName = 'body_measurements';
  static const String exercisesBoxName = 'exercises';
  static const String workoutsBoxName = 'workouts';
  static const String workoutSetsBoxName = 'workout_sets';
  static const String progressPhotosBoxName = 'progress_photos';
  static const String customTemplatesBoxName = 'custom_templates';

  // Hive'ı başlat
  static Future<void> initialize() async {
    await Hive.initFlutter();

    // Adapterleri kaydet
    Hive.registerAdapter(UserProfileAdapter());
    Hive.registerAdapter(BodyMeasurementAdapter());
    Hive.registerAdapter(ExerciseAdapter());
    Hive.registerAdapter(WorkoutAdapter());
    Hive.registerAdapter(WorkoutSetAdapter());
    Hive.registerAdapter(ProgressPhotoAdapter());
    Hive.registerAdapter(WorkoutTemplateAdapter());
    Hive.registerAdapter(TemplateExerciseAdapter());

    // Box'ları aç
    await Hive.openBox<UserProfile>(userProfileBoxName);
    await Hive.openBox<BodyMeasurement>(bodyMeasurementsBoxName);
    await Hive.openBox<Exercise>(exercisesBoxName);
    await Hive.openBox<Workout>(workoutsBoxName);
    await Hive.openBox<WorkoutSet>(workoutSetsBoxName);
    await Hive.openBox<ProgressPhoto>(progressPhotosBoxName);
    await Hive.openBox<WorkoutTemplate>(customTemplatesBoxName);
  }

  // Box'ları al
  static Box<UserProfile> get userProfileBox =>
      Hive.box<UserProfile>(userProfileBoxName);

  static Box<BodyMeasurement> get bodyMeasurementsBox =>
      Hive.box<BodyMeasurement>(bodyMeasurementsBoxName);

  static Box<Exercise> get exercisesBox =>
      Hive.box<Exercise>(exercisesBoxName);

  static Box<Workout> get workoutsBox =>
      Hive.box<Workout>(workoutsBoxName);

  static Box<WorkoutSet> get workoutSetsBox =>
      Hive.box<WorkoutSet>(workoutSetsBoxName);

  static Box<ProgressPhoto> get progressPhotosBox =>
      Hive.box<ProgressPhoto>(progressPhotosBoxName);

  // Veritabanını temizle (test veya sıfırlama için)
  static Future<void> clearAll() async {
    await userProfileBox.clear();
    await bodyMeasurementsBox.clear();
    await exercisesBox.clear();
    await workoutsBox.clear();
    await workoutSetsBox.clear();
    await progressPhotosBox.clear();
  }
}
