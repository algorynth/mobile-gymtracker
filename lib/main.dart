import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'theme/app_theme.dart';
import 'services/database_service.dart';
import 'screens/home_screen.dart';
import 'data/exercise_library.dart';
import 'services/database_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive database
  await DatabaseService.initialize();
  
  // Initialize exercise library (save to database if first time)
  await _initializeExercises();
  
  runApp(
    const ProviderScope(
      child: GymTrackerApp(),
    ),
  );
}

Future<void> _initializeExercises() async {
  final exerciseBox = DatabaseService.exercisesBox;
  
  // If no exercises exist, add the predefined ones
  if (exerciseBox.isEmpty) {
    for (final exercise in ExerciseLibrary.predefinedExercises) {
      await exerciseBox.add(exercise);
    }
  }
}

class GymTrackerApp extends StatelessWidget {
  const GymTrackerApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gym Tracker',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const HomeScreen(),
    );
  }
}
